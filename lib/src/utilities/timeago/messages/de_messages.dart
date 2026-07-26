import 'lookupmessages.dart';

/// German Messages
class DeMessages implements LookupMessages {
  @override
  String prefixAgo() => 'vor';
  @override
  String prefixFromNow() => 'in';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'weniger als eine Minute';

  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 Minute';
    } else if (minutes > 1 && minutes < 11) {
      return 'etwa $minutes Minuten';
    } else {
      return '$minutes Minuten';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 Stunde';
    } else if (hours > 1 && hours < 11) {
      return 'etwa $hours Stunden';
    } else {
      return '$hours Stunden';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 Tag';
    } else if (days > 1 && days < 11) {
      return 'etwa $days Tagen';
    } else {
      return '$days Tagen';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 Monat';
    } else if (months > 1 && months < 11) {
      return 'etwa $months Monaten';
    } else {
      return '$months Monaten';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 Jahr';
    } else if (years > 1 && years < 11) {
      return 'etwa $years Jahren';
    } else {
      return '$years Jahren';
    }
  }

  @override
  String wordSeparator() => ' ';
}

/// German short Messages
class DeShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'Jetzt';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 Min.';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes Min.';
    } else {
      return '$minutes Min.';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 Std.';
    } else if (hours > 1 && hours < 11) {
      return '~$hours Std.';
    } else {
      return '$hours Std.';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 Tg.';
    } else if (days > 1 && days < 11) {
      return '~$days Tg.';
    } else {
      return '$days Tg.';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 Mo.';
    } else if (months > 1 && months < 11) {
      return '~$months Mo.';
    } else {
      return '$months Mo.';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 Jahr';
    } else if (years > 1 && years < 11) {
      return '~$years Jr.';
    } else {
      return '$years Jr.';
    }
  }

  @override
  String wordSeparator() => ' ';
}
