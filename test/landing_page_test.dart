import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_form_stateful_test.mocks.dart';


class MockUser extends Mock implements User{}

void main() {
  var mockAuth = MockAuth();
  final mockUser = MockUser();
  StreamController<User> onAuthStateChangedController = StreamController<User>();

  tearDown(() => onAuthStateChangedController.close());

  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: const MaterialApp(
          home: LandingPage(),
        ),
      ),
    );
    await tester.pump();
  }


  void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged) {
    onAuthStateChangedController.addStream(Stream<User>.fromIterable(onAuthStateChanged));
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });
  }

  // void stubOnAuthStateNull(Iterable<User> onAuthStateChanged) {
  //   onAuthStateChangedController.addStream(Stream<User>.fromIterable(onAuthStateChanged));
  //   when(mockAuth.authStateChanges()).thenAnswer((_) {
  //     return onAuthStateChangedController.stream;
  //   });
  // }

  testWidgets('stream waiting', (WidgetTester tester) async {
    stubOnAuthStateChangedYields([]); // Empty list creates an empty stream
    await pumpLandingPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget );
  } );

  // testWidgets('null user', (WidgetTester tester) async {
  //   // stubOnAuthStateChangedYields(null);
  //   await pumpLandingPage(tester);
  //   expect(find.byType(SignInPage), findsOneWidget );
  // } );

  void stubSignInWithGoogleSucceeds() {
    when(mockAuth.signInWithGoogle())
        .thenAnswer((_) => Future<User>.value(mockUser));
  }

  testWidgets('non-null user', (WidgetTester tester) async {

    stubSignInWithGoogleSucceeds();
    var user = await mockAuth.signInWithGoogle();
    expect(user, mockUser);

    stubOnAuthStateChangedYields([user as User]); // We are getting a null uid from Firebase, but we're making it to the HomePage()
    await pumpLandingPage(tester);
    expect(find.byType(HomePage), findsOneWidget );
  } );

}
