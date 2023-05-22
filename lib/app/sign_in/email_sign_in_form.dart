import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';

import '../../services/auth.dart';

enum EmailSignInFormType{ signIn, register}

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
// Used for controlling Text inside TextField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

 EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit() async {
    // print(
    //     'email: ${_emailController.text} password:${_passwordController.text}');
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      }
      else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop(); // Dismiss the screen and navigates to the last widget on the stack.
    } catch(e) {
      print(e.toString());
    }

  }

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

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn ? 'SignIn' : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn ? 'Need an account? Register' : 'Have an account? SignIn';


    return [
      TextField(
          controller: _emailController,
          decoration:
              InputDecoration(labelText: 'Email', hintText: 'test@test.com'),
          onChanged: (value) {
            print(value);
          }),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormSubmitButton(
          text: primaryText,
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: _submit,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: TextButton(
            onPressed: _toggleFormType, child: Text(secondaryText)),
      )
    ];
  }
}
