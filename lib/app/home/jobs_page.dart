import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';


import '../../common_widgets/show_alert_dialog.dart';
import '../../services/database.dart';
import 'models/job.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});


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
    final didRequestSignOut = await showAlertDialog(context, title: 'Logout',
        content: 'Are you sure you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout');
    if(didRequestSignOut == true) {
      _signOut(context);
    }
  }

  void _createJob(BuildContext context) async {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'blogging', ratePerHour: 10));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _createJob(context)),
    );
  }

}