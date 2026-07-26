import 'lookupmessages.dart';

/// Hungarian Messages
class HuMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'ezelőtt';
  @override
  String suffixFromNow() => 'mostantól';
  @override
  String lessThanOneMinute(int seconds) => 'egy pillanattal';

  @override
  String minutes(int minutes) => '$minutes perccel';

  @override
  String hours(int hours) => '$hours órával';

  @override
  String days(int days) => '$days nappal';

  @override
  String months(int months) => '$months hónappal';

  @override
  String years(int years) => '$years évvel';
  @override
  String wordSeparator() => ' ';
}

/// Hungarian short Messages
class HuShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'most';

  @override
  String minutes(int minutes) => '$minutes perce';

  @override
  String hours(int hours) => '$hours órája';

  @override
  String days(int days) => '$days napja';

  @override
  String months(int months) {
    if (months == 1) {
      return '1 م';
    } else if (months > 1 && months < 11) {
      return '~$months م';
    } else {
      return '$months م';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 سنه';
    } else if (years > 1 && years < 11) {
      return '~$years سنوات';
    } else {
      return '$years سنوات';
    }
  }

  @override
  String wordSeparator() => ' ';
}
