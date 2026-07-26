import 'lookupmessages.dart';

/// Spanish Messages
class EsMessages implements LookupMessages {
  @override
  String prefixAgo() => 'hace';
  @override
  String prefixFromNow() => 'dentro de';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'un momento';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return 'un minuto';
    } else if (minutes > 1 && minutes < 11) {
      return 'unos $minutes minutos';
    } else {
      return '$minutes minutos';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return 'una hora';
    } else if (hours > 1 && hours < 11) {
      return 'unas $hours horas';
    } else {
      return '$hours horas';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return 'un día';
    } else if (days > 1 && days < 11) {
      return 'unos $days días';
    } else {
      return '$days días';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return 'un mes';
    } else if (months > 1 && months < 11) {
      return 'unos $months meses';
    } else {
      return '$months meses';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return 'un año';
    } else if (years > 1 && years < 11) {
      return 'unos $years años';
    } else {
      return '$years años';
    }
  }

  @override
  String wordSeparator() => ' ';
}

/// Spanish short Messages
class EsShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'ahora';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 m';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes m';
    } else {
      return '$minutes m';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 h';
    } else if (hours > 1 && hours < 11) {
      return '~$hours h';
    } else {
      return '$hours h';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 d';
    } else if (days > 1 && days < 11) {
      return '~$days d';
    } else {
      return '$days d';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 m';
    } else if (months > 1 && months < 11) {
      return '~$months m';
    } else {
      return '$months m';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 y';
    } else if (years > 1 && years < 11) {
      return '~$years y';
    } else {
      return '$years y';
    }
  }

  @override
  String wordSeparator() => ' ';
}
