import 'package:flutter_test/flutter_test.dart';

import 'package:task_flow/data/repositories/fake_auth_repository.dart';
import 'package:task_flow/domain/models/user.dart';
import 'package:task_flow/ui/login/view_model/login_view_model.dart';

void main() {
  late LoginViewModel viewModel;

  setUp(() {
    viewModel = LoginViewModel(
      authRepository: FakeAuthRepository(delay: Duration.zero),
    );
  });

  tearDown(() => viewModel.dispose());

  test('no field errors before first submit', () {
    expect(viewModel.emailError, isNull);
    expect(viewModel.passwordError, isNull);
  });

  test('invalid email blocks sign-in', () async {
    viewModel.onEmailChanged('not-an-email');
    viewModel.onPasswordChanged('password123');

    expect(await viewModel.signIn(), isNull);
    expect(viewModel.emailError, 'Enter a valid email');
  });

  test('wrong password sets error message', () async {
    viewModel.onEmailChanged('aisha@taskflow.app');
    viewModel.onPasswordChanged('wrong');

    expect(await viewModel.signIn(), isNull);
    expect(viewModel.errorMessage, 'Incorrect email or password.');
    expect(viewModel.isLoading, isFalse);
  });

  test('valid credentials return user', () async {
    viewModel.onEmailChanged('aisha@taskflow.app');
    viewModel.onPasswordChanged('password123');

    final User? user = await viewModel.signIn();

    expect(user?.email, 'aisha@taskflow.app');
    expect(viewModel.errorMessage, isNull);
  });

  test('editing a field clears the error message', () async {
    viewModel.onEmailChanged('aisha@taskflow.app');
    viewModel.onPasswordChanged('wrong');
    await viewModel.signIn();

    viewModel.onPasswordChanged('password12');

    expect(viewModel.errorMessage, isNull);
  });

  test('toggles password visibility', () {
    expect(viewModel.obscurePassword, isTrue);
    viewModel.togglePasswordVisibility();
    expect(viewModel.obscurePassword, isFalse);
  });
}
