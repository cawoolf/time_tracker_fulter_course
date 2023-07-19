
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';
import 'email_sign_in_change_model.dart';

//'with' mixin, Extends to functionality of the class.
class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({super.key, required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
        create: (_) => EmailSignInChangeModel(auth: auth),
        child: Consumer<EmailSignInChangeModel>(
          builder: (_, model, __) =>
              EmailSignInFormChangeNotifier(model: model),
        ));
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
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
  EmailSignInChangeModel get model => widget.model;

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
    print('_submit() called');
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on Exception catch (e) {
      print('Sign in failed');
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  /*
  Shifts the focus to the password field when the user clicks the 'Next' button
  on their device
   */
  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /* When called, sets the EmailSignInForType enum to ether register or signIn,
     Calls set state to redraw the Widget
     The Primary and Secondary text are then set in build() based on the enum Value
   */
  void _toggleFormType() {
    print('_toggleFormType');
      model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
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
      _buildSubmitButton(model.primaryButtonText, model.canSubmit),

      // Secondary Button, 'Need Account?'
      _buildSecondaryButton(model.secondaryButtonText)
    ];
  }

  /*Methods are in order of how the appear in the UI, and the order they are called in
   the parent method. */

  // User enters Email Address
  TextField _buildEmailTextField() {
    // email and password validators come from the EmailAndPasswordValidators mixin

    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: model.emailErrorText,
          // Used to disable the TextField if a auth request is currently is progress.
          enabled: model.isLoading == false),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      //Gives the keyboard a Next button
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,

      // Updates the State everytime the TextField changes so that the Submit button knows to be disabled or not
      onChanged: model.updateEmail, // Parameters passed in implicitly
    );
  }

  // User enters Password
  TextField _buildPasswordTextField() {
    // email and password validators come from the EmailAndPasswordValidators mixin

    return TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
            labelText: 'Password',
            errorText: model.passwordErrorText,
            // Used to disable the TextField if a auth request is currently is progress.
            enabled: model.isLoading == false),
        obscureText: true,
        //Gives the keyboard a Done button
        textInputAction: TextInputAction.done,
        // Calls submit when the User clicks the 'Done' button on the keyboard.
        onEditingComplete: _submit,
        // Updates the State everytime the TextField changes so that the Submit button knows to be disabled or not
        onChanged: model.updatePassword);
  }

  // User Submits email and Password. SignIn or Create an Account
  Padding _buildSubmitButton(String primaryText, bool submitEnabled) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormSubmitButton(
          text: primaryText,
          color: Colors.blue,
          textColor: Colors.white,
          // Used to disable the button if Email or Password are empty. UI doesn't automatically reflect this.
          /* However, this is also triggered on bad formatted email and password.
          Need to fix this. Should show the Firebase error. Setting to true shows errors*/
          onPressed: model.canSubmit
              ? _submit
              : () {
                  /* Display error msg for handling empty email and password or bad formatted*/
                  showAlertDialog(context, title: 'Error', content: 'password and email can not be empty, or bad formatting', defaultActionText: 'Okay');
                }),
    );
  }

  // User toggles between SignIn and Create an Account
  Padding _buildSecondaryButton(String secondaryText) {
    print('_buildSecondaryButton ${model.isLoading.toString()}');
    return // Secondary Button, 'Need Account?'
        Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextButton(
          onPressed: !model.isLoading ? _toggleFormType : null,
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
