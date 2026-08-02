# ShieldCam

Offline Android security monitoring app that automatically records evidence of
failed lock-screen unlock attempts. When a wrong PIN, password or pattern is
entered, ShieldCam captures front and rear camera photos plus GPS coordinates
and stores them locally on the device. Nothing ever leaves the phone — ShieldCam
is 100 % offline with no internet permission, no account, and no analytics.

## Features

- **Failed unlock detection** — an Android accessibility service watches the
  keyguard and infers failed unlock attempts while the device stays locked.
- **Evidence capture** — front / rear camera photos and optional GPS location
  are saved with every event, together with timestamp, battery level and device
  model.
- **Fully offline & private** — no internet permission; all data lives on-device
  in app-private storage. No backend, no cloud, no tracking.
- **On-device dashboard** — total detections plus Today / This week /
  This month counts, and one-tap Test / Export / Gallery actions.
- **Gallery** — browse captured evidence photos with date filters and a
  full-screen detail view.
- **Event details** — inspect each detection with its photos, location and
  captured metadata.
- **Export** — bundle events, photos and metadata into ZIP, PDF or JSON for
  local backup or manual review.
- **App lock** — optional 4–6 digit PIN gate shown before the app UI opens,
  stored encrypted on-device.
- **Background monitoring** — a foreground service (camera + location types)
  keeps detection alive after the app is backgrounded or swiped away, and a
  boot receiver restarts it after device reboot.
- **Privacy controls** — Delete all data wipes events, photos, exports and the
  database; Clear cache removes thumbnails and temp files.

## Screens

| Screen | Purpose |
| --- | --- |
| Splash | App entry and startup routing |
| Onboarding | First-run introduction |
| Permissions | Guided camera / location / notification / accessibility grants |
| Dashboard | Detection counts, status, quick actions |
| Gallery | Photo evidence browser with filters |
| Event detail | Full record for a single detection |
| Settings | Theme, evidence capture options, storage, security, about |
| App lock | Full-screen PIN pad when app lock is enabled |

## Tech Stack

- **Flutter / Dart** — UI, state (Riverpod), routing (go_router), DI (get_it)
- **Kotlin** — native detection engine, foreground service, accessibility
  service, camera + location capture
- **Isar** — embedded on-device database
- **flutter_secure_storage** — encrypted storage for the app-lock PIN
- **geolocator** — GPS capture
- **archive / pdf** — ZIP and PDF export

## Project Layout

```
lib/
  core/          constants, theme, errors, providers, utils, shared widgets
  data/          Isar database + repositories (events, settings)
  di/            service locator
  features/      app_lock, dashboard, event_detail, gallery, home, onboarding,
                 permissions, settings, splash
  models/        domain models (DetectionEvent, etc.)
  navigation/    go_router configuration
  services/      detection, export, location, logging, monitoring, platform,
                 settings, storage, thumbnail

android/app/src/main/kotlin/com/shieldcam/app/
  monitor/       ShieldCamAccessibilityService (unlock detection)
                 ShieldCamForegroundService (background monitoring)
                 DetectionEngine (failed-attempt inference + capture)
                 BootReceiver (restart after reboot / update)
                 PlatformChannel (Flutter <-> Kotlin bridge)
  capture/       CameraCaptureManager (front / rear photos)
  util/          AppStorage, DeviceInfo, LocationProvider
  admin/         optional Device Admin receiver
```

## Prerequisites

- Flutter SDK (Dart SDK `^3.11.1`)
- Android SDK (targetSdk 36, minSdk 24) — Android 6.0+ device
- A physical Android device with a camera (recommended) or an emulator

## Installation (end users)

Download the latest `app-release.apk` from the
[Releases](https://github.com/OWNER/ShieldCam/releases) page, transfer it to
your phone, and open it to install. You may need to allow "Install unknown
apps" for your file manager / browser.

> Note: the APK in GitHub releases is signed with the project's debug key so it
> can be sideloaded and updated by everyone. If you plan to distribute on
> Google Play, set up your own signing config (see below).

## Getting Started (developers)

```bash
flutter pub get
flutter run
```

Build a debug APK:

```bash
flutter build apk --debug
```

Build a release APK:

```bash
flutter build apk --release
```

The release APK is written to
`build/app/outputs/flutter-apk/app-release.apk`.

### Signing (before publishing to Play Store)

The release build currently signs with the debug key so that `flutter run
--release` works out of the box. **Replace this before Play Store
distribution.** See the Flutter docs on
[signing your app](https://docs.flutter.dev/deployment/android#signing-the-app)
and update the `signingConfig` in `android/app/build.gradle.kts`.

## Usage

### First launch

1. Complete the onboarding and permission screens. Grant:
   - **Camera** — evidence photos
   - **Location** — GPS coordinates (optional)
   - **Notifications** — persistent monitoring indicator
   - **Accessibility** — unlock detection (via System Settings → Accessibility)
2. Optionally allow ShieldCam to ignore battery optimization so monitoring
   survives backgrounding.
3. From the Dashboard, confirm monitoring is **Active**.

### Verifying detection

1. With monitoring active, lock the device.
2. Enter an incorrect PIN / password / pattern several times.
3. Unlock the device and reopen ShieldCam.
4. The failed attempts are logged — see the Dashboard count and the photos and
   coordinates in the Gallery.

### Everyday use

- **Dashboard** — monitor detection totals. Tap **Test** to create a manual
  event, **Export** to back up evidence, **Gallery** to browse photos.
- **Gallery** — filter events by date and open any event to view its full
  record and images.
- **Settings** — toggle front / rear camera capture, location, and JPEG
  quality; manage storage (auto delete, clear cache, delete all data); set up
  app lock and review permissions.
- **App lock** — Settings → App lock to set a 4–6 digit PIN. Once enabled, a
  full-screen PIN pad appears before the UI. Change PIN and Disable both require
  the current PIN.

## Storage

Everything is written to app-private external storage:

```
Android/data/com.shieldcam.app/files/ShieldCam/
  Images/     captured evidence photos
  Exports/    ZIP / PDF / JSON exports
  Database/   Isar database
  Logs/       app.log (diagnostics)
  Temp/       thumbnails + pending events
```

Settings → Delete all data clears all of the above. Uninstalling the app also
removes everything.

## Detection Notes

- Detection relies on the **accessibility service** observing the keyguard and
  on the device's locked state. Evidence is captured when unlock attempts fail
  while the device remains locked.
- On some devices / emulators the keyguard does not visually dismiss in the
  accessibility tree, which can produce additional events; on real hardware a
  successful unlock dismisses the keyguard and cancels the pending check.
- Monitoring must be running (foreground service) for detection to work when
  the app is backgrounded. Re-grant the accessibility permission if the system
  ever revokes it.

## Privacy

See [PRIVACY](PRIVACY.md) for the in-app privacy policy. In short: ShieldCam is
fully offline, stores everything locally, and has no way to transmit data.

## Contributing

Bug reports and feature requests are welcome via GitHub issues. For code
changes, please keep the existing structure (feature folders, Riverpod +
go_router, Kotlin native layer) and run `flutter analyze` before opening a pull
request.

## Changelog

See [CHANGELOG](CHANGELOG.md).

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
