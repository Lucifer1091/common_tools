import 'lookupmessages.dart';

/// Cambodian messages
class KmMessages implements LookupMessages {
  @override
  String prefixAgo() => 'មុននេះ';
  @override
  String prefixFromNow() => 'ក្រោយពីនេះ';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'បន្ដិច';

  @override
  String minutes(int minutes) => ' $minutes នាទី';

  @override
  String hours(int hours) => ' $hours ម៉ោង';

  @override
  String days(int days) => ' $days ថ្ងៃ';

  @override
  String months(int months) => ' $months ខែ';

  @override
  String years(int years) => ' $years ឆ្នាំ';

  @override
  String wordSeparator() => '​';
}

/// Cambodian short messages
class KmShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'មិញ';

  @override
  String minutes(int minutes) => '$minutes ន';

  @override
  String hours(int hours) => '$hours ម';

  @override
  String days(int days) => '$days ថ';

  @override
  String months(int months) => '$months ខ';

  @override
  String years(int years) => '$years ឆ';

  @override
  String wordSeparator() => '';
}
