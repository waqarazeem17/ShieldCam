import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';
import 'package:shieldcam/features/gallery/gallery_controller.dart';
import 'package:shieldcam/features/gallery/widgets/event_image_tile.dart';
import 'package:shieldcam/features/gallery/widgets/filter_sheet.dart';
import 'package:shieldcam/models/intrusion_event.dart';
import 'package:shieldcam/navigation/app_router.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  bool _searching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(galleryControllerProvider);
    final controller = ref.read(galleryControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search events\u2026',
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: controller.setQuery,
              )
            : const Text('Gallery'),
        actions: [
          if (!_searching)
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                setState(() => _searching = true);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close search',
              onPressed: () {
                _searchController.clear();
                controller.setQuery('');
                setState(() => _searching = false);
              },
            ),
          IconButton(
            icon: Icon(state.gridView ? Icons.view_list_outlined : Icons.grid_view_outlined),
            tooltip: state.gridView ? 'Switch to list' : 'Switch to grid',
            onPressed: () => controller.setGridView(!state.gridView),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _FilterBar(
            state: state,
            onSortChanged: controller.setSort,
            onOpenFilters: () => _openFilters(context, state, controller),
            hasActiveFilters: state.query.isNotEmpty ||
                state.fromDate != null ||
                state.year != null ||
                state.onlyWithLocation,
            onClear: controller.clearFilters,
          ),
        ),
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.events.isEmpty
              ? _EmptyState(
                  onReset: controller.clearFilters,
                  hasFilters: state.query.isNotEmpty ||
                      state.fromDate != null ||
                      state.year != null ||
                      state.onlyWithLocation,
                )
              : state.gridView
                  ? _buildGrid(state.events, theme)
                  : _buildList(state.events, theme),
    );
  }

  Widget _buildGrid(List<IntrusionEvent> events, ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventImageTile(
          event: event,
          onTap: () => context.push(AppRoutes.eventDetailFor(event.id)),
        );
      },
    );
  }

  Widget _buildList(List<IntrusionEvent> events, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _ListTile(
          event: event,
          onTap: () => context.push(AppRoutes.eventDetailFor(event.id)),
        );
      },
    );
  }

  Future<void> _openFilters(
    BuildContext context,
    GalleryState state,
    GalleryController controller,
  ) async {
    final result = await showModalBottomSheet<FilterSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => FilterSheet(
        currentYear: state.year,
        currentMonth: state.month,
        fromDate: state.fromDate,
        toDate: state.toDate,
        onlyWithLocation: state.onlyWithLocation,
      ),
    );
    if (result != null) {
      controller.setDateRange(result.from, result.to);
      controller.setYear(null);
      controller.setMonth(null, null);
      if (result.byLocation) controller.setOnlyWithLocation(true);
    }
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.state,
    required this.onSortChanged,
    required this.onOpenFilters,
    required this.hasActiveFilters,
    required this.onClear,
  });

  final GalleryState state;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onOpenFilters;
  final bool hasActiveFilters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          _Chip(
            icon: Icons.swap_vert,
            label: state.sort == 'oldest' ? 'Oldest' : 'Newest',
            onTap: () => onSortChanged(state.sort == 'newest' ? 'oldest' : 'newest'),
          ),
          const SizedBox(width: 8),
          _Chip(
            icon: Icons.filter_alt_outlined,
            label: 'Filter',
            onTap: onOpenFilters,
            active: hasActiveFilters,
          ),
          const Spacer(),
          if (hasActiveFilters)
            TextButton(onPressed: onClear, child: const Text('Clear')),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: active ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: active ? scheme.onPrimaryContainer : scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: active ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.event, required this.onTap});

  final IntrusionEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: EventImageTile(event: event, onTap: onTap, thumbnailOnly: true),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateTimeUtils.formatTimestamp(event.timestamp.toLocal()),
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Attempt #${event.attemptCount}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    if (event.hasLocation)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.place_outlined, size: 14, color: Colors.redAccent),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${event.latitude!.toStringAsFixed(4)}, ${event.longitude!.toStringAsFixed(4)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset, required this.hasFilters});

  final VoidCallback onReset;
  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.photo_library_outlined, size: 72, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            hasFilters ? 'No events match your filters' : 'No events yet',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try removing some filters.'
                : 'Detected unlock attempts will appear here.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          if (hasFilters) ...[
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onReset, child: const Text('Clear filters')),
          ],
        ],
      ),
    );
  }
}
