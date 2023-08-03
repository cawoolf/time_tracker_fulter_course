import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';

import '../app/home/models/job.dart';

abstract class Database {

  Future<void> createJob(Job job);

}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> createJob(Job job) => _setData(
      path: APIPath.job(uid, 'job_abc2'),
      data: job.toMap());

  // Defines a single entry point to all FireStore writes. Best practice. Good for debuging
  Future<void> _setData({required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);

  }

}
