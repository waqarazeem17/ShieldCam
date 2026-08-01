import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shieldcam/data/repositories/settings_repository.dart';
import 'package:shieldcam/models/app_settings.dart';

/// Application settings + sensitive preference storage.
///
/// The app-lock PIN is stored as a salted SHA-256 hash in the platform
/// encrypted storage (Keystore-backed) - never in the database.
class SettingsService {
  SettingsService(this._repository);

  final SettingsRepository _repository;
  final _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _pinHashKey = 'app_lock_pin_hash';
  static const _pinSaltKey = 'app_lock_pin_salt';
  static const _pinLengthKey = 'app_lock_pin_length';
  static const _monitoringKey = 'monitoring_enabled_flag';

  AppSettings? _cache;

  Future<AppSettings> getSettings() async {
    _cache ??= await _repository.getSettings();
    return _cache!;
  }

  Future<void> update(void Function(AppSettings) mutate) async {
    final settings = await getSettings();
    mutate(settings);
    await _repository.save(settings);
    _cache = settings;
  }

  Future<void> setThemeMode(String mode) => update((s) => s.themeMode = mode);

  Future<void> setCaptureFront(bool value) => update((s) => s.captureFront = value);

  Future<void> setCaptureRear(bool value) => update((s) => s.captureRear = value);

  Future<void> setEnableLocation(bool value) => update((s) => s.enableLocation = value);

  Future<void> setImageQuality(int value) => update((s) => s.imageQuality = value);

  Future<void> setAutoDeleteDays(int days) => update((s) => s.autoDeleteDays = days);

  Future<void> setAppLockEnabled(bool value) => update((s) => s.appLockEnabled = value);

  Future<void> setOnboarded() => update((s) => s.onboarded = true);

  Future<void> setMonitoringEnabled(bool value) async {
    await update((s) => s.monitoringEnabled = value);
    if (value) {
      await _secure.write(key: _monitoringKey, value: '1');
    } else {
      await _secure.delete(key: _monitoringKey);
    }
  }

  Future<void> resetSettings() async {
    await _repository.reset();
    _cache = null;
    await _secure.delete(key: _pinHashKey);
    await _secure.delete(key: _pinSaltKey);
  }

  // ---------------------------------------------------------------------
  // App lock (encrypted)
  // ---------------------------------------------------------------------

  Future<bool> hasPin() async {
    final hash = await _secure.read(key: _pinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    final salt = _randomSalt();
    final hash = _hashPin(pin, salt);
    await _secure.write(key: _pinSaltKey, value: salt);
    await _secure.write(key: _pinHashKey, value: hash);
    await _secure.write(key: _pinLengthKey, value: '${pin.length}');
  }

  Future<int> pinLength() async {
    final value = await _secure.read(key: _pinLengthKey);
    final parsed = int.tryParse(value ?? '');
    return (parsed != null && parsed >= 4 && parsed <= 6) ? parsed : 4;
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _secure.read(key: _pinSaltKey);
    final hash = await _secure.read(key: _pinHashKey);
    if (salt == null || hash == null) return false;
    final expected = _hashPin(pin, salt);
    if (hash.length != expected.length) return false;
    var diff = 0;
    for (var i = 0; i < hash.length; i++) {
      diff |= hash.codeUnitAt(i) ^ expected.codeUnitAt(i);
    }
    return diff == 0;
  }

  Future<void> removePin() async {
    await _secure.delete(key: _pinHashKey);
    await _secure.delete(key: _pinSaltKey);
    await _secure.delete(key: _pinLengthKey);
  }

  String _randomSalt() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    return base64Encode(bytes);
  }

  String _hashPin(String pin, String salt) {
    final input = utf8.encode('$salt:$pin');
    return base64Encode(sha256.convert(input).bytes);
  }
}
