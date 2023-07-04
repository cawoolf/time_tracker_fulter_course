import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';
import 'email_sign_in_model.dart';

//'with' mixin, Extends to functionality of the class.
class EmailSignInFormBlocBased extends StatefulWidget
    with EmailAndPasswordValidators {
  EmailSignInFormBlocBased({super.key, required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
          builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc)),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
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
  late EmailSignInModel? model;

  /*
  Called whenever a Widget is removed from the WidgetTree
   */
  @override
  void dispose() {
    print('Dispose called');
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
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  /*
  Shifts the focus to the password field when the user clicks the 'Next' button
  on their device
   */
  void _emailEditingComplete() {
    print('emailEditingComplete() called');
    final newFocus = widget.emailValidator.isValid(model!.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /* When called, sets the EmailSignInForType enum to ether register or signIn,
     Calls set state to redraw the Widget
     The Primary and Secondary text are then set in build() based on the enum Value
   */
  void _toggleFormType() {
    widget.bloc.toggleFormType();
   _emailController.clear();
   _passwordController.clear();
  }


  // New convention, all methods related to the front-end go after the
  // build() method. All business logic comes before the build() method.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    final primaryText = model?.formType == EmailSignInFormType.signIn
        ? 'SignIn'
        : 'Create an account';
    final secondaryText = model?.formType == EmailSignInFormType.signIn
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
        model!.submitted && !widget.emailValidator.isValid(model!.email);

    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText:
              showEmailErrorText ? widget.invalidPasswordErrorText : null,
          // Used to disable the TextField if a auth request is currently is progress.
          enabled: model?.isLoading == false),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      //Gives the keyboard a Next button
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,

      // Updates the State everytime the TextField changes so that the Submit button knows to be disabled or not
      onChanged: widget.bloc.updateEmail, // Parameters passed in implicitly
    );
  }

  // User enters Password
  TextField _buildPasswordTextField() {
    // email and password validators come from the EmailAndPasswordValidators mixin
    bool showPasswordErrorText =
        model!.submitted && !widget.passwordValidator.isValid(model!.password);

    return TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
            labelText: 'Password',
            errorText:
                showPasswordErrorText ? widget.invalidPasswordErrorText : null,
            // Used to disable the TextField if a auth request is currently is progress.
            enabled: model?.isLoading == false),
        obscureText: true,
        //Gives the keyboard a Done button
        textInputAction: TextInputAction.done,
        // Calls submit when the User clicks the 'Done' button on the keyboard.
        onEditingComplete: _submit,
        // Updates the State everytime the TextField changes so that the Submit button knows to be disabled or not
        onChanged: widget.bloc.updatePassword);
  }

  // User Submits email and Password. SignIn or Create an Account
  Padding _buildSubmitButton(String primaryText) {
    bool submitEnabled = widget.emailValidator.isValid(model!.email) &&
        widget.passwordValidator.isValid(model!.password) &&
        !model!.isLoading;
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
          onPressed: model!.isLoading ? _toggleFormType : null,
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
