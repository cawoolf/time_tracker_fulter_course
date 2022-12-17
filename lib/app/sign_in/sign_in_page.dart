import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(),
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
          _signInText(),
          _spaceBetweenWidgets(),
          _googleSignInButton(),
          _spaceBetweenWidgets(),
        ],
      ), // The child of a Container can be any Widget in Flutter
    );
  }

  Text _signInText() {
    return const Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  SizedBox _spaceBetweenWidgets() {
    return const SizedBox(height: 8.0);
  }

  ElevatedButton _googleSignInButton() {
    return ElevatedButton(
        onPressed: () {
          _signInWithGoogle();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        child: const Text(
          "Sign in with Google",
          style: TextStyle(color: Colors.black),
        ));
  }

  void _signInWithGoogle() {
    print('Google Sign in clicked: Authenticating with Google');
  }
}
