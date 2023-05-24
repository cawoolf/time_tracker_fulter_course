import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';

import '../../services/auth.dart';

enum EmailSignInFormType { signIn, register }

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

  /* When called, sets the EmailSignInForType enum to ether register or signIn,
     Calls set state to redraw the Widget
     The Primary and Secondary text are then set in build() based on the enum Value
   */
  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  /*
  Uses the auth Widget passed into the constructor to make a call to Firebase to either
  Create an Account or SignIn, based on the state of the EmailSignInFormType enum.
   */
  void _submit() async {
    // print(
    //     'email: ${_emailController.text} password:${_passwordController.text}');
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context)
          .pop(); // Dismiss the screen and navigates to the last widget on the stack.
    } catch (e) {
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
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'SignIn'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? SignIn';

    return [
      /*
      Just using this as an example of code comment convention.
      Document every method like this?
       */

      // User Email Address
      _buildEmailTextField(),

      // User Password
      _buildPasswordTextField(),

      // Submit Button
      _buildSubmitButton(primaryText),

      // Secondary Button, 'Need Account?'
      _buildSecondaryButton(secondaryText)
    ];
  }

  /*Methods are in order of how the appear in the UI, and the order they are called in
   the parent method. */

  // User enters Email Address
  TextField _buildEmailTextField() {
    return TextField(
        controller: _emailController,
        decoration:
            InputDecoration(labelText: 'Email', hintText: 'test@test.com'),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        //Gives the keyboard a Next button
        onChanged: (value) {
          print(value);
        });
  }

  // User enters Password
  TextField _buildPasswordTextField() {
    return // User Password
        TextField(
      controller: _passwordController,
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      textInputAction: TextInputAction.done, //Gives the keyboard a Done button
    );
  }

  // User Submits email and Password. SignIn or Create an Account
  Padding _buildSubmitButton(String primaryText) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormSubmitButton(
        text: primaryText,
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: _submit,
      ),
    );
  }

  // User toggles between SignIn and Create an Account
  Padding _buildSecondaryButton(String secondaryText) {
    return // Secondary Button, 'Need Account?'
        Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextButton(onPressed: _toggleFormType, child: Text(secondaryText)),
    );
  }
}
