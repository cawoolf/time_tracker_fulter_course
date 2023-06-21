import 'dart:html';
import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

class SignInPage extends StatelessWidget {

  void _showSignInError(BuildContext context, Exception exception) {
    // The exception.code is declared in auth.dart
    // if(exception is FirebaseException && exception.code == 'ERROR_ABORTED_BY_USER'){
    //   return;
    // }
    showExceptionAlertDialog(context, title: 'Sign in failed', exception: exception);
  }

  void _signInWithEmail(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context);

    // Uses a Navigator Widget the pushes and pops pages off the
    // Navigation Stack
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // False slides in from left, true slides in from bottom. Specific to IOS
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signInAnonymously();
      // print('${userCredentials.user?.uid}');
      // onSignIn(user as User?);
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    if (kIsWeb) {
      try {
        print("Google web sign in");
        await auth.signInWithGoogleWeb();
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        await auth?.signInWithGoogle();
        print('Google Sign in clicked: Authenticating with Google');
        // print('${userCredentials.user?.uid}');
        // onSignIn(user as User?);
      } on Exception  catch (e) {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFaceBook() async {
    // TODO: Implement Facebook SignIn
    // Holding off on this for now..
  }

  // UI Widgets

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
  // only accessible at the file level
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
          _signInTitleText(),
          _spaceBetweenWidgets(height: 48.0),

          // Google Sign In
              SocialSignInButton(
                assetName: 'images/google-logo.png',
                text: "Sign in with Google",
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () => _signInWithGoogle(context),
              ),

          _spaceBetweenWidgets(),

          // Facebook Sign In
          SocialSignInButton(
              assetName: 'images/facebook-logo.png',
              text: "Sign in with Facebook",
              color: const Color(0xFF334D92),
              textColor: Colors.white,
              onPressed: () {
                null;
              }),

          _spaceBetweenWidgets(),

          // Email Sign In
          SignInButton(
              text: "Sign in with Email",
              color: Colors.teal,
              textColor: Colors.white,
              onPressed: () => _signInWithEmail(context)),

          _spaceBetweenWidgets(),
          _orText(),
          _spaceBetweenWidgets(),

          // Anonymous Sign In
          SignInButton(
            text: "Go anonymous",
            color: Colors.limeAccent,
            textColor: Colors.black,
            onPressed: ()=> _signInAnonymously(context),
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

}
