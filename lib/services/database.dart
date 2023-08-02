import 'package:cloud_firestore/cloud_firestore.dart';

import '../app/home/models/job.dart';

abstract class Database {

  Future<void> createJob(Job job);

}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> createJob(Job job) async {
    final path ='users/$uid/jobs/job_abc'; // Test path to write to FireStore
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(job.toMap());
  }
}
