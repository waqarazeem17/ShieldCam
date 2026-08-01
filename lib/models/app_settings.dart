import 'package:isar/isar.dart';

part 'app_settings.g.dart';

/// Single-row settings table. Sensitive values (the app-lock PIN hash) are
/// kept in encrypted storage instead and are never stored here.
@collection
class AppSettings {
  Id id = 1;

  /// system | light | dark
  String themeMode = 'system';

  bool captureFront = true;
  bool captureRear = true;
  bool enableLocation = true;

  /// JPEG quality used when generating thumbnails / exports (1..100).
  int imageQuality = 92;

  /// 0 = never, otherwise days after which old events are auto-deleted.
  int autoDeleteDays = 0;

  bool appLockEnabled = false;

  bool onboarded = false;
  bool monitoringEnabled = false;

  DateTime? createdAt;
  DateTime? updatedAt;
}
