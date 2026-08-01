import 'package:flutter/material.dart';

/// Explains why the battery optimisation exemption matters and how to grant it.
class BatteryGuideScreen extends StatelessWidget {
  const BatteryGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Battery optimization')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.battery_charging_full, size: 56, color: Colors.green),
          const SizedBox(height: 12),
          Text(
            'Keep ShieldCam reliable',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Android aggressively restricts background apps to save battery. Without an '
            'exemption, the system may stop ShieldCam from monitoring or capturing '
            'evidence while it runs in the background.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _Step(number: '1', text: 'Open Settings and tap "Battery" or "Apps > ShieldCam".'),
          _Step(number: '2', text: 'Find "Battery optimization" (sometimes under "Battery > Unrestricted").'),
          _Step(number: '3', text: 'Select "Don\'t optimize" or choose the "Unrestricted" mode for ShieldCam.'),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tip: keep the monitoring notification visible. It confirms the '
                'foreground service is running and prevents the system from '
                'freezing the app.',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check),
            label: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primaryContainer,
            ),
            child: Text(
              number,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
