import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextWidgets extends StatelessWidget {
  const AppTextWidgets({super.key});

  Text signInTitleText() {
    return const Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text googleSignInButtonText() {
    return const Text(
        "Sign in with Google",
        style: TextStyle(color: Colors.black87));
  }

  Text facebookSignInButtonText() {
    return const Text(
        "Sign in with Facebook",
        style: TextStyle(color: Colors.black87));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}




