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


void main() {

  var mockSignInManager = MockSignInManager();
  var mockAuth = MockAuth();

  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SignInPage(manager: mockSignInManager, isLoading: false,))
    );
  }

  group('sign in methods', () {
    testWidgets(' GIVEN the user has landed on the SignInPage '
        ' WHEN the user taps the google_sign_in_button '
        ' AND regardless of which platform is being used'
        ' THEN the user is signed in with google',(WidgetTester tester) async {

      await pumpSignInPage(tester);

      final googleSignInButton = find.byKey(const Key('google_sign_in_button'));
      expect(googleSignInButton, findsOneWidget);

      await tester.tap(googleSignInButton);

      if(kIsWeb) {
        verify(mockSignInManager.signInWithGoogleWeb()).called(1);
      }
      else {
        verify(mockSignInManager.signInWithGoogle()).called(1);
      }
    }
    );

    // We know this fails, so we need to test auth directly.
    // We need to know if the manger returns a user or not, not just that the method was called.
    testWidgets(' GIVEN the user has landed on the SignInPage '
        ' WHEN the user taps the sign_in_anonymously_button '
        ' THEN the user is signed in anonymously',(WidgetTester tester) async {

      await pumpSignInPage(tester);

      final anonymousSignInButton = find.byKey(const Key('anonymous_sign_in_button'));
      expect(anonymousSignInButton, findsOneWidget);

      await tester.tap(anonymousSignInButton);

      verify(mockSignInManager..signInAnonymously()).called(1);

    }
    );
  });


}