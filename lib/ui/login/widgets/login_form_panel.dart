import 'package:material_ui/material_ui.dart';

import '../../../domain/models/user.dart';
import '../../core/widgets/progress_filled_button.dart';
import '../view_model/login_view_model.dart';
import 'auth_standalone_field.dart';
import 'password_visibility_button.dart';
import 'show_signed_in_message.dart';

/// Email and password fields with the sign-in button. Shows field validation
/// errors and the error of the last sign-in attempt from [viewModel].
class LoginFormPanel extends StatelessWidget {
  const new({super.key, required this.viewModel});

  static const Key emailFieldKey = Key('loginEmailField');
  static const Key passwordFieldKey = Key('loginPasswordField');
  static const Key signInButtonKey = Key('loginSignInButton');

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final String? errorMessage = viewModel.errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AuthStandaloneField(
          key: emailFieldKey,
          label: 'Email',
          icon: Icons.mail_outline_rounded,
          hintText: 'you@company.com',
          onChanged: viewModel.onEmailChanged,
          errorText: viewModel.emailError,
          enabled: !viewModel.isLoading,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.email],
        ),
        const SizedBox(height: 20),
        AuthStandaloneField(
          key: passwordFieldKey,
          label: 'Password',
          icon: Icons.lock_outline_rounded,
          hintText: 'Your password',
          onChanged: viewModel.onPasswordChanged,
          onSubmitted: (_) => _signIn(context),
          errorText: viewModel.passwordError,
          enabled: !viewModel.isLoading,
          obscureText: viewModel.obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.password],
          suffix: PasswordVisibilityButton(
            obscured: viewModel.obscurePassword,
            onPressed: viewModel.togglePasswordVisibility,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            // TODO: navigate to forgot-password screen.
            onPressed: () {},
            child: const Text('Forgot password?'),
          ),
        ),
        if (errorMessage != null)
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: colors.error),
          ),
        const SizedBox(height: 12),
        ProgressFilledButton(
          key: signInButtonKey,
          label: 'Sign in',
          isLoading: viewModel.isLoading,
          onPressed: () => _signIn(context),
        ),
      ],
    );
  }

  /// Closes the keyboard, signs in with the entered credentials and shows the
  /// result when it succeeds. Failures are shown from the view model's errors.
  Future<void> _signIn(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final User? user = await viewModel.signIn();
    if (user != null && context.mounted) {
      showSignedInMessage(context, user);
    }
  }
}
