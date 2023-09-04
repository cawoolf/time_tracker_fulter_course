import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_item_builder.dart';
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
          child: const Icon(Icons.add), onPressed: () => EditJobPage.show(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder(
            snapshot: snapshot,
            itemBuilder: (context, job) => JobListTile(
                job: job,
                onTap: () => EditJobPage.show(context, job: job))
        );
      },
    );
  }
}
