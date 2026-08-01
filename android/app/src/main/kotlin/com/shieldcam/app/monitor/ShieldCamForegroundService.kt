package com.shieldcam.app.monitor

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import com.shieldcam.app.MainActivity
import com.shieldcam.app.R
import com.shieldcam.app.util.AppStorage
import com.shieldcam.app.util.DeviceInfo
import org.json.JSONObject

/**
 * Persistent foreground service that:
 *  - keeps ShieldCam alive in the background,
 *  - holds the camera/location foreground-service types so evidence can be
 *    captured while the UI is not visible,
 *  - polls the system keyguard state so the lock-status is accurate even when
 *    the accessibility service is not enabled,
 *  - relays detection events to the Flutter engine via the event channel.
 */
class ShieldCamForegroundService : Service(), DetectionEngine.Sink {

    private var watchdogHandler: Handler? = null
    private var watchdogThread: HandlerThread? = null
    private var isForeground = false
    private var lockWatchdog: Runnable? = null

    override fun onCreate() {
        super.onCreate()
        DetectionEngine.init(this)
        DetectionEngine.sink = this
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        AppStorage.monitoringEnabled = true

        when (intent?.action) {
            ACTION_STOP_MONITORING -> {
                stopSelf()
                return START_NOT_STICKY
            }
            ACTION_MANUAL_TRIGGER -> {
                startForegroundInternal()
                DetectionEngine.triggerTest(this)
                return START_STICKY
            }
            else -> {
                startForegroundInternal()
                ensureWatchdog()
                return START_STICKY
            }
        }
    }

    private fun startForegroundInternal() {
        if (isForeground) return
        val notification = buildNotification(locked = DetectionEngine.isScreenLocked())
        var type = 0
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            if (DeviceInfo.hasPermission(this, android.Manifest.permission.CAMERA)) {
                type = type or ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA
            }
            if (DeviceInfo.hasPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) ||
                DeviceInfo.hasPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION)
            ) {
                type = type or ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTIFICATION_ID, notification, type)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        isForeground = true
        AppStorage.writeLog("Foreground service started (types=$type)")
    }

    override fun onDestroy() {
        stopWatchdog()
        DetectionEngine.sink = null
        AppStorage.monitoringEnabled = false
        AppStorage.writeLog("Foreground service destroyed")
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    // -----------------------------------------------------------------
    // Watchdog: poll system keyguard state every second
    // -----------------------------------------------------------------

    private fun ensureWatchdog() {
        if (watchdogHandler != null) return
        watchdogThread = HandlerThread("shieldcam-watchdog").also { it.start() }
        watchdogHandler = Handler(watchdogThread!!.looper)
        lockWatchdog = object : Runnable {
            override fun run() {
                try {
                    val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
                    val screenOn = pm.isInteractive
                    val keyguard = (getSystemService(Context.KEYGUARD_SERVICE) as android.app.KeyguardManager)
                    val locked = if (screenOn) keyguard.isKeyguardLocked else keyguard.isKeyguardLocked
                    DetectionEngine.onLockStateChange(locked)
                } catch (e: Exception) {
                    AppStorage.writeLog("watchdog error: ${e.message}")
                }
                watchdogHandler?.postDelayed(this, WATCHDOG_INTERVAL_MS)
            }
        }
        watchdogHandler?.post(lockWatchdog!!)
    }

    private fun stopWatchdog() {
        lockWatchdog?.let { watchdogHandler?.removeCallbacks(it) }
        watchdogHandler?.removeCallbacksAndMessages(null)
        watchdogThread?.quitSafely()
        watchdogHandler = null
        watchdogThread = null
    }

    // -----------------------------------------------------------------
    // DetectionEngine.Sink
    // -----------------------------------------------------------------

    override fun onDetectionEvent(event: JSONObject) {
        PlatformChannel.emitDetection(event)
    }

    override fun onLockStateChanged(locked: Boolean) {
        PlatformChannel.emitLockState(locked)
        updateNotification(locked)
    }

    override fun onAttemptThrottled() {
        // Attempts spaced < MIN_ATTEMPT_INTERVAL apart are ignored.
    }

    // -----------------------------------------------------------------
    // Notification
    // -----------------------------------------------------------------

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                getString(R.string.monitoring_notification_channel),
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = getString(R.string.monitoring_notification_channel_desc)
                setShowBadge(false)
            }
            val nm = getSystemService(NotificationManager::class.java)
            nm.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(locked: Boolean): Notification {
        val contentIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val stopIntent = PendingIntent.getService(
            this,
            1,
            Intent(this, ShieldCamForegroundService::class.java).setAction(ACTION_STOP_MONITORING),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val subtitle = if (locked) "Device locked - watching" else "Device unlocked - monitoring"
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_shield)
            .setContentTitle(getString(R.string.monitoring_notification_title))
            .setContentText(getString(R.string.monitoring_notification_text))
            .setSubText(subtitle)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(false)
            .setContentIntent(contentIntent)
            .addAction(0, "Stop monitoring", stopIntent)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun updateNotification(locked: Boolean) {
        if (!isForeground) return
        val nm = getSystemService(NotificationManager::class.java)
        try {
            nm.notify(NOTIFICATION_ID, buildNotification(locked))
        } catch (_: Exception) {
        }
    }

    companion object {
        private const val CHANNEL_ID = "shieldcam_monitoring"
        private const val NOTIFICATION_ID = 1001
        private const val WATCHDOG_INTERVAL_MS = 1000L

        const val ACTION_START_MONITORING = "com.shieldcam.app.ACTION_START_MONITORING"
        const val ACTION_STOP_MONITORING = "com.shieldcam.app.ACTION_STOP_MONITORING"
        const val ACTION_MANUAL_TRIGGER = "com.shieldcam.app.ACTION_MANUAL_TRIGGER"

        fun ensureStarted(context: Context) {
            val intent = Intent(context, ShieldCamForegroundService::class.java)
                .setAction(ACTION_START_MONITORING)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            val intent = Intent(context, ShieldCamForegroundService::class.java)
                .setAction(ACTION_STOP_MONITORING)
            context.stopService(intent)
        }

        fun isRunning(context: Context): Boolean = AppStorage.monitoringEnabled
    }
}
