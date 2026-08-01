import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';
import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/models/intrusion_event.dart';

class GalleryState {
  final List<IntrusionEvent> events;
  final bool gridView;
  final String query;
  final String sort; // newest | oldest
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? year;
  final int? month;
  final bool onlyWithLocation;
  final bool loading;

  const GalleryState({
    this.events = const [],
    this.gridView = true,
    this.query = '',
    this.sort = 'newest',
    this.fromDate,
    this.toDate,
    this.year,
    this.month,
    this.onlyWithLocation = false,
    this.loading = true,
  });

  GalleryState copyWith({
    List<IntrusionEvent>? events,
    bool? gridView,
    String? query,
    String? sort,
    DateTime? fromDate,
    DateTime? toDate,
    int? year,
    int? month,
    bool? onlyWithLocation,
    bool? loading,
  }) {
    return GalleryState(
      events: events ?? this.events,
      gridView: gridView ?? this.gridView,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      year: year ?? this.year,
      month: month ?? this.month,
      onlyWithLocation: onlyWithLocation ?? this.onlyWithLocation,
      loading: loading ?? this.loading,
    );
  }
}

/// Drives the gallery: live event list + fast in-memory filtering, search and
/// sorting. The base list stays indexed by Isar; filters are applied locally
/// so interactions remain instant.
class GalleryController extends StateNotifier<GalleryState> {
  GalleryController(this._ref) : super(const GalleryState()) {
    _repository = _ref.read(eventRepositoryProvider);
    _sub = _repository.watchAll().listen(_onBaseList);
  }

  final Ref _ref;
  late final EventRepository _repository;
  late final StreamSubscription<List<IntrusionEvent>> _sub;
  List<IntrusionEvent> _base = const [];

  void _onBaseList(List<IntrusionEvent> events) {
    _base = events;
    _apply();
  }

  void _apply() {
    final s = state;
    var filtered = List<IntrusionEvent>.from(_base);

    final needle = s.query.trim().toLowerCase();
    if (needle.isNotEmpty) {
      filtered = filtered.where((e) {
        return e.deviceModel.toLowerCase().contains(needle) ||
            e.manufacturer.toLowerCase().contains(needle) ||
            e.androidVersion.toLowerCase().contains(needle) ||
            e.address.toLowerCase().contains(needle) ||
            DateTimeUtils.formatTimestamp(e.timestamp).contains(needle) ||
            DateTimeUtils.formatDate(e.timestamp).contains(needle);
      }).toList();
    }

    if (s.fromDate != null) {
      filtered = filtered.where((e) => !e.timestamp.isBefore(s.fromDate!)).toList();
    }
    if (s.toDate != null) {
      filtered = filtered.where((e) => !e.timestamp.isAfter(s.toDate!)).toList();
    }
    if (s.year != null) {
      filtered = filtered.where((e) => e.timestamp.year == s.year).toList();
    }
    if (s.month != null) {
      filtered = filtered.where((e) => e.timestamp.month == s.month).toList();
    }
    if (s.onlyWithLocation) {
      filtered = filtered.where((e) => e.hasLocation).toList();
    }

    filtered.sort(s.sort == 'oldest'
        ? (a, b) => a.timestamp.compareTo(b.timestamp)
        : (a, b) => b.timestamp.compareTo(a.timestamp));

    state = s.copyWith(events: filtered, loading: false);
  }

  void setGridView(bool value) => state = state.copyWith(gridView: value);

  void setQuery(String value) {
    state = state.copyWith(query: value);
    _apply();
  }

  void setSort(String value) {
    state = state.copyWith(sort: value);
    _apply();
  }

  void setDateRange(DateTime from, DateTime to) {
    state = state.copyWith(fromDate: from, toDate: to, year: null, month: null);
    _apply();
  }

  void setYear(int? year) {
    state = state.copyWith(year: year, month: null, fromDate: null, toDate: null);
    _apply();
  }

  void setMonth(int? year, int? month) {
    state = state.copyWith(year: year, month: month, fromDate: null, toDate: null);
    _apply();
  }

  void setOnlyWithLocation(bool value) {
    state = state.copyWith(onlyWithLocation: value);
    _apply();
  }

  void clearFilters() {
    state = state.copyWith(
      query: '',
      sort: 'newest',
      fromDate: null,
      toDate: null,
      year: null,
      month: null,
      onlyWithLocation: false,
    );
    _apply();
  }

  void refresh() => _apply();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final galleryControllerProvider =
    StateNotifierProvider<GalleryController, GalleryState>(
  (ref) => GalleryController(ref),
);
