import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'email_sign_in_form_stateful_test.mocks.dart';


void main() {
  var mockAuth = MockAuth();

  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: const MaterialApp(
          home: LandingPage(),
        ),
      ),
    );
  }

  void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged) {
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return Stream<User>.fromIterable(onAuthStateChanged);
    });
  }
}
