import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves the ShieldCam folder structure inside app-private storage.
///
/// The layout mirrors the native Kotlin layer so that evidence photos,
/// exports, logs and the database are always shared between the two sides.
///
///   ShieldCam/
///     Images/    - captured evidence photos
///     Exports/   - ZIP / PDF / JSON exports
///     Database/  - Isar database files
///     Logs/      - plain-text debug logs
///     Temp/      - temporary work files
///     Temp/thumbs/     - generated thumbnails
///     Temp/pending/    - native detection events waiting to be imported
class AppFolders {
  AppFolders._();

  static const String rootName = 'ShieldCam';
  static const String imagesName = 'Images';
  static const String exportsName = 'Exports';
  static const String databaseName = 'Database';
  static const String logsName = 'Logs';
  static const String tempName = 'Temp';
  static const String thumbsName = 'thumbs';
  static const String pendingName = 'pending';

  static Future<Directory> _base() async {
    final external = await getExternalStorageDirectory();
    if (external != null) return external;
    return getApplicationSupportDirectory();
  }

  static Future<Directory> root() async {
    final base = await _base();
    return Directory(p.join(base.path, rootName)).create(recursive: true);
  }

  static Future<Directory> images() async {
    final rootDir = await root();
    return Directory(p.join(rootDir.path, imagesName)).create(recursive: true);
  }

  static Future<Directory> exports() async {
    final rootDir = await root();
    return Directory(p.join(rootDir.path, exportsName)).create(recursive: true);
  }

  static Future<Directory> database() async {
    final rootDir = await root();
    return Directory(p.join(rootDir.path, databaseName)).create(recursive: true);
  }

  static Future<Directory> logs() async {
    final rootDir = await root();
    return Directory(p.join(rootDir.path, logsName)).create(recursive: true);
  }

  static Future<Directory> temp() async {
    final rootDir = await root();
    return Directory(p.join(rootDir.path, tempName)).create(recursive: true);
  }

  static Future<Directory> thumbs() async {
    final tempDir = await temp();
    return Directory(p.join(tempDir.path, thumbsName)).create(recursive: true);
  }

  static Future<Directory> pending() async {
    final tempDir = await temp();
    return Directory(p.join(tempDir.path, pendingName)).create(recursive: true);
  }
}
