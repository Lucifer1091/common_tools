import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../index.dart';
import '../index.dart';

class DatePickers {
  DatePickers._();

  /// Displays an adaptive date and time picker based on the current platform.
  ///
  /// On iOS and macOS, it shows a Cupertino-style picker. On other platforms,
  /// it shows a Material-style picker.
  ///
  /// The [context] parameter is required to provide the necessary context for
  /// the picker. The [mode] parameter specifies whether to show a date, time,
  /// or both date and time picker. The [initialDate] parameter sets
  /// the initial date and time to be displayed by the picker.
  ///
  /// The [firstDate] and [lastDate] parameters set the selectable date range
  /// for the picker. If not provided, defaults are used.
  /// Returns a `Future<DateTime?>` that completes with the selected date and time
  /// or null if the user cancels the picker.
  ///
  /// ```dart
  /// final DateTime? selectedDateTime = await showPicker(
  ///  context,
  ///  mode: DateTimeFieldPickerMode.dateTime,
  ///  initialDate: DateTime.now(),
  ///  firstDate: DateTime(2011),
  ///  lastDate: DateTime(2125),
  /// );
  /// ```
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTimeFieldPickerMode mode,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    OnDateTimeSelect? onDateTimeSelect,
    DatePickerMode? initialDatePickerMode,
  }) async {
    DateTime? selectedDateTime = initialDate ?? DateTime.now();

    selectedDateTime = _getInitialDate(
      initialDate,
      firstDate ?? kDefaultFirstSelectableDate,
      lastDate ?? kDefaultLastSelectableDate,
    );

    switch (mode) {
      // TODO : Break Month and Year Pickers in Separate Cases
      case DateTimeFieldPickerMode.year:
        final date = await getYear(
          context,
          initialDate: selectedDateTime,
          firstDate: firstDate,
          lastDate: lastDate,
        );
        onDateTimeSelect?.call(date, null);
        return date;
      case DateTimeFieldPickerMode.month:
      case DateTimeFieldPickerMode.monthYear:
        final date = await getMonthYear(
          context,
          initialDate: selectedDateTime,
          firstDate: firstDate,
          lastDate: lastDate,
          // initialMonthPickerMode: initialMonthPickerMode,
        );
        onDateTimeSelect?.call(date, null);
        return date;

      case DateTimeFieldPickerMode.date:
        final date = await getDate(
          context,
          initialDate: selectedDateTime,
          firstDate: firstDate,
          lastDate: lastDate,
          initialDatePickerMode: initialDatePickerMode,
        );
        onDateTimeSelect?.call(date, null);
        return date;

      case DateTimeFieldPickerMode.time:
        DateTime date0 = _getInitialTime(
          initialDate,
          firstDate ?? kDefaultFirstSelectableDate,
          lastDate ?? kDefaultLastSelectableDate,
        );

        final timeOfDay = await getTime(
          context,
          initialTime: TimeOfDay.fromDateTime(date0),
        );
        onDateTimeSelect?.call(null, timeOfDay);
        return convert(timeOfDay);

      case DateTimeFieldPickerMode.dateTime:
        TimeOfDay? timeOfDay;

        final date = await getDate(
          context,
          initialDate: selectedDateTime,
          firstDate: firstDate,
          lastDate: lastDate,
          initialDatePickerMode: initialDatePickerMode,
        ).then((date) async {
          if (date != null) {
            DateTime date0 = _getInitialTime(
              initialDate,
              firstDate ?? kDefaultFirstSelectableDate,
              lastDate ?? kDefaultLastSelectableDate,
            );

            timeOfDay = await getTime(
              context,
              initialTime: TimeOfDay.fromDateTime(date0),
            );
          }
          return date;
        });
        onDateTimeSelect?.call(combine(date, timeOfDay), timeOfDay);
        return combine(date, timeOfDay);
    }
  }

  static Future<TimeOfDay?> getTime(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: getTheme,
    );
  }

  static Future<DateTime?> getDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DatePickerMode? initialDatePickerMode,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? kDefaultFirstSelectableDate,
      lastDate: lastDate ?? kDefaultLastSelectableDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: initialDatePickerMode ?? DatePickerMode.day,
      builder: getTheme,
    );
  }

  static Future<DateTime?> getDateTime(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DatePickerMode? initialDatePickerMode,
  }) async {
    TimeOfDay? time;

    final date = await getDate(
      context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: initialDatePickerMode,
    ).then((date) async {
      if (date != null) {
        var initialTime = TimeOfDay(
          hour: initialDate?.hour ?? 0,
          minute: initialDate?.minute ?? 0,
        );
        time = await getTime(context, initialTime: initialTime);
      }
      return date;
    });

    return combine(date, time);
  }

  static Future<DateTimeRange?> getDateRange(
    BuildContext context, {
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    List<QuickDateRange>? ranges,
  }) async {
    if (initialDateRange != null) {
      if (firstDate != null && initialDateRange.start.isBefore(firstDate)) {
        firstDate = initialDateRange.start;
      }
      if (lastDate != null && initialDateRange.end.isAfter(lastDate)) {
        lastDate = initialDateRange.end;
      }
    }

    return await showFancyDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate ?? kDefaultFirstSelectableDate,
      lastDate: lastDate ?? kDefaultLastSelectableDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: getTheme,
    );
  }

  static Future<DateTime?> getYear(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return showDialog<DateTime?>(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dividerTheme: const DividerThemeData(
              thickness: 0,
              color: MyColors.transparent,
            ),
            datePickerTheme: DatePickerThemeData(
              todayForegroundColor: const WidgetStateProperty.fromMap({
                WidgetState.selected: Colors.white,
              }),
              yearForegroundColor: WidgetStateProperty.fromMap({
                WidgetState.selected: Colors.white,
                WidgetState.any: context.colorScheme.foreground,
              }),
            ),
          ),
          child: MyYearPicker(
            initialDate: initialDate,
            firstDate: firstDate ?? kDefaultFirstSelectableDate,
            lastDate: lastDate ?? kDefaultLastSelectableDate,
          ),
        );
      },
    );
  }

  static Future<DateTime?> getMonthYear(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    // return await showMonthYearPicker(
    //   context: context,
    //   initialDate: initialDate ?? DateTime.now(),
    //   firstDate: firstDate ?? kDefaultFirstSelectableDate,
    //   lastDate: lastDate ?? kDefaultLastSelectableDate,
    //   initialMonthYearPickerMode:
    //       initialMonthPickerMode ?? MonthYearPickerMode.month,
    //   builder: getTheme,
    // );
  }

  static Widget getTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        visualDensity: const VisualDensity(),
        useMaterial3: false,
        colorScheme:
            context.isDark
                ? ColorScheme.dark(
                  primary: context.colorScheme.primary,
                  onSurface: context.colorScheme.primary,
                  onBackground: context.colorScheme.primary,
                  secondary: context.colorScheme.primary,
                )
                : ColorScheme.light(
                  primary: context.colorScheme.primary,
                  onSurface: context.colorScheme.primary,
                  onBackground: context.colorScheme.primary,
                  secondary: context.colorScheme.primary,
                  onSecondary: context.colorScheme.primaryForeground,
                ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        timePickerTheme: Theme.of(context).timePickerTheme.copyWith(
          backgroundColor: context.colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          helpTextStyle: context.bodyMedium.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.primary,
          ),
        ),
        datePickerTheme: Theme.of(context).datePickerTheme.copyWith(
          backgroundColor: context.colorScheme.background,
          headerBackgroundColor: context.colorScheme.primary,
          headerForegroundColor: Colors.white,
          rangePickerHeaderBackgroundColor: context.colorScheme.primary,
          rangePickerHeaderForegroundColor: Colors.white,
          rangePickerBackgroundColor: context.colorScheme.background,
        ),
      ),
      child: child!,
    );
  }

  /// Returns an empty string if [DateFormat.format()] throws or [date] is null.
  static String tryFormat(DateTime? date, DateFormat format) {
    if (date != null) {
      try {
        return format.format(date);
      } catch (e) {
        // print('Error formatting date: $e');
      }
    }
    return '';
  }

  /// Returns null if [format.parse()] throws.
  static DateTime? tryParse(String string, DateFormat format) {
    if (string.isNotEmpty) {
      try {
        return format.parse(string);
      } catch (e) {
        // print('Error parsing date: $e');
      }
    }
    return null;
  }

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  static DateTime? combine(DateTime? date, TimeOfDay? time) =>
      (date == null && time == null)
          ? null
          : DateTime(
            date?.year ?? 1,
            date?.month ?? 1,
            date?.day ?? 1,
            time?.hour ?? 0,
            time?.minute ?? 0,
          );

  static DateTime? convert(TimeOfDay? time) =>
      time == null ? null : DateTime(1970, 1, 1, time.hour, time.minute);

  /// A function that returns the initial date to be displayed by the picker.
  /// If [initialPickerDateTime] is not provided, the function returns the current
  /// date if it is within the selectable date range. Otherwise, it returns the
  /// [firstDate] or [lastDate] depending on the current date.
  static DateTime _getInitialDate(
    DateTime? initialPickerDateTime,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    if (initialPickerDateTime != null) return initialPickerDateTime;

    final DateTime now = DateTime.now();

    if (now.isBefore(firstDate)) return firstDate;

    if (now.isAfter(lastDate)) return lastDate;

    return now;
  }

  /// A function that compares two [TimeOfDay] objects, should be
  /// replaced by the [TimeOfDay.compareTo] method when available in more
  /// stable Flutter versions.
  static int _compareTimeOfDayTo(TimeOfDay current, TimeOfDay other) {
    final int hourComparison = current.hour.compareTo(other.hour);
    if (hourComparison == 0) {
      return current.minute.compareTo(other.minute);
    } else {
      return hourComparison;
    }
  }

  /// A function that returns the initial time to be displayed by the picker.
  /// If [initialPickerDateTime] is not provided, the function returns the current
  /// time if it is within the selectable time range. Otherwise, it returns the
  /// [firstDate] or [lastDate] depending on the current time.
  static DateTime _getInitialTime(
    DateTime? initialPickerDateTime,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    if (initialPickerDateTime != null) {
      return initialPickerDateTime;
    }

    final TimeOfDay now = TimeOfDay.now();

    if (_compareTimeOfDayTo(now, TimeOfDay.fromDateTime(firstDate)) < 0) {
      return firstDate;
    }

    if (_compareTimeOfDayTo(now, TimeOfDay.fromDateTime(lastDate)) > 0) {
      return lastDate;
    }

    return DateTime(
      firstDate.year,
      firstDate.month,
      firstDate.day,
      now.hour,
      now.minute,
    );
  }
}
