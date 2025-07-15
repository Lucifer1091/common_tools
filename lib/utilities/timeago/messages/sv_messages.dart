import 'lookupmessages.dart';

/// Swedish messages
class SvMessages implements LookupMessages {
  @override
  String prefixAgo() => 'för';
  @override
  String prefixFromNow() => 'om';
  @override
  String suffixAgo() => 'sedan';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'en stund';

  @override
  String minutes(int minutes) => '$minutes minuter';

  @override
  String hours(int hours) => '$hours timmar';

  @override
  String days(int days) => '$days dagar';

  @override
  String months(int months) => '$months månader';

  @override
  String years(int years) => '$years år';

  @override
  String wordSeparator() => ' ';
}

/// Swedish Short messages
class SvShortMessages implements LookupMessages {
  @override
  String prefixAgo() => 'för ';
  @override
  String prefixFromNow() => 'om';
  @override
  String suffixAgo() => 'sedan';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'nu';

  @override
  String minutes(int minutes) => '$minutes min';

  @override
  String hours(int hours) => '$hours h';

  @override
  String days(int days) => '$days d';

  @override
  String months(int months) => '$months må';

  @override
  String years(int years) => '$years år';

  @override
  String wordSeparator() => ' ';
}
