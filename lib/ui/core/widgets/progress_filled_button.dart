import 'package:material_ui/material_ui.dart';

/// Primary button with [label] that shows a spinner while [isLoading]. It
/// stays enabled while loading, and view models ignore repeated taps, so that
/// the spinner sits on the primary color instead of the grey disabled state.
class ProgressFilledButton extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: isLoading
          ? SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : Text(label),
    );
  }
}
