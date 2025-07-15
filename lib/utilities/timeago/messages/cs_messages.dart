import 'lookupmessages.dart';

/// Czech Messages
class CsMessages implements LookupMessages {
  @override
  String prefixAgo() => 'před';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => 'od teď';
  @override
  String lessThanOneMinute(int seconds) => 'chvílí';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 minutou';
    } else if (minutes > 1 && minutes < 5) {
      return '$minutes minutami';
    }
    return '$minutes minutami';
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 hodinou';
    } else if (hours > 1 && hours < 5) {
      return '$hours hodinami';
    }
    return '$hours hodinami';
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 dnem';
    } else if (days > 1 && days < 5) {
      return '$days dny';
    }
    return '$days dny';
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 měsícem';
    } else if (months > 1 && months < 5) {
      return '$months měsíci';
    }
    return '$months měsíci';
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 rokem';
    } else if (years > 1 && years < 5) {
      return '$years roky';
    }
    return '$years roky';
  }

  @override
  String wordSeparator() => ' ';
}

/// Czech short Messages
class CsShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'teď';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 min';
    } else if (minutes > 1 && minutes < 5) {
      return '$minutes min';
    }
    return '$minutes min';
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 h';
    } else if (hours > 1 && hours < 5) {
      return '$hours h';
    }
    return '$hours h';
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 den';
    } else if (days > 1 && days < 5) {
      return '$days dny';
    }
    return '$days dní';
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 měsíc';
    } else if (months > 1 && months < 5) {
      return '$months měsíce';
    }
    return '$months měsíců';
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 rok';
    } else if (years > 1 && years < 5) {
      return '$years roky';
    }
    return '$years roků';
  }

  @override
  String wordSeparator() => ' ';
}
