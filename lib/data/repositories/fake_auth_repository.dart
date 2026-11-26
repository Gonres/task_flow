import '../../domain/models/user.dart';
import 'auth_exception.dart';
import 'auth_repository.dart';

/// In-memory implementation for development until a real backend exists.
/// Accepts any valid email with the password `password123`. Every call waits
/// for [delay] to simulate network latency.
class FakeAuthRepository implements AuthRepository {
  new({this.delay = const Duration(seconds: 1)});

  final Duration delay;

  static const String _validPassword = 'password123';

  /// Returns a user named after the local part of [email] when [password] is
  /// `password123`, otherwise throws an `AuthException`.
  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    if (password != _validPassword) {
      throw const AuthException('Incorrect email or password.');
    }
    return User(id: 'user-1', email: email, name: email.split('@').first);
  }

  /// Always succeeds and returns the same fixed demo user.
  @override
  Future<User> signInWithGoogle() async {
    await Future<void>.delayed(delay);
    return const User(
      id: 'google-user-1',
      email: 'aisha@taskflow.app',
      name: 'Aisha',
    );
  }
}
