import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  User? _user;

  @override
  void initState() {
    super.initState();

    // Gets the current logged in User, so that if the app restarts, they are still logged in.
    _updateUser(widget.auth.currentUser);
  }


  // Rebuilds the LandingPage
  void _updateUser(User? user) {
    print('User id: ${user?.uid}');
    setState(() {
      _user = user;
    });
  }


  // Builds the child of the LandingPage as ethier the SignInPage or the HomePage
  // Depending on if the User is logged in or not.
  Widget build(BuildContext context) {

    // Useful widget for manging Streams
    return StreamBuilder<User?>(

      // Stream coming from Firebase that emits the User state
      stream: widget.auth.authStateChanges(),

      // Snapshot is the data being emited from the Stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage(
              onSignIn: (user) /* This user is coming from the SignInPage*/ =>
                  _updateUser(user),
              auth: widget.auth,
            );
          }
          return HomePage(
            onSignOut: () => _updateUser(null),
            auth: widget.auth,
          ); //Placeholder

        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

    );
  }
}
