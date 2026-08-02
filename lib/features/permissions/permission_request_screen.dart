import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/navigation/app_router.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

/// Onboarding permission flow. Requests runtime permissions and guides the
/// user through the settings-gated capabilities (accessibility, battery).
class PermissionRequestScreen extends ConsumerStatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  ConsumerState<PermissionRequestScreen> createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends ConsumerState<PermissionRequestScreen> {
  bool _starting = false;

  Future<void> _request(Permission permission) async {
    try {
      final status = await permission.request();
      await _openIfDenied(permission, status);
    } catch (e, s) {
      AppLogger.e('Permission request failed', e, s);
    }
    setState(() {});
  }

  Future<void> _openIfDenied(Permission permission, PermissionStatus status) async {
    if (status.isDenied && !status.isPermanentlyDenied) return;
    if (status.isPermanentlyDenied || (await permission.isPermanentlyDenied)) {
      if (mounted) {
        final open = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission blocked'),
            content: const Text('Open app settings to allow this permission.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Not now')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Open settings')),
            ],
          ),
        );
        if (open == true) await openAppSettings();
      }
    }
  }

  Future<void> _finish() async {
    if (_starting) return;
    setState(() => _starting = true);

    final settings = ref.read(settingsServiceProvider);
    final monitoring = ref.read(monitoringServiceProvider);
    await settings.setOnboarded();
    await settings.setMonitoringEnabled(true);
    try {
      await monitoring.start();
    } catch (e, s) {
      AppLogger.e('Start monitoring during onboarding failed', e, s);
    }
    if (mounted) context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platform = ref.watch(platformServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Set up ShieldCam')),
      body: FutureBuilder(
        future: _loadStatuses(platform),
        builder: (context, snapshot) {
          final sdk = snapshot.data;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Grant the permissions below so ShieldCam can watch your lock '
                  'screen and capture evidence. Everything stays on your device.',
                ),
              ),
              _RuntimePermission(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Capture evidence photos',
                status: sdk?.camera ?? false,
                onTap: () => _request(Permission.camera),
              ),
              _RuntimePermission(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Show the monitoring status notification',
                status: sdk?.notification ?? false,
                onTap: () => _request(Permission.notification),
              ),
              _RuntimePermission(
                icon: Icons.location_on_outlined,
                title: 'Location',
                subtitle: 'Record GPS coordinates with each event',
                status: sdk?.location ?? false,
                onTap: () => _request(Permission.locationWhenInUse),
              ),
              _RuntimePermission(
                icon: Icons.location_searching,
                title: 'Background location',
                subtitle: 'Location even when ShieldCam is in the background',
                status: sdk?.backgroundLocation ?? false,
                onTap: () async {
                  await _request(Permission.locationAlways);
                  setState(() {});
                },
              ),
              _GuidedPermission(
                icon: Icons.accessibility_new,
                title: 'Accessibility service',
                subtitle: 'Detect failed unlock attempts',
                enabled: sdk?.accessibility ?? false,
                onTap: () async {
                  await platform.openAccessibilitySettings();
                  setState(() {});
                },
                platform: platform,
              ),
              _GuidedPermission(
                icon: Icons.battery_charging_full,
                title: 'Battery optimization',
                subtitle: 'Keep monitoring running in the background',
                enabled: sdk?.batteryExempt ?? false,
                onTap: () async {
                  await platform.requestIgnoreBatteryOptimizations();
                  setState(() {});
                },
                platform: platform,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _starting ? null : _finish,
                    child: _starting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text('Start monitoring'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Text(
                  'You can change or revoke any permission later from Settings.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<_StatusBundle> _loadStatuses(dynamic platform) async {
    final camera = await Permission.camera.isGranted;
    final notification = await Permission.notification.isGranted;
    final location = await Permission.locationWhenInUse.isGranted;
    final background = await Permission.locationAlways.isGranted;
    final info = await platform.getDeviceInfo();
    return _StatusBundle(
      camera: camera,
      notification: notification,
      location: location,
      backgroundLocation: background,
      accessibility: info.isAccessibilityEnabled,
      batteryExempt: info.isBatteryOptimizationIgnored,
    );
  }
}

class _StatusBundle {
  final bool camera;
  final bool notification;
  final bool location;
  final bool backgroundLocation;
  final bool accessibility;
  final bool batteryExempt;

  const _StatusBundle({
    required this.camera,
    required this.notification,
    required this.location,
    required this.backgroundLocation,
    required this.accessibility,
    required this.batteryExempt,
  });
}

class _RuntimePermission extends StatelessWidget {
  const _RuntimePermission({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, color: status ? Colors.green.shade700 : theme.colorScheme.onSurfaceVariant),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: status
            ? Icon(Icons.check_circle, color: Colors.green.shade700)
            : FilledButton.tonal(onPressed: onTap, child: const Text('Allow')),
      ),
    );
  }
}

class _GuidedPermission extends ConsumerStatefulWidget {
  const _GuidedPermission({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
    required this.platform,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;
  final dynamic platform;

  @override
  ConsumerState<_GuidedPermission> createState() => _GuidedPermissionState();
}

class _GuidedPermissionState extends ConsumerState<_GuidedPermission> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(
          widget.icon,
          color: widget.enabled ? Colors.green.shade700 : theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        trailing: widget.enabled
            ? Icon(Icons.check_circle, color: Colors.green.shade700)
            : FilledButton.tonal(onPressed: widget.onTap, child: const Text('Open settings')),
      ),
    );
  }
}
