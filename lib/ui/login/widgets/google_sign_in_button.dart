import 'package:material_ui/material_ui.dart';

/// Outlined "Continue with Google" button. Disabled when [onPressed] is null.
class GoogleSignInButton extends StatelessWidget {
  const new({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // TODO: replace with the official Google "G" logo asset.
          Text(
            'G',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4285F4), // Google brand color
            ),
          ),
          SizedBox(width: 12),
          Text('Continue with Google'),
        ],
      ),
    );
  }
}
