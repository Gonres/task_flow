import 'package:flutter_test/flutter_test.dart';

import 'package:task_flow/data/repositories/auth_exception.dart';
import 'package:task_flow/data/repositories/fake_auth_repository.dart';
import 'package:task_flow/domain/models/user.dart';
import 'package:task_flow/ui/sign_up/view_model/sign_up_view_model.dart';

/// Fake backend that requires email confirmation, like a Supabase project
/// with "Confirm email" turned on, or rejects every sign-up with [error].
class _ConfirmingAuthRepository extends FakeAuthRepository {
  new({this.error}) : super(delay: Duration.zero);

  final AuthException? error;

  @override
  Future<User?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (error case final AuthException error?) {
      throw error;
    }
    return null;
  }
}

/// Fills all fields of [viewModel] with valid input.
void _fillValid(SignUpViewModel viewModel) {
  viewModel.onNameChanged('Aisha');
  viewModel.onEmailChanged('aisha@taskflow.app');
  viewModel.onPasswordChanged('secret123');
}

void main() {
  test('no field errors before first submit', () {
    final SignUpViewModel viewModel = SignUpViewModel(
      authRepository: FakeAuthRepository(delay: Duration.zero),
    );

    expect(viewModel.nameError, isNull);
    expect(viewModel.emailError, isNull);
    expect(viewModel.passwordError, isNull);
  });

  test('empty submit shows all field errors', () async {
    final SignUpViewModel viewModel = SignUpViewModel(
      authRepository: FakeAuthRepository(delay: Duration.zero),
    );

    expect(await viewModel.signUp(), isNull);
    expect(viewModel.nameError, 'Enter your name');
    expect(viewModel.emailError, 'Enter your email');
    expect(viewModel.passwordError, 'Enter a password');
  });

  test('short password blocks sign-up', () async {
    final SignUpViewModel viewModel = SignUpViewModel(
      authRepository: FakeAuthRepository(delay: Duration.zero),
    );
    _fillValid(viewModel);
    viewModel.onPasswordChanged('short');

    expect(await viewModel.signUp(), isNull);
    expect(viewModel.passwordError, 'Use at least 8 characters');
  });

  test('valid input returns the signed-in user', () async {
    final SignUpViewModel viewModel = SignUpViewModel(
      authRepository: FakeAuthRepository(delay: Duration.zero),
    );
    _fillValid(viewModel);

    final User? user = await viewModel.signUp();

    expect(user?.name, 'Aisha');
    expect(viewModel.confirmationEmail, isNull);
  });

  test('required confirmation sets the confirmation email', () async {
    final SignUpViewModel viewModel = SignUpViewModel(
      authRepository: _ConfirmingAuthRepository(),
    );
    _fillValid(viewModel);

    expect(await viewModel.signUp(), isNull);
    expect(viewModel.confirmationEmail, 'aisha@taskflow.app');
    expect(viewModel.errorMessage, isNull);
  });

  test('rejected sign-up sets the error message', () async {
    final SignUpViewModel viewModel = SignUpViewModel(
      authRepository: _ConfirmingAuthRepository(
        error: const AuthException(
          'An account with this email already exists.',
        ),
      ),
    );
    _fillValid(viewModel);

    expect(await viewModel.signUp(), isNull);
    expect(
      viewModel.errorMessage,
      'An account with this email already exists.',
    );
    expect(viewModel.confirmationEmail, isNull);
    expect(viewModel.isLoading, isFalse);
  });
}
