/// Global application constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'ShieldCam';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.shieldcam.app';
  static const String providerAuthority = 'com.shieldcam.app.fileprovider';

  /// Method channel used to talk to the native Android layer.
  static const String platformMethodChannel = 'com.shieldcam.platform';
  static const String platformEventChannel = 'com.shieldcam.events';

  /// Maximum number of detections to keep in memory at once (pagination).
  static const int pageSize = 24;

  /// Automatic cleanup interval for orphaned image files.
  static const Duration storageMaintenanceInterval = Duration(hours: 6);
}
