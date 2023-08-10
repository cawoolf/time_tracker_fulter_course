import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import '../services/database.dart';
import 'home/jobs/jobs_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // Builds the child of the LandingPage as either the SignInPage or the HomePage
  // Depending on if the User is logged in or not.
  @override
  Widget build(BuildContext context) {
    // Finds the AuthProvider ancestor in the Widget Tree
    final auth = Provider.of<AuthBase>(context, listen: false);
    // Useful widget for manging Streams
    return StreamBuilder<User?>(
      // Stream coming from Firebase that emits the User state
      stream: auth.authStateChanges(),

      // Snapshot is the data being emitted from the Stream
      // Checks to see if the User is actually logged in
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid), // user.uid comes from the snapshot
              child: const JobsPage());
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
