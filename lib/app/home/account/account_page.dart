import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';

import '../../../common_widgets/avatar.dart';
import '../../../services/auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: <Widget>[
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth?.signOut();
      print('Logged out');
      // onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Why is this async?
  /*
  Ohh we have to await for the User to interact with the Alert and press a button, which returns a boolean
   */
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  _buildUserInfo(User? user) {
     return Column(
       children:<Widget> [Avatar(
         photoUrl: user?.photoURL,
         radius: 50,
       ),
       const SizedBox(height: 8),// Used for padding
       if(user?.displayName != null)
         Text(
             user!.displayName as String,
             style: const TextStyle(color: Colors.white)
         ),
       const SizedBox(height: 8)
       ]
     );
  }
}
