import 'package:isar/isar.dart';
import 'package:shieldcam/data/database/app_database.dart';
import 'package:shieldcam/models/app_settings.dart';

/// Persistence layer for app settings (single-row table).
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Isar get _isar => _db.isar;

  Future<AppSettings> getSettings() async {
    final existing = await _isar.appSettings.get(1);
    if (existing != null) return existing;
    final fresh = AppSettings()
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.appSettings.put(fresh));
    return fresh;
  }

  Future<void> save(AppSettings settings) async {
    settings.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.appSettings.put(settings));
  }

  Future<void> reset() async {
    final fresh = AppSettings()
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.appSettings.put(fresh));
  }
}
