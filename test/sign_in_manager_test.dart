import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';

import 'all_mocks_test.mocks.dart';

// 402: Custom class to store values from the ValueNotifier
class MockValueNotifier<T> extends ValueNotifier<bool> {
  MockValueNotifier(T value) : super(value as bool);

  List<T> values = [];

  @override
  set value(dynamic newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  late MockUser mockUser;
  late MockAuth mockAuth;
  late MockValueNotifier<bool> isLoading;
  late SignInManager signInManager;

  setUp(() {
    mockUser = MockUser();
    mockAuth = MockAuth();
    isLoading = MockValueNotifier<bool>(false);
    signInManager = SignInManager(auth: mockAuth, isLoading: isLoading);
  });

  test('sign-in- success', () async {
    // ARRANGE
    when(mockAuth.signInAnonymously())
        .thenAnswer((_) => Future.value(mockUser));

    // ACT
    await signInManager.signInAnonymously();

    // ASSERT
    expect(isLoading.values, [true]);
  });

  test('sign-in- failure', () async {
    // ARRANGE
    when(mockAuth.signInAnonymously())
        .thenThrow(PlatformException(code: 'ERROR', message: 'sign-in-failed'));

    // ACT
    try {
      await signInManager.signInAnonymously();
    } catch (e) {
      // ASSERT
      expect(isLoading.values, [true, false]);
    }
  });
}
