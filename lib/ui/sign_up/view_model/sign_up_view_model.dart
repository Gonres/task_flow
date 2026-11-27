import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/user.dart';
import '../../core/validation/validate_email.dart';

/// Holds the sign-up screen's state and logic. Knows nothing about widgets, so
/// it can be unit tested without pumping a widget tree.
class SignUpViewModel extends ChangeNotifier {
  new({required this._authRepository});

  final AuthRepository _authRepository;

  /// Shortest password accepted, matching common Supabase project settings.
  static const int minPasswordLength = 8;

  String _name = '';
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _submitted = false;
  String? _errorMessage;
  String? _confirmationEmail;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  /// Error from the last sign-up attempt (e.g. email taken), or null.
  String? get errorMessage => _errorMessage;

  /// Email address that a confirmation link was sent to after a successful
  /// sign-up, or null while the account hasn't been created yet.
  String? get confirmationEmail => _confirmationEmail;

  /// Validation error of the name field. Null until the user has tried to
  /// submit, so that the form doesn't show errors before the first attempt.
  String? get nameError => _submitted ? _validateName(_name) : null;

  /// Validation error of the email field. Null until the user has tried to
  /// submit, so that the form doesn't show errors before the first attempt.
  String? get emailError => _submitted ? validateEmail(_email) : null;

  /// Validation error of the password field. Null until the user has tried to
  /// submit, so that the form doesn't show errors before the first attempt.
  String? get passwordError => _submitted ? _validatePassword(_password) : null;

  /// Stores the trimmed name and clears the error of the last attempt,
  /// because it no longer applies to the edited input.
  void onNameChanged(String value) {
    _name = value.trim();
    _clearError();
  }

  /// Stores the trimmed email and clears the error of the last attempt,
  /// because it no longer applies to the edited input.
  void onEmailChanged(String value) {
    _email = value.trim();
    _clearError();
  }

  /// Stores the password and clears the error of the last attempt, because it
  /// no longer applies to the edited input.
  void onPasswordChanged(String value) {
    _password = value;
    _clearError();
  }

  /// Shows the password in plain text when hidden, and hides it when shown.
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Validates the fields and creates the account. Returns the signed-in user
  /// when the backend signs in right away. Returns null when validation or
  /// sign-up failed, in which case the field errors or [errorMessage] say
  /// why, or when a confirmation email was sent, in which case
  /// [confirmationEmail] is set. Returns null without doing anything while
  /// another attempt is in progress.
  Future<User?> signUp() async {
    if (_isLoading) {
      return null;
    }
    _submitted = true;
    if (_validateName(_name) != null ||
        validateEmail(_email) != null ||
        _validatePassword(_password) != null) {
      notifyListeners();
      return null;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final User? user = await _authRepository.signUpWithEmail(
        name: _name,
        email: _email,
        password: _password,
      );
      _confirmationEmail = user == null ? _email : null;
      return user;
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

  /// Removes the error of the last attempt and redraws the form.
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Returns the message to show under the name field, or null when [name]
  /// is not empty.
  static String? _validateName(String name) {
    if (name.isEmpty) {
      return 'Enter your name';
    }
    return null;
  }

  /// Returns the message to show under the password field, or null when
  /// [password] has at least [minPasswordLength] characters.
  static String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Enter a password';
    }
    if (password.length < minPasswordLength) {
      return 'Use at least $minPasswordLength characters';
    }
    return null;
  }
}
