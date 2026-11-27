import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/auth_repository.dart';
import '../view_model/sign_up_view_model.dart';
import 'sign_up_confirmation_panel.dart';
import 'sign_up_small_pane.dart';

/// Full sign-up screen with a back button to the login screen. Shows the form
/// until the account is created, then the "check your email" message when
/// the backend requires email confirmation. Owns its view model, so that the
/// entered data is dropped when the screen closes.
class SignUpScreen extends StatefulWidget {
  const new({super.key, required this.authRepository});

  /// Route name under which the app registers this screen.
  static const String routeName = '/sign-up';

  final AuthRepository authRepository;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

/// Creates the view model when the screen opens and disposes it on close.
class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpViewModel _viewModel = SignUpViewModel(
    authRepository: widget.authRepository,
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: _buildBody,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the confirmation message once a link was sent, otherwise the
  /// sign-up form.
  Widget _buildBody(BuildContext context, Widget? child) {
    final String? confirmationEmail = _viewModel.confirmationEmail;
    if (confirmationEmail != null) {
      return SignUpConfirmationPanel(email: confirmationEmail);
    }
    return SignUpSmallPane(viewModel: _viewModel);
  }
}
