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

  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SignInPage(manager: mockSignInManager, isLoading: false,))
    );
  }

  group('google sign in methods', () {
    testWidgets(' GIVEN the user has landed on the SignInPage '
        ' WHEN the user taps the google_sign_in_button '
        ' AND regardless of which platform is being used'
        ' THEN signInWithGoogle() is called ',(WidgetTester tester) async {

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
  });

}