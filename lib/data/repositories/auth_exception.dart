/// Thrown by an `AuthRepository` with a message that is safe to show to the
/// user, as opposed to unexpected errors that need a generic message.
class AuthException implements Exception {
  const new(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}
