import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/add_job_page.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import '../../../common_widgets/show_alert_dialog.dart';
import '../../../services/database.dart';
import '../models/job.dart';

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
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  void _createJob(BuildContext context) async {
    try {
      print('Job created');
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Blogginggg', ratePerHour: 12));
    } catch (e) {
      // Catch FirebaseException
      print('Firebase Exception: ${e.toString()}');
      showAlertDialog(context,
          title: 'Firebase Exception',
          content: e.toString(),
          defaultActionText: 'Okay');
      // For some reason e is just an Object and not an Exception
      // There's some issue going on between the Web version of Flutter and Firebase?
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Temporary code: delete me
    // final database = Provider.of<Database>(context, listen: false);
    // database.readJobs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: <Widget>[
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ))
        ],
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () => AddJobPage.show(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs?.map((job) => Text(job!.name)).toList();
          return ListView(children: List<Text>.from(children ?? []));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Some error occured'));
        }
        else {
          return const Center(child: CircularProgressIndicator()); // or any other loading indicator
        }
      },
    );
  }
}
