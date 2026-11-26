import 'package:material_ui/material_ui.dart';

/// Labelled text input used on the auth screens. Reports every edit through
/// [onChanged] instead of belonging to a form. Its look comes from
/// `inputDecorationTheme` in `AppTheme`.
class AuthStandaloneField extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.icon,
    required this.onChanged,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: Icon(icon),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
