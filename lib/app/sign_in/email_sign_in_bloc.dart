import 'dart:async';

import 'email_sign_in_model.dart';

class EmailSignInBloc {
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
}
