import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';

class EmailSignInForm extends StatelessWidget {
  const EmailSignInForm({Key? key}) : super(key: key);

  // New convention, all methods related to the front-end go after the
  // build() method. All business logic comes before the build() method.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}

List<Widget> _buildChildren() {
  return [
    const TextField(
      decoration:
          InputDecoration(labelText: 'Email', hintText: 'test@test.com'),
    ),
    const TextField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormSubmitButton(
        text: 'Sign In',
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextButton(
          onPressed: () {}, child: const Text('Need an account? Register.')),
    )
  ];
}
