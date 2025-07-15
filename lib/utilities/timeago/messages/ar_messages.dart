import 'lookupmessages.dart';

/// Arabic Messages
class ArMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => 'من الآن';
  @override
  String lessThanOneMinute(int seconds) => 'قبل ثواني';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return 'دقيقة واحدة';
    } else if (minutes > 1 && minutes < 11) {
      return 'حوالي $minutes دقائق';
    } else {
      return '$minutes دقائق';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return 'ساعة واحدة';
    } else if (hours > 1 && hours < 11) {
      return 'حوالي $hours ساعات';
    }
    return '$hours ساعات';
  }

  @override
  String days(int days) {
    if (days == 1) {
      return 'يوم واحد';
    } else if (days > 1 && days < 11) {
      return 'حوالي $days أيام';
    }
    return '$days أيام';
  }

  @override
  String months(int months) {
    if (months == 1) {
      return 'شهر واحد';
    } else if (months > 1 && months < 11) {
      return 'حوالي $months أشهر';
    }
    return '$months أشهر';
  }

  @override
  String years(int years) {
    if (years == 1) {
      return 'سنة واحدة';
    } else if (years > 1 && years < 11) {
      return 'حوالي $years سنوات';
    }
    return '$years سنوات';
  }

  @override
  String wordSeparator() => ' ';
}

/// Arabic short Messages
class ArShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'الأن';

  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 د';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes د';
    } else {
      return '$minutes د';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 س';
    } else if (hours > 1 && hours < 11) {
      return '~$hours س';
    } else {
      return '$hours س';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 ي';
    } else if (days > 1 && days < 11) {
      return '~$days ي';
    } else {
      return '$days ي';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 م';
    } else if (months > 1 && months < 11) {
      return '~$months م';
    } else {
      return '$months م';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 س';
    } else if (years > 1 && years < 11) {
      return '~$years س';
    } else {
      return '$years س';
    }
  }

  @override
  String wordSeparator() => ' ';
}
