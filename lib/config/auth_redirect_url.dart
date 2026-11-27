/// Deep link that Supabase redirects to after Google sign-in in the browser.
/// Must be listed under Authentication > URL Configuration > Redirect URLs in
/// the Supabase dashboard, and match the scheme registered in
/// AndroidManifest.xml and Info.plist.
const String authRedirectUrl = 'com.example.taskflow://login-callback';
