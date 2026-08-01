package com.shieldcam.app.admin

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import com.shieldcam.app.util.AppStorage

/** Optional Device Admin receiver that allows locking the device on demand. */
class ShieldCamDeviceAdminReceiver : DeviceAdminReceiver() {

    override fun onEnabled(context: Context, intent: Intent) {
        AppStorage.writeLog("Device admin enabled")
    }

    override fun onDisabled(context: Context, intent: Intent) {
        AppStorage.writeLog("Device admin disabled")
    }
}
