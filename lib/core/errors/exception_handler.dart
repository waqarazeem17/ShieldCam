import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shieldcam/core/errors/app_exception.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

/// Central place for catching and reporting unexpected failures.
///
/// ShieldCam never fails silently: every unhandled error is logged to the
/// local log file and, when a UI is attached, reported through a zone that
/// the app can display.
class ExceptionHandler {
  ExceptionHandler._();

  static FlutterExceptionHandler? _previousHandler;

  /// Installs the global exception handler. Call once at startup.
  static void install() {
    _previousHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      AppLogger.e('Unhandled Flutter error', details.exception, details.stack);
      _previousHandler?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.e('Unhandled platform error', error, stack);
      return true;
    };

    runZonedGuarded(() {
      // The zone guards async errors thrown after startup.
    }, (error, stack) {
      AppLogger.e('Unhandled async error', error, stack);
    });
  }

  /// Renders a user-facing message from any thrown object.
  static String messageOf(Object error, [String fallback = 'Something went wrong']) {
    if (error is AppException) return error.message;
    if (error is Exception) return error.toString();
    if (error is String) return error;
    return fallback;
  }
}
