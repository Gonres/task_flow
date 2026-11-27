import 'package:material_ui/material_ui.dart';

/// "Already have an account?" prompt with a button back to the login screen.
class SignInPromptPanel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Already have an account?',
          style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}
