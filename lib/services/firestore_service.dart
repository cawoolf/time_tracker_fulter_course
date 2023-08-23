import 'package:cloud_firestore/cloud_firestore.dart';

import '../app/home/models/job.dart';
import 'api_path.dart';

// Class for seperating out the Firestore functions from the database class.
class FirestoreService {

  //Singleton patern for Dart. We only want one instance of this service class.
  FirestoreService._(); // Private constructor
  static final instance = FirestoreService._();

  // Defines a single entry point to all FireStore writes. Best practice. Good for debuging
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  // Generics for handling different types of Collections. Not just Jobs
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map((snapshot) =>
        snapshot.docs.map((snapshot) => builder(snapshot.data(), snapshot.id)).toList()); //data is assigned here
  }
}


// Notes methods. Not for use. collectionStream is a refactor of this.
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
      .map((snapshot) => Job.fromMap(snapshot.data(),'test'))
      .toList()); // Common mistake is to convert the Iterable into a List .map() returns an Iterable
}