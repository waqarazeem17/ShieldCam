import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shieldcam/core/constants/app_constants.dart';
import 'package:shieldcam/models/device_info_snapshot.dart';
import 'package:shieldcam/models/platform_event.dart';

/// Thin wrapper over the native method + event channels.
class PlatformService {
  static const _channel = MethodChannel(AppConstants.platformMethodChannel);
  static const _events = EventChannel(AppConstants.platformEventChannel);

  Stream<PlatformEvent>? _eventStream;

  Future<DeviceInfoSnapshot> getDeviceInfo() async {
    final map = await _channel.invokeMapMethod<String, dynamic>('getDeviceInfo');
    return DeviceInfoSnapshot.fromMap(map ?? {});
  }

  Future<String> getStorageRoot() async {
    return await _channel.invokeMethod<String>('getStorageRoot') ?? '';
  }

  Future<bool> startMonitoring() async {
    return await _channel.invokeMethod<bool>('startMonitoring') ?? false;
  }

  Future<bool> stopMonitoring() async {
    return await _channel.invokeMethod<bool>('stopMonitoring') ?? false;
  }

  Future<bool> isMonitoringActive() async {
    return await _channel.invokeMethod<bool>('isMonitoringActive') ?? false;
  }

  Future<bool> isAccessibilityEnabled() async {
    return await _channel.invokeMethod<bool>('isAccessibilityEnabled') ?? false;
  }

  Future<void> openAccessibilitySettings() =>
      _channel.invokeMethod<void>('openAccessibilitySettings');

  Future<bool> isBatteryOptimizationIgnored() async {
    return await _channel.invokeMethod<bool>('isBatteryOptimizationIgnored') ?? false;
  }

  Future<void> requestIgnoreBatteryOptimizations() =>
      _channel.invokeMethod<void>('requestIgnoreBatteryOptimizations');

  Future<bool> isDeviceAdminActive() async {
    return await _channel.invokeMethod<bool>('isDeviceAdminActive') ?? false;
  }

  Future<void> activateDeviceAdmin() =>
      _channel.invokeMethod<void>('activateDeviceAdmin');

  Future<void> deactivateDeviceAdmin() =>
      _channel.invokeMethod<void>('deactivateDeviceAdmin');

  Future<void> lockDeviceNow() => _channel.invokeMethod<void>('lockDeviceNow');

  Future<void> triggerTest() => _channel.invokeMethod<void>('triggerTest');

  Future<Map<String, dynamic>> getLockState() async {
    return await _channel.invokeMapMethod<String, dynamic>('getLockState') ?? {};
  }

  /// Stream of native detection events and lock-state updates.
  Stream<PlatformEvent> get eventStream {
    if (_eventStream != null) return _eventStream!;
    _eventStream = _events
        .receiveBroadcastStream()
        .map((event) {
          if (event is Map) {
            return PlatformEvent.fromMap(Map<dynamic, dynamic>.from(event));
          }
          if (event is String) {
            final decoded = jsonDecode(event);
            if (decoded is Map) {
              return PlatformEvent.fromMap(Map<dynamic, dynamic>.from(decoded));
            }
          }
          return const PlatformEvent(type: 'unknown');
        })
        .asBroadcastStream();
    return _eventStream!;
  }

  /// Events produced while the Flutter engine was not attached.
  Future<List<Map<String, dynamic>>> getPendingEvents() async {
    final raw = await _channel.invokeMethod<List<dynamic>>('getPendingEvents');
    final result = <Map<String, dynamic>>[];
    for (final item in raw ?? <dynamic>[]) {
      if (item is String) {
        try {
          result.add(jsonDecode(item) as Map<String, dynamic>);
        } catch (_) {
          // Skip malformed entries.
        }
      }
    }
    return result;
  }

  Future<void> clearPendingEvent(String id) =>
      _channel.invokeMethod<void>('clearPendingEvent', {'id': id});

  /// Shares one or more files using the system share sheet (native FileProvider).
  Future<bool> shareFiles(List<String> paths) async {
    return await _channel.invokeMethod<bool>('shareFiles', {'paths': paths}) ?? false;
  }
}
