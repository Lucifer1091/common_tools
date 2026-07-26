import 'lookupmessages.dart';

/// Japanese messages
class JaMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '今から';
  @override
  String suffixAgo() => '前';
  @override
  String suffixFromNow() => '後';
  @override
  String lessThanOneMinute(int seconds) => '1分未満';

  @override
  String minutes(int minutes) => '$minutes分';

  @override
  String hours(int hours) => '約$hours時間';

  @override
  String days(int days) => '約$days日';

  @override
  String months(int months) => '約$monthsか月';

  @override
  String years(int years) => '約$years年';

  @override
  String wordSeparator() => '';
}

/// Japanese short Messages
class JaShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'たった今';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1分';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes分';
    } else {
      return '$minutes分';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1時間';
    } else if (hours > 1 && hours < 11) {
      return '~$hours時間';
    } else {
      return '$hours時間';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1日';
    } else if (days > 1 && days < 11) {
      return '~$days日';
    } else {
      return '$days日';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1か月';
    } else if (months > 1 && months < 11) {
      return '~$monthsか月';
    } else {
      return '$monthsか月';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1年';
    } else if (years > 1 && years < 11) {
      return '~$years年';
    } else {
      return '$years年';
    }
  }

  @override
  String wordSeparator() => ' ';
}
