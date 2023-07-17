import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

import '../../services/auth.dart';
import 'email_sign_in_model.dart';



class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  // Named parameters with default values
  EmailSignInChangeModel(
      {required this.auth,
        this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading:true);
    try {
      if(this.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      }
      else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    }
    catch (e) {
      // If the signIn fails, then we catch the exception, set loading to false, and dismiss the page
      updateWith(isLoading: false);
      rethrow;
    }

  }

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

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
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
