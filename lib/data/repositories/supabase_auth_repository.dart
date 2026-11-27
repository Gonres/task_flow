import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthException, User;

import '../../domain/models/user.dart';
import 'auth_exception.dart';
import 'auth_repository.dart';

/// Signs in through Supabase Auth. Translates Supabase errors into
/// `AuthException`s with messages that are safe to show to the user.
class SupabaseAuthRepository implements AuthRepository {
  new({
    required this._auth,
    required this._redirectUrl,
    this._oauthTimeout = const Duration(minutes: 3),
  });

  final GoTrueClient _auth;

  /// Deep link that the browser returns to after Google sign-in.
  final String _redirectUrl;

  /// How long to wait for the user to finish Google sign-in in the browser.
  /// The browser doesn't report cancellation, so this ends the wait instead.
  final Duration _oauthTimeout;

  /// Signs in with Supabase's email provider. Throws an `AuthException` when
  /// the credentials are wrong, the email isn't confirmed yet, or the server
  /// can't be reached.
  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = response.session;
      if (session == null) {
        throw const AuthException('Sign-in failed. Please try again.');
      }
      return _toUser(session);
    } on AuthApiException catch (exception) {
      throw AuthException(_messageForCode(exception.code, exception.message));
    } on AuthRetryableFetchException {
      throw const AuthException(_offlineMessage);
    }
  }

  /// Opens Google sign-in in the browser and waits until Supabase reports the
  /// session from the redirect back into the app. Throws an `AuthException`
  /// when the browser can't be opened or the user doesn't finish in time.
  @override
  Future<User> signInWithGoogle() async {
    // Subscribe before launching, so that a fast redirect isn't missed.
    final Future<AuthState> signedIn = _auth.onAuthStateChange
        .firstWhere(
          (AuthState state) => state.event == AuthChangeEvent.signedIn,
        )
        .timeout(_oauthTimeout);
    final bool launched;
    try {
      launched = await _auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _redirectUrl,
      );
    } on AuthRetryableFetchException {
      signedIn.ignore();
      throw const AuthException(_offlineMessage);
    }
    if (!launched) {
      signedIn.ignore();
      throw const AuthException("Couldn't open Google sign-in.");
    }
    return _awaitGoogleSession(signedIn);
  }

  /// Returns the user of the session in [signedIn], or throws an
  /// `AuthException` when it times out or carries no session.
  Future<User> _awaitGoogleSession(Future<AuthState> signedIn) async {
    try {
      final Session? session = (await signedIn).session;
      if (session == null) {
        throw const AuthException('Google sign-in failed. Please try again.');
      }
      return _toUser(session);
    } on TimeoutException {
      throw const AuthException('Google sign-in was cancelled.');
    }
  }

  /// Creates the account in Supabase with [name] stored as `full_name` in the
  /// user metadata. The confirmation email links back into the app through
  /// the redirect URL.
  @override
  Future<User?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _auth.signUp(
        email: email,
        password: password,
        data: <String, Object>{'full_name': name},
        emailRedirectTo: _redirectUrl,
      );
      return _signedUpUser(response);
    } on AuthWeakPasswordException {
      throw const AuthException(_weakPasswordMessage);
    } on AuthApiException catch (exception) {
      throw AuthException(_messageForCode(exception.code, exception.message));
    } on AuthRetryableFetchException {
      throw const AuthException(_offlineMessage);
    }
  }

  /// Returns the user of a sign-up [response], or null when the email still
  /// needs to be confirmed. Throws an `AuthException` when the email is
  /// taken: with confirmation on, Supabase hides that by returning a user
  /// without identities instead of an error.
  static User? _signedUpUser(AuthResponse response) {
    if (response.session != null) {
      return _toUser(response.session!);
    }
    if (response.user?.identities?.isEmpty ?? false) {
      throw const AuthException(_emailTakenMessage);
    }
    return null;
  }

  static const String _offlineMessage =
      "Can't reach the server. Check your connection and try again.";
  static const String _emailTakenMessage =
      'An account with this email already exists.';
  static const String _weakPasswordMessage =
      'Choose a stronger password with letters and numbers.';

  /// Returns a user-facing message for the Supabase error [code], falling
  /// back to Supabase's own [message] for codes without a custom text.
  static String _messageForCode(String? code, String message) {
    switch (code) {
      case 'invalid_credentials':
        return 'Incorrect email or password.';
      case 'email_not_confirmed':
        return 'Confirm your email address before signing in.';
      case 'user_already_exists':
      case 'email_exists':
        return _emailTakenMessage;
      case 'weak_password':
        return _weakPasswordMessage;
      case 'over_request_rate_limit':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return message;
    }
  }

  /// Converts the Supabase user of [session] to the app's user. Takes the name
  /// from the profile metadata that Google fills in, or from the local part of
  /// the email when there's none.
  static User _toUser(Session session) {
    final String email = session.user.email ?? '';
    final Object? name =
        session.user.userMetadata?['full_name'] ??
        session.user.userMetadata?['name'];
    return User(
      id: session.user.id,
      email: email,
      name: name is String && name.isNotEmpty ? name : email.split('@').first,
    );
  }
}
