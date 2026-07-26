import 'lookupmessages.dart';

/// Chinese messages
class ZhMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '前';
  @override
  String suffixFromNow() => '後';
  @override
  String lessThanOneMinute(int seconds) => '少於一分鐘';

  @override
  String minutes(int minutes) => '$minutes分';

  @override
  String hours(int hours) => '約$hours小時';

  @override
  String days(int days) => '約$days日';

  @override
  String months(int months) => '約$months月';

  @override
  String years(int years) => '約$years年';

  @override
  String wordSeparator() => ' ';
}

/// Chinese short Messages
class ZhShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => '刚刚';
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
      return '1 小时';
    } else if (hours > 1 && hours < 11) {
      return '~$hours小时';
    } else {
      return '$hours小时';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1天';
    } else if (days > 1 && days < 11) {
      return '~$days天';
    } else {
      return '$days天';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1个月';
    } else if (months > 1 && months < 11) {
      return '~$months个月';
    } else {
      return '$months个月';
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
