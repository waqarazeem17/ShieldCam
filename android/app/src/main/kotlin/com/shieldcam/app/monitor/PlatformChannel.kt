package com.shieldcam.app.monitor

import android.accessibilityservice.AccessibilityServiceInfo
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import com.shieldcam.app.admin.ShieldCamDeviceAdminReceiver
import com.shieldcam.app.util.AppStorage
import com.shieldcam.app.util.DeviceInfo
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.File

/**
 * Bridges the native detection layer and the Flutter engine.
 *
 *  - MethodChannel "com.shieldcam.platform"  : Flutter -> native commands
 *  - EventChannel  "com.shieldcam.events"    : native -> Flutter event stream
 *
 * The foreground service emits detection events through [emitDetection] and
 * lock-state updates through [emitLockState]. If the Flutter engine is not
 * attached the events are simply lost - the event is still persisted to the
 * pending queue by the detection engine and imported by Flutter on launch.
 */
object PlatformChannel {

    private const val METHOD_CHANNEL = "com.shieldcam.platform"
    private const val EVENT_CHANNEL = "com.shieldcam.events"

    var eventSink: EventChannel.EventSink? = null

    fun setup(messenger: BinaryMessenger, context: Context) {
        MethodChannel(messenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            handleMethod(call, context, result)
        }
        EventChannel(messenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    private fun handleMethod(call: MethodCall, context: Context, result: MethodChannel.Result) {
        val appContext = context.applicationContext
        try {
            when (call.method) {
                "getDeviceInfo" -> result.success(deviceInfoMap(appContext))
                "getStorageRoot" -> result.success(AppStorage.rootPath())
                "startMonitoring" -> {
                    ShieldCamForegroundService.ensureStarted(appContext)
                    result.success(true)
                }
                "stopMonitoring" -> {
                    ShieldCamForegroundService.stop(appContext)
                    result.success(true)
                }
                "isMonitoringActive" -> result.success(ShieldCamForegroundService.isRunning(appContext))
                "isAccessibilityEnabled" -> result.success(
                    DeviceInfo.isAccessibilityEnabled(appContext, ShieldCamAccessibilityService::class.java)
                )
                "openAccessibilitySettings" -> {
                    appContext.startActivity(
                        Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    result.success(true)
                }
                "isBatteryOptimizationIgnored" -> result.success(DeviceInfo.isIgnoringBatteryOptimizations(appContext))
                "requestIgnoreBatteryOptimizations" -> {
                    val intent = Intent(
                        Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                        Uri.parse("package:${appContext.packageName}"),
                    ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    appContext.startActivity(intent)
                    result.success(true)
                }
                "isDeviceAdminActive" -> result.success(DeviceInfo.isDeviceAdminActive(appContext))
                "activateDeviceAdmin" -> {
                    val component = ComponentName(appContext, ShieldCamDeviceAdminReceiver::class.java)
                    val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
                        .setComponent(component)
                        .putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, component)
                        .putExtra(
                            DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                            "ShieldCam can lock the device immediately when a monitoring problem is detected.",
                        )
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    appContext.startActivity(intent)
                    result.success(true)
                }
                "deactivateDeviceAdmin" -> {
                    val dpm = appContext.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val component = ComponentName(appContext, ShieldCamDeviceAdminReceiver::class.java)
                    dpm.removeActiveAdmin(component)
                    result.success(true)
                }
                "lockDeviceNow" -> {
                    val dpm = appContext.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val component = ComponentName(appContext, ShieldCamDeviceAdminReceiver::class.java)
                    if (dpm.isAdminActive(component)) {
                        dpm.lockNow()
                        result.success(true)
                    } else {
                        result.error("ADMIN_INACTIVE", "Device admin is not active", null)
                    }
                }
                "triggerTest" -> {
                    ShieldCamForegroundService.ensureStarted(appContext)
                    DetectionEngine.triggerTest(appContext)
                    result.success(true)
                }
                "getLockState" -> result.success(
                    mapOf(
                        "locked" to DetectionEngine.isScreenLocked(),
                        "keyguardVisible" to DetectionEngine.isKeyguardVisible(),
                        "monitoring" to ShieldCamForegroundService.isRunning(appContext),
                    )
                )
                "setSecureFlag" -> result.success(true) // set in MainActivity
                "getPendingEvents" -> {
                    val list = AppStorage.listPendingEvents().map { it.toString() }
                    result.success(list)
                }
                "clearPendingEvent" -> {
                    val id = call.argument<String>("id")
                    if (id != null) {
                        AppStorage.deletePendingEvent(id)
                        result.success(true)
                    } else {
                        result.error("BAD_ARG", "id required", null)
                    }
                }
                "shareFiles" -> {
                    val paths = call.argument<List<String>>("paths") ?: emptyList()
                    if (paths.isEmpty) {
                        result.error("BAD_ARG", "paths required", null)
                    } else {
                        shareFiles(appContext, paths)
                        result.success(true)
                    }
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            AppStorage.writeLog("method ${call.method} failed: ${e.message}")
            result.error("PLATFORM_ERROR", e.message, null)
        }
    }

    private fun deviceInfoMap(context: Context): Map<String, Any> {
        val am = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as android.view.accessibility.AccessibilityManager
        val services = am.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
            .any { it.resolveInfo.serviceInfo?.packageName == context.packageName }
        val flat = Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
        ) ?: ""
        val accessibilityEnabled = services ||
            flat.split(':').any { it.startsWith(context.packageName + "/") }

        return mapOf(
            "deviceModel" to DeviceInfo.model(),
            "manufacturer" to DeviceInfo.manufacturer(),
            "androidVersion" to DeviceInfo.androidVersion(),
            "sdkInt" to DeviceInfo.sdkInt(),
            "batteryLevel" to DeviceInfo.batteryLevel(context),
            "batteryCharging" to DeviceInfo.isCharging(context),
            "isMonitoringActive" to ShieldCamForegroundService.isRunning(context),
            "isAccessibilityEnabled" to accessibilityEnabled,
            "isBatteryOptimizationIgnored" to DeviceInfo.isIgnoringBatteryOptimizations(context),
            "isDeviceAdminActive" to DeviceInfo.isDeviceAdminActive(context),
        )
    }

    fun emitDetection(event: JSONObject) {
        eventSink?.success(mapOf("type" to "detection", "event" to event.toString()))
    }

    fun emitLockState(locked: Boolean) {
        eventSink?.success(mapOf("type" to "lockState", "locked" to locked))
    }

    /** Shares files through the Android share sheet using a FileProvider. */
    private fun shareFiles(context: Context, paths: List<String>) {
        val uris = paths.mapNotNull { path ->
            val file = File(path)
            if (!file.exists()) {
                null
            } else {
                try {
                    androidx.core.content.FileProvider.getUriForFile(
                        context,
                        context.getString(com.shieldcam.app.R.string.file_provider_authority),
                        file,
                    )
                } catch (_: Exception) {
                    null
                }
            }
        }
        if (uris.isEmpty()) return

        val send = Intent(Intent.ACTION_SEND_MULTIPLE).apply {
            type = if (uris.size == 1) "image/jpeg" else "*/*"
            putParcelableArrayListExtra(Intent.EXTRA_STREAM, ArrayList(uris))
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        val chooser = Intent.createChooser(send, "Share ShieldCam export")
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(chooser)
    }
}
