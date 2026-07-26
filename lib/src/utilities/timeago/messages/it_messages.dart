import 'lookupmessages.dart';

/// Italian messages
class ItMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'tra';
  @override
  String suffixAgo() => 'fa';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'meno di un minuto';

  @override
  String minutes(int minutes) => '$minutes minuti';

  @override
  String hours(int hours) => '$hours ore';

  @override
  String days(int days) => '$days giorni';

  @override
  String months(int months) => '$months mesi';

  @override
  String years(int years) => '$years anni';

  @override
  String wordSeparator() => ' ';
}

/// Italian short messages
class ItShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'ora';

  @override
  String minutes(int minutes) => '$minutes m';

  @override
  String hours(int hours) => '$hours o';

  @override
  String days(int days) => '$days g';

  @override
  String months(int months) => '$months m';

  @override
  String years(int years) => '$years a';

  @override
  String wordSeparator() => ' ';
}
