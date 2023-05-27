abstract class StringValidator {
  bool isValid(String value);
}

class NotEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
  
}

/*
 Used to manually handled data validation logic. Can easily make changes and abstracts the logic
 away from the UI class EmailSignInForm.
 */

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NotEmptyStringValidator();
  final StringValidator passwordValidator = NotEmptyStringValidator();
}