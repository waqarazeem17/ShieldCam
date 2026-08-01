import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';
import 'package:shieldcam/core/widgets/offline_map_preview.dart';
import 'package:shieldcam/features/event_detail/event_detail_controller.dart';
import 'package:shieldcam/models/intrusion_event.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final int eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  int _photoIndex = 0;
  final _notesController = TextEditingController();
  bool _notesLoaded = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventDetailControllerProvider(widget.eventId));
    final controller = ref.read(eventDetailControllerProvider(widget.eventId).notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          if (state.event != null) ...[
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share',
              onPressed: () => _share(context, state.event!),
            ),
            IconButton(
              icon: const Icon(Icons.ios_share_outlined),
              tooltip: 'Export',
              onPressed: () => _export(context, state.event!),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context, controller),
            ),
          ],
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.event == null
              ? _Missing(theme: theme, error: state.error)
              : _buildContent(theme, state.event!, controller),
    );
  }

  Widget _buildContent(ThemeData theme, IntrusionEvent event, EventDetailController controller) {
    final photos = [
      if (event.hasFrontImage) ('Front', event.frontImagePath),
      if (event.hasRearImage) ('Rear', event.rearImagePath),
    ];

    if (!_notesLoaded) {
      _notesLoaded = true;
      _notesController.text = event.notes;
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (photos.isNotEmpty)
          _PhotoViewer(
            photos: photos,
            index: _photoIndex,
            onChanged: (i) => setState(() => _photoIndex = i),
          ),
        _InfoCard(event: event),
        if (event.hasLocation) _LocationCard(event: event),
        _DeviceCard(event: event),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add a private note to this event\u2026',
              ),
              onChanged: (value) => controller.updateNotes(value),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _share(BuildContext context, IntrusionEvent event) async {
    final export = ref.read(exportServiceProvider);
    final platform = ref.read(platformServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file = await export.exportZip([event], name: 'event_${event.uuid.substring(0, 8)}');
      await platform.shareFiles([file.path]);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Share failed: $e')));
    }
  }

  Future<void> _export(BuildContext context, IntrusionEvent event) async {
    final export = ref.read(exportServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final file = await export.exportZip([event], name: 'event_${event.uuid.substring(0, 8)}');
      messenger.showSnackBar(SnackBar(content: Text('Exported: ${file.path}')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _confirmDelete(BuildContext context, EventDetailController controller) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete event?'),
        content: const Text('This permanently deletes the event and its evidence images.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final ok = await controller.delete();
      if (ok && context.mounted) {
        messenger.showSnackBar(const SnackBar(content: Text('Event deleted')));
        context.pop();
      }
    }
  }
}

class _Missing extends StatelessWidget {
  const _Missing({required this.theme, this.error});

  final ThemeData theme;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_busy, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(error ?? 'Event not found', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer({required this.photos, required this.index, required this.onChanged});

  final List<(String, String)> photos;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              itemCount: photos.length,
              onPageChanged: onChanged,
              itemBuilder: (context, i) {
                return Image.file(
                  File(photos[i].$2),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: theme.colorScheme.outline,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
          if (photos.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photos.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.event});

  final IntrusionEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detection', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.schedule,
              label: 'Timestamp',
              value: DateTimeUtils.formatTimestamp(event.timestamp.toLocal()),
            ),
            _InfoRow(
              icon: Icons.tag,
              label: 'Attempt count',
              value: '${event.attemptCount}',
            ),
            _InfoRow(
              icon: Icons.source,
              label: 'Source',
              value: event.source.isEmpty ? 'native' : event.source,
            ),
            if (event.hasLocation)
              _InfoRow(
                icon: Icons.place,
                label: 'Coordinates',
                value: '${event.latitude!.toStringAsFixed(6)}, ${event.longitude!.toStringAsFixed(6)}',
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends ConsumerWidget {
  const _LocationCard({required this.event});

  final IntrusionEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            OfflineMapPreview(
              latitude: event.latitude!,
              longitude: event.longitude!,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Open in Google Maps'),
                    onPressed: () async {
                      final launched = await _openInMaps(event);
                      if (!launched) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Could not open Google Maps')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _openInMaps(IntrusionEvent event) async {
    final uri = Uri.parse('geo:${event.latitude},${event.longitude}?q=${event.latitude},${event.longitude}');
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.event});

  final IntrusionEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.smartphone,
              label: 'Model',
              value: event.deviceModel.isEmpty ? 'Unknown' : '${event.manufacturer} ${event.deviceModel}',
            ),
            _InfoRow(
              icon: Icons.android,
              label: 'Android version',
              value: event.androidVersion.isEmpty ? 'Unknown' : event.androidVersion,
            ),
            _InfoRow(
              icon: Icons.battery_full,
              label: 'Battery',
              value: '${event.batteryLevel ?? 'Unknown'}%${event.batteryCharging ? ' (charging)' : ''}',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
