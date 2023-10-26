import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });

    test('zero', () {
      expect(Format.hours(0), '0h');
    });

    test('negative', () {
      expect(Format.hours(-5), '0h');
    });

    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });

  group('data - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en-GB'; // Important to localize tests if needed
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2023-10-25', () {
      expect(Format.date(DateTime(2023, 10, 25)), '25 Oct 2023');
    });
  });

  group('data - US Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en-US'; // Important to localize tests if needed
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2023-10-25', () {
      expect(Format.date(DateTime(2023, 10, 25)), 'Oct 25, 2023');
    });
  });

  group('dayOfWeek - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en-GB'; // Important to localize tests if needed
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('Wednesday', () {
      expect(Format.dayOfWeek(DateTime(2023, 10, 25)), 'Wed');
    });
  });

  group('currency - US Locale', () {
    setUp(() => Intl.defaultLocale = 'en-US');
    test('positive', () {
      expect(Format.currency(10), '\$10');
    });

    test('zero', () {
      expect(Format.currency(0), '');
    });

    test('negative', () {
      expect(Format.currency(-5), '-\$5');
    });
  });
}
