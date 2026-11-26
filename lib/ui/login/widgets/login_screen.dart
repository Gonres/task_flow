import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../view_model/login_view_model.dart';
import 'login_small_pane.dart';

/// Full login screen. Sets status-bar icons that contrast with the surface,
/// closes the keyboard on taps outside a field, and shows [LoginSmallPane]
/// scrollable, because the app runs on phones only.
class LoginScreen extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final LoginViewModel viewModel;

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
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: ListenableBuilder(
                        listenable: viewModel,
                        builder: (BuildContext context, Widget? child) {
                          return LoginSmallPane(viewModel: viewModel);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
