import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import 'config/auth_redirect_url.dart';
import 'config/supabase_publishable_key.dart';
import 'config/supabase_url.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/fake_auth_repository.dart';
import 'data/repositories/supabase_auth_repository.dart';
import 'task_flow_app.dart';

/// Locks the app to portrait, because it's designed for phones only, and
/// starts it with the Supabase backend.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  runApp(TaskFlowApp(authRepository: await _createAuthRepository()));
}

/// Connects to Supabase and returns its repository. Falls back to the fake
/// backend when no Supabase keys were passed at build time, so that the app
/// still runs without a project.
Future<AuthRepository> _createAuthRepository() async {
  if (supabaseUrl.isEmpty || supabasePublishableKey.isEmpty) {
    debugPrint(
      'Supabase keys missing, using FakeAuthRepository. '
      'Run with --dart-define-from-file=supabase.json to connect.',
    );
    return FakeAuthRepository();
  }
  final Supabase supabase = await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );
  return SupabaseAuthRepository(
    auth: supabase.client.auth,
    redirectUrl: authRedirectUrl,
  );
}
