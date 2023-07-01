import 'dart:async';
import 'dart:js';

import 'package:provider/provider.dart';

import '../../services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  EmailSignInModel _model = EmailSignInModel();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  // Always dispose of the BLoC inside the Provider that creates it
  void dispose() {
    _modelController.close();
  }

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
    _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);
    _modelController.add(_model);
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
