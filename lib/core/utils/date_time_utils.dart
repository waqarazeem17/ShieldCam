import 'package:intl/intl.dart';

/// Date/time formatting helpers used across the UI and exports.
class DateTimeUtils {
  DateTimeUtils._();

  static String formatTimestamp(DateTime dt) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());

  static String formatDate(DateTime dt) =>
      DateFormat('yyyy-MM-dd').format(dt.toLocal());

  static String formatTime(DateTime dt) =>
      DateFormat('HH:mm:ss').format(dt.toLocal());

  static String formatFriendlyDate(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    if (startOfDay(local) == startOfDay(now)) return 'Today';
    if (startOfDay(local) == startOfDay(now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    return DateFormat('EEE, MMM d').format(local);
  }

  static String eventFilename(DateTime dt) =>
      DateFormat('yyyy-MM-dd_HH-mm-ss').format(dt.toLocal());

  static String monthLabel(DateTime dt) =>
      DateFormat('MMMM yyyy').format(dt.toLocal());

  static DateTime startOfDay(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static DateTime startOfWeek(DateTime dt) {
    final day = startOfDay(dt);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  static DateTime startOfMonth(DateTime dt) => DateTime(dt.year, dt.month, 1);

  static DateTime endOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999);
}
