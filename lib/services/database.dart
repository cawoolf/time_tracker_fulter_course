import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

import '../app/home/models/job.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job?>> jobsStream();
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job? job});
}

// Used for generating a unique ID for the Job document
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance; //Singleton for the service class.

  // Set date regardless of if it is a new or existing document
  @override
  Future<void> setJob(Job job) =>
      _service.setData(path: APIPath.job(uid, job.id), data: job.toMap());

  @override
  Future<void> deleteJob(Job job) => _service.deleteData(
      path: APIPath.job(uid, job.id));

  /* I don't understand where the data variable is coming from.. Ohhh data isn't being assinged here,
  this is just a parameter for the anonymous function being used inside _collectionStream
  _collectionStream assignees the data
*/
  @override
  Stream<List<Job?>> jobsStream() =>
      _service.collectionStream(
          path: APIPath.jobs(uid), builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
    path: APIPath.entry(uid, entry.id),
    data: entry.toMap(),
  );

  @override
  Future<void> deleteEntry(Entry entry) {
    // TODO: implement deleteEntry
    throw UnimplementedError();
  }

  @override
  Stream<List<Entry>> entriesStream({Job? job}) {
    // TODO: implement entriesStream
    throw UnimplementedError();
  }

}
