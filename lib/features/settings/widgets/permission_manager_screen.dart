import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shieldcam/core/providers/providers.dart';

/// Central permission status + activation screen.
///
/// Some capabilities (accessibility, battery exemption, device admin) are not
/// runtime permissions - they are user-gated settings that ShieldCam can only
/// open for the user to toggle.
class PermissionManagerScreen extends ConsumerStatefulWidget {
  const PermissionManagerScreen({super.key});

  @override
  ConsumerState<PermissionManagerScreen> createState() => _PermissionManagerScreenState();
}

class _PermissionManagerScreenState extends ConsumerState<PermissionManagerScreen> {
  bool _loading = true;
  bool _accessibility = false;
  bool _batteryExempt = false;
  bool _adminActive = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final platform = ref.read(platformServiceProvider);
    final info = await platform.getDeviceInfo();
    setState(() {
      _accessibility = info.isAccessibilityEnabled;
      _batteryExempt = info.isBatteryOptimizationIgnored;
      _adminActive = info.isDeviceAdminActive;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Permissions let ShieldCam watch the lock screen and capture '
                      'evidence. Everything stays on this device. You can revoke '
                      'any of them at any time.',
                    ),
                  ),
                  _PermissionTile(
                    icon: Icons.accessibility_new,
                    title: 'Accessibility service',
                    subtitle: 'Required to detect failed unlock attempts. '
                        'ShieldCam never reads your PIN, password or pattern.',
                    enabled: _accessibility,
                    actionLabel: _accessibility ? 'Configured' : 'Enable',
                    action: _accessibility
                        ? null
                        : () async {
                            await ref.read(platformServiceProvider).openAccessibilitySettings();
                          },
                  ),
                  _PermissionTile(
                    icon: Icons.battery_charging_full,
                    title: 'Battery optimization exemption',
                    subtitle: 'Stops Android from killing monitoring in the background.',
                    enabled: _batteryExempt,
                    actionLabel: _batteryExempt ? 'Exempt' : 'Exempt',
                    action: _batteryExempt
                        ? null
                        : () async {
                            await ref.read(platformServiceProvider).requestIgnoreBatteryOptimizations();
                          },
                  ),
                  _PermissionTile(
                    icon: Icons.admin_panel_settings,
                    title: 'Device admin',
                    subtitle: 'Optional. Allows ShieldCam to lock the device on demand.',
                    enabled: _adminActive,
                    actionLabel: _adminActive ? 'Active' : 'Activate',
                    action: _adminActive
                        ? () async {
                            await ref.read(platformServiceProvider).deactivateDeviceAdmin();
                            await _refresh();
                          }
                        : () async {
                            await ref.read(platformServiceProvider).activateDeviceAdmin();
                          },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.actionLabel,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final String actionLabel;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: enabled ? Colors.green.shade700 : theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: enabled
            ? Icon(Icons.check_circle, color: Colors.green.shade700)
            : action == null
                ? TextButton(onPressed: null, child: Text(actionLabel))
                : FilledButton.tonal(onPressed: action, child: Text(actionLabel)),
      ),
    );
  }
}
