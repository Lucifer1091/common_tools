import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

String expectedTimeZone(DateTime value, {bool separateWithColon = true}) {
  final int inMinutes = value.timeZoneOffset.abs().inMinutes;
  final int hours = inMinutes ~/ 60;
  final int minutes = inMinutes - (hours * 60);

  return '${value.timeZoneOffset.isNegative ? '-' : '+'}'
      '${hours.toString().padLeft(2, '0')}'
      '${separateWithColon ? ':' : ''}'
      '${minutes.toString().padLeft(2, '0')}';
}

void main() {
  group('DateConversions', () {
    test('format respects provided pattern', () {
      final DateTime value = DateTime(2024, 6, 23, 14, 5, 9);

      expect(
        value.format(pattern: MyDateFormats.defaultDateTime),
        '2024-06-23 14:05:09',
      );
    });

    test('toMonth handles all abbreviation styles', () {
      final DateTime value = DateTime(2024, 6, 23);

      expect(value.toMonth(), 'June');
      expect(value.toMonth(style: Abbreviation.semi), 'Jun');
      expect(value.toMonth(style: Abbreviation.full), 'Jun');
    });

    test('toWeekday handles all abbreviation styles', () {
      final DateTime value = DateTime(2024, 7);

      expect(value.toWeekday(), 'Monday');
      expect(value.toWeekday(style: Abbreviation.semi), 'Mon');
      expect(value.toWeekday(style: Abbreviation.full), 'M');
    });

    test('greeting returns expected message for each time period', () {
      expect(DateTime(2024, 1, 1, 6).greeting(), 'Good Morning');
      expect(DateTime(2024, 1, 1, 14).greeting(), 'Good Afternoon');
      expect(DateTime(2024, 1, 1, 18).greeting(), 'Good Evening');
      expect(DateTime(2024, 1, 1, 2).greeting(), 'Good Night');
    });

    test('totalMinutes and timeOfDay convert correctly', () {
      final DateTime value = DateTime(2024, 1, 1, 2, 30);
      final TimeOfDay time = value.timeOfDay;

      expect(value.totalMinutes, 150);
      expect(time.hour, 2);
      expect(time.minute, 30);
    });

    test('timeAgo returns ago text for past and date string for future', () {
      final DateTime twoHoursAgo = DateTime.now().subtract(
        const Duration(hours: 2),
      );
      final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

      expect(twoHoursAgo.timeAgo, '2 hours ago');
      expect(tomorrow.timeAgo, tomorrow.format(pattern: MyDateFormats.date));
    });

    test('toHuman handles today', () {
      final DateTime utcNow = DateTime.now().toUtc();
      final DateTime value =
          DateTime.utc(utcNow.year, utcNow.month, utcNow.day, 13, 45).toLocal();

      expect(value.toHuman, 'Today at ${DateFormat.jm().format(value)}');
    });

    test('toHuman handles tomorrow', () {
      final DateTime utcNow = DateTime.now().toUtc();
      final DateTime value =
          DateTime.utc(
            utcNow.year,
            utcNow.month,
            utcNow.day,
          ).add(const Duration(days: 1, hours: 9, minutes: 15)).toLocal();

      expect(value.toHuman, 'Tomorrow at ${DateFormat.jm().format(value)}');
    });

    test('toHuman handles yesterday', () {
      final DateTime utcNow = DateTime.now().toUtc();
      final DateTime value =
          DateTime.utc(utcNow.year, utcNow.month, utcNow.day)
              .subtract(const Duration(days: 1))
              .add(const Duration(hours: 19, minutes: 20))
              .toLocal();

      expect(value.toHuman, 'Yesterday at ${DateFormat.jm().format(value)}');
    });

    test('toHuman handles next week', () {
      final DateTime value = DateTime.now().startOfWeek
          .addDays(9)
          .add(const Duration(hours: 10));
      final String day = value.format(pattern: MyDateFormats.fullDay);
      final String time = DateFormat.jm().format(value);

      expect(value.toHuman, '$day at $time');
    });

    test('toHuman handles last week', () {
      final DateTime value = DateTime.now().startOfWeek
          .subtract(const Duration(days: 5))
          .add(const Duration(hours: 10));
      final String day = value.format(pattern: MyDateFormats.fullDay);
      final String time = DateFormat.jm().format(value);

      expect(value.toHuman, 'Last $day at $time');
    });

    test('toHuman falls back to full date time outside relative ranges', () {
      final DateTime value = DateTime.now().startOfWeek
          .subtract(const Duration(days: 14))
          .add(const Duration(hours: 10));
      final String expected =
          '${DateFormat.yMMMEd().format(value)} ${DateFormat.jm().format(value)}';

      expect(value.toHuman, expected);
    });

    test(
      'weekNumber and isoWeekYear follow ISO rules around year boundary',
      () {
        final DateTime jan1_2021 = DateTime.utc(2021);
        final DateTime jan4_2021 = DateTime.utc(2021, 1, 4);
        final DateTime dec31_2018 = DateTime.utc(2018, 12, 31);

        expect(jan1_2021.weekNumber, 53);
        expect(jan1_2021.isoWeekYear, 2020);
        expect(jan4_2021.weekNumber, 1);
        expect(jan4_2021.isoWeekYear, 2021);
        expect(dec31_2018.weekNumber, 1);
        expect(dec31_2018.isoWeekYear, 2019);
      },
    );

    test('toAge and timeStamp return expected values', () {
      final DateTime now = DateTime.now();
      final DateTime birthDate = now.subtract(
        const Duration(days: (20 * 365) + 30),
      );
      final DateTime timestampSource = DateTime.fromMillisecondsSinceEpoch(
        1700000000123,
      );

      expect(birthDate.toAge, now.difference(birthDate).inDays ~/ 365);
      expect(timestampSource.timeStamp, 1700000000);
    });

    test('daysInMonth handles leap and non-leap years', () {
      expect(DateTime(2024, 2).daysInMonth, 29);
      expect(DateTime(2023, 2).daysInMonth, 28);
      expect(DateTime(2024, 4).daysInMonth, 30);
    });

    test('dayOfYear returns one-based day index', () {
      expect(DateTime(2024).dayOfYear, 1);
      expect(DateTime(2024, 12, 31).dayOfYear, 366);
      expect(DateTime.utc(2023, 12, 31).dayOfYear, 365);
    });

    test('differenceInYear, differenceInMonth, and differenceInDays work', () {
      final DateTime yearA = DateTime(2025);
      final DateTime yearB = DateTime(2020);
      final DateTime monthA = DateTime(2024, 7);
      final DateTime monthB = DateTime(2024);
      final DateTime dayA = DateTime(2024, 6, 10, 23, 59);
      final DateTime dayB = DateTime(2024, 6, 1, 0, 1);

      expect(
        yearA.differenceInYear(yearB),
        yearA.difference(yearB).inDays ~/ 365,
      );
      expect(monthA.differenceInMonth(monthB), 6);
      expect(dayA.differenceInDays(dayB), 9);
      expect(dayB.differenceInDays(dayA), -9);
    });

    test('fromNow returns current difference', () {
      final DateTime fiveMinutesAgo = DateTime.now().subtract(
        const Duration(minutes: 5),
      );
      final Duration diff = fiveMinutesAgo.fromNow();

      expect(diff.isNegative, isTrue);
      expect(diff.inMinutes <= -4, isTrue);
      expect(diff.inMinutes >= -6, isTrue);
    });

    test('toRange creates ascending ranges regardless of input order', () {
      final DateTime earlier = DateTime(2024);
      final DateTime later = DateTime(2024, 1, 5);
      final DateTimeRange ordered = earlier.toRange(later);
      final DateTimeRange swapped = later.toRange(earlier);

      expect(ordered.start, earlier);
      expect(ordered.end, later);
      expect(swapped.start, earlier);
      expect(swapped.end, later);
    });

    test('hour12 and quarter convert correctly', () {
      expect(DateTime(2024).hour12, 12);
      expect(DateTime(2024, 1, 1, 12).hour12, 12);
      expect(DateTime(2024, 1, 1, 15).hour12, 3);

      expect(DateTime(2024).quarter, 1);
      expect(DateTime(2024, 4).quarter, 2);
      expect(DateTime(2024, 8).quarter, 3);
      expect(DateTime(2024, 12).quarter, 4);
    });

    test('timeZoneFormatted supports colon and compact output', () {
      final DateTime local = DateTime(2024);
      final DateTime utc = DateTime.utc(2024);

      expect(local.timeZoneFormatted(), expectedTimeZone(local));
      expect(
        local.timeZoneFormatted(false),
        expectedTimeZone(local, separateWithColon: false),
      );
      expect(utc.timeZoneFormatted(), '+00:00');
      expect(utc.timeZoneFormatted(false), '+0000');
    });

    test('toUtcString and asUtc normalize correctly', () {
      final DateTime local = DateTime(2024, 1, 2, 3, 4, 5, 678);
      final DateTime? utcCopy = local.asUtc;

      expect(local.toUtcString(utc: false), local.toString().split('.')[0]);
      expect(local.toUtcString(), local.toUtc().toString().split('.')[0]);

      expect(utcCopy, isNotNull);
      expect(utcCopy!.isUtc, isTrue);
      expect(utcCopy.year, local.year);
      expect(utcCopy.month, local.month);
      expect(utcCopy.day, local.day);
      expect(utcCopy.hour, local.hour);
      expect(utcCopy.minute, local.minute);
      expect(utcCopy.second, local.second);
    });
  });

  group('ParseDateTime', () {
    test('isDate handles null, valid, and invalid values', () {
      String? empty;

      expect(empty.isDate, isFalse);
      expect(''.isDate, isFalse);
      expect('31/12/2024'.isDate, isTrue);
      expect('2024-12-31T23:59:59Z'.isDate, isTrue);
      expect('not-a-date'.isDate, isFalse);
    });

    test('toTime parses hh:mm a and handles empty input', () {
      final String input = DateFormat.jm().format(DateTime(2024, 1, 1, 14, 30));
      final TimeOfDay? parsed = input.toTime();
      String? empty;

      expect(parsed, isNotNull);
      expect(parsed!.hour, 14);
      expect(parsed.minute, 30);
      expect(empty.toTime(), isNull);
      expect(() => 'bad value'.toTime(), throwsFormatException);
    });

    test('toDateTime parses using provided format and utc option', () {
      final DateTime? local = '15/01/2024 18:45'.toDateTime(
        format: 'dd/MM/yyyy HH:mm',
      );
      final DateTime? utc = '15/01/2024 18:45'.toDateTime(
        utc: true,
        format: 'dd/MM/yyyy HH:mm',
      );

      expect(local, DateTime(2024, 1, 15, 18, 45));
      expect(utc, DateTime.utc(2024, 1, 15, 18, 45));
    });

    test(
      'toUtcString normalizes to utc or local and returns null when empty',
      () {
        const String input = '2024-01-15 18:45:00';
        const String pattern = 'yyyy-MM-dd HH:mm:ss';
        final String expectedLocal =
            DateFormat(pattern).parse(input).toLocal().toString().split('.')[0];
        final String expectedUtc =
            DateFormat(
              pattern,
            ).parse(input, true).toUtc().toString().split('.')[0];
        String? empty;

        expect(input.toUtcString(utc: false, format: pattern), expectedLocal);
        expect(input.toUtcString(format: pattern), expectedUtc);
        expect(empty.toUtcString(format: pattern), isNull);
      },
    );

    test('parse handles null, explicit format, iso, and invalid values', () {
      expect(ParseDateTime.parse(null), isNull);
      expect(ParseDateTime.parse(''), isNull);
      expect(
        ParseDateTime.parse(
          '15/01/2024 18:45',
          format: 'dd/MM/yyyy HH:mm',
          utc: false,
        ),
        DateTime(2024, 1, 15, 18, 45),
      );
      expect(
        ParseDateTime.parse('2024-01-10T12:00:00Z'),
        DateTime.utc(2024, 1, 10, 12),
      );
      expect(ParseDateTime.parse('not-a-date'), isNull);
    });

    test(
      'parse fallback supports millisecond and detected pattern recovery',
      () {
        final DateTime? withMillis = ParseDateTime.parse(
          '2024-04-17T07:20:57.573',
          format: 'yyyy/MM/dd',
        );
        final DateTime? recovered = ParseDateTime.parse(
          '29 Apr 1999',
          format: 'yyyy-MM-dd',
        );

        expect(withMillis, DateTime.utc(2024, 4, 17, 7, 20, 57, 573));
        expect(recovered, isNotNull);
        expect(recovered!.year, 1999);
        expect(recovered.month, 4);
        expect(recovered.day, 29);
      },
    );
  });
}
