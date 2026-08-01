import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';
import 'package:shieldcam/models/intrusion_event.dart';

/// Renders an event's evidence image (or thumbnail) with lazy loading and a
/// small timestamp overlay. [thumbnailOnly] renders just the image for use in
/// list rows.
class EventImageTile extends ConsumerWidget {
  const EventImageTile({
    super.key,
    required this.event,
    required this.onTap,
    this.thumbnailOnly = false,
  });

  final IntrusionEvent event;
  final VoidCallback onTap;
  final bool thumbnailOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbs = ref.watch(thumbnailServiceProvider);
    final theme = Theme.of(context);
    final path = event.hasFrontImage
        ? event.frontImagePath
        : event.hasRearImage
            ? event.rearImagePath
            : null;

    Widget image;
    if (path == null) {
      image = const _NoImage();
    } else {
      image = FutureBuilder<Uint8List?>(
        future: thumbs.getThumbnail(path),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            );
          }
          if (snapshot.hasError) {
            return const _NoImage();
          }
          return Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }

    if (thumbnailOnly) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  image,
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${DateTimeUtils.formatDate(event.timestamp.toLocal())}',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Text(
                  'Attempt #${event.attemptCount}',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (event.hasLocation)
                  const Icon(Icons.place, size: 14, color: Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
