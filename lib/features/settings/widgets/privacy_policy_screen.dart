import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy policy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'ShieldCam privacy policy',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _paragraph(
            'ShieldCam is a fully offline application. It has no backend, no account, '
            'no cloud storage and no analytics. It does not collect or transmit any '
            'data, and it cannot - it has no internet capability.',
          ),
          _section(theme, 'What we store', [
            'Captured evidence photos (front and rear camera).',
            'Event metadata: timestamp, location, battery level and device model.',
            'Settings and your optional app-lock PIN (stored as an encrypted hash).',
            'Local logs used for debugging.',
          ]),
          _section(theme, 'Where it is stored', [
            'Everything is stored exclusively in app-private storage on your device. '
            'Nothing is uploaded anywhere, ever.',
          ]),
          _section(theme, 'Location', [
            'If you enable location, ShieldCam records the GPS coordinates of each '
            'detected event. This data never leaves your device.',
          ]),
          _section(theme, 'Accessibility service', [
            'The accessibility service only observes whether the lock screen is '
            'shown or dismissed. It never reads the content of PIN, password or '
            'pattern fields, and it never transmits anything.',
          ]),
          _section(theme, 'Deleting your data', [
            'You can delete any event at any time, or wipe all data from '
            'Settings > Delete all data.',
          ]),
        ],
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text),
    );
  }

  Widget _section(ThemeData theme, String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(item)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
