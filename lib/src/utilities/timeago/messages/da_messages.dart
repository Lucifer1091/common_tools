import 'lookupmessages.dart';

/// Danish Messages
class DaMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'siden';
  @override
  String suffixFromNow() => 'fra nu';
  @override
  String lessThanOneMinute(int seconds) => 'et øjeblik';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 minut';
    } else if (minutes > 1 && minutes < 11) {
      return '$minutes minutter';
    }
    return '$minutes minutter';
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 time';
    } else if (hours > 1 && hours < 11) {
      return '$hours timer';
    }
    return '$hours timer';
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 dag';
    } else if (days > 1 && days < 11) {
      return '$days dage';
    }
    return '$days dage';
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 måned';
    } else if (months > 1 && months < 11) {
      return '$months måneder';
    }
    return '$months måneder';
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 år';
    } else if (years > 1 && years < 11) {
      return '$years år';
    }
    return '$years år';
  }

  @override
  String wordSeparator() => ' ';
}

/// Danish short Messages
class DaShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'nu';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 min';
    } else if (minutes > 1 && minutes < 11) {
      return '$minutes min';
    }
    return '$minutes min';
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 t';
    } else if (hours > 1 && hours < 11) {
      return '$hours t';
    }
    return '$hours t';
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 d';
    } else if (days > 1 && days < 11) {
      return '$days d';
    }
    return '$days d';
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 md';
    } else if (months > 1 && months < 11) {
      return '$months md';
    }
    return '$months md';
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 år';
    } else if (years > 1 && years < 11) {
      return '$years år';
    }
    return '$years år';
  }

  @override
  String wordSeparator() => ' ';
}
