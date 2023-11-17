import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;

  // StreamController refactored to use BehaviorSubject
  // final StreamController<EmailSignInModel> _modelController =
  // StreamController<EmailSignInModel>();
  // Stream<EmailSignInModel> get modelStream => _modelController.stream;

  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel()); // Behavior Subject can take an initial value or seed.
  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get _model => _modelSubject.value;

  // Always dispose of the BLoC inside the Provider that creates it
  void dispose() {
    _modelSubject.close();
  }

  void toggleFormType() {
    final formType = _model!.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );

  }

  // Convience methods for just updating password or email
  void updatePassword(String password) => updateWith(password: password);
  void updateEmail(String email) => updateWith(email: email);

  /*
  Creates a copy of the model, and then adds it to the stream
  This causes the SignInForm to rebuild with the new data
   */
  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    _modelSubject.value =_model.copyWith( //Setting the value is equivalent to using .add() on a StreamController
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);
  }

  /*
  Uses the auth Widget passed into the constructor to make a call to Firebase to either
  Create an Account or SignIn, based on the state of the EmailSignInFormType enum.
   */
  Future<void> submit() async {
    updateWith(submitted: true, isLoading:true);
    try {
      if(_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      }
      else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    }
    catch (e) {
      // If the signIn fails, then we catch the exception, set loading to false, and dismiss the page
      updateWith(isLoading: false);
      rethrow;
    }

  }
}
