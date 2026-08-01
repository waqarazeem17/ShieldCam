package com.shieldcam.app.monitor

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.shieldcam.app.capture.CameraCaptureManager
import com.shieldcam.app.util.AppStorage
import com.shieldcam.app.util.DeviceInfo
import com.shieldcam.app.util.LocationProvider
import org.json.JSONObject
import java.util.Date
import java.util.UUID

/**
 * Modular detection core.
 *
 * ShieldCam cannot read lock-screen credentials - no app can. Instead it uses
 * two legitimate system signals:
 *
 *  1. An Accessibility service that observes the lock screen window. When the
 *     keyguard is visible and the user interacts with it (view clicked /
 *     text changed on the PIN/password/pattern views) but the keyguard stays
 *     up afterwards, ShieldCam infers a failed unlock attempt.
 *  2. A foreground service watchdog that polls the system keyguard state so
 *     the lock-state status stays accurate even when accessibility is off.
 *
 * This module is fully isolated: it exposes three small entry points
 * (onKeyguardShown/Hidden/Interaction, onLockStateChange) and emits
 * DetectionEvent payloads. It never touches Flutter directly.
 */
object DetectionEngine {

    interface Sink {
        fun onDetectionEvent(event: JSONObject)
        fun onLockStateChanged(locked: Boolean)
        fun onAttemptThrottled()
    }

    var sink: Sink? = null

    private var appContext: Context? = null

    @Volatile private var keyguardVisible = false
    @Volatile private var screenLocked = false
    @Volatile private var interactionArmed = false
    @Volatile private var sessionAttempts = 0
    @Volatile private var lastAttemptAt = 0L

    private val handler = Handler(Looper.getMainLooper())
    private var checkRunnable: Runnable? = null

    fun init(context: Context) {
        if (appContext == null) {
            appContext = context.applicationContext
        }
    }

    fun isKeyguardVisible(): Boolean = keyguardVisible

    fun isScreenLocked(): Boolean = screenLocked

    /** True right after the user interacts with the keyguard. */
    fun isInteractionArmed(): Boolean = interactionArmed

    fun reset() {
        keyguardVisible = false
        interactionArmed = false
        sessionAttempts = 0
        cancelCheck()
        sink?.onLockStateChanged(screenLocked)
    }

    // -----------------------------------------------------------------
    // Accessibility service inputs
    // -----------------------------------------------------------------

    fun onKeyguardShown() {
        keyguardVisible = true
        cancelCheck()
    }

    fun onKeyguardHidden() {
        keyguardVisible = false
        interactionArmed = false
        sessionAttempts = 0
        cancelCheck()
    }

    /**
     * Called when an interaction event arrives from the keyguard while it is
     * visible. Arms a short confirmation window; if the keyguard is still up
     * when it elapses, the interaction is treated as a failed unlock attempt.
     */
    fun onKeyguardInteraction() {
        if (!keyguardVisible) return
        interactionArmed = true
        cancelCheck()
        val runnable = Runnable {
            checkRunnable = null
            if (interactionArmed && keyguardVisible) {
                interactionArmed = false
                handleFailedAttempt("accessibility")
            }
        }
        checkRunnable = runnable
        handler.postDelayed(runnable, KEYGUARD_CONFIRM_MS)
    }

    // -----------------------------------------------------------------
    // Foreground service watchdog inputs
    // -----------------------------------------------------------------

    fun onLockStateChange(locked: Boolean) {
        if (screenLocked == locked) return
        screenLocked = locked
        if (!locked) {
            // Successful unlock: end the current attempt session.
            onKeyguardHidden()
        }
        sink?.onLockStateChanged(locked)
    }

    /** Manual / debug trigger that runs the full evidence pipeline. */
    fun triggerTest(context: Context) {
        if (appContext == null) appContext = context.applicationContext
        handleFailedAttempt("manual")
    }

    // -----------------------------------------------------------------
    // Evidence pipeline
    // -----------------------------------------------------------------

    private fun handleFailedAttempt(source: String) {
        val now = System.currentTimeMillis()
        if (now - lastAttemptAt < MIN_ATTEMPT_INTERVAL_MS) {
            sink?.onAttemptThrottled()
            return
        }
        lastAttemptAt = now
        sessionAttempts += 1
        val attemptNumber = sessionAttempts
        val ctx = appContext ?: return

        AppStorage.writeLog("Failed unlock attempt #$attemptNumber detected via $source")

        // A camera-typed foreground service must be running to access the
        // camera from the background.
        ShieldCamForegroundService.ensureStarted(ctx)

        // Capture evidence and build the event on a worker thread.
        Thread {
            val fix = LocationProvider.lastKnown(ctx)
            val capture = CameraCaptureManager(ctx)
            capture.captureBoth { result ->
                try {
                    val event = JSONObject()
                        .put("id", UUID.randomUUID().toString())
                        .put("timestamp", System.currentTimeMillis())
                        .put("attemptCount", attemptNumber)
                        .put("batteryLevel", DeviceInfo.batteryLevel(ctx))
                        .put("batteryCharging", DeviceInfo.isCharging(ctx))
                        .put("deviceModel", DeviceInfo.model())
                        .put("manufacturer", DeviceInfo.manufacturer())
                        .put("androidVersion", DeviceInfo.androidVersion())
                        .put("sdkInt", DeviceInfo.sdkInt())
                        .put("frontImage", result.frontImage ?: "")
                        .put("rearImage", result.rearImage ?: "")
                        .put("latitude", fix.latitude ?: JSONObject.NULL)
                        .put("longitude", fix.longitude ?: JSONObject.NULL)
                        .put("source", source)

                    AppStorage.writePendingEvent(event)
                    AppStorage.writeLog("Event ${event.optString("id")} persisted locally")
                    sink?.onDetectionEvent(event)
                } catch (e: Exception) {
                    AppStorage.writeLog("Failed to build event: ${e.message}")
                } finally {
                    capture.dispose()
                }
            }
        }.start()
    }

    private fun cancelCheck() {
        checkRunnable?.let { handler.removeCallbacks(it) }
        checkRunnable = null
    }

    private const val KEYGUARD_CONFIRM_MS = 1400L
    private const val MIN_ATTEMPT_INTERVAL_MS = 5000L
}
