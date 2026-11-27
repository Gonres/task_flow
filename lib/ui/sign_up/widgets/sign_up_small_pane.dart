import 'package:material_ui/material_ui.dart';

import '../view_model/sign_up_view_model.dart';
import 'sign_in_prompt_panel.dart';
import 'sign_up_form_panel.dart';

/// Sign-up body for phones: heading, the account form and a link back to
/// signing in.
class SignUpSmallPane extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final SignUpViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 16),
          Text('Create your account', style: text.headlineLarge),
          const SizedBox(height: 8),
          Text(
            "Start organizing your team's tasks in minutes.",
            style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          SignUpFormPanel(viewModel: viewModel),
          const SizedBox(height: 24),
          const SignInPromptPanel(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
