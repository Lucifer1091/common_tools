import 'lookupmessages.dart';

/// Romanian messages
class RoMessages implements LookupMessages {
  @override
  String prefixAgo() => 'acum';
  @override
  String prefixFromNow() => 'peste';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'o clipită';

  @override
  String minutes(int minutes) => '$minutes minute';

  @override
  String hours(int hours) => '$hours ore';

  @override
  String days(int days) => '$days zile';

  @override
  String months(int months) => '$months luni';

  @override
  String years(int years) => '$years ani';

  @override
  String wordSeparator() => ' ';
}

/// Romanian short messages
class RoShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'acum';

  @override
  String minutes(int minutes) => '$minutes min';

  @override
  String hours(int hours) => '$hours ore';

  @override
  String days(int days) => '$days zile';

  @override
  String months(int months) => '$months luni';

  @override
  String years(int years) => '$years ani';

  @override
  String wordSeparator() => ' ';
}
