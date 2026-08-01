import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/navigation/app_router.dart';
import 'package:shieldcam/services/detection/detection_service.dart';
import 'package:shieldcam/services/logging/app_logger.dart';
import 'package:shieldcam/services/monitoring/monitoring_service.dart';
import 'package:shieldcam/services/settings/settings_service.dart';
import 'package:shieldcam/services/storage/storage_service.dart';

/// Bootstraps the app and routes to onboarding, app-lock or the home shell.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (_started) return;
    _started = true;

    try {
      final settings = ref.read(settingsServiceProvider);
      final monitoring = ref.read(monitoringServiceProvider);
      final detection = ref.read(detectionServiceProvider);
      final storage = ref.read(storageServiceProvider);

      await monitoring.refresh();
      await detection.start();

      final appSettings = await settings.getSettings();

      // Background maintenance.
      unawaited(storage.applyAutoDelete(appSettings.autoDeleteDays));
      unawaited(storage.removeOrphans());

      // Automatic restart of monitoring when the app was monitoring before.
      if (appSettings.monitoringEnabled && !monitoring.isActive) {
        unawaited(monitoring.start().catchError((Object e) {
          AppLogger.e('Monitoring auto-start failed', e);
          return false;
        }));
      }

      await _route(appSettings.onboarded);
    } catch (e, s) {
      AppLogger.e('Bootstrap failed', e, s);
      await _route(false);
    }
  }

  Future<void> _route(bool onboarded) async {
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final settings = ref.read(settingsServiceProvider);
    final locked = await settings.appLockEnabled && await settings.hasPin();

    final target = !onboarded
        ? AppRoutes.onboarding
        : locked
            ? AppRoutes.appLock
            : AppRoutes.dashboard;
    context.go(target);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 52),
            ),
            const SizedBox(height: 24),
            Text(
              'ShieldCam',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Protecting your device, offline.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
