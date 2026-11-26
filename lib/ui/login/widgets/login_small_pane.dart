import 'package:material_ui/material_ui.dart';

import '../../../domain/models/user.dart';
import '../view_model/login_view_model.dart';
import 'google_sign_in_button.dart';
import 'login_form_panel.dart';
import 'logo_panel.dart';
import 'or_divider_panel.dart';
import 'show_signed_in_message.dart';
import 'sign_up_prompt_panel.dart';

/// Login body for phones: logo, greeting, the email form, Google sign-in and
/// a link to create an account at the bottom. Must be placed in a parent with
/// bounded height, because it uses a `Spacer` to push the footer down.
class LoginSmallPane extends StatelessWidget {
  const new({super.key, required this.viewModel});

  static const Key googleSignInButtonKey = Key('loginGoogleSignInButton');

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 48),
          const LogoPanel(),
          const SizedBox(height: 40),
          Text('Welcome back', style: text.headlineLarge),
          const SizedBox(height: 8),
          Text(
            "Sign in to see your team's tasks for today.",
            style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          LoginFormPanel(viewModel: viewModel),
          const SizedBox(height: 32),
          const OrDividerPanel(),
          const SizedBox(height: 32),
          GoogleSignInButton(
            key: googleSignInButtonKey,
            onPressed: viewModel.isLoading
                ? null
                : () => _signInWithGoogle(context),
          ),
          const Spacer(),
          const SizedBox(height: 24),
          const SignUpPromptPanel(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Signs in with Google and shows the result when it succeeds. Failures are
  /// shown by the form from the view model's error message.
  Future<void> _signInWithGoogle(BuildContext context) async {
    final User? user = await viewModel.signInWithGoogle();
    if (user != null && context.mounted) {
      showSignedInMessage(context, user);
    }
  }
}
