# ShieldCam ProGuard rules.
# Keep Isar model classes and their generated code.
-keep class com.shieldcam.app.** { *; }

# Keep Kotlin metadata required by reflection-free serialization.
-keep class com.shieldcam.app.models.** { *; }

-dontwarn kotlinx.serialization.**
