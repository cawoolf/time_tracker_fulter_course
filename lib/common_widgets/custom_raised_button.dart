
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget{
  const CustomRaisedButton({super.key});

  @override
  Widget build(BuildContext context) {
    // The Buttons can have children
   return ElevatedButton(
        onPressed: () {
          // _signInWithGoogle();
          null;
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)))),
        child: const Text(
          "Sign in with Google",
          style: TextStyle(color: Colors.black87),
        ));
  }


}