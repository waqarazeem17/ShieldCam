import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shieldcam/app.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/core/utils/app_folders.dart';
import 'package:shieldcam/features/settings/widgets/pin_dialogs.dart';
import 'package:shieldcam/services/logging/app_logger.dart';
import 'package:shieldcam/services/settings/settings_service.dart';
import 'package:shieldcam/services/storage/storage_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final settingsService = ref.read(settingsServiceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader('Appearance'),
          RadioListTile<String>(
            value: 'light',
            groupValue: settings.themeMode,
            onChanged: (v) => controller.setThemeMode(v!),
            title: const Text('Light theme'),
            secondary: const Icon(Icons.light_mode_outlined),
          ),
          RadioListTile<String>(
            value: 'dark',
            groupValue: settings.themeMode,
            onChanged: (v) => controller.setThemeMode(v!),
            title: const Text('Dark theme'),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          RadioListTile<String>(
            value: 'system',
            groupValue: settings.themeMode,
            onChanged: (v) => controller.setThemeMode(v!),
            title: const Text('System theme'),
            secondary: const Icon(Icons.brightness_auto_outlined),
          ),

          _SectionHeader('Evidence capture'),
          SwitchListTile(
            secondary: const Icon(Icons.camera_front_outlined),
            title: const Text('Front camera'),
            subtitle: const Text('Capture a photo with the front camera'),
            value: settings.captureFront,
            onChanged: controller.setCaptureFront,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.camera_rear_outlined),
            title: const Text('Rear camera'),
            subtitle: const Text('Capture a photo with the rear camera'),
            value: settings.captureRear,
            onChanged: controller.setCaptureRear,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.location_on_outlined),
            title: const Text('Enable location'),
            subtitle: const Text('Record GPS coordinates with each event'),
            value: settings.enableLocation,
            onChanged: controller.setEnableLocation,
          ),
          ListTile(
            leading: const Icon(Icons.high_quality_outlined),
            title: const Text('Image quality'),
            subtitle: Text('JPEG quality: ${settings.imageQuality}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickQuality(context, ref, settings.imageQuality),
          ),

          _SectionHeader('Storage'),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Auto delete'),
            subtitle: Text(_autoDeleteLabel(settings.autoDeleteDays)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickAutoDelete(context, ref, settings.autoDeleteDays),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Storage folder'),
            subtitle: const Text('On-device, private to ShieldCam'),
            onTap: () => _showFolders(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('Clear cache'),
            subtitle: const Text('Remove thumbnails and temporary files'),
            onTap: () => _clearCache(context, ref),
          ),

          _SectionHeader('Security'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('App lock'),
            subtitle: Text(
              settings.appLockEnabled ? 'PIN protection enabled' : 'Lock ShieldCam behind a PIN',
            ),
            trailing: settings.appLockEnabled
                ? const Icon(Icons.chevron_right)
                : const Switch(value: false, onChanged: null),
            onTap: () => _appLockTap(context, ref, settingsService, settings.appLockEnabled),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text('Permission manager'),
            subtitle: const Text('Review and grant permissions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/permissions'),
          ),
          ListTile(
            leading: const Icon(Icons.battery_charging_full),
            title: const Text('Battery optimization guide'),
            subtitle: const Text('Keep monitoring reliable in the background'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/battery'),
          ),

          _SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy policy'),
            subtitle: const Text('Everything stays on your device'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About ShieldCam'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/about'),
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Reset settings'),
            subtitle: const Text('Restore default preferences'),
            onTap: () => _resetSettings(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: theme.colorScheme.error),
            title: Text('Delete all data', style: TextStyle(color: theme.colorScheme.error)),
            subtitle: const Text('Remove all events, photos and exports'),
            onTap: () => _deleteAllData(context, ref),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _autoDeleteLabel(int days) {
    if (days <= 0) return 'Never';
    return 'After $days days';
  }

  Future<void> _pickQuality(BuildContext context, WidgetRef ref, int current) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('JPEG quality'),
        children: [70, 80, 90, 92, 95, 100].map((q) {
          return RadioListTile<int>(
            value: q,
            groupValue: current,
            onChanged: (v) => Navigator.pop(context, v),
            title: Text(q >= 92 ? '$q (high)' : '$q (smaller files)'),
          );
        }).toList(),
      ),
    );
    if (result != null) {
      await ref.read(settingsControllerProvider.notifier).setImageQuality(result);
    }
  }

  Future<void> _pickAutoDelete(BuildContext context, WidgetRef ref, int current) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Auto delete events'),
        children: [
          _autoOption(context, 'Never', 0, current),
          _autoOption(context, 'After 7 days', 7, current),
          _autoOption(context, 'After 30 days', 30, current),
          _autoOption(context, 'After 90 days', 90, current),
        ],
      ),
    );
    if (result != null) {
      await ref.read(settingsControllerProvider.notifier).setAutoDeleteDays(result);
    }
  }

  Widget _autoOption(BuildContext context, String label, int value, int current) {
    return RadioListTile<int>(
      value: value,
      groupValue: current,
      onChanged: (v) => Navigator.pop(context, v),
      title: Text(label),
    );
  }

  Future<void> _showFolders(BuildContext context, WidgetRef ref) async {
    final storage = ref.read(storageServiceProvider);
    final images = await AppFolders.images();
    final exports = await AppFolders.exports();
    final total = await storage.totalBytes();
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Images\n${images.path}'),
            const SizedBox(height: 12),
            Text('Exports\n${exports.path}'),
            const SizedBox(height: 12),
            Text('Total used: ${StorageService.formatBytes(total)}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final storage = ref.read(storageServiceProvider);
    final thumbs = ref.read(thumbnailServiceProvider);
    await storage.clearCache();
    await thumbs.clear();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared')),
      );
    }
  }

  Future<void> _appLockTap(
    BuildContext context,
    WidgetRef ref,
    SettingsService settingsService,
    bool enabled,
  ) async {
    if (!enabled) {
      final pin = await showPinSetupDialog(context);
      if (pin != null) {
        await settingsService.setPin(pin);
        await ref.read(settingsControllerProvider.notifier).setAppLockEnabled(true);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App lock enabled')),
          );
        }
      }
    } else {
      final action = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.change_circle_outlined),
                title: const Text('Change PIN'),
                onTap: () => Navigator.pop(context, 'change'),
              ),
              ListTile(
                leading: const Icon(Icons.lock_open_outlined),
                title: const Text('Disable app lock'),
                onTap: () => Navigator.pop(context, 'disable'),
              ),
            ],
          ),
        ),
      );
      if (action == 'change') {
        final verified = await showPinVerifyDialog(context, settingsService);
        if (verified) {
          final pin = await showPinSetupDialog(context);
          if (pin != null) {
            await settingsService.setPin(pin);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN changed')),
              );
            }
          }
        }
      } else if (action == 'disable') {
        final verified = await showPinVerifyDialog(context, settingsService);
        if (verified) {
          await settingsService.removePin();
          await ref.read(settingsControllerProvider.notifier).setAppLockEnabled(false);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('App lock disabled')),
            );
          }
        }
      }
    }
  }

  Future<void> _resetSettings(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset settings?'),
        content: const Text('All preferences will be restored to defaults. Your events are kept.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final settingsService = ref.read(settingsServiceProvider);
      await settingsService.resetSettings();
      ref.invalidate(settingsControllerProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings reset')),
      );
    }
  }

  Future<void> _deleteAllData(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all data?'),
        content: const Text('This permanently deletes every event, all evidence photos and all exports. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(storageServiceProvider).deleteAllData();
        messenger.showSnackBar(const SnackBar(content: Text('All data deleted')));
      } catch (e, s) {
        AppLogger.e('deleteAllData failed', e, s);
        messenger.showSnackBar(const SnackBar(content: Text('Deletion failed')));
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
