# Changelog

All notable changes to ShieldCam are documented in this file.

## [1.0.0] - 2026-08-02

### Added

- Failed lock-screen unlock detection via an Android accessibility service.
- Front / rear camera evidence capture with configurable JPEG quality.
- Optional GPS location recording per event.
- On-device dashboard with Today / This week / This month totals.
- Reactive gallery with date filters and full-screen event detail view.
- ZIP / PDF / JSON export of events and evidence.
- Optional 4–6 digit app lock PIN, stored encrypted on-device.
- Background monitoring via a foreground service and reboot restart.
- Privacy controls: delete all data, clear cache, auto-delete.
- Onboarding, permission management, and battery-optimization guides.
- Fully offline: no internet permission, no cloud, no analytics.

### Fixed

- PIN setup / change dialogs no longer trigger a Flutter framework assertion
  when the dialog pops while the text field is losing focus.

### Security

- Evidence and settings stored exclusively in app-private storage.
- App-lock PIN stored as an encrypted value via `flutter_secure_storage`.
