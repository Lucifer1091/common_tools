import 'lookupmessages.dart';

/// Azeri Messages
class AzMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'əvvəl';
  @override
  String suffixFromNow() => 'indidən';
  @override
  String lessThanOneMinute(int seconds) => 'bir an';

  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return 'bir dəqiqə';
    } else if (minutes > 1 && minutes < 11) {
      return 'təxminən $minutes dəqiqə';
    } else {
      return '$minutes dəqiqə';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return 'bir saat';
    } else if (hours > 1 && hours < 11) {
      return 'təxminən $hours saat';
    } else {
      return '$hours saat';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return 'bir gün';
    } else if (days > 1 && days < 11) {
      return 'təxminən $days gün';
    } else {
      return '$days gün';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return 'bir ay';
    } else if (months > 1 && months < 11) {
      return 'təxminən $months ay';
    } else {
      return '$months ay';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return 'bir il';
    } else if (years > 1 && years < 11) {
      return 'təxminən $years il';
    } else {
      return '$years il';
    }
  }

  @override
  String wordSeparator() => ' ';
}

/// Azeri short Messages
class AzShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'indi';

  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 dəq';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes dəq';
    } else {
      return '$minutes dəq';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 s';
    } else if (hours > 1 && hours < 11) {
      return '~$hours s';
    } else {
      return '$hours s';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 g';
    } else if (days > 1 && days < 11) {
      return '~$days g';
    } else {
      return '$days g';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 ay';
    } else if (months > 1 && months < 11) {
      return '~$months ay';
    } else {
      return '$months ay';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 il';
    } else if (years > 1 && years < 11) {
      return '~$years il';
    } else {
      return '$years il';
    }
  }

  @override
  String wordSeparator() => ' ';
}
