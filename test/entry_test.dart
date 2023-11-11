import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      bool doesNotCompile = false;
      try {
        final entry = Entry.fromMap(<String, dynamic>{}, 'abc');
        print(entry.toString());
      } catch (e) {
        doesNotCompile = true;
      }
      expect(doesNotCompile, true);
    });

    test('entry with all properties', () {
      final entry = Entry.fromMap({
        'id': 'abc',
        'jobId': '123',
         'start': DateTime.fromMillisecondsSinceEpoch(0).millisecondsSinceEpoch,
          'end' : DateTime.fromMillisecondsSinceEpoch(1).millisecondsSinceEpoch,
          'comment' : 'test'
      }, 'abc');
      // This statement works because hashCode and == operator for the Job class are implemented.
      expect(entry, Entry(id: 'abc', jobId: '123', start: DateTime.fromMillisecondsSinceEpoch(0), end: DateTime.fromMillisecondsSinceEpoch(1), comment: 'test'));
    });
  });

  test('difference', () {
    final start = DateTime.fromMillisecondsSinceEpoch(0);
    final end = DateTime.fromMillisecondsSinceEpoch(1);
    final durationInHours = end.difference(start).inMinutes.toDouble() / 60.0;
    final entry = Entry(id: 'abc', jobId: '123', start: DateTime.fromMillisecondsSinceEpoch(0), end: DateTime.fromMillisecondsSinceEpoch(1), comment: 'test');
    expect(entry.durationInHours, durationInHours);
  });
}
