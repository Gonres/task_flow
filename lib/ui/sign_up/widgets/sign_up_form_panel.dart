import 'package:material_ui/material_ui.dart';

import '../../../domain/models/user.dart';
import '../../core/widgets/progress_filled_button.dart';
import '../../login/widgets/auth_standalone_field.dart';
import '../../login/widgets/password_visibility_button.dart';
import '../../login/widgets/show_signed_in_message.dart';
import '../view_model/sign_up_view_model.dart';

/// Name, email and password fields with the create-account button. Shows
/// field validation errors and the error of the last attempt from
/// [viewModel].
class SignUpFormPanel extends StatelessWidget {
  const new({super.key, required this.viewModel});

  static const Key nameFieldKey = Key('signUpNameField');
  static const Key emailFieldKey = Key('signUpEmailField');
  static const Key passwordFieldKey = Key('signUpPasswordField');
  static const Key createAccountButtonKey = Key('signUpCreateAccountButton');

  final SignUpViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final String? errorMessage = viewModel.errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AuthStandaloneField(
          key: nameFieldKey,
          label: 'Name',
          icon: Icons.person_outline_rounded,
          hintText: 'Your full name',
          onChanged: viewModel.onNameChanged,
          errorText: viewModel.nameError,
          enabled: !viewModel.isLoading,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.name],
        ),
        const SizedBox(height: 20),
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
          hintText: 'At least ${SignUpViewModel.minPasswordLength} characters',
          onChanged: viewModel.onPasswordChanged,
          onSubmitted: (_) => _signUp(context),
          errorText: viewModel.passwordError,
          enabled: !viewModel.isLoading,
          obscureText: viewModel.obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.newPassword],
          suffix: PasswordVisibilityButton(
            obscured: viewModel.obscurePassword,
            onPressed: viewModel.togglePasswordVisibility,
          ),
        ),
        const SizedBox(height: 24),
        if (errorMessage != null) ...<Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: colors.error),
          ),
          const SizedBox(height: 12),
        ],
        ProgressFilledButton(
          key: createAccountButtonKey,
          label: 'Create account',
          isLoading: viewModel.isLoading,
          onPressed: () => _signUp(context),
        ),
      ],
    );
  }

  /// Closes the keyboard and creates the account. When the user is signed in
  /// right away, shows it and returns to the previous screen. Otherwise the
  /// screen shows the errors or the confirmation message from the view model.
  Future<void> _signUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final User? user = await viewModel.signUp();
    if (user != null && context.mounted) {
      showSignedInMessage(context, user);
      Navigator.of(context).pop();
    }
  }
}
