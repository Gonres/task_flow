import 'package:material_ui/material_ui.dart';

/// Tells the user to confirm the account through the link sent to [email],
/// with a button back to the login screen.
class SignUpConfirmationPanel extends StatelessWidget {
  const new({super.key, required this.email});

  static const Key backToSignInButtonKey = Key('signUpBackToSignInButton');

  final String email;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 48),
        Icon(Icons.mark_email_unread_outlined, size: 64, color: colors.primary),
        const SizedBox(height: 24),
        Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: text.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'We sent a confirmation link to $email. Open it on this phone to '
          'activate your account, then sign in.',
          textAlign: TextAlign.center,
          style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        FilledButton(
          key: backToSignInButtonKey,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back to sign in'),
        ),
      ],
    );
  }
}
