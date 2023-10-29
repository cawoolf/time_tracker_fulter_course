import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

void main() {
  group('fromMap',() {
    // test('null data', () {
     // final job = Job.fromMap(null, 'abc'); //fromMap() is null safe
    //   expect(job, null);
    // });

    test('job with all properties', () {
      final job = Job.fromMap({
        'name' : 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      // expect(job, Job(name: 'Blogging', ratePerHour: 10, id: 'abc'));
      expect(job.name, 'Blogging');
      expect(job.ratePerHour, 10);
    });
  });

  group('toMap',() {

    test('job to map',()
    {
      final job = Job(name: 'test', ratePerHour: 10, id: 'abc');
      expect(job.toMap()['name'], 'test');
      expect(job.toMap()['ratePerHour'],10);
    });
  });
}