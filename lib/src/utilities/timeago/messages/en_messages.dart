import 'lookupmessages.dart';

/// English Messages
class EnMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'ago';
  @override
  String suffixFromNow() => 'from now';
  @override
  String lessThanOneMinute(int seconds) => 'a moment';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return 'a minute';
    } else if (minutes > 1 && minutes < 11) {
      return 'about $minutes minutes';
    } else {
      return '$minutes minutes';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return 'an hour';
    } else if (hours > 1 && hours < 11) {
      return 'about $hours hours';
    } else {
      return '$hours hours';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return 'a day';
    } else if (days > 1 && days < 11) {
      return 'about $days days';
    } else {
      return '$days days';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return 'a month';
    } else if (months > 1 && months < 11) {
      return 'about $months months';
    } else {
      return '$months months';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return 'a year';
    } else if (years > 1 && years < 11) {
      return 'about $years years';
    } else {
      return '$years years';
    }
  }

  @override
  String wordSeparator() => ' ';
}

/// English short Messages
class EnShortMessages implements LookupMessages {
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
