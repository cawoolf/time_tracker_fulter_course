import 'dart:async';

import 'email_sign_in_model.dart';

class EmailSignInBloc {
  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  // Always dispose of the BLoC inside the Provider that creates it
  void dispose() {
    _modelController.close();
  }
}