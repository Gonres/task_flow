import 'package:material_ui/material_ui.dart';

/// TaskFlow logo: the app icon on a rounded primary square, followed by the
/// app name.
class LogoPanel extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.notes_rounded, color: colors.onPrimary),
        ),
        const SizedBox(width: 10),
        Text('TaskFlow', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
