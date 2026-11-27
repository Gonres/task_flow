/// Publishable (anon) key of the Supabase project, passed at build time with
/// `--dart-define-from-file=supabase.json`, so that it stays out of the source
/// code. Empty when not provided.
const String supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
);
