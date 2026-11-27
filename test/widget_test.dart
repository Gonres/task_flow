import 'package:flutter_test/flutter_test.dart';

import 'package:task_flow/data/repositories/fake_auth_repository.dart';
import 'package:task_flow/task_flow_app.dart';
import 'package:task_flow/ui/login/widgets/login_form_panel.dart';
import 'package:task_flow/ui/login/widgets/sign_up_prompt_panel.dart';
import 'package:task_flow/ui/sign_up/widgets/sign_up_form_panel.dart';

void main() {
  testWidgets('login screen shows validation errors on empty submit', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TaskFlowApp(authRepository: FakeAuthRepository(delay: Duration.zero)),
    );

    expect(find.text('Welcome back'), findsOneWidget);

    await tester.tap(find.byKey(LoginFormPanel.signInButtonKey));
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });

  testWidgets('create account opens sign-up and back returns to login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      TaskFlowApp(authRepository: FakeAuthRepository(delay: Duration.zero)),
    );

    await tester.ensureVisible(
      find.byKey(SignUpPromptPanel.createAccountButtonKey),
    );
    await tester.tap(find.byKey(SignUpPromptPanel.createAccountButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(SignUpFormPanel.createAccountButtonKey),
    );
    await tester.tap(find.byKey(SignUpFormPanel.createAccountButtonKey));
    await tester.pump();

    expect(find.text('Enter your name'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
