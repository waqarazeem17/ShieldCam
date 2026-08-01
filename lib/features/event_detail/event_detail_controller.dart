import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/models/intrusion_event.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

class EventDetailState {
  final IntrusionEvent? event;
  final bool loading;
  final String? error;

  const EventDetailState({this.event, this.loading = true, this.error});

  EventDetailState copyWith({IntrusionEvent? event, bool? loading, String? error}) {
    return EventDetailState(
      event: event ?? this.event,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class EventDetailController extends StateNotifier<EventDetailState> {
  EventDetailController(this._ref, this.eventId) : super(const EventDetailState()) {
    _repository = _ref.read(eventRepositoryProvider);
    load();
  }

  final Ref _ref;
  final int eventId;
  late final EventRepository _repository;

  Future<void> load() async {
    try {
      final event = await _repository.getById(eventId);
      if (event == null) {
        state = const EventDetailState(event: null, loading: false, error: 'Event not found');
        return;
      }
      state = EventDetailState(event: event, loading: false);
    } catch (e, s) {
      AppLogger.e('Failed to load event $eventId', e, s);
      state = EventDetailState(event: null, loading: false, error: '$e');
    }
  }

  Future<void> updateNotes(String notes) async {
    final event = state.event;
    if (event == null) return;
    event.notes = notes;
    await _repository.update(event);
    state = state.copyWith(event: event);
  }

  Future<bool> delete() async {
    final event = state.event;
    if (event == null) return false;
    try {
      await _repository.delete(event.id);
      state = const EventDetailState(event: null, loading: false);
      return true;
    } catch (e, s) {
      AppLogger.e('Failed to delete event', e, s);
      state = state.copyWith(error: '$e');
      return false;
    }
  }
}

final eventDetailControllerProvider =
    StateNotifierProvider.family<EventDetailController, EventDetailState, int>(
  (ref, eventId) => EventDetailController(ref, eventId),
);
