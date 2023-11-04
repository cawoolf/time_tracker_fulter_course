import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';

@GenerateNiceMocks([MockSpec<Auth>()])
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'email_sign_in_form_stateful_test.mocks.dart';

void main() {
  var mockAuth = MockAuth();

  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(body: EmailSignInFormStateful()),
        ),
      ),
    );
  }

  group('sign in', () {
    // Convention to name tests using different Acceptance Criteria for that feature
    testWidgets(
        'WHEN user doesn\'t enter the email and password '
        ' AND user taps on the sign-in button'
        ' THEN signInWithEmailAndPassword IS NOT called',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);
      verifyNever(mockAuth.signInWithEmailAndPassword('', ''));
    });

    testWidgets(
        ' WHEN user doesn\'t enter the email and password '
            ' AND user taps on the sign-in button '
            ' THEN signInWithEmailAndPassword IS called ',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      const email = 'email@email.com';
      const password ='password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // When running tests, the widgets arent automatically rebuilt when setState() is called.
      // Must pump() the widget to reset the state
      await tester.pump();
      // await tester.pumpAndSettle(); // Waits for all animations to be finished.

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      // called() is the number of times we expect the method to be called.
      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
    });
  });

  group('register', () {
    // Convention to name tests using different Acceptance Criteria for that feature
    testWidgets(
        'WHEN user taps on the secondary button '
        ' THEN form toggles to registration mode',
            (WidgetTester tester) async {
          await pumpEmailSignInForm(tester);

          final registerButton = find.text('Need an account? Register');
          await tester.tap(registerButton);
          await tester.pump();
          final createAccountButton = find.text('Create an account');
          expect(createAccountButton, findsOneWidget);
        });
  });
}
