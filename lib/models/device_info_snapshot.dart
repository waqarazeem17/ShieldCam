/// Read-only snapshot of device / system / permission state, received from
/// the native Kotlin layer through the method channel.
class DeviceInfoSnapshot {
  final String deviceModel;
  final String manufacturer;
  final String androidVersion;
  final int sdkInt;
  final int? batteryLevel;
  final bool batteryCharging;
  final bool isMonitoringActive;
  final bool isAccessibilityEnabled;
  final bool isBatteryOptimizationIgnored;
  final bool isDeviceAdminActive;

  const DeviceInfoSnapshot({
    required this.deviceModel,
    required this.manufacturer,
    required this.androidVersion,
    required this.sdkInt,
    required this.batteryLevel,
    required this.batteryCharging,
    required this.isMonitoringActive,
    required this.isAccessibilityEnabled,
    required this.isBatteryOptimizationIgnored,
    required this.isDeviceAdminActive,
  });

  factory DeviceInfoSnapshot.fromMap(Map<dynamic, dynamic> map) {
    return DeviceInfoSnapshot(
      deviceModel: (map['deviceModel'] as String?) ?? '',
      manufacturer: (map['manufacturer'] as String?) ?? '',
      androidVersion: (map['androidVersion'] as String?) ?? '',
      sdkInt: (map['sdkInt'] as int?) ?? 0,
      batteryLevel: map['batteryLevel'] as int?,
      batteryCharging: (map['batteryCharging'] as bool?) ?? false,
      isMonitoringActive: (map['isMonitoringActive'] as bool?) ?? false,
      isAccessibilityEnabled: (map['isAccessibilityEnabled'] as bool?) ?? false,
      isBatteryOptimizationIgnored: (map['isBatteryOptimizationIgnored'] as bool?) ?? false,
      isDeviceAdminActive: (map['isDeviceAdminActive'] as bool?) ?? false,
    );
  }
}
