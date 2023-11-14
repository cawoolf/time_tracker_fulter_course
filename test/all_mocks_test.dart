
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<Auth>()])
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'all_mocks_test.mocks.dart';

@GenerateNiceMocks([MockSpec<User>()])
import 'package:firebase_auth/firebase_auth.dart';

@GenerateNiceMocks([MockSpec<SignInManager>()])
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';

@GenerateNiceMocks([MockSpec<Firebase>()])
import 'package:firebase_core/firebase_core.dart';

@GenerateNiceMocks([MockSpec<FirestoreDatabase>()])
import 'package:time_tracker_flutter_course/services/database.dart';


void main() {

  test('test generate mocks', () {
    final auth = MockAuth();
    final user = MockUser();
    final signInManager = MockSignInManager();
    final database = MockFirestoreDatabase();

  });

}