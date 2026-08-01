import 'package:isar/isar.dart';

part 'intrusion_event.g.dart';

/// A recorded failed unlock attempt with its collected evidence.
@collection
class IntrusionEvent {
  Id id = Isar.autoIncrement;

  /// Stable identifier used by the native layer for the pending queue.
  late String uuid;

  @Index()
  late DateTime timestamp;

  /// Attempt number within the current lock session.
  int attemptCount = 1;

  int? batteryLevel;
  bool batteryCharging = false;

  String deviceModel = '';
  String manufacturer = '';
  String androidVersion = '';
  int sdkInt = 0;

  String frontImagePath = '';
  String rearImagePath = '';

  double? latitude;
  double? longitude;
  String address = '';

  /// Where the attempt was detected: accessibility | manual | imported.
  String source = '';

  String notes = '';

  bool get hasFrontImage => frontImagePath.isNotEmpty;
  bool get hasRearImage => rearImagePath.isNotEmpty;
  bool get hasLocation => latitude != null && longitude != null;
}
