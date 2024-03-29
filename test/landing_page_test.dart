import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'all_mocks_test.mocks.dart';

/*
Just move on from section 397 for now. Testing Firestore is difficult and wierd on this version
of flutter. Need to research it and try a different approach. Maybe start a separate project just
to practice TTD and Firestore testing.
 */
void main() {
  var mockAuth = MockAuth();
  final mockUser = MockUser();
  var mockDatabase = MockFirestoreDatabase();

  StreamController<User> onAuthStateChangedController = StreamController<User>();

  setUp(() => onAuthStateChangedController = StreamController<User>());
  tearDown(() => onAuthStateChangedController.close());

  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: const MaterialApp(
          // home: LandingPage(databaseBuilder:),
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

  void stubOnAuthStateNull(Iterable<User> onAuthStateChanged) {
    onAuthStateChangedController.addStream(Stream<User>.fromIterable(onAuthStateChanged));
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });
  }

  // testWidgets('stream waiting', (WidgetTester tester) async {
  //   stubOnAuthStateChangedYields([]); // Empty list creates an empty stream
  //   await pumpLandingPage(tester);
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget );
  // } );

  // testWidgets('null user', (WidgetTester tester) async {
  //   stubOnAuthStateChangedYields(null);
  //   await pumpLandingPage(tester);
  //   expect(find.byType(SignInPage), findsOneWidget );
  // } );

  void stubSignInWithGoogleSucceeds() {
    when(mockAuth.signInWithGoogle())
        .thenAnswer((_) => Future<User>.value(mockUser));
  }

  // testWidgets('non-null user', (WidgetTester tester) async {
  //
  //   stubSignInWithGoogleSucceeds();
  //   var user = await mockAuth.signInWithGoogle();
  //   expect(user, mockUser);
  //
  //   stubOnAuthStateChangedYields([user as User]); // We are getting a null uid from Firebase, but we're making it to the HomePage(). JobPage is loaded by the HomePage
  //   await pumpLandingPage(tester);
  //   expect(find.byType(HomePage), findsOneWidget );
  // } );

}
