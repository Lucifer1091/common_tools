import 'lookupmessages.dart';

/// Thai messages
class ThMessages implements LookupMessages {
  @override
  String prefixAgo() => 'เมื่อ';
  @override
  String prefixFromNow() => 'ใน';
  @override
  String suffixAgo() => 'ที่แล้ว';
  @override
  String suffixFromNow() => 'จากนี้';
  @override
  String lessThanOneMinute(int seconds) => 'เมื่อครู่นี้';

  @override
  String minutes(int minutes) => '$minutes นาที';

  @override
  String hours(int hours) => '$hours ชั่วโมง';

  @override
  String days(int days) => '$days วัน';

  @override
  String months(int months) => '$months เดือน';

  @override
  String years(int years) => '$years ปี';

  @override
  String wordSeparator() => ' ';
}

/// Thai short messages
class ThShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'เมื่อครู่';

  @override
  String minutes(int minutes) => '$minutes นาที';

  @override
  String hours(int hours) => '$hours ชม';

  @override
  String days(int days) => '$days ว';

  @override
  String months(int months) => '$months ด';

  @override
  String years(int years) => '$years ป';

  @override
  String wordSeparator() => ' ';
}
