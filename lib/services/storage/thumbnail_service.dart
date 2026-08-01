import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shieldcam/core/utils/app_folders.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

/// Generates and caches small thumbnails so the gallery stays smooth and
/// memory-efficient. Thumbnails are written to Temp/thumbs and a small
/// in-memory LRU cache avoids repeated I/O during scrolling.
class ThumbnailService {
  ThumbnailService();

  static const int _memoryCacheSize = 60;

  final Map<String, Uint8List> _memoryCache = <String, Uint8List>{};
  final List<String> _lruOrder = [];

  /// Returns a decoded thumbnail for [imagePath]. Falls back to a file-read
  /// without decoding when generation fails.
  Future<Uint8List?> getThumbnail(String imagePath, {int width = 360}) async {
    final key = '${p.basename(imagePath)}_$width';

    final cached = _memoryCache[key];
    if (cached != null) return cached;

    final thumbFile = await _thumbFile(key);
    if (thumbFile.existsSync()) {
      try {
        final bytes = thumbFile.readAsBytesSync();
        _putCache(key, bytes);
        return bytes;
      } catch (_) {}
    }

    try {
      final original = File(imagePath);
      if (!original.existsSync()) return null;
      final bytes = await original.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;

      final resized = img.copyResize(
        decoded,
        width: decoded.width <= width ? decoded.width : width,
        interpolation: img.Interpolation.linear,
      );
      final jpg = Uint8List.fromList(img.encodeJpg(resized, quality: 78));
      await thumbFile.parent.create(recursive: true);
      await thumbFile.writeAsBytes(jpg, flush: true);
      _putCache(key, jpg);
      return jpg;
    } catch (e, s) {
      AppLogger.e('Thumbnail failed for $imagePath', e, s);
      return null;
    }
  }

  Future<File> _thumbFile(String key) async {
    final dir = await AppFolders.thumbs();
    return File(p.join(dir.path, key));
  }

  void _putCache(String key, Uint8List bytes) {
    if (_lruOrder.length >= _memoryCacheSize) {
      final evicted = _lruOrder.removeAt(0);
      _memoryCache.remove(evicted);
    }
    _lruOrder.remove(key);
    _lruOrder.add(key);
    _memoryCache[key] = bytes;
  }

  Future<void> clear() async {
    _memoryCache.clear();
    _lruOrder.clear();
    final dir = await AppFolders.thumbs();
    if (dir.existsSync()) {
      for (final f in dir.listSync()) {
        try {
          f.deleteSync();
        } catch (_) {}
      }
    }
  }
}
