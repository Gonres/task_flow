import 'package:material_ui/material_ui.dart';

import '../../sign_up/widgets/sign_up_screen.dart';

/// "New to TaskFlow?" prompt with a button that leads to account creation.
class SignUpPromptPanel extends StatelessWidget {
  const new({super.key});

  static const Key createAccountButtonKey = Key('loginCreateAccountButton');

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'New to TaskFlow?',
          style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        TextButton(
          key: createAccountButtonKey,
          onPressed: () {
            Navigator.of(context).pushNamed(SignUpScreen.routeName);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: const Text('Create account'),
        ),
      ],
    );
  }
}
