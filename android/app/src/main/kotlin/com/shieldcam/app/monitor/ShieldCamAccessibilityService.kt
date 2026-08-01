package com.shieldcam.app.monitor

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import com.shieldcam.app.util.AppStorage

/**
 * Observes the Android lock screen without ever reading credentials.
 *
 * The service only receives high-level UI events. While the device is locked
 * (keyguard active) and the user interacts with the SystemUI lock screen,
 * ShieldCam arms a short confirmation window. If the keyguard is still active
 * afterwards, the interaction is reported to [DetectionEngine] as a failed
 * unlock attempt.
 *
 * Important: this service never reads window content that contains a PIN,
 * password or pattern - it only observes *that* interaction happened.
 */
class ShieldCamAccessibilityService : AccessibilityService() {

    override fun onServiceConnected() {
        super.onServiceConnected()
        DetectionEngine.init(this)
        AppStorage.writeLog("Accessibility service connected")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return
        val pkg = event.packageName?.toString() ?: ""
        val cls = event.className?.toString() ?: ""
        val isSystemUi = pkg == "com.android.systemui" || pkg.contains("keyguard", ignoreCase = true)

        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                if (isSystemUi && isKeyguardClassName(cls)) {
                    DetectionEngine.onKeyguardShown()
                } else if (DetectionEngine.isKeyguardVisible() && !isKeyguardClassName(cls)) {
                    DetectionEngine.onKeyguardHidden()
                }
            }

            AccessibilityEvent.TYPE_WINDOWS_CHANGED -> {
                // Treat a disappearing keyguard window as a successful unlock.
                val windows = windows
                val keyguardStillUp = windows.any {
                    val cn = it.root?.className?.toString() ?: ""
                    isKeyguardClassName(cn)
                }
                if (!keyguardStillUp && DetectionEngine.isKeyguardVisible()) {
                    DetectionEngine.onKeyguardHidden()
                }
            }

            AccessibilityEvent.TYPE_VIEW_CLICKED,
            AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED,
            AccessibilityEvent.TYPE_VIEW_FOCUSED,
            AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED,
            -> {
                if (isSystemUi && (DetectionEngine.isKeyguardVisible() || DetectionEngine.isScreenLocked())) {
                    DetectionEngine.onKeyguardInteraction()
                }
            }
        }
    }

    override fun onInterrupt() {
        // No credentials are being read, so nothing to reset here.
    }

    override fun onUnbind(intent: android.content.Intent?): Boolean {
        AppStorage.writeLog("Accessibility service unbound")
        DetectionEngine.reset()
        return super.onUnbind(intent)
    }

    private fun isKeyguardClassName(className: String): Boolean {
        return className.contains("Keyguard", ignoreCase = true) ||
            className.contains("keyguard", ignoreCase = true)
    }
}
