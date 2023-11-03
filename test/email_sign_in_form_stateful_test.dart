import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

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

  // Convention to name tests using different Acceptance Criteria for that feature
  testWidgets(
      'WHEN user doesn\'t enter the email and password '
          ' AND user taps on the sign-in button'
          ' THEN signInWithEmailAndPassword is not called',
          (WidgetTester tester) async {
        await pumpEmailSignInForm(tester);

        final signInButton = find.text('Sign in');
        await tester.tap(signInButton);
        // verifyNever(mockAuth.signInWithEmailAndPassword('test', 'test'));
        verifyNever(mockAuth.mockTest('email', 'password'));

      });
}