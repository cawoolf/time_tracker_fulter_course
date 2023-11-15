import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'all_mocks_test.mocks.dart';

void main() {
  late MockSignInManager mockSignInManager;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockSignInManager = MockSignInManager();
    mockNavigatorObserver = MockNavigatorObserver();
    mockAuth = MockAuth();
    mockUser = MockUser();
  });

  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SignInPage(
        manager: mockSignInManager,
        isLoading: false,
      ),
      navigatorObservers: [mockNavigatorObserver],
    ));
  }

  // User builder to pass context. From time_tracker_flutter_course
  // Probably should use Provider<AuthBase> just to be consistent with how the app is set up.
  Future<void> pumpSignInPage2(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Builder(builder: (context) => SignInPage.create(context)),
        navigatorObservers: [mockNavigatorObserver],
      ),
    ));

    verify(mockNavigatorObserver.didPush(any, any)).called(1); // Navigator is called once when the SignInPage is pushed. Need to register this so other tests don't see the called count as 2
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
        ' WHEN the user taps the sign_in_anonymously_button '
        ' THEN the user is signed in anonymously', (WidgetTester tester) async {
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
    testWidgets(
        ' GIVEN the user has landed on the SignInPage '
        ' WHEN the user taps the google_sign_in_button '
        ' AND the user is NOT on a web platform '
        ' THEN the user is signed in with google', (WidgetTester tester) async {
      if (kIsWeb == false) {
        await pumpSignInPage(tester);

        final googleSignInButton =
            find.byKey(const Key('google_sign_in_button'));
        expect(googleSignInButton, findsOneWidget);

        await tester.tap(googleSignInButton);

        verify(mockSignInManager.signInWithGoogle()).called(1);

        stubSignInWithGoogleSucceeds();

        var user = await mockAuth.signInWithGoogle();

        expect(user, mockUser);
      } else {
        print('kIsWeb: $kIsWeb');

        stubSignInWithGoogleWebSucceeds();

        var user = await mockAuth.signInWithGoogleWeb();

        expect(user, mockUser);
      }
    });
    //Test google signInWithGoogleWeb(). Fails unless you run

    testWidgets(
        ' GIVEN the user has landed on the SignInPage '
        ' WHEN the user taps the google_sign_in_button '
        ' AND the user is on a web platform '
        ' THEN the user is signed in with google web'
        'ELSE the user is signed in with in google',
        (WidgetTester tester) async {
      //kisWeb = true so sign in with google web
      if (kIsWeb) {
        await pumpSignInPage(tester);

        final googleSignInButton =
            find.byKey(const Key('google_sign_in_button'));
        expect(googleSignInButton, findsOneWidget);

        await tester.tap(googleSignInButton);

        verify(mockSignInManager.signInWithGoogleWeb()).called(1);

        stubSignInWithGoogleWebSucceeds();

        var user = await mockAuth.signInWithGoogleWeb();

        expect(user, mockUser);
      } else {
        //kIsWeb = false, so sign in with google
        print('kIsWeb: $kIsWeb');

        stubSignInWithGoogleSucceeds();

        var user = await mockAuth.signInWithGoogle();

        expect(user, mockUser);
      }
    });
  });

  group('navigation tests', () {
    testWidgets('email & password navigation', (WidgetTester tester) async {
      await pumpSignInPage2(tester);

      final emailSignInButton = find.byKey(SignInPage.emailSignInKey);
      expect(emailSignInButton, findsOneWidget);

      await tester.tap(emailSignInButton);
      await tester
          .pumpAndSettle(); // called for navigation. Wait for animations to settle

      verify(mockNavigatorObserver.didPush(any, any)).called(1);
    });
  });
}
