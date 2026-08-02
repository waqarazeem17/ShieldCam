import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/core/theme/app_theme.dart';
import 'package:shieldcam/models/app_settings.dart';
import 'package:shieldcam/navigation/app_router.dart';
import 'package:shieldcam/services/logging/app_logger.dart';
import 'package:shieldcam/services/settings/settings_service.dart';

final routerProvider = Provider<GoRouter>((ref) => buildRouter());

/// Reactive settings state for the whole app.
class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._service) : super(AppSettings()) {
    _load();
  }

  final SettingsService _service;

  Future<void> _load() async {
    try {
      final settings = await _service.getSettings();
      state = settings;
    } catch (e, s) {
      AppLogger.e('Failed to load settings', e, s);
    }
  }

  Future<void> setThemeMode(String mode) async {
    await _service.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setCaptureFront(bool value) async {
    await _service.setCaptureFront(value);
    state = state.copyWith(captureFront: value);
  }

  Future<void> setCaptureRear(bool value) async {
    await _service.setCaptureRear(value);
    state = state.copyWith(captureRear: value);
  }

  Future<void> setEnableLocation(bool value) async {
    await _service.setEnableLocation(value);
    state = state.copyWith(enableLocation: value);
  }

  Future<void> setImageQuality(int value) async {
    await _service.setImageQuality(value);
    state = state.copyWith(imageQuality: value);
  }

  Future<void> setAutoDeleteDays(int value) async {
    await _service.setAutoDeleteDays(value);
    state = state.copyWith(autoDeleteDays: value);
  }

  Future<void> setAppLockEnabled(bool value) async {
    await _service.setAppLockEnabled(value);
    state = state.copyWith(appLockEnabled: value);
  }

  Future<void> setMonitoringEnabled(bool value) async {
    await _service.setMonitoringEnabled(value);
    state = state.copyWith(monitoringEnabled: value);
  }

  Future<void> setOnboarded() async {
    await _service.setOnboarded();
    state = state.copyWith(onboarded: true);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>(
  (ref) => SettingsController(ref.watch(settingsServiceProvider)),
);

/// The root application widget.
class ShieldCamApp extends ConsumerWidget {
  const ShieldCamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final router = ref.watch(routerProvider);

    final ThemeMode themeMode;
    switch (settings.themeMode) {
      case 'light':
        themeMode = ThemeMode.light;
      case 'dark':
        themeMode = ThemeMode.dark;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp.router(
      title: 'ShieldCam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

extension on AppSettings {
  AppSettings copyWith({
    String? themeMode,
    bool? captureFront,
    bool? captureRear,
    bool? enableLocation,
    int? imageQuality,
    int? autoDeleteDays,
    bool? appLockEnabled,
    bool? monitoringEnabled,
    bool? onboarded,
  }) {
    return AppSettings()
      ..id = id
      ..themeMode = themeMode ?? this.themeMode
      ..captureFront = captureFront ?? this.captureFront
      ..captureRear = captureRear ?? this.captureRear
      ..enableLocation = enableLocation ?? this.enableLocation
      ..imageQuality = imageQuality ?? this.imageQuality
      ..autoDeleteDays = autoDeleteDays ?? this.autoDeleteDays
      ..appLockEnabled = appLockEnabled ?? this.appLockEnabled
      ..monitoringEnabled = monitoringEnabled ?? this.monitoringEnabled
      ..onboarded = onboarded ?? this.onboarded
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}
