import 'package:material_ui/material_ui.dart';

/// Horizontal divider with "or" in the middle, separating alternative
/// sign-in methods.
class OrDividerPanel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final Color outline = Theme.of(context).colorScheme.outline;

    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('or', style: TextStyle(color: outline)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
