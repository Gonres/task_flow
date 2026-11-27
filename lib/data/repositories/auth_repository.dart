import '../../domain/models/user.dart';

/// Contract for authentication. The view model depends only on this, so the
/// backend (Firebase, REST API, fake) can be swapped freely.
abstract class AuthRepository {
  /// Signs in with [email] and [password] and returns the signed-in user.
  /// Throws an `AuthException` when the credentials are rejected.
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs in through the Google account flow and returns the signed-in user.
  /// Throws an `AuthException` when the user cancels or Google rejects it.
  Future<User> signInWithGoogle();

  /// Creates an account with [email] and [password] and stores [name] in the
  /// user's profile. Returns the signed-in user, or null when the backend
  /// first requires the user to confirm the email address through a link sent
  /// to it. Throws an `AuthException` when the email is already registered or
  /// the password is rejected.
  Future<User?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });
}
