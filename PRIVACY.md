# ShieldCam Privacy Policy

**Last updated:** 2026

ShieldCam is a fully offline application. It has no backend, no account, no
cloud storage and no analytics. It does not collect or transmit any data, and
it cannot — it has no internet capability.

## What we store

- Captured evidence photos (front and rear camera).
- Event metadata: timestamp, location, battery level and device model.
- Settings and your optional app-lock PIN (stored as an encrypted hash via
  `flutter_secure_storage`).
- Local logs used for debugging.

## Where it is stored

Everything is stored exclusively in app-private storage on your device:

```
Android/data/com.shieldcam.app/files/ShieldCam/
```

Nothing is uploaded anywhere, ever.

## Location

If you enable location, ShieldCam records the GPS coordinates of each detected
event. This data never leaves your device.

## Accessibility service

The accessibility service only observes whether the lock screen is shown or
dismissed. It never reads the content of PIN, password or pattern fields, and
it never transmits anything.

## Deleting your data

You can delete any event at any time, or wipe all data from
Settings > Delete all data. Uninstalling the app removes everything.
