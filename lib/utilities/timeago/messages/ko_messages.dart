import 'lookupmessages.dart';

/// Korean messages
class KoMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '전';
  @override
  String suffixFromNow() => '후';
  @override
  String lessThanOneMinute(int seconds) => '방금';

  @override
  String minutes(int minutes) => '$minutes분';

  @override
  String hours(int hours) => '$hours시간';

  @override
  String days(int days) => '$days일';

  @override
  String months(int months) => '$months개월';

  @override
  String years(int years) => '$years년';

  @override
  String wordSeparator() => ' ';
}

/// Korean short Messages
class KoShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => '방금';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1분';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes분';
    } else {
      return '$minutes분';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1시간';
    } else if (hours > 1 && hours < 11) {
      return '~$hours시간';
    } else {
      return '$hours시간';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1일';
    } else if (days > 1 && days < 11) {
      return '~$days일';
    } else {
      return '$days일';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1개월';
    } else if (months > 1 && months < 11) {
      return '~$months개월';
    } else {
      return '$months개월';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1년';
    } else if (years > 1 && years < 11) {
      return '~$years년';
    } else {
      return '$years년';
    }
  }

  @override
  String wordSeparator() => ' ';
}
