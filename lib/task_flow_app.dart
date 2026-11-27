import 'package:material_ui/material_ui.dart';

import 'data/repositories/auth_repository.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/login/view_model/login_view_model.dart';
import 'ui/login/widgets/login_screen.dart';
import 'ui/sign_up/widgets/sign_up_screen.dart';

/// Root of the app. Applies the light and dark theme and opens the login
/// screen. Login and sign-up both go through [authRepository].
class TaskFlowApp extends StatefulWidget {
  const new({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  State<TaskFlowApp> createState() => _TaskFlowAppState();
}

/// Owns the login view model so that it lives as long as the app and is
/// disposed with it.
class _TaskFlowAppState extends State<TaskFlowApp> {
  late final LoginViewModel _loginViewModel = LoginViewModel(
    authRepository: widget.authRepository,
  );

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: LoginScreen(viewModel: _loginViewModel),
      routes: <String, WidgetBuilder>{
        SignUpScreen.routeName: (BuildContext context) {
          return SignUpScreen(authRepository: widget.authRepository);
        },
      },
    );
  }
}
