import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/models/device_info_snapshot.dart';
import 'package:shieldcam/models/intrusion_event.dart';
import 'package:shieldcam/services/detection/detection_service.dart';
import 'package:shieldcam/services/logging/app_logger.dart';
import 'package:shieldcam/services/monitoring/monitoring_service.dart';
import 'package:shieldcam/services/storage/storage_service.dart';

class DashboardState {
  final int todayCount;
  final int weekCount;
  final int monthCount;
  final int totalCount;
  final int storageBytes;
  final DeviceInfoSnapshot deviceInfo;
  final bool monitoringActive;
  final bool locked;
  final IntrusionEvent? latestEvent;
  final bool loading;
  final String? error;

  const DashboardState({
    this.todayCount = 0,
    this.weekCount = 0,
    this.monthCount = 0,
    this.totalCount = 0,
    this.storageBytes = 0,
    this.deviceInfo = const DeviceInfoSnapshot(
      deviceModel: '',
      manufacturer: '',
      androidVersion: '',
      sdkInt: 0,
      batteryLevel: null,
      batteryCharging: false,
      isMonitoringActive: false,
      isAccessibilityEnabled: false,
      isBatteryOptimizationIgnored: false,
      isDeviceAdminActive: false,
    ),
    this.monitoringActive = false,
    this.locked = false,
    this.latestEvent,
    this.loading = true,
    this.error,
  });

  DashboardState copyWith({
    int? todayCount,
    int? weekCount,
    int? monthCount,
    int? totalCount,
    int? storageBytes,
    DeviceInfoSnapshot? deviceInfo,
    bool? monitoringActive,
    bool? locked,
    IntrusionEvent? latestEvent,
    bool? loading,
    String? error,
  }) {
    return DashboardState(
      todayCount: todayCount ?? this.todayCount,
      weekCount: weekCount ?? this.weekCount,
      monthCount: monthCount ?? this.monthCount,
      totalCount: totalCount ?? this.totalCount,
      storageBytes: storageBytes ?? this.storageBytes,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      monitoringActive: monitoringActive ?? this.monitoringActive,
      locked: locked ?? this.locked,
      latestEvent: latestEvent ?? this.latestEvent,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._ref) : super(const DashboardState()) {
    _monitoring = _ref.read(monitoringServiceProvider);
    _repository = _ref.read(eventRepositoryProvider);
    _storage = _ref.read(storageServiceProvider);
    _detection = _ref.read(detectionServiceProvider);
    _sub = _detection.onEvent.listen((_) => refresh());
    _watch = _repository.watchAll().listen((_) => refresh());
    refresh();
  }

  final Ref _ref;
  late final MonitoringService _monitoring;
  late final EventRepository _repository;
  late final StorageService _storage;
  late final DetectionService _detection;
  late final StreamSubscription<IntrusionEvent> _sub;
  late final StreamSubscription<List<IntrusionEvent>> _watch;

  Future<void> refresh() async {
    try {
      final today = await _repository.countToday();
      final week = await _repository.countThisWeek();
      final month = await _repository.countThisMonth();
      final total = await _repository.countAll();
      final bytes = await _storage.totalBytes();
      final info = await _monitoring.deviceInfo();
      final lockState = await _monitoring.lockState();
      final latest = await _repository.latest();

      state = state.copyWith(
        todayCount: today,
        weekCount: week,
        monthCount: month,
        totalCount: total,
        storageBytes: bytes,
        deviceInfo: info,
        monitoringActive: info.isMonitoringActive,
        locked: (lockState['locked'] as bool?) ?? false,
        latestEvent: latest,
        loading: false,
        error: null,
      );
    } catch (e, s) {
      AppLogger.e('Dashboard refresh failed', e, s);
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  Future<bool> toggleMonitoring() async {
    try {
      if (state.monitoringActive) {
        await _monitoring.stop();
        await _ref.read(settingsServiceProvider).setMonitoringEnabled(false);
      } else {
        await _monitoring.start();
        await _ref.read(settingsServiceProvider).setMonitoringEnabled(true);
      }
      await refresh();
      return true;
    } catch (e, s) {
      AppLogger.e('toggleMonitoring failed', e, s);
      state = state.copyWith(error: '$e');
      return false;
    }
  }

  Future<void> triggerTestDetection() async {
    await _monitoring.triggerTestDetection();
  }

  @override
  void dispose() {
    _sub.cancel();
    _watch.cancel();
    super.dispose();
  }
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>(
  (ref) => DashboardController(ref),
);
