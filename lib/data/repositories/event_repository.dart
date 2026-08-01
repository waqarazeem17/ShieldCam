import 'dart:io';

import 'package:isar/isar.dart';
import 'package:shieldcam/core/utils/app_folders.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';
import 'package:shieldcam/data/database/app_database.dart';
import 'package:shieldcam/models/intrusion_event.dart';

/// Persistence layer for intrusion events.
class EventRepository {
  EventRepository(this._db);

  final AppDatabase _db;

  Isar get _isar => _db.isar;

  Future<IntrusionEvent> add(IntrusionEvent event) async {
    await _isar.writeTxn(() => _isar.intrusionEvents.put(event));
    return event;
  }

  Future<IntrusionEvent> update(IntrusionEvent event) async {
    await _isar.writeTxn(() => _isar.intrusionEvents.put(event));
    return event;
  }

  Future<bool> delete(Id id) async {
    return _isar.writeTxn(() => _isar.intrusionEvents.delete(id));
  }

  Future<void> deleteAll(List<Id> ids) async {
    await _isar.writeTxn(() => _isar.intrusionEvents.deleteAll(ids));
  }

  Future<void> deleteWhere(QueryBuilder<IntrusionEvent, IntrusionEvent, QWhere> q) async {
    await _isar.writeTxn(() => q.deleteAll());
  }

  Future<IntrusionEvent?> getById(Id id) => _isar.intrusionEvents.get(id);

  Future<IntrusionEvent?> getByUuid(String uuid) {
    return _isar.intrusionEvents
        .where()
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
  }

  Future<List<IntrusionEvent>> getAll({int? limit, int offset = 0}) async {
    var q = _isar.intrusionEvents.where().sortByTimestampDesc();
    if (limit != null) q = q.limit(limit).offset(offset);
    return q.findAll();
  }

  Future<List<IntrusionEvent>> getByDateRange(DateTime from, DateTime to) {
    return _isar.intrusionEvents
        .where()
        .timestampGreaterThanOrEqualTo(from)
        .and()
        .timestampLessThanOrEqualTo(to)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<IntrusionEvent>> getByMonth(DateTime month) {
    final from = DateTimeUtils.startOfMonth(month);
    final to = DateTime(from.year, from.month + 1, 1)
        .subtract(const Duration(milliseconds: 1));
    return getByDateRange(from, to);
  }

  Future<List<IntrusionEvent>> getByYear(int year) {
    final from = DateTime(year, 1, 1);
    final to = DateTime(year + 1, 1, 1).subtract(const Duration(milliseconds: 1));
    return getByDateRange(from, to);
  }

  Future<int> countAll() => _isar.intrusionEvents.where().count();

  Future<int> countToday() async {
    final start = DateTimeUtils.startOfDay(DateTime.now());
    return _isar.intrusionEvents
        .where()
        .timestampGreaterThanOrEqualTo(start)
        .count();
  }

  Future<int> countThisWeek() async {
    final start = DateTimeUtils.startOfWeek(DateTime.now());
    return _isar.intrusionEvents
        .where()
        .timestampGreaterThanOrEqualTo(start)
        .count();
  }

  Future<int> countThisMonth() async {
    final start = DateTimeUtils.startOfMonth(DateTime.now());
    return _isar.intrusionEvents
        .where()
        .timestampGreaterThanOrEqualTo(start)
        .count();
  }

  Future<int> countSince(DateTime from) {
    return _isar.intrusionEvents
        .where()
        .timestampGreaterThanOrEqualTo(from)
        .count();
  }

  Future<IntrusionEvent?> latest() {
    return _isar.intrusionEvents.where().sortByTimestampDesc().findFirst();
  }

  Stream<List<IntrusionEvent>> watchAll() => _isar.intrusionEvents.where().watch(fireImmediately: true);

  Stream<void> watchChanges() => _isar.intrusionEvents.where().watchLazy(fireImmediately: true);

  /// Indexed where-query access for advanced filtering (used by the gallery).
  Future<List<IntrusionEvent>> query({
    DateTime? from,
    DateTime? to,
    bool newestFirst = true,
    int? limit,
  }) {
    var q = _isar.intrusionEvents.where();
    if (from != null) q = q.timestampGreaterThanOrEqualTo(from);
    if (to != null) q = q.timestampLessThanOrEqualTo(to);
    if (newestFirst) q = q.sortByTimestampDesc();
    if (limit != null) q = q.limit(limit);
    return q.findAll();
  }

  /// Fast text search over local event fields. The result set is small enough
  /// that an indexed in-memory scan is effectively instant.
  Future<List<IntrusionEvent>> search(String query) async {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return getAll();
    final all = await getAll();
    return all.where((e) {
      return e.deviceModel.toLowerCase().contains(needle) ||
          e.manufacturer.toLowerCase().contains(needle) ||
          e.androidVersion.toLowerCase().contains(needle) ||
          e.address.toLowerCase().contains(needle) ||
          e.notes.toLowerCase().contains(needle) ||
          DateTimeUtils.formatTimestamp(e.timestamp).contains(needle) ||
          DateTimeUtils.formatDate(e.timestamp).contains(needle);
    }).toList();
  }

  /// Total bytes occupied by evidence images (used for storage stats).
  Future<int> storageBytes() async {
    final dir = await AppFolders.images();
    var total = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }
}
