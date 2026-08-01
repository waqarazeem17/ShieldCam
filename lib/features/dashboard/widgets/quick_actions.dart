import 'package:flutter/material.dart';

/// Horizontal quick-action row on the dashboard.
class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onTest,
    required this.onExport,
    required this.onGallery,
  });

  final VoidCallback onTest;
  final VoidCallback onExport;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _Action(
              icon: Icons.flash_on,
              label: 'Test',
              onTap: onTest,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Action(
              icon: Icons.archive_outlined,
              label: 'Export',
              onTap: onExport,
              color: const Color(0xFF2E8B57),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Action(
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              onTap: onGallery,
              color: const Color(0xFF7B4FB0),
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
