import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';

@GenerateNiceMocks([MockSpec<SignInManager>()])
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
        ' AND the user IS NOT using a web platform '
        ' THEN signInWithGoogle() is called ',(WidgetTester tester) async {

      await pumpSignInPage(tester);

      final googleSignInButton = find.byKey(const Key('google_sign_in_button'));
      expect(googleSignInButton, findsOneWidget);

      await tester.tap(googleSignInButton);

      verify(mockSignInManager.signInWithGoogle()).called(1);
    }
    );

    // run flutter test --platform chrome to set kIsWeb to true
    // testWidgets(' GIVEN the user has landed on the SignInPage '
    //     ' WHEN the user taps the google_sign_in_button '
    //     ' AND the user IS using a web platform '
    //     ' THEN signInWithGoogleWeb() is called ',(WidgetTester tester) async {
    //
    //   await pumpSignInPage(tester);
    //
    //   final googleSignInButton = find.byKey(const Key('google_sign_in_button'));
    //   expect(googleSignInButton, findsOneWidget);
    //
    //   await tester.tap(googleSignInButton);
    //
    //   verify(mockSignInManager.signInWithGoogleWeb()).called(1);
    // }
    // );
  });

}