import 'package:flutter/material.dart';
import 'package:shieldcam/services/settings/settings_service.dart';

/// Dialog to create a new 4-6 digit app-lock PIN. Returns the PIN or null.
Future<String?> showPinSetupDialog(BuildContext context) async {
  final first = await _enterPin(context, 'Set a PIN', 'Choose a 4-6 digit PIN');
  if (first == null) return null;
  // Let the first dialog's route fully dispose before autofocusing the next
  // field, otherwise its caret post-frame callbacks fire on a detached node.
  await Future<void>.delayed(const Duration(milliseconds: 350));
  final second = await _enterPin(context, 'Confirm your PIN', 'Enter the same PIN again');
  if (second == null) return null;
  if (first != second) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match. Try again.')),
      );
    }
    return showPinSetupDialog(context);
  }
  return first;
}

/// Dialog that verifies the current PIN. Returns true when verified.
Future<bool> showPinVerifyDialog(BuildContext context, SettingsService service) async {
  final pin = await _enterPin(context, 'Enter current PIN', 'Verify to continue');
  if (pin == null) return false;
  final ok = await service.verifyPin(pin);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Incorrect PIN')),
    );
    return showPinVerifyDialog(context, service);
  }
  return ok;
}

Future<String?> _enterPin(BuildContext context, String title, String subtitle) {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 6,
        autofocus: true,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: '****',
          helperText: subtitle,
          counterText: '',
        ),
        onSubmitted: (v) async {
          if (v.length >= 4) {
            await _submit(context, controller, focusNode);
          }
        },
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => _submit(context, controller, focusNode),
          child: const Text('Continue'),
        ),
      ],
    ),
  ).whenComplete(() {
    controller.dispose();
    focusNode.dispose();
  });
}

/// Drops keyboard focus first, then lets the caret post-frame callbacks drain
/// before popping, avoiding a framework assert on the detaching text field.
Future<void> _submit(
  BuildContext context,
  TextEditingController controller,
  FocusNode focusNode,
) async {
  final value = controller.text.trim();
  if (value.length < 4) return;
  focusNode.unfocus();
  await Future<void>.delayed(const Duration(milliseconds: 150));
  if (context.mounted) Navigator.pop(context, value);
}
