import 'package:shieldcam/models/device_info_snapshot.dart';
import 'package:shieldcam/services/logging/app_logger.dart';
import 'package:shieldcam/services/platform/platform_service.dart';

/// Controls the background monitoring lifecycle (native foreground service,
/// accessibility watchdog, boot restart) and reports its current status.
class MonitoringService {
  MonitoringService(this._platform);

  final PlatformService _platform;

  bool _active = false;

  bool get isActive => _active;

  Future<bool> start() async {
    try {
      _active = await _platform.startMonitoring();
      AppLogger.i('Monitoring started: $_active');
      return _active;
    } catch (e, s) {
      AppLogger.e('Failed to start monitoring', e, s);
      rethrow;
    }
  }

  Future<bool> stop() async {
    try {
      _active = !(await _platform.stopMonitoring());
      AppLogger.i('Monitoring stopped');
      return !_active;
    } catch (e, s) {
      AppLogger.e('Failed to stop monitoring', e, s);
      rethrow;
    }
  }

  Future<void> refresh() async {
    _active = await _platform.isMonitoringActive();
  }

  Future<DeviceInfoSnapshot> deviceInfo() => _platform.getDeviceInfo();

  Future<Map<String, dynamic>> lockState() => _platform.getLockState();

  /// Runs the full native evidence pipeline once (used by the dashboard
  /// "test detection" action and for verifying the module end-to-end).
  Future<void> triggerTestDetection() => _platform.triggerTest();
}
