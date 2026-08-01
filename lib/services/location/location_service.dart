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
  /// Offline geocoding depends on the device; failures yield an empty string.
  Future<String> reverseGeocode(double latitude, double longitude) async {
    try {
      final placemarks =
          await Geolocator.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return '';
      final pm = placemarks.first;
      final parts = <String>[
        if (pm.subThoroughfare?.isNotEmpty ?? false) pm.subThoroughfare!,
        if (pm.thoroughfare?.isNotEmpty ?? false) pm.thoroughfare!,
        if (pm.subLocality?.isNotEmpty ?? false) pm.subLocality!,
        if (pm.locality?.isNotEmpty ?? false) pm.locality!,
        if (pm.adminArea?.isNotEmpty ?? false) pm.adminArea!,
        if (pm.country?.isNotEmpty ?? false) pm.country!,
      ];
      return parts.join(', ');
    } catch (e) {
      AppLogger.w('reverseGeocode failed (offline): $e');
      return '';
    }
  }
}
