import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shieldcam/app.dart';
import 'package:shieldcam/core/errors/exception_handler.dart';
import 'package:shieldcam/di/service_locator.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ExceptionHandler.install();
  await setupLocator();
  try {
    await bootstrapDatabase();
  } catch (e, s) {
    AppLogger.e('Database bootstrap failed', e, s);
    rethrow;
  }
  runApp(const ProviderScope(child: ShieldCamApp()));
}
