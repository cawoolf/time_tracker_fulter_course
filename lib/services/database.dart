import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

import '../app/home/models/job.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job?>> jobsStream();
  Stream<Job> jobStream({required String jobId});
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
  Future<void> deleteJob(Job job) async {

    // Deletes all Entries associated with the Job
    // We have to do this because we made Entries a separate collection as a design choice
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if(entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }

    // Deletes the Job
    await _service.deleteData(
      path: APIPath.job(uid, job.id));
  }

  /* I don't understand where the data variable is coming from.. Ohhh data isn't being assinged here,
  this is just a parameter for the anonymous function being used inside _collectionStream
  _collectionStream assignees the data

  The data is coming from snapshot.data() line 41 firestore_service, which pass the Job.fromMap() function
  as the argument for the builder function of the collectionStream
*/
  @override
  Stream<List<Job?>> jobsStream() =>
      _service.collectionStream(
          path: APIPath.jobs(uid), builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Stream<Job> jobStream({required String jobId}) => _service.documentStream(
      path: APIPath.job(uid, jobId),
      builder: (data, documentId) => Job.fromMap(data!, documentId)
  );

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
  Stream<List<Entry>> entriesStream({Job? job}) =>
    _service.collectionStream<Entry>(
      path: APIPath.entries(uid),
      queryBuilder: job != null
          ? (query) => query!.where('jobId', isEqualTo: job.id)
          : null, // No filtering of the data is needed if a Job is not provided. Returns a List of all Entries.
      builder: (data, documentID) => Entry.fromMap(data, documentID),
      sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
    );
}
