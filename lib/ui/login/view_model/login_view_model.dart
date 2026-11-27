import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/user.dart';
import '../../core/validation/validate_email.dart';

/// Holds the login screen's state and logic. Knows nothing about widgets, so
/// it can be unit tested without pumping a widget tree.
class LoginViewModel extends ChangeNotifier {
  new({required this._authRepository});

  final AuthRepository _authRepository;

  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _submitted = false;
  String? _errorMessage;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  /// Error from the last sign-in attempt (e.g. wrong password), or null.
  String? get errorMessage => _errorMessage;

  /// Validation error of the email field. Null until the user has tried to
  /// submit, so that the form doesn't show errors before the first attempt.
  String? get emailError => _submitted ? validateEmail(_email) : null;

  /// Validation error of the password field. Null until the user has tried to
  /// submit, so that the form doesn't show errors before the first attempt.
  String? get passwordError => _submitted ? _validatePassword(_password) : null;

  /// Stores the trimmed email and clears the error of the last sign-in
  /// attempt, because it no longer applies to the edited input.
  void onEmailChanged(String value) {
    _email = value.trim();
    _errorMessage = null;
    notifyListeners();
  }

  /// Stores the password and clears the error of the last sign-in attempt,
  /// because it no longer applies to the edited input.
  void onPasswordChanged(String value) {
    _password = value;
    _errorMessage = null;
    notifyListeners();
  }

  /// Shows the password in plain text when hidden, and hides it when shown.
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Validates the fields and signs in with email and password. Returns the
  /// signed-in user, or null when validation or sign-in failed, in which case
  /// [emailError], [passwordError] or [errorMessage] say why. Returns null
  /// without doing anything while another sign-in is in progress.
  Future<User?> signIn() async {
    if (_isLoading) {
      return null;
    }
    _submitted = true;
    if (validateEmail(_email) != null || _validatePassword(_password) != null) {
      notifyListeners();
      return null;
    }
    return _run(
      () => _authRepository.signInWithEmail(email: _email, password: _password),
    );
  }

  /// Signs in with Google. Returns the signed-in user, or null when sign-in
  /// failed and [errorMessage] says why. Returns null without doing anything
  /// while another sign-in is in progress.
  Future<User?> signInWithGoogle() async {
    if (_isLoading) {
      return null;
    }
    return _run(_authRepository.signInWithGoogle);
  }

  /// Runs the sign-in [action] with [isLoading] set, and returns its user.
  /// Returns null and sets [errorMessage] when it throws: the message of an
  /// `AuthException`, or a generic message for unexpected errors so that
  /// internals aren't shown to the user.
  Future<User?> _run(Future<User> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await action();
    } on AuthException catch (exception) {
      _errorMessage = exception.message;
      return null;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Returns the message to show under the password field, or null when
  /// [password] is not empty. Strength isn't checked on sign-in.
  static String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Enter your password';
    }
    return null;
  }
}
