import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

import 'email_sign_in_model.dart';



class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  // Named parameters with default values
  EmailSignInChangeModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'SignIn'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? SignIn';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        isLoading;
  }

  String? get emailErrorText {
    bool showEmailErrorText =
        submitted && emailValidator.isValid(email);
    return showEmailErrorText ? invalidEmailErrorText : null;
  }

  String? get passwordErrorText {
    bool showPasswordErrorText =
        submitted && passwordValidator.isValid(password);
    return showPasswordErrorText ? invalidPasswordErrorText : null;
  }

    void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    // ?? returns the value to left if it is not null, other it returns the value to the right.
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formType  = formType?? this.formType;
      this.isLoading = isLoading ?? this.isLoading;
      this.submitted  = submitted?? this.submitted;

  }
}
