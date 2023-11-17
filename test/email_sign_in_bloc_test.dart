import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';

import 'all_mocks_test.mocks.dart';

void main() {
  late MockAuth mockAuth;
  late EmailSignInBloc bloc;

  setUp(() {
    mockAuth = MockAuth();
    bloc = EmailSignInBloc(auth: mockAuth);
  });

  tearDown(() => bloc.dispose());

  test(
      'WHEN email is updated'
          'AND password is updated'
          'AND submit is called'
          'THEN modelStream emits the correct events', () async {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(code: 'ERROR'));

   // When we use emitsInOrder, then our tests will wait until all these values have been emitted by the stream
    // If an expected value is not emitted by the Stream, the test will time out.
    expect(
        bloc.modelStream,
        emitsInOrder([
          EmailSignInModel(),
          EmailSignInModel(email: 'email@email.com'),
          EmailSignInModel(
            email: 'email@email.com',
            password: 'password',
          ),
          EmailSignInModel(
            email: 'email@email.com',
            password: 'password',
            submitted: true,
            isLoading: true,
          ),
          EmailSignInModel(
            email: 'email@email.com',
            password: 'password',
            submitted: true,
            isLoading: false,
          ),
        ])
    );

    bloc.updateEmail('email@email.com');

    bloc.updatePassword('password');

    try {
      await bloc.submit();
    } catch (_) {
    }
  });
}
