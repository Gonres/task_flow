import 'package:material_ui/material_ui.dart';

/// Eye icon button that shows a hidden password, or hides it again when
/// [obscured] is false.
class PasswordVisibilityButton extends StatelessWidget {
  const new({super.key, required this.obscured, required this.onPressed});

  final bool obscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: obscured ? 'Show password' : 'Hide password',
      icon: Icon(
        obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
    );
  }
}
