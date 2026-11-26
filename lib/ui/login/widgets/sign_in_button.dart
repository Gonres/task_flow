import 'package:material_ui/material_ui.dart';

/// Primary sign-in button that shows a spinner while [isLoading]. It stays
/// enabled while loading, and the view model ignores repeated taps, so that
/// the spinner sits on the primary color instead of the grey disabled state.
class SignInButton extends StatelessWidget {
  const new({super.key, required this.isLoading, required this.onPressed});

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
          : const Text('Sign in'),
    );
  }
}
