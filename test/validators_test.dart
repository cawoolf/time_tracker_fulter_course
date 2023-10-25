import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

void main() {
  test('non empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid('test'), true); //Asserting that the value of the first argument matches the value of the second.
  });

  test('empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''),false);
  });

  // Write edge cases to create more robust code. General create a failing test, and then make it pass.
  test('edge case string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(2.toString()),true);
  });
}
