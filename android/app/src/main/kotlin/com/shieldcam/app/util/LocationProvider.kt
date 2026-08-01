package com.shieldcam.app.util

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.location.Location
import android.location.LocationManager
import android.os.HandlerThread
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/**
 * Resolves the most recent device location using the framework
 * LocationManager only - no Google Play Services and no network required.
 * The fix comes from the cached GPS/network location, which is instant.
 */
object LocationProvider {

    data class Fix(val latitude: Double?, val longitude: Double?)

    @SuppressLint("MissingPermission")
    fun lastKnown(context: Context): Fix {
        if (!DeviceInfo.hasPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) &&
            !DeviceInfo.hasPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
        ) {
            return Fix(null, null)
        }

        val thread = HandlerThread("shieldcam-location").also { it.start() }
        val latch = CountDownLatch(1)
        var result = Fix(null, null)

        android.os.Handler(thread.looper).post {
            try {
                val manager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
                val providers = listOf(LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER)
                var best: Location? = null
                providers.forEach { provider ->
                    try {
                        val loc = manager.getLastKnownLocation(provider)
                        if (loc != null && (best == null || loc.time > best.time)) best = loc
                    } catch (_: Exception) {
                    }
                }
                result = Fix(best?.latitude, best?.longitude)
            } catch (e: Exception) {
                AppStorage.writeLog("lastKnown failed: ${e.message}")
            } finally {
                latch.countDown()
            }
        }

        if (!latch.await(3, TimeUnit.SECONDS)) {
            AppStorage.writeLog("lastKnown location timed out")
        }
        thread.quitSafely()
        return result
    }
}
