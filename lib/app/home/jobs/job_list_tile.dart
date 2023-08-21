import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';


// This class helps offload some of the UI code from jobs_page
class JobListTile extends StatelessWidget {
  const JobListTile({super.key, required this.job, required this.onTap});
  final Job? job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job!.name),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
