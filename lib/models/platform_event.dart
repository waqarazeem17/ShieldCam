/// A single message pushed by the native layer over the event channel.
///
/// [type] is one of:
///   - "detection": a failed unlock attempt was detected; [eventJson]
///     contains the full payload produced by [DetectionEngine].
///   - "lockState": the keyguard lock state changed; [locked] is set.
class PlatformEvent {
  final String type;
  final String? eventJson;
  final bool? locked;

  const PlatformEvent({
    required this.type,
    this.eventJson,
    this.locked,
  });

  factory PlatformEvent.fromMap(Map<dynamic, dynamic> map) {
    return PlatformEvent(
      type: (map['type'] as String?) ?? '',
      eventJson: map['event'] as String?,
      locked: map['locked'] as bool?,
    );
  }

  bool get isDetection => type == 'detection';
  bool get isLockState => type == 'lockState';
}
