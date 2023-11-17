import 'package:flutter_test/flutter_test.dart';
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
      'WHEN email is updated '
      'AND password is updated '
      'AND submit is called '
      'THEN modelStream emits the correct events ',
      () async {
        expect(bloc.modelStream, emits(EmailSignInModel()));
      });
}
