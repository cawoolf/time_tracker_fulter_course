import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  // Constructor
  SignInPage({super.key, /*required this.onSignIn, */ required this.auth});
  final AuthBase auth;

  /* onSignIn is a function that is a property of the SignInPage,
  and is set by the Constructor. Part of a basic CallBack pattern.
  State is being passed from the SignInPage to the LandingPage */
  // final void Function(User?) onSignIn;

  Future<void> _signInAnonymously() async {
    try {
      final user = await auth.signInAnonymously();
      // print('${userCredentials.user?.uid}');
      // onSignIn(user as User?);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final user = await auth.signInWithGoogle();
      print('Google Sign in clicked: Authenticating with Google');
      // print('${userCredentials.user?.uid}');
      // onSignIn(user as User?);
    } catch (e) {
      print(e.toString());
    }
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
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  // the _methodName is convention for making the method private
  // only accessible at the file level
  Widget _buildContent() {
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
            onPressed: _signInWithGoogle,
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
              onPressed: () {
                null;
              }),

          _spaceBetweenWidgets(),
          _orText(),
          _spaceBetweenWidgets(),

          // Anonymous Sign In
          SignInButton(
            text: "Go anonymous",
            color: Colors.limeAccent,
            textColor: Colors.black,
            onPressed: _signInAnonymously,
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
