import 'package:material_ui/material_ui.dart';

import '../../../domain/models/user.dart';

/// Shows a snack bar confirming that [user] signed in. Placeholder for the
/// navigation to the task list, which doesn't exist yet.
void showSignedInMessage(BuildContext context, User user) {
  // TODO: navigate to the task list once it exists.
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Signed in as ${user.email}')));
}
