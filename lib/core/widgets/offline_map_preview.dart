import 'dart:math';

import 'package:flutter/material.dart';

/// Fully offline map preview.
///
/// ShieldCam never uses the network, so no tile provider can be used. This
/// widget renders a stylised lat/lng graticule centred on the captured
/// coordinates with a marker. It supports pinch-zoom and pan through
/// [InteractiveViewer]. An "Open in Google Maps" action is provided by the
/// parent (that is an explicit user action on the Maps app itself).
class OfflineMapPreview extends StatelessWidget {
  const OfflineMapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 220,
  });

  final double latitude;
  final double longitude;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 6,
                child: CustomPaint(
                  painter: _GraticulePainter(
                    latitude: latitude,
                    longitude: longitude,
                    theme: theme,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GraticulePainter extends CustomPainter {
  _GraticulePainter({
    required this.latitude,
    required this.longitude,
    required this.theme,
  });

  final double latitude;
  final double longitude;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = theme.colorScheme.outlineVariant.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    // Vertical graticule lines.
    const lines = 12;
    for (var i = 0; i <= lines; i++) {
      final x = size.width * i / lines;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    // Horizontal graticule lines.
    for (var i = 0; i <= lines; i++) {
      final y = size.height * i / lines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Soft "landmass" hint: a few blurred organic blobs make the map feel
    // more like a map without any network dependency.
    final blobPaint = Paint()
      ..color = theme.colorScheme.primary.withValues(alpha: 0.10);
    final rand = Random(42);
    for (var i = 0; i < 6; i++) {
      final cx = size.width * (0.2 + rand.nextDouble() * 0.6);
      final cy = size.height * (0.2 + rand.nextDouble() * 0.6);
      final r = size.width * (0.08 + rand.nextDouble() * 0.16);
      canvas.drawCircle(Offset(cx, cy), r, blobPaint);
    }

    // Marker.
    final center = Offset(size.width / 2, size.height / 2);
    final haloPaint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.25);
    canvas.drawCircle(center, 22, haloPaint);
    final pinPaint = Paint()..color = Colors.redAccent;
    canvas.drawCircle(center, 10, pinPaint);
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _GraticulePainter oldDelegate) {
    return oldDelegate.latitude != latitude ||
        oldDelegate.longitude != longitude ||
        oldDelegate.theme != theme;
  }
}
