import 'dart:async';
import 'dart:convert';

import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/models/intrusion_event.dart';
import 'package:shieldcam/models/platform_event.dart';
import 'package:shieldcam/services/logging/app_logger.dart';
import 'package:shieldcam/services/platform/platform_service.dart';
import 'package:uuid/uuid.dart';

/// Bridges the native detection layer into the Flutter data layer.
///
///  - Listens to the live event channel and persists every detection.
///  - Imports events that were recorded while the UI was not attached
///    (the native layer buffers them as pending JSON files).
///  - Exposes a [Stream] of freshly saved events so the UI can react.
class DetectionService {
  DetectionService(this._platform, this._repository);

  final PlatformService _platform;
  final EventRepository _repository;

  final _controller = StreamController<IntrusionEvent>.broadcast();
  StreamSubscription<PlatformEvent>? _subscription;

  Stream<IntrusionEvent> get onEvent => _controller.stream;

  bool _listening = false;

  /// Starts listening to native events and imports any buffered events.
  Future<void> start() async {
    if (_listening) return;
    _listening = true;
    _subscription = _platform.eventStream.listen(_handle, onError: (Object e, StackTrace s) {
      AppLogger.e('Event channel error', e, s);
    });
    await importPending();
  }

  Future<void> stop() async {
    _listening = false;
    await _subscription?.cancel();
    _subscription = null;
  }

  void _handle(PlatformEvent event) {
    if (event.isDetection && event.eventJson != null) {
      final parsed = _parseNativeEvent(event.eventJson!);
      if (parsed != null) _persist(parsed, clearPending: true);
    }
  }

  /// Imports buffered native events recorded while Flutter was not attached.
  Future<void> importPending() async {
    try {
      final pending = await _platform.getPendingEvents();
      for (final raw in pending) {
        final parsed = _parseNativeEvent(jsonEncode(raw));
        if (parsed != null) {
          final saved = await _persist(parsed, clearPending: false);
          if (saved != null) {
            await _platform.clearPendingEvent(saved.uuid);
          }
        }
      }
    } catch (e, s) {
      AppLogger.e('importPending failed', e, s);
    }
  }

  IntrusionEvent? _parseNativeEvent(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;

      final tsValue = map['timestamp'];
      final DateTime timestamp;
      if (tsValue is int) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(tsValue);
      } else if (tsValue is num) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(tsValue.round());
      } else {
        timestamp = DateTime.tryParse((tsValue as String?) ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
      }

      return IntrusionEvent()
        ..uuid = (map['id'] as String?) ?? _uuid()
        ..timestamp = timestamp
        ..attemptCount = (map['attemptCount'] as num?)?.toInt() ?? 1
        ..batteryLevel = (map['batteryLevel'] as num?)?.toInt()
        ..batteryCharging = (map['batteryCharging'] as bool?) ?? false
        ..deviceModel = (map['deviceModel'] as String?) ?? ''
        ..manufacturer = (map['manufacturer'] as String?) ?? ''
        ..androidVersion = (map['androidVersion'] as String?) ?? ''
        ..sdkInt = (map['sdkInt'] as num?)?.toInt() ?? 0
        ..frontImagePath = (map['frontImage'] as String?) ?? ''
        ..rearImagePath = (map['rearImage'] as String?) ?? ''
        ..latitude = (map['latitude'] as num?)?.toDouble()
        ..longitude = (map['longitude'] as num?)?.toDouble()
        ..address = (map['address'] as String?) ?? ''
        ..source = (map['source'] as String?) ?? 'native';
    } catch (e, s) {
      AppLogger.e('Failed to parse native event', e, s);
      return null;
    }
  }

  Future<IntrusionEvent?> _persist(IntrusionEvent event, {required bool clearPending}) async {
    try {
      final existing = await _repository.getByUuid(event.uuid);
      if (existing != null) return null; // Already imported.
      final saved = await _repository.add(event);
      if (clearPending) {
        await _platform.clearPendingEvent(event.uuid);
      }
      _controller.add(saved);
      AppLogger.i('Detection persisted: ${saved.uuid} (attempt ${saved.attemptCount})');
      return saved;
    } catch (e, s) {
      AppLogger.e('Failed to persist detection', e, s);
      return null;
    }
  }

  String _uuid() => const Uuid().v4();

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
