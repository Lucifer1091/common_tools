import 'lookupmessages.dart';

/// Catalan Messages
class CaMessages implements LookupMessages {
  @override
  String prefixAgo() => 'fa';
  @override
  String prefixFromNow() => "d'aquí a";
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'un moment';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return 'un minut';
    } else if (minutes > 1 && minutes < 11) {
      return 'aproximadament $minutes minuts';
    } else {
      return '$minutes minuts';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return 'una hora';
    } else if (hours > 1 && hours < 11) {
      return 'aproximadament $hours hores';
    } else {
      return '$hours hores';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return 'un dia';
    } else if (days > 1 && days < 11) {
      return 'aproximadament $days dies';
    } else {
      return '$days dies';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return 'un mes';
    } else if (months > 1 && months < 11) {
      return 'aproximadament $months mesos';
    } else {
      return '$months mesos';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return 'un any';
    } else if (years > 1 && years < 11) {
      return 'aproximadament $years anys';
    } else {
      return '$years anys';
    }
  }

  @override
  String wordSeparator() => ' ';
}

/// Catalan short Messages
class CaShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'ara';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 min';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes min';
    } else {
      return '$minutes min';
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
      return '1 dia';
    } else if (days > 1 && days < 11) {
      return '~$days dies';
    } else {
      return '$days dies';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 mes';
    } else if (months > 1 && months < 11) {
      return '~$months mesos';
    } else {
      return '$months mesos';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 any';
    } else if (years > 1 && years < 11) {
      return '~$years anys';
    } else {
      return '$years anys';
    }
  }

  @override
  String wordSeparator() => ' ';
}
