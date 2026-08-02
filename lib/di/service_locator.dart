import 'package:get_it/get_it.dart';
import 'package:shieldcam/data/database/app_database.dart';
import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/data/repositories/settings_repository.dart';
import 'package:shieldcam/services/detection/detection_service.dart';
import 'package:shieldcam/services/export/export_service.dart';
import 'package:shieldcam/services/location/location_service.dart';
import 'package:shieldcam/services/logging/app_logger.dart';
import 'package:shieldcam/services/monitoring/monitoring_service.dart';
import 'package:shieldcam/services/platform/platform_service.dart';
import 'package:shieldcam/services/settings/settings_service.dart';
import 'package:shieldcam/services/storage/storage_service.dart';
import 'package:shieldcam/services/storage/thumbnail_service.dart';

/// Central service registry (GetIt).
///
/// Plain Dart services are registered as lazy singletons. Isar-backed
/// repositories and services that depend on the database are registered after
/// the database is opened during bootstrap.
final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  AppLogger.d('Setting up service locator');

  // Core / stateless services.
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton<PlatformService>(PlatformService.new);

  // Database-dependent registrations happen after open().
}

Future<void> bootstrapDatabase() async {
  final db = locator<AppDatabase>();
  await db.open();
  AppLogger.d('Isar database opened');

  locator
    ..registerLazySingleton(() => EventRepository(db))
    ..registerLazySingleton(() => SettingsRepository(db))
    ..registerLazySingleton<DetectionService>(
      () => DetectionService(locator<PlatformService>(), locator<EventRepository>()),
    )
    ..registerLazySingleton<MonitoringService>(
      () => MonitoringService(locator<PlatformService>()),
    )
    ..registerLazySingleton<SettingsService>(
      () => SettingsService(locator<SettingsRepository>()),
    )
    ..registerLazySingleton<StorageService>(
      () => StorageService(locator<EventRepository>()),
    )
    ..registerLazySingleton<ExportService>(
      () => ExportService(),
    )
    ..registerLazySingleton<LocationService>(LocationService.new)
    ..registerLazySingleton<ThumbnailService>(ThumbnailService.new);
}
