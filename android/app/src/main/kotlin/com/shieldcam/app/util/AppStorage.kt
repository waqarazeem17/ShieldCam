package com.shieldcam.app.util

import android.content.Context
import org.json.JSONObject
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.ConcurrentLinkedQueue

/**
 * Manages the on-device folder structure and the pending-event hand-off queue
 * between the native detection layer and the Flutter UI.
 *
 * All data lives in app-specific storage, so no storage permission is required
 * and the content stays private to ShieldCam.
 *
 * Folder layout (under the app external files root):
 *   ShieldCam/
 *     Images/    - captured evidence photos
 *     Exports/   - ZIP / PDF / JSON exports
 *     Database/  - Isar database files
 *     Logs/      - plain-text debug logs
 *     Temp/      - temporary work files
 *     Temp/pending/ - detection events waiting to be imported by Flutter
 */
object AppStorage {

    const val ROOT_NAME = "ShieldCam"

    private lateinit var appContext: Context

    /** Init once the app is created. Must be called from Application / service. */
    fun init(context: Context) {
        if (::appContext.isInitialized) return
        appContext = context.applicationContext
    }

    private fun root(): File {
        val base = appContext.getExternalFilesDir(null) ?: appContext.filesDir
        return File(base, ROOT_NAME).apply { mkdirs() }
    }

    fun rootPath(): String = root().absolutePath

    fun imagesDir(): File = File(root(), "Images").apply { mkdirs() }
    fun exportsDir(): File = File(root(), "Exports").apply { mkdirs() }
    fun databaseDir(): File = File(root(), "Database").apply { mkdirs() }
    fun logsDir(): File = File(root(), "Logs").apply { mkdirs() }
    fun tempDir(): File = File(root(), "Temp").apply { mkdirs() }
    fun pendingDir(): File = File(tempDir(), "pending").apply { mkdirs() }

    fun ensureStructure() {
        root(); imagesDir(); exportsDir(); databaseDir(); logsDir(); tempDir(); pendingDir()
    }

    /** Standard evidence filename, e.g. 2026-08-01_14-30-05_front.jpg */
    fun evidenceFileName(ts: Date, lens: String): String {
        val stamp = SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.US).format(ts)
        return "$stamp" + "_$lens.jpg"
    }

    fun logTag(): String = "ShieldCam"

    /** Appends a line to the native debug log. Never throws. */
    fun writeLog(message: String) {
        try {
            val logFile = File(logsDir(), "native.log")
            if (logFile.length() > 2_000_000) {
                val rotated = File(logsDir(), "native_prev.log")
                rotated.delete()
                logFile.copyTo(rotated, overwrite = true)
                logFile.delete()
            }
            val stamp = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.US).format(Date())
            logFile.appendText("[$stamp] $message\n")
        } catch (_: Exception) {
        }
    }

    // ---------------------------------------------------------------------
    // Pending event hand-off queue
    // ---------------------------------------------------------------------

    fun writePendingEvent(event: JSONObject) {
        try {
            val id = event.optString("id")
            val file = File(pendingDir(), "$id.json")
            file.writeText(event.toString())
        } catch (e: Exception) {
            writeLog("writePendingEvent failed: ${e.message}")
        }
    }

    fun listPendingEvents(): List<JSONObject> {
        val events = mutableListOf<JSONObject>()
        pendingDir().listFiles { f -> f.extension == "json" }?.forEach { f ->
            try {
                events.add(JSONObject(f.readText()))
            } catch (_: Exception) {
                writeLog("Skipping corrupt pending event ${f.name}")
                f.delete()
            }
        }
        return events
    }

    fun deletePendingEvent(id: String) {
        File(pendingDir(), "$id.json").delete()
    }

    // ---------------------------------------------------------------------
    // Simple shared state used by the foreground service / boot receiver.
    // This is native infrastructure state, not structured application data.
    // ---------------------------------------------------------------------

    private val prefs by lazy {
        appContext.getSharedPreferences("shieldcam_monitor", Context.MODE_PRIVATE)
    }

    var monitoringEnabled: Boolean
        get() = if (::appContext.isInitialized) prefs.getBoolean("enabled", false) else false
        set(value) {
            if (::appContext.isInitialized) prefs.edit().putBoolean("enabled", value).apply()
        }
}
