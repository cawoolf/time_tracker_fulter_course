import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {

  //'with' mixin, Extends to functionality of the class.

  @override
  State<EmailSignInFormStateful> createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  // Best practice used for controlling Text inside TextField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Everything below is a State variable, which can change in response to Callbacks.

  /*
  FocusNode can be assigned to TextFields (all Widgets?) to manage focus manually.
  FocusScope can shift focus to a FocusNode attached to a specific Widget.
   */
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  // Used to help managed the emailErrorText and passwordErrorText
  bool _submitted = false;
  bool _isLoading = false;


  /*
  Called whenever a Widget is removed from the WidgetTree
   */
  @override
  void dispose() {
    // Must dispose of Controllers and FocusNodes. Objects that we no longer need when the page is closed.
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /*
  Uses the auth Widget passed into the constructor to make a call to Firebase to either
  Create an Account or SignIn, based on the state of the EmailSignInFormType enum.
   */
  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    // email and password validators come from the EmailAndPasswordValidators mixin
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);

    if (submitEnabled) {
      // await Future.delayed(const Duration(seconds: 3)); // For simulating a slow network.
      try {
        if (_formType == EmailSignInFormType.signIn) {
          await auth?.signInWithEmailAndPassword(_email, _password);
        } else {
          await auth?.createUserWithEmailAndPassword(_email, _password);
        }
        Navigator.of(context)
            .pop(); // Dismiss the screen and navigates to the last widget on the stack.
      }on FirebaseAuthException catch (e) { // Catch certain types of Exceptions. Currently getting an UnknownError
        showExceptionAlertDialog(context,
            title: 'Sign In failed',
            exception: e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Display error msg. Email and password aren't valid and the submit button is disabled.
    }
  }

  /*
  Shifts the focus to the password field when the user clicks the 'Next' button
  on their device
   */
  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /* When called, sets the EmailSignInForType enum to ether register or signIn,
     Calls set state to redraw the Widget
     The Primary and Secondary text are then set in build() based on the enum Value
   */
  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void updateState() {
    // print('email: $_email password:$_password');
    setState(() {
      /* Used to rebuild the State and update the UI everytime to TextField changes
      * This way the SignIn Button can be disabled while the TextField email and password are empty,
      * and enabled if a certain validate is met  */
    });
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
    // email and password validators come from the EmailAndPasswordValidators mixin
    bool showEmailErrorText =
        _submitted && !widget.emailValidator.isValid(_email);

    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText:
              showEmailErrorText ? widget.invalidPasswordErrorText : null,
          // Used to disable the TextField if a auth request is currently is progress.
          enabled: _isLoading == false),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      //Gives the keyboard a Next button
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,

      // Updates the State everytime the TextField changes so that the Submit button knows to be disabled or not
      onChanged: (email) => updateState(),
    );
  }

  // User enters Password
  TextField _buildPasswordTextField() {
    // email and password validators come from the EmailAndPasswordValidators mixin
    bool showPasswordErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);

    return TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
            labelText: 'Password',
            errorText:
                showPasswordErrorText ? widget.invalidPasswordErrorText : null,
            // Used to disable the TextField if a auth request is currently is progress.
            enabled: _isLoading == false),
        obscureText: true,
        //Gives the keyboard a Done button
        textInputAction: TextInputAction.done,
        // Calls submit when the User clicks the 'Done' button on the keyboard.
        onEditingComplete: _submit,
        // Updates the State everytime the TextField changes so that the Submit button knows to be disabled or not
        onChanged: (password) => updateState());
  }

  // User Submits email and Password. SignIn or Create an Account
  Padding _buildSubmitButton(String primaryText) {
    bool submitEnabled = _email.isNotEmpty && _password.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormSubmitButton(
          text: primaryText,
          color: Colors.blue,
          textColor: Colors.white,
          // Used to disable the button if Email or Password are empty. UI doesn't automatically reflect this.
          onPressed: submitEnabled
              ? _submit
              : () {
                  /* Display error msg */
                }),
    );
  }

  // User toggles between SignIn and Create an Account
  Padding _buildSecondaryButton(String secondaryText) {
    return // Secondary Button, 'Need Account?'
        Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextButton(
          onPressed: !_isLoading ? _toggleFormType : null,
          child: Text(secondaryText)),
    );
  }

  void showGenericAlertDialog(Object e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign in failed'),
            content: Text(e.toString()),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Ok'))
            ],
          );
        });
  }
}
