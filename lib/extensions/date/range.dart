import 'package:flutter/material.dart';

import 'misc.dart';
import 'validators.dart';

extension DateRangeValidators on DateTimeRange? {
  /// Checks if the [DateTimeRange] value is null.
  bool get isNull => this == null;

  /// Checks if the [DateTimeRange] value is not null.
  bool get isNotNull => !isNull;

  /// Checks if this [DateTimeRange] is between or equal to the given [start] and [end] dates.
  ///
  /// Returns `true` if this [DateTimeRange] overlaps with the range defined by [start] and [end],
  /// inclusive of both ends. Returns `false` otherwise.
  ///
  /// If this [DateTimeRange], [start], or [end] is null, returns `false`.
  bool isBetweenOrEqual({DateTime? start, DateTime? end}) {
    if (isNull || start == null || end == null) return false;

    if (this!.start.isBeforeOrEqualTo(end) &&
        start.isBeforeOrEqualTo(this!.end)) {
      return true;
    }

    return false;
  }

  /// Checks if the [date] is within the range, inclusive of start and end dates.
  ///
  /// Returns `true` if the [date] falls on or between the start and end dates.
  /// Otherwise, returns `false`.
  bool includes(DateTime date) =>
      isNotNull && date.isBetween(this?.start, this?.end);

  /// Checks if the [range] is completely within this range.
  ///
  /// Returns `true` if both the start and end of the [range] are within this range.
  bool contains(DateTimeRange range) =>
      includes(range.start) && includes(range.end);

  /// Checks if the [range] overlaps with this range at any point.
  ///
  /// Returns `true` if any part of the [range] intersects with this range.
  bool cross(DateTimeRange range) =>
      isNotNull && includes(range.start) ||
      includes(range.end) ||
      range.includes(this!.start) ||
      range.includes(this!.end);

  /// Checks if the [range] is exactly equal to this range.
  ///
  /// Returns `true` if the start and end of the [range] are the same as this range.
  bool equals(DateTimeRange range) =>
      isNotNull &&
      this!.start.equals(range.start) &&
      this!.end.equals(range.end);

  /// Static method to determine if two date ranges overlap.
  ///
  /// [firstStartDate]: The start date of the first range.
  /// [firstEndDate]: The end date of the first range.
  /// [secondStartDate]: The start date of the second range.
  /// [secondEndDate]: The end date of the second range.
  ///
  /// Throws a [RangeError] if either range is invalid (start date is after end date).
  ///
  /// Returns `true` if the two date ranges overlap, otherwise returns `false`.
  static bool areRangesOverlapping(
    DateTime firstStartDate,
    DateTime firstEndDate,
    DateTime secondStartDate,
    DateTime secondEndDate,
  ) {
    if (firstStartDate.isAfter(firstEndDate)) {
      throw RangeError('Invalid initial range');
    }

    if (secondStartDate.isAfter(secondEndDate)) {
      throw RangeError('Invalid comparison range');
    }

    final initial = DateTimeRange(start: firstStartDate, end: firstEndDate);
    final compared = DateTimeRange(start: secondStartDate, end: secondEndDate);

    return initial.cross(compared) || compared.cross(initial);
  }
}

extension DateRangeOperators on DateTimeRange {
  /// Compares if this range starts before [other].
  ///
  /// Returns `true` if the start of this range is before the start of [other].
  bool operator <(DateTimeRange other) => start.isBefore(other.start);

  /// Compares if this range starts before or at the same moment as [other].
  ///
  /// Returns `true` if the start of this range is before or at the same moment as the start of [other].
  bool operator <=(DateTimeRange other) =>
      start.isBefore(other.start) || start.isAtSameMomentAs(other.start);

  /// Compares if this range ends after [other].
  ///
  /// Returns `true` if the end of this range is after the end of [other].
  bool operator >(DateTimeRange other) => end.isAfter(other.end);

  /// Compares if this range ends after or at the same moment as [other].
  ///
  /// Returns `true` if the end of this range is after or at the same moment as the end of [other].
  bool operator >=(DateTimeRange other) =>
      end.isAfter(other.end) || end.isAtSameMomentAs(other.end);
}

extension DateRange on DateTimeRange {
  /// Creates a new [DateTimeRange] with the specified [start] and [end] dates.
  ///
  /// Returns a [DateTimeRange] starting at [start] and ending at [end].
  static DateTimeRange set(DateTime start, DateTime end) =>
      DateTimeRange(start: start, end: end);

  /// Creates a new [DateTimeRange] with the specified [start] date and the current end date.
  ///
  /// Returns a [DateTimeRange] with [start] as the start date and the current end date.
  DateTimeRange setStart(DateTime start) => set(start, end);

  /// Creates a new [DateTimeRange] with the current start date and the specified [end] date.
  ///
  /// Returns a [DateTimeRange] with the current start date and [end] as the end date.
  DateTimeRange setEnd(DateTime end) => set(start, end);

  /// Creates a new [DateTimeRange] with the current start date and a duration of [duration].
  ///
  /// Returns a [DateTimeRange] with the current start date and an end date
  /// calculated by adding [duration] to the start date.
  DateTimeRange setDuration(Duration duration) =>
      set(start, start.add(duration));
}

extension DateRangeConversions on DateTimeRange {
  /// Returns the union of this [DateTimeRange] and another [DateTimeRange].
  ///
  /// If the ranges overlap or touch, the result is a [DateTimeRange] from the earliest
  /// start to the latest end. Throws a [RangeError] if the ranges do not overlap.
  DateTimeRange union(DateTimeRange other) {
    if (cross(other)) {
      if (end.isAfter(other.start) || end.isAtSameMomentAs(other.start)) {
        return DateRange.set(start, other.end);
      } else if (other.end.isAfter(start) ||
          other.end.isAtSameMomentAs(start)) {
        return DateRange.set(other.start, end);
      } else {
        throw RangeError('Error this: $this; other: $other');
      }
    } else {
      throw RangeError("DateTimeRanges don't cross");
    }
  }

  /// Returns the intersection of this [DateTimeRange] and another [DateTimeRange].
  ///
  /// The result is a [DateTimeRange] representing the overlap between the two ranges.
  /// Throws a [RangeError] if the ranges do not overlap.
  DateTimeRange intersection(DateTimeRange other) {
    if (!cross(other)) {
      if (other.contains(this)) return this;

      throw RangeError("DateTimeRanges don't cross");
    }

    final intersectionStart = Date.max(start, other.start);
    final intersectionEnd = Date.min(end, other.end);

    return DateRange.set(intersectionStart, intersectionEnd);
  }

  /// Returns the difference between this [DateTimeRange] and another [DateTimeRange].
  ///
  /// The result is a [DateTimeRange] that represents the non-overlapping portion of this range.
  /// Returns null if the ranges are identical. Throws a [RangeError] if ranges overlap in an unexpected way.
  DateTimeRange? difference(DateTimeRange other) {
    if (other == this) {
      return null;
    } else if (this <= other) {
      if (end.isBefore(other.start)) {
        return this;
      } else {
        return DateRange.set(start, other.start);
      }
    } else if (this >= other) {
      if (other.end.isBefore(start)) {
        return this;
      } else {
        return DateRange.set(other.end, end);
      }
    } else {
      throw RangeError('Error this: $this; other: $other');
    }
  }

  /// Returns a string representation of the [DateTimeRange].
  ///
  /// Format: '<start | end | duration>'.
  String toPrint() => '<$start | $end | $duration>';
}
