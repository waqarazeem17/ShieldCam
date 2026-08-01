import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shieldcam/data/repositories/event_repository.dart';
import 'package:shieldcam/data/repositories/settings_repository.dart';
import 'package:shieldcam/di/service_locator.dart';
import 'package:shieldcam/services/detection/detection_service.dart';
import 'package:shieldcam/services/export/export_service.dart';
import 'package:shieldcam/services/location/location_service.dart';
import 'package:shieldcam/services/monitoring/monitoring_service.dart';
import 'package:shieldcam/services/platform/platform_service.dart';
import 'package:shieldcam/services/settings/settings_service.dart';
import 'package:shieldcam/services/storage/storage_service.dart';
import 'package:shieldcam/services/storage/thumbnail_service.dart';

/// Global providers. Services are owned by GetIt; these providers expose them
/// to the Riverpod UI layer.

final eventRepositoryProvider = Provider<EventRepository>((ref) => locator<EventRepository>());
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) => locator<SettingsRepository>());
final settingsServiceProvider = Provider<SettingsService>((ref) => locator<SettingsService>());
final monitoringServiceProvider = Provider<MonitoringService>((ref) => locator<MonitoringService>());
final platformServiceProvider = Provider<PlatformService>((ref) => locator<PlatformService>());
final storageServiceProvider = Provider<StorageService>((ref) => locator<StorageService>());
final locationServiceProvider = Provider<LocationService>((ref) => locator<LocationService>());
final exportServiceProvider = Provider<ExportService>((ref) => locator<ExportService>());
final thumbnailServiceProvider = Provider<ThumbnailService>((ref) => locator<ThumbnailService>());
final detectionServiceProvider = Provider<DetectionService>((ref) => locator<DetectionService>());
