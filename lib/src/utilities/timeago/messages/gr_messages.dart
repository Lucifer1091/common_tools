import 'lookupmessages.dart';

/// Greek messages
class GrMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'πριν';
  @override
  String suffixFromNow() => 'από τώρα';
  @override
  String lessThanOneMinute(int seconds) => 'μια στιγμή';

  @override
  String minutes(int minutes) => '$minutes λεπτά';

  @override
  String hours(int hours) => '$hours ώρες';

  @override
  String days(int days) => '$days μέρες';

  @override
  String months(int months) => '$months μήνες';

  @override
  String years(int years) => '$years χρόνια';

  @override
  String wordSeparator() => ' ';
}

/// Greek short messages
class GrShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'τώρα';

  @override
  String minutes(int minutes) => '$minutes λπτ';

  @override
  String hours(int hours) => '$hours ώρες';

  @override
  String days(int days) => '$days μρς';

  @override
  String months(int months) => '$months μνς';

  @override
  String years(int years) => '$years χρ';

  @override
  String wordSeparator() => ' ';
}
