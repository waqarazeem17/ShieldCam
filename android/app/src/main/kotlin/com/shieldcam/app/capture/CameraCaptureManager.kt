package com.shieldcam.app.capture

import android.annotation.SuppressLint
import android.content.Context
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCaptureSession
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraMetadata
import android.hardware.camera2.CaptureRequest
import android.hardware.camera2.params.StreamConfigurationMap
import android.media.Image
import android.media.ImageReader
import android.os.Handler
import android.os.HandlerThread
import android.util.Size
import com.shieldcam.app.util.AppStorage
import java.io.File
import java.io.FileOutputStream
import java.util.Date
import java.util.concurrent.TimeUnit

/**
 * Captures full-resolution JPEG evidence photos with the Android Camera2 API.
 *
 * This runs inside the camera-typed foreground service, which is the only
 * legitimate way to access the camera while the app is in the background on
 * Android 9+. Both the rear and the front camera are captured sequentially.
 * If a camera cannot be opened (in use, missing, restricted) the manager
 * gracefully continues with the other one and never blocks the service.
 */
class CameraCaptureManager(private val context: Context) {

    private var handlerThread: HandlerThread? = null
    private var handler: Handler? = null
    private var callbackThread: HandlerThread? = null
    private var callbackHandler: Handler? = null

    /** Result of a capture attempt. */
    data class Result(
        val frontImage: String?,
        val rearImage: String?,
        val error: String? = null,
    )

    @SuppressLint("MissingPermission")
    fun captureBoth(onComplete: (Result) -> Unit) {
        ensureThread()
        handler?.post {
            val front = captureLens(FRONT)
            val rear = captureLens(REAR)
            val result = Result(front, rear)
            AppStorage.writeLog("captureBoth finished: front=${front != null} rear=${rear != null}")
            handler?.post { onComplete(result) }
        }
    }

    @SuppressLint("MissingPermission")
    private fun captureLens(lens: Int): String? {
        val manager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        val cameraId = findCameraId(manager, lens) ?: return null
        return try {
            captureSingle(manager, cameraId)
        } catch (e: Exception) {
            AppStorage.writeLog("captureLens($lens) failed: ${e.message}")
            null
        }
    }

    /** Returns the best camera id for the requested lens facing. */
    private fun findCameraId(manager: CameraManager, lens: Int): String? {
        val ids = manager.cameraIdList
        // Prefer an exact facing match, otherwise fall back to any camera.
        ids.forEach { id ->
            val facing = manager.getCameraCharacteristics(id)
                .get(CameraCharacteristics.LENS_FACING)
            if (facing != null && facing == lens) return id
        }
        return ids.firstOrNull()
    }

    @SuppressLint("MissingPermission")
    private fun captureSingle(manager: CameraManager, cameraId: String): String {
        val characteristics = manager.getCameraCharacteristics(cameraId)
        val map = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)!!
        val jpegSize = pickJpegSize(map)

        val file = File(
            AppStorage.imagesDir(),
            AppStorage.evidenceFileName(Date(), if (cameraIdIsFront(manager, cameraId)) "front" else "back")
        )

        val done = java.util.concurrent.CountDownLatch(1)
        var failure: Exception? = null

        val imageReader = ImageReader.newInstance(jpegSize.width, jpegSize.height, android.graphics.ImageFormat.JPEG, 2)
        imageReader.setOnImageAvailableListener({ reader ->
            val image: Image? = reader.acquireNextImage()
            if (image != null) {
                try {
                    writeJpeg(image, file)
                } catch (e: Exception) {
                    failure = e
                } finally {
                    image.close()
                    done.countDown()
                }
            } else {
                done.countDown()
            }
        }, callbackHandler)

        var openedCamera: CameraDevice? = null
        var openedSession: CameraCaptureSession? = null

        manager.openCamera(cameraId, object : CameraDevice.StateCallback() {
            override fun onOpened(camera: CameraDevice) {
                openedCamera = camera
                try {
                    val builder = camera.createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE)
                    builder.addTarget(imageReader.surface)
                    builder.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE)
                    builder.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
                    builder.set(CaptureRequest.JPEG_QUALITY, 95.toByte())
                    builder.set(CaptureRequest.JPEG_ORIENTATION, jpegOrientation(characteristics))

                    camera.createCaptureSession(
                        listOf(imageReader.surface),
                        object : CameraCaptureSession.StateCallback() {
                            override fun onConfigured(session: CameraCaptureSession) {
                                openedSession = session
                                try {
                                    session.capture(builder.build(), object : CameraCaptureSession.CaptureCallback() {
                                        override fun onCaptureCompleted(
                                            session: CameraCaptureSession,
                                            request: CaptureRequest,
                                            result: android.hardware.camera2.TotalCaptureResult,
                                        ) {
                                            // JPEG delivery is signalled by the ImageReader listener.
                                        }
                                    }, callbackHandler)
                                } catch (e: CameraAccessException) {
                                    failure = e
                                    done.countDown()
                                    closeAll(session, camera, imageReader)
                                }
                            }

                            override fun onConfigureFailed(session: CameraCaptureSession) {
                                failure = CameraAccessException(CameraAccessException.CAMERA_ERROR)
                                done.countDown()
                                closeAll(session, camera, imageReader)
                            }
                        },
                        callbackHandler,
                    )
                } catch (e: Exception) {
                    failure = e
                    done.countDown()
                    camera.close()
                    imageReader.close()
                }
            }

            override fun onDisconnected(camera: CameraDevice) {
                failure = CameraAccessException(CameraAccessException.CAMERA_DISCONNECTED)
                done.countDown()
                camera.close()
                imageReader.close()
            }

            override fun onError(camera: CameraDevice, error: Int) {
                failure = CameraAccessException(CameraAccessException.CAMERA_ERROR)
                done.countDown()
                camera.close()
                imageReader.close()
            }
        }, callbackHandler)

        // Time-box the whole capture to avoid blocking the service.
        if (!done.await(8, TimeUnit.SECONDS)) {
            // Close whatever is still open so the camera is released.
            try { openedSession?.close() } catch (_: Exception) {}
            openedCamera?.close()
            imageReader.close()
            throw IllegalStateException("Camera capture timed out for $cameraId")
        }
        if (failure != null) {
            try { openedSession?.close() } catch (_: Exception) {}
            openedCamera?.close()
            imageReader.close()
            throw failure!!
        }

        // Success: release the camera, session and reader.
        try { openedSession?.close() } catch (_: Exception) {}
        openedCamera?.close()
        imageReader.close()

        return file.absolutePath
    }

    private fun closeAll(session: CameraCaptureSession, camera: CameraDevice, reader: ImageReader) {
        try { session.close() } catch (_: Exception) {}
        camera.close()
        reader.close()
    }

    private fun pickJpegSize(map: StreamConfigurationMap): Size {
        val jpegSizes = map.getOutputSizes(android.graphics.ImageFormat.JPEG) ?: arrayOf(Size(640, 480))
        if (jpegSizes.isEmpty()) return Size(640, 480)
        var best = jpegSizes[0]
        for (s in jpegSizes) {
            if (s.width.toLong() * s.height > best.width.toLong() * best.height) best = s
        }
        // Avoid absurd sizes on emulators; cap at 12 megapixels.
        if (best.width.toLong() * best.height > 12_000_000L) {
            for (s in jpegSizes) {
                val area = s.width.toLong() * s.height
                if (area <= 12_000_000L && area > 800_000L) { best = s; break }
            }
        }
        return best
    }

    private fun cameraIdIsFront(manager: CameraManager, cameraId: String): Boolean {
        val facing = manager.getCameraCharacteristics(cameraId).get(CameraCharacteristics.LENS_FACING)
        return facing != null && facing == CameraCharacteristics.LENS_FACING_FRONT
    }

    private fun jpegOrientation(characteristics: CameraCharacteristics): Int {
        val sensorOrientation = characteristics.get(CameraCharacteristics.SENSOR_ORIENTATION) ?: 0
        val facing = characteristics.get(CameraCharacteristics.LENS_FACING)
        val mirror = facing == CameraCharacteristics.LENS_FACING_FRONT
        return (sensorOrientation + if (mirror) 180 else 0) % 360
    }

    private fun writeJpeg(image: Image, file: File) {
        val buffer = image.planes[0].buffer
        val bytes = ByteArray(buffer.remaining())
        buffer.get(bytes)
        FileOutputStream(file).use { it.write(bytes) }
    }

    private fun ensureThread() {
        if (handlerThread == null) {
            handlerThread = HandlerThread("shieldcam-camera").also { it.start() }
            handler = Handler(handlerThread!!.looper)
        }
        if (callbackThread == null) {
            callbackThread = HandlerThread("shieldcam-camera-callback").also { it.start() }
            callbackHandler = Handler(callbackThread!!.looper)
        }
    }

    fun dispose() {
        handlerThread?.quitSafely()
        handlerThread = null
        handler = null
        callbackThread?.quitSafely()
        callbackThread = null
        callbackHandler = null
    }

    companion object {
        private const val FRONT = CameraCharacteristics.LENS_FACING_FRONT
        private const val REAR = CameraCharacteristics.LENS_FACING_BACK
    }
}
