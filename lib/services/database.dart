import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';

import '../app/home/models/job.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job?>> jobsStream();

}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  @override
  Future<void> createJob(Job job) =>
      _setData(path: APIPath.job(uid, 'job_abc2'), data: job.toMap());


  // Defines a single entry point to all FireStore writes. Best practice. Good for debuging
  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  @override
  Stream<List<Job?>> jobsStream() => _collectionStream(
      path: APIPath.jobs(uid),
      builder: (data) => Job.fromMap(data));


  // Generics for handling different types of Collections. Not just Jobs
  Stream<List<T>> _collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map((snapshot) =>
        snapshot.docs.map((snapshot) => builder(snapshot.data())).toList());
  }

}

// Notes methods. Not for use
Stream<List<Job?>> notesJobsStream() {
  String uid = 'test';
  final path = APIPath.jobs(uid);
  final reference = FirebaseFirestore.instance.collection(path);

  // snapshots() is a reference that returns a Stream<QuerySnapshot>
  // a snapshot is an instance of FireStore collection at any given time.
  final snapshots =
  reference.snapshots(); //Returns a stream of individual snapshots
  // The snapshot represents a Firestore Collection. In this case a collection of Jobs.
  snapshots.listen((snapshots) {
    for (var snapshot in snapshots.docs) {
      print(snapshot.data()); //This data is a list of all Jobs
    }
  });

  return snapshots.map((snapshot) => snapshot.docs
      .map((snapshot) => Job.fromMap(snapshot.data()))
      .toList()); // Common mistake is to convert the Iterable into a List .map() returns an Iterable
}

// Debugging/Troubleshooting method
void readJobs() {
  String uid = 'test';
  final path = APIPath.jobs(uid);
  final reference = FirebaseFirestore.instance.collection(path);

  // snapshots() is a reference that returns a Stream<QuerySnapshot>
  // a snapshot is an instance of FireStore collection at any given time.
  final snapshots =
  reference.snapshots(); //Returns a stream of individual snapshots
  // The snapshot represents a Firestore Collection. In this case a collection of Jobs.
  snapshots.listen((snapshots) {
    for (var snapshot in snapshots.docs) {
      print(snapshot.data()); //This data is a list of all Jobs
    }
  });
}
