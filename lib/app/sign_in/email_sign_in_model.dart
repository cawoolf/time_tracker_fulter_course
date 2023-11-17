import 'dart:ui';

import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  // Named parameters with default values
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final String email;
  final String password;
  late final EmailSignInFormType formType;
  final bool isLoading;
  late final bool submitted;

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
        !isLoading;
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

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    // ?? returns the value to left if it is not null, other it returns the value to the right.
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  // Must over ride these methods to compare model objects for testing!
  @override
  int get hashCode =>
      hashValues(email, password, formType, isLoading, submitted);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final EmailSignInModel otherModel = other as EmailSignInModel;
    return email == otherModel.email &&
        password == otherModel.password &&
        formType == otherModel.formType &&
        isLoading == otherModel.isLoading &&
        submitted == otherModel.submitted;
  }

  @override
  String toString() =>
      'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';

}
