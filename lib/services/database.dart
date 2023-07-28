import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Database {

  Future<void> createJob(Map<String,dynamic> jobData);

}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> createJob(Map<String, dynamic> jobData) async {
    final path ='users/$uid/jobs/job_abc'; // Test path to write to FireStore
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(jobData);
  }
}
