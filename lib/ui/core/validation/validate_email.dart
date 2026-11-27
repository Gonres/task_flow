final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Returns the message to show under an email field, or null when [email] is
/// a non-empty, valid email address.
String? validateEmail(String email) {
  if (email.isEmpty) {
    return 'Enter your email';
  }
  if (!_emailPattern.hasMatch(email)) {
    return 'Enter a valid email';
  }
  return null;
}
