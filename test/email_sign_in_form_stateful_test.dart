import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';

@GenerateNiceMocks([MockSpec<Auth>()])
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'email_sign_in_form_stateful_test.mocks.dart';

// User constructor is private. Need to use a Mock
class MockUser extends Mock implements User{}

void main() {
  var mockAuth = MockAuth();
  var mockUser = MockUser();

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

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(mockUser));
  }

  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(FirebaseAuthException(code: 'Login Failed'));
  }

  // Stubbbingggg
  test('stub test',() async {
    stubSignInWithEmailAndPasswordSucceeds();
    var user = await mockAuth.signInWithEmailAndPassword('email', 'password');
    expect(user, mockUser);

  });

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
        ' WHEN user enter the correct email and password '
            ' AND user taps on the sign-in button '
            ' THEN signInWithEmailAndPassword IS called '
            ' AND user is signed in ',
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

      await tester.pump();


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

    testWidgets(
        'WHEN user taps on the secondary button'
            ' AND user enters the email and password'
            ' AND user taps on the register button  '
            ' THEN createUserWithEmail is called ',
            (WidgetTester tester) async {
          await pumpEmailSignInForm(tester);

          const email = 'email@email.com';
          const password ='password';

          final registerButton = find.text('Need an account? Register');
          await tester.tap(registerButton);

          await tester.pump();

          final emailField = find.byKey(Key('email'));
          expect(emailField, findsOneWidget);
          await tester.enterText(emailField, email);

          final passwordField = find.byKey(Key('password'));
          expect(passwordField, findsOneWidget);
          await tester.enterText(passwordField, password);

          await tester.pump();

          final createAccountButton = find.text('Create an account');
          expect(createAccountButton, findsOneWidget);
          await tester.tap(createAccountButton);

          // called() is the number of times we expect the method to be called.
          verify(mockAuth.createUserWithEmailAndPassword(email, password)).called(1);

        });
  });
}
