import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.manager, required this.isLoading});

  final SignInManager manager;
  final bool isLoading;

  static const emailSignInKey = Key('email_sign_in_button');

  // final bloc = Provider.of<SignInBloc>(context, listen: false); Note what assigning bloc looks like

  // Creates an instance of the SignInPage with a Provider and SignInBloc
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        // Everytime isLoading (coming from the ValueNotifier) changes, the builder is called, and updates (rebuilds) the SignInPage
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) =>
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    /*The exception.code is declared in auth.dart
    Code so that the user is not shown an error when they cancel a SignIn
    if(exception is FirebaseException && exception.code == 'ERROR_ABORTED_BY_USER'){
       return;
     }
    */

    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  void _signInWithEmail(BuildContext context) {
    // Uses a Navigator Widget the pushes and pops pages off the
    // Navigation Stack
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // False slides in from left, true slides in from bottom. Specific to IOS
        fullscreenDialog: true,
        builder: (context) =>
            EmailSignInPage(), //EmailSignInPage is built right here
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
      // await auth.signInAnonymously();
      // print('${userCredentials.user?.uid}');
      // onSignIn(user as User?);
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      await manager.signInWithGoogleWeb();
    } else {
      await manager.signInWithGoogle();
    }
  }

  Future<void> _signInWithFaceBook() async {
    // TODO: Implement Facebook SignIn
    // Holding off on this for now..
  }

  // UI Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  // the _methodName is convention for making the method private
  Widget _buildContent(BuildContext context) {
    return Padding(
      //Container with Padding with no background
      // color: Colors.yellow,
      padding: const EdgeInsets.all(16), // 16 What? Dp?
      child: Column(
        // Columns used for creating vertical layout
        //Basically vertical alignment
        mainAxisAlignment: MainAxisAlignment.center,
        // The crossAxisAlignment property determines how Row and Column can position their children on their cross axes.
        // Essentially Horizontal Alignment
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //SizedBox is used to ensure that the child Widget always takes up 50.0 pixels vertically
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),

          _spaceBetweenWidgets(height: 48.0),

          // Google Sign In
          SocialSignInButton(
            key: const Key('google_sign_in_button'),
            assetName: 'images/google-logo.png',
            text: "Sign in with Google",
            color: Colors.white,
            textColor: Colors.black,
            onPressed: () => isLoading != null && isLoading
                ? null
                : _signInWithGoogle(context),
          ),
          _spaceBetweenWidgets(),

          // Facebook Sign In Not Implemented
          SocialSignInButton(
              assetName: 'images/facebook-logo.png',
              text: "Sign in with Facebook",
              color: const Color(0xFF334D92),
              textColor: Colors.white,
              onPressed: () {
                print('Facebook Sign Clicked');
              }),

          _spaceBetweenWidgets(),

          // Email Sign In
          SignInButton(
              key: emailSignInKey,
              text: "Sign in with Email",
              color: Colors.teal,
              textColor: Colors.white,
              onPressed: () => isLoading != null && isLoading
                  ? null
                  : _signInWithEmail(context)),

          _spaceBetweenWidgets(),
          _orText(),
          _spaceBetweenWidgets(),

          // Anonymous Sign In
          SignInButton(
            key: const Key('anonymous_sign_in_button'),
            text: "Go anonymous",
            color: Colors.limeAccent,
            textColor: Colors.black,
            onPressed: () => isLoading != null && isLoading
                ? null
                : _signInAnonymously(context),
          ),
        ],
      ), // The child of a Container can be any Widget in Flutter
    );
  }

  // Returns a sized box with a optional parameter for height, default height of 8.0,
  SizedBox _spaceBetweenWidgets({double height = 8.0}) {
    return SizedBox(height: height);
  }

  Text _signInTitleText() {
    return const Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text _orText() {
    return const Text(
      "or",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14.0, color: Colors.black87),
    );
  }

  Widget _buildHeader() {
    if (isLoading != null && isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    // Just do nothing. There's no Loading indicator to show.
    else {
      return _signInTitleText();
    }
  }
}
