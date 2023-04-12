import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  // This Callback code no longer needed if using StreamBuilder and Streams to
  // manage the auth and direct to the correct LandingPage
  //
  // @override
  // User? _user;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Gets the current logged in User, so that if the app restarts, they are still logged in.
  //   _updateUser(widget.auth.currentUser);
  // }
  //
  //
  // // Rebuilds the LandingPage
  // void _updateUser(User? user) {
  //   print('User id: ${user?.uid}');
  //   setState(() {
  //     _user = user;
  //   });
  // }


  // Builds the child of the LandingPage as either the SignInPage or the HomePage
  // Depending on if the User is logged in or not.
  Widget build(BuildContext context) {

    // Useful widget for manging Streams
    return StreamBuilder<User?>(

      // Stream coming from Firebase that emits the User state
      stream: auth.authStateChanges(),

      // Snapshot is the data being emited from the Stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage(
              // onSignIn: (user) /* This user is coming from the SignInPage*/ =>
              //     _updateUser(user),
              auth: auth,
            );
          }
          return HomePage(
            // onSignOut: () => _updateUser(null),
            auth: auth,
          ); //Placeholder

        }

        // Default Widget if the data is still loading from the Stream
        // When the first value is received by the Stream the page will reload.
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

    );
  }
}
