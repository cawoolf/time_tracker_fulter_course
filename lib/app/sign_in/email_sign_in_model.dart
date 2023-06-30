
enum EmailSignInFormType { signIn, register }

class EmailSignInModel {
  // Named parameters with default values
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.sumbitted = false});

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool sumbitted;
}
