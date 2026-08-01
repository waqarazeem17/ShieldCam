import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';
import 'package:shieldcam/features/dashboard/dashboard_controller.dart';
import 'package:shieldcam/features/dashboard/widgets/quick_actions.dart';
import 'package:shieldcam/features/dashboard/widgets/stat_card.dart';
import 'package:shieldcam/models/intrusion_event.dart';
import 'package:shieldcam/navigation/app_router.dart';
import 'package:shieldcam/services/storage/storage_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: _MonitoringChip(
                active: state.monitoringActive,
                onTap: () => controller.toggleMonitoring(),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _HeroCard(state: state, theme: theme),
            QuickActions(
              onTest: () => _runTest(context, ref, controller),
              onExport: () => _exportAll(context, ref),
              onGallery: () => context.go(AppRoutes.gallery),
            ),
            _StatsGrid(state: state),
            _StorageCard(state: state, theme: theme),
            _MonitoringCard(state: state, theme: theme),
            if (state.latestEvent != null)
              _LatestEventCard(
                event: state.latestEvent!,
                onTap: () => context.push(AppRoutes.eventDetailFor(state.latestEvent!.id)),
              ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Refresh failed: ${state.error}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _runTest(BuildContext context, WidgetRef ref, DashboardController controller) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Capturing test evidence\u2026')),
    );
    await controller.triggerTestDetection();
    messenger.showSnackBar(
      const SnackBar(content: Text('Test detection completed')),
    );
  }

  Future<void> _exportAll(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(eventRepositoryProvider);
    final export = ref.read(exportServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      messenger.showSnackBar(
        const SnackBar(content: Text('Building export archive\u2026')),
      );
      final events = await repository.getAll();
      final file = await export.exportZip(events, name: 'shieldcam_backup');
      messenger.showSnackBar(
        SnackBar(content: Text('Exported ${events.length} events: ${file.path}')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }
}

class _MonitoringChip extends StatelessWidget {
  const _MonitoringChip({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.green.shade700 : Theme.of(context).colorScheme.outline;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 10, color: active ? Colors.green.shade700 : color),
            const SizedBox(width: 6),
            Text(
              active ? 'Active' : 'Off',
              style: TextStyle(
                color: active ? Colors.green.shade700 : color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.state, required this.theme});

  final DashboardState state;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            Color.lerp(theme.colorScheme.primary, theme.colorScheme.tertiary, 0.5)!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total detections',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.totalCount}',
            style: theme.textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.locked ? 'Device is currently locked' : 'Device is unlocked',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.today,
              label: 'Today',
              value: '${state.todayCount}',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: StatCard(
              icon: Icons.date_range,
              label: 'This week',
              value: '${state.weekCount}',
              color: const Color(0xFF7B4FB0),
            ),
          ),
          Expanded(
            child: StatCard(
              icon: Icons.calendar_month,
              label: 'This month',
              value: '${state.monthCount}',
              color: const Color(0xFF2E8B57),
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageCard extends StatelessWidget {
  const _StorageCard({required this.state, required this.theme});

  final DashboardState state;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final bytes = state.storageBytes;
    final total = 500 * 1024 * 1024; // Soft 500 MB budget indicator.
    final fraction = total == 0 ? 0.0 : (bytes / total).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text('Storage usage', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  StorageService.formatBytes(bytes),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All data stays on this device only.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonitoringCard extends StatelessWidget {
  const _MonitoringCard({required this.state, required this.theme});

  final DashboardState state;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final info = state.deviceInfo;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_heart_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text('System health', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            _HealthRow(
              icon: Icons.security,
              label: 'Monitoring',
              ok: state.monitoringActive,
              status: state.monitoringActive ? 'Running' : 'Stopped',
            ),
            _HealthRow(
              icon: Icons.lock_outline,
              label: 'Accessibility service',
              ok: info.isAccessibilityEnabled,
              status: info.isAccessibilityEnabled ? 'Enabled' : 'Not enabled',
            ),
            _HealthRow(
              icon: Icons.battery_charging_full,
              label: 'Battery optimization',
              ok: info.isBatteryOptimizationIgnored,
              status: info.isBatteryOptimizationIgnored ? 'Exempt' : 'Not exempt',
            ),
            _HealthRow(
              icon: Icons.camera_alt_outlined,
              label: 'Camera permission',
              ok: info.sdkInt > 0,
              status: info.sdkInt > 0 ? 'Available' : 'Unknown',
            ),
            if (info.batteryLevel != null)
              _HealthRow(
                icon: Icons.battery_std,
                label: 'Battery level',
                ok: true,
                status: '${info.batteryLevel}%',
              ),
            _HealthRow(
              icon: Icons.smartphone,
              label: 'Device',
              ok: true,
              status: info.deviceModel.isEmpty
                  ? 'Unknown'
                  : '${info.manufacturer} ${info.deviceModel}',
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow({
    required this.icon,
    required this.label,
    required this.ok,
    required this.status,
  });

  final IconData icon;
  final String label;
  final bool ok;
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Text(
            status,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ok ? Colors.green.shade700 : theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestEventCard extends StatelessWidget {
  const _LatestEventCard({required this.event, required this.onTap});

  final IntrusionEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = event.hasFrontImage ? event.frontImagePath : (event.hasRearImage ? event.rearImagePath : null);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: preview != null
                      ? Image.file(
                          File(preview),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest event',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateTimeUtils.formatTimestamp(event.timestamp.toLocal()),
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Attempt #${event.attemptCount}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.image_not_supported_outlined),
    );
  }
}
