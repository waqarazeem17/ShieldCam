package com.shieldcam.app.monitor

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.shieldcam.app.util.AppStorage

/**
 * Restarts monitoring after a reboot or an app update, as permitted by
 * Android. On Android 14+ the receiver is registered in the manifest and
 * runs in the main process without starting a separate process.
 */
class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        AppStorage.init(context)

        if (action == Intent.ACTION_BOOT_COMPLETED ||
            action == Intent.ACTION_LOCKED_BOOT_COMPLETED ||
            action == Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            if (AppStorage.monitoringEnabled) {
                AppStorage.writeLog("Boot receiver: resuming monitoring ($action)")
                ShieldCamForegroundService.ensureStarted(context)
            } else {
                AppStorage.writeLog("Boot receiver: monitoring was disabled, skipping")
            }
        }
    }
}
