import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shieldcam/core/providers/providers.dart';
import 'package:shieldcam/navigation/app_router.dart';
import 'package:shieldcam/services/logging/app_logger.dart';

/// Full-screen PIN pad shown when app lock is enabled.
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _entered = '';
  int _pinLength = 4;
  bool _checking = false;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _loadPinLength();
  }

  Future<void> _loadPinLength() async {
    final length = await ref.read(settingsServiceProvider).pinLength();
    if (mounted) setState(() => _pinLength = length);
  }

  Future<void> _onDigit(String digit) async {
    if (_checking) return;
    final next = _entered + digit;
    setState(() {
      _entered = next;
      _showError = false;
    });

    if (_entered.length >= _pinLength) {
      await _verify();
    }
  }

  Future<void> _verify() async {
    setState(() => _checking = true);
    final ok = await ref.read(settingsServiceProvider).verifyPin(_entered);
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.dashboard);
      return;
    }
    AppLogger.w('App lock PIN verification failed');
    setState(() {
      _checking = false;
      _entered = '';
      _showError = true;
    });
  }

  void _backspace() {
    if (_entered.isEmpty || _checking) return;
    setState(() {
      _entered = _entered.substring(0, _entered.length - 1);
      _showError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Icon(Icons.lock_outline_rounded, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'ShieldCam is locked',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your PIN to continue',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            _PinDots(count: _pinLength, filled: _entered.length, error: _showError),
            if (_showError)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Incorrect PIN',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            const Spacer(flex: 2),
            _Keypad(onDigit: _onDigit, onBackspace: _backspace, disabled: _checking),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  const _PinDots({required this.count, required this.filled, required this.error});

  final int count;
  final int filled;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = error ? theme.colorScheme.error : theme.colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < filled ? color : Colors.transparent,
            border: Border.all(color: color, width: 1.5),
          ),
        );
      }),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onDigit, required this.onBackspace, required this.disabled});

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool disabled;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          for (final row in _rows)
            Row(
              children: [
                for (final digit in row) _Key(disabled: disabled, label: digit, onTap: () => onDigit(digit)),
              ],
            ),
          Row(
            children: [
              const _Key(disabled: false, label: '', onTap: null, empty: true),
              _Key(disabled: disabled, label: '0', onTap: () => onDigit('0')),
              _Key(
                disabled: disabled,
                label: '',
                icon: Icons.backspace_outlined,
                onTap: onBackspace,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.disabled,
    required this.label,
    required this.onTap,
    this.icon,
    this.empty = false,
  });

  final bool disabled;
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool empty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = Material(
      color: empty ? Colors.transparent : theme.colorScheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: disabled || empty ? null : onTap,
        child: SizedBox(
          width: 76,
          height: 76,
          child: Center(
            child: icon != null
                ? Icon(icon, size: 28, color: theme.colorScheme.onSurface)
                : Text(
                    label,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(6),
      child: button,
    );
  }
}
