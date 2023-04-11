import 'package:flutter/widgets.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  User? _user;
  
  @override
  void initState() {
    // Gets the current logged in User, so that if the app restarts, they are still logged in.
    super.initState();
    _updateUser(FirebaseAuth.instance.currentUser);
  }

  void _updateUser(User? user) {
    print('User id: ${user?.uid}');
    setState(() {
      _user = user;
    });
  }

  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
          onSignIn: (user) /* This user is coming from the SignInPage*/ =>
              _updateUser(user));
    }
    return HomePage(
      onSignOut: () => _updateUser(null),
    ); //Placeholder
  }
}
