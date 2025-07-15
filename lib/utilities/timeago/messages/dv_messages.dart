import 'lookupmessages.dart';

/// Divehi Messages
class DvMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'ކުރިން';
  @override
  String suffixFromNow() => 'ފަހުން';
  @override
  String lessThanOneMinute(int seconds) => 'ހިނދުކޮޅެއް';

  @override
  String minutes(int minutes) => '$minutes މިނެޓު';

  @override
  String hours(int hours) => '$hours ގަޑިއިރު';

  @override
  String days(int days) => '$days ދުވަސް';

  @override
  String months(int months) => '$months މަސް';

  @override
  String years(int years) => '$years އަހަރު';

  @override
  String wordSeparator() => ' ';
}

/// Divehi short Messages
class DvShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'މިހާރު';

  @override
  String minutes(int minutes) => '$minutes މިނެޓް';

  @override
  String hours(int hours) => '$hours ގ';

  @override
  String days(int days) => '$days ދުވަސް';

  @override
  String months(int months) => '$months މަސް';

  @override
  String years(int years) => '$years އަހަރު';

  @override
  String wordSeparator() => ' ';
}
