import 'package:isar/isar.dart';
import 'package:shieldcam/core/utils/app_folders.dart';
import 'package:shieldcam/models/app_settings.dart';
import 'package:shieldcam/models/intrusion_event.dart';

/// Owns the Isar database instance. Opened once during bootstrap.
class AppDatabase {
  Isar? _isar;

  Isar get isar {
    final db = _isar;
    if (db == null) {
      throw StateError('AppDatabase has not been opened yet');
    }
    return db;
  }

  bool get isOpen => _isar != null;

  Future<Isar> open() async {
    if (_isar != null) return _isar!;
    final dir = await AppFolders.database();
    final isar = await Isar.open(
      [IntrusionEventSchema, AppSettingsSchema],
      directory: dir.path,
      name: 'shieldcam',
    );
    _isar = isar;
    return isar;
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
