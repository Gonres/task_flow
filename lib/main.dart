import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'data/repositories/fake_auth_repository.dart';
import 'task_flow_app.dart';

/// Locks the app to portrait, because it's designed for phones only, and
/// starts it with the fake backend.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  // Swap FakeAuthRepository for a real implementation when the backend is ready.
  runApp(TaskFlowApp(authRepository: FakeAuthRepository()));
}
