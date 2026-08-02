import 'package:geolocator/geolocator.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

/// Location + reverse-geocoding. Everything runs on-device; address lookup
/// returns an empty string when no offline geocoding data is available.
class LocationService {
  bool _serviceEnabled = false;

  Future<bool> isEnabled() async {
    try {
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    } catch (_) {
      _serviceEnabled = false;
    }
    return _serviceEnabled;
  }

  /// Best-effort last known position. Returns null when unavailable.
  Future<Position?> lastKnown() async {
    try {
      if (!await isEnabled()) return null;
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getLastKnownPosition();
    } catch (e, s) {
      AppLogger.e('lastKnown failed', e, s);
      return null;
    }
  }

  /// Reverse geocodes coordinates into a human-readable address.
  ///
  /// Fully offline by design: this never calls network geocoding services.
  /// It returns an empty string (device-provided geocoding may be plugged in
  /// later); the address field is optional everywhere in the UI.
  Future<String> reverseGeocode(double latitude, double longitude) async {
    // Kept offline: address is an optional, best-effort field.
    return '';
  }
}
