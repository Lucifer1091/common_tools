import 'lookupmessages.dart';

/// Farsi Messages
class FaMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'پیش';
  @override
  String suffixFromNow() => 'بعد';
  @override
  String lessThanOneMinute(int seconds) => 'چند لحظه';
  @override
  String minutes(int minutes) => '$minutes دقیقه';

  @override
  String hours(int hours) => '$hours ساعت';

  @override
  String days(int days) => '$days روز';

  @override
  String months(int months) => '$months ماه';

  @override
  String years(int years) => '$years سال';

  @override
  String wordSeparator() => ' ';
}

/// Farsi short Messages
class FaShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'now';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 m';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes mins';
    } else {
      return '$minutes mins';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 h';
    } else if (hours > 1 && hours < 11) {
      return '~$hours hrs';
    } else {
      return '$hours hrs';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 d';
    } else if (days > 1 && days < 11) {
      return '~$days days';
    } else {
      return '$days days';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 m';
    } else if (months > 1 && months < 11) {
      return '~$months mos';
    } else {
      return '$months mos';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 y';
    } else if (years > 1 && years < 11) {
      return '~$years yrs';
    } else {
      return '$years yrs';
    }
  }

  @override
  String wordSeparator() => ' ';
}
