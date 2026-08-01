package com.shieldcam.app

import android.os.Bundle
import android.view.WindowManager
import com.shieldcam.app.monitor.PlatformChannel
import com.shieldcam.app.util.AppStorage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppStorage.init(this)
        // Hide ShieldCam content from screenshots and the recents preview.
        // On supported devices the background app-switcher blur is also used.
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE,
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PlatformChannel.setup(flutterEngine.dartExecutor.binaryMessenger, applicationContext)
        AppStorage.writeLog("Flutter engine configured, platform channels attached")
    }
}
