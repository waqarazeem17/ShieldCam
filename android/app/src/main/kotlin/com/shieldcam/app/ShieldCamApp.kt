package com.shieldcam.app

import android.app.Application
import com.shieldcam.app.util.AppStorage
import com.shieldcam.app.util.DeviceInfo

class ShieldCamApp : Application() {

    override fun onCreate() {
        super.onCreate()
        AppStorage.init(this)
        AppStorage.ensureStructure()
        AppStorage.writeLog("ShieldCam process started (model=${DeviceInfo.model()}, sdk=${DeviceInfo.sdkInt()})")
    }
}
