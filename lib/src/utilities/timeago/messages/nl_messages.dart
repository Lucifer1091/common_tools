import 'lookupmessages.dart';

/// Dutch messages
class NlMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'over';
  @override
  String suffixAgo() => 'geleden';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'een moment';

  @override
  String minutes(int minutes) => '$minutes minuten';

  @override
  String hours(int hours) => '$hours uren';

  @override
  String days(int days) => '$days dagen';

  @override
  String months(int months) => '$months maanden';

  @override
  String years(int years) => '$years jaren';

  @override
  String wordSeparator() => ' ';
}

/// Dutch short messages
class NlShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'nu';

  @override
  String minutes(int minutes) => '$minutes min';

  @override
  String hours(int hours) => '$hours u';

  @override
  String days(int days) => '$days d';

  @override
  String months(int months) => '$months ma';

  @override
  String years(int years) => '$years jr';

  @override
  String wordSeparator() => ' ';
}
