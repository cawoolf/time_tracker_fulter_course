import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';

@GenerateNiceMocks([MockSpec<SignInManager>()])
import 'email_sign_in_form_stateful_test.mocks.dart'; // Use it for the Auth mock
import 'sign_in_page_test.mocks.dart';

class MockUser extends Mock implements User {}

void main() {
  final mockSignInManager = MockSignInManager();
  final mockAuth = MockAuth();
  final mockUser = MockUser();

  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SignInPage(
          manager: mockSignInManager,
          isLoading: false,
        )));
  }

  void stubSignInWithGoogleSucceeds() {
    when(mockAuth.signInWithGoogle())
        .thenAnswer((_) => Future<User>.value(mockUser));
  }

  void stubSignInWithGoogleWebSucceeds() {
    when(mockAuth.signInWithGoogleWeb())
        .thenAnswer((_) => Future<User>.value(mockUser));
  }

  void stubSignInAnonymouslySucceeds() {
    when(mockAuth.signInAnonymously())
        .thenAnswer((realInvocation) => Future<User>.value(mockUser));
  }

  // Can't easily set kIsWeb during tests..
  // This a test work around
  group('sign in methods', () {
    testWidgets(
        ' GIVEN the user has landed on the SignInPage '
            ' WHEN the user taps the google_sign_in_button '
            ' AND regardless of which platform is being used'
            ' THEN the user is signed in with google', (
        WidgetTester tester) async {
      await pumpSignInPage(tester);

      final googleSignInButton = find.byKey(const Key('google_sign_in_button'));
      expect(googleSignInButton, findsOneWidget);

      await tester.tap(googleSignInButton);

      if (kIsWeb) {
        verify(mockSignInManager.signInWithGoogleWeb()).called(1);

        stubSignInWithGoogleWebSucceeds();

        var user = await mockAuth.signInWithGoogleWeb();

        expect(user, mockUser);

        print('kIsWeb: $kIsWeb -> signInWithGoogleWeb() called');

      } else {
        verify(mockSignInManager.signInWithGoogle()).called(1);

        stubSignInWithGoogleSucceeds();

        var user = await mockAuth.signInWithGoogle();

        expect(user, mockUser);

        print('kIsWeb: $kIsWeb -> signInWithGoogle() called');
      }
    });

    // Actually.. If we check if the HomePage() is shown, then we know if the signIn was successful or not.
    // This would also check any config changes in Firebase. This is more of an integration test I guess.
    testWidgets(
        ' GIVEN the user has landed on the SignInPage '
            ' WHEN the user taps the sign_in_anonymously_button '
            ' THEN the user is signed in anonymously', (
        WidgetTester tester) async {
      await pumpSignInPage(tester);

      final anonymousSignInButton =
      find.byKey(const Key('anonymous_sign_in_button'));
      expect(anonymousSignInButton, findsOneWidget);

      await tester.tap(anonymousSignInButton);

      verify(mockSignInManager.signInAnonymously()).called(1);

      stubSignInAnonymouslySucceeds();

      var user = await mockAuth.signInAnonymously();

      expect(user, mockUser);
    });
  });

  testWidgets(
      ' GIVEN the user has landed on the SignInPage '
          ' WHEN the user taps the google_sign_in_button '
          ' AND the user is on a mobile platform '
          ' THEN the user is signed in with google', (
      WidgetTester tester) async {

    await pumpSignInPage(tester);

    final googleSignInButton = find.byKey(const Key('google_sign_in_button'));
    expect(googleSignInButton, findsOneWidget);

    await tester.tap(googleSignInButton);

    verify(mockSignInManager.signInWithGoogle()).called(1);

    stubSignInWithGoogleSucceeds();

    var user = await mockAuth.signInWithGoogle();

    expect(user, mockUser);

  });

  /* Test google signInWithGoogleWeb(). Fails unless you run
 flutter test --platform chrome
  testWidgets(
      ' GIVEN the user has landed on the SignInPage '
          ' WHEN the user taps the google_sign_in_button '
          ' AND the user is on a web platform '
          ' THEN the user is signed in with google web', (
      WidgetTester tester) async {

    await pumpSignInPage(tester);

    final googleSignInButton = find.byKey(const Key('google_sign_in_button'));
    expect(googleSignInButton, findsOneWidget);

    await tester.tap(googleSignInButton);

    verify(mockSignInManager.signInWithGoogleWeb()).called(1);

    stubSignInWithGoogleWebSucceeds();

    var user = await mockAuth.signInWithGoogleWeb();

    expect(user, mockUser);

  }); */
}

