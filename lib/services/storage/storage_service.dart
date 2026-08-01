import 'dart:io';

import 'package:shieldcam/core/utils/app_folders.dart';
import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

/// Storage accounting and maintenance.
class StorageService {
  StorageService(this._repository);

  final EventRepository _repository;

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Future<int> _folderSize(Directory dir) async {
    var total = 0;
    if (!dir.existsSync()) return 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        try {
          total += await entity.length();
        } catch (_) {}
      }
    }
    return total;
  }

  Future<int> totalBytes() async {
    final root = await AppFolders.root();
    return _folderSize(root);
  }

  Future<int> imagesBytes() async {
    final dir = await AppFolders.images();
    return _folderSize(dir);
  }

  Future<int> databaseBytes() async {
    final dir = await AppFolders.database();
    return _folderSize(dir);
  }

  Future<int> exportsBytes() async {
    final dir = await AppFolders.exports();
    return _folderSize(dir);
  }

  Future<int> tempBytes() async {
    final dir = await AppFolders.temp();
    return _folderSize(dir);
  }

  /// Removes image files that are no longer referenced by any database row.
  /// Also removes empty leftover thumbnails.
  Future<void> removeOrphans() async {
    try {
      final events = await _repository.getAll();
      final referenced = <String>{};
      for (final e in events) {
        if (e.frontImagePath.isNotEmpty) referenced.add(e.frontImagePath);
        if (e.rearImagePath.isNotEmpty) referenced.add(e.rearImagePath);
      }

      final imagesDir = await AppFolders.images();
      var removed = 0;
      if (imagesDir.existsSync()) {
        await for (final entity in imagesDir.list()) {
          if (entity is File) {
            final resolved = entity.path;
            if (!referenced.contains(resolved)) {
              try {
                entity.deleteSync();
                removed++;
              } catch (_) {}
            }
          }
        }
      }

      final thumbsDir = await AppFolders.thumbs();
      if (thumbsDir.existsSync()) {
        await for (final entity in thumbsDir.list()) {
          try {
            entity.deleteSync();
          } catch (_) {}
        }
      }
      AppLogger.i('Orphan cleanup: removed $removed image(s)');
    } catch (e, s) {
      AppLogger.e('removeOrphans failed', e, s);
    }
  }

  /// Clears temporary caches (thumbnails, pending hand-offs, temp files).
  Future<void> clearCache() async {
    final tempDir = await AppFolders.temp();
    if (tempDir.existsSync()) {
      for (final entity in tempDir.listSync()) {
        try {
          if (entity is Directory) entity.deleteSync(recursive: true);
          if (entity is File) entity.deleteSync();
        } catch (_) {}
      }
    }
    AppLogger.i('Cache cleared');
  }

  /// Deletes every event, its evidence photos and all exports.
  Future<void> deleteAllData() async {
    final events = await _repository.getAll();
    final ids = events.map((e) => e.id).toList();
    if (ids.isNotEmpty) await _repository.deleteAll(ids);
    for (final e in events) {
      for (final path in [e.frontImagePath, e.rearImagePath]) {
        if (path.isNotEmpty) {
          try {
            final f = File(path);
            if (f.existsSync()) f.deleteSync();
          } catch (_) {}
        }
      }
    }
    final exportsDir = await AppFolders.exports();
    if (exportsDir.existsSync()) {
      for (final entity in exportsDir.listSync()) {
        try {
          entity.deleteSync(recursive: true);
        } catch (_) {}
      }
    }
    await clearCache();
    AppLogger.i('All data deleted');
  }

  /// Applies the auto-delete policy (0 = never).
  Future<void> applyAutoDelete(int days) async {
    if (days <= 0) return;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final oldEvents = await _repository.query(to: cutoff);
    if (oldEvents.isEmpty) return;
    final ids = oldEvents.map((e) => e.id).toList();
    for (final e in oldEvents) {
      for (final path in [e.frontImagePath, e.rearImagePath]) {
        if (path.isNotEmpty) {
          try {
            final f = File(path);
            if (f.existsSync()) f.deleteSync();
          } catch (_) {}
        }
      }
    }
    await _repository.deleteAll(ids);
    AppLogger.i('Auto-delete: removed ${ids.length} event(s) older than $days days');
  }
}
