import 'lookupmessages.dart';

/// Hebrew Messages
class HeMessages implements LookupMessages {
  @override
  String prefixAgo() => 'לפני';
  @override
  String prefixFromNow() => 'בעוד';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'כמה רגעים';

  @override
  String minutes(int minutes) => '$minutes דקות';

  @override
  String hours(int hours) => '$hours שעות';

  @override
  String days(int days) => '$days ימים';

  @override
  String months(int months) => '$months חודשים';

  @override
  String years(int years) => '$years שנים';

  @override
  String wordSeparator() => ' ';
}

/// Hebrew short Messages
class HeShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'בעוד';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'כעת';

  @override
  String minutes(int minutes) => '$minutes דקות';

  @override
  String hours(int hours) => '$hours שעות';

  @override
  String days(int days) => '$days ימים';

  @override
  String months(int months) => '$months חודשים';

  @override
  String years(int years) => '$years שנים';

  @override
  String wordSeparator() => ' ';
}
