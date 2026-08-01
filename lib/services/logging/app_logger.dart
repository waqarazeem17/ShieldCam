import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shieldcam/core/utils/app_folders.dart';

/// Lightweight local file logger.
///
/// Writes to ShieldCam/Logs/app.log, rotates at 2 MB, and never throws.
/// Debug builds also mirror to the console via [debugPrint].
class AppLogger {
  AppLogger._();

  static const int _maxSize = 2 * 1024 * 1024;
  static File? _file;
  static bool _enabled = true;

  static void enable(bool value) => _enabled = value;

  static Future<void> _ensureFile() async {
    if (_file != null) return;
    final dir = await AppFolders.logs();
    _file = File('${dir.path}${Platform.pathSeparator}app.log');
    if (_file!.existsSync() && _file!.lengthSync() > _maxSize) {
      final prev = File('${_file!.path}.prev');
      if (prev.existsSync()) prev.deleteSync();
      _file!.copySync(prev.path);
      _file!.deleteSync();
    }
  }

  static Future<void> _write(String level, String message) async {
    if (!_enabled) return;
    try {
      await _ensureFile();
      final line = '${DateTime.now().toIso8601String()} [$level] $message\n';
      await _file!.writeAsString(line, mode: FileMode.append);
    } catch (_) {
      // Logging must never break the app.
    }
  }

  static void d(String message) {
    debugPrint('[ShieldCam] $message');
    _write('D', message);
  }

  static void i(String message) {
    debugPrint('[ShieldCam] $message');
    _write('I', message);
  }

  static void w(String message) {
    debugPrint('[ShieldCam] WARN: $message');
    _write('W', message);
  }

  static void e(String message, [Object? error, StackTrace? stack]) {
    debugPrint('[ShieldCam] ERROR: $message');
    _write('E', '$message${error == null ? '' : '\n  cause: $error'}'
        '${stack == null ? '' : '\n  stack: ${stack.toString().split('\n').take(8).join('\n  ')}'}');
  }
}
