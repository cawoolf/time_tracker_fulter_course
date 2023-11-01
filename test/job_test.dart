import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      bool doesNotCompile = false;
      try {
        final job =
            Job.fromMap(<String, dynamic>{}, 'abc'); //fromMap() is null safe
        print(job.toString());
      } catch (e) {
        doesNotCompile = true;
      }
      expect(doesNotCompile, true);
    });

    test('job with all properties', () {
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      // This statement works because hashCode and == operator for the Job class are implemented.
      expect(job, Job(name: 'Blogging', ratePerHour: 10, id: 'abc'));
    });

    test('missing name', () {
      bool doesNotCompile = false;
      try {
        final job = Job.fromMap({
          'ratePerHour': 10,
        }, 'abc');
        print(job.toString());
      } catch (e) {
        doesNotCompile = true;
      }
      expect(doesNotCompile, true);
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(name: 'test', ratePerHour: 10, id: 'abc');

      // orignal code.
      // expect(job.toMap()['name'], 'test');
      // expect(job.toMap()['ratePerHour'], 10);

      // Better code below.
      expect(job.toMap(), {
        'name': 'test',
        'ratePerHour' : 10
      });
    });
  });
}
