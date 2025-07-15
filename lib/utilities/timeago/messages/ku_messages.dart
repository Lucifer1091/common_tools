import 'lookupmessages.dart';

/// Kurdish messages
class KuMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => 'لە ئێستاوە';
  @override
  String lessThanOneMinute(int seconds) => 'چەند چرکەیەک لەمەوپێش';

  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return 'خولەکێک لەمەوپێش';
    }
    return '$minutes خولەک لەمەوپێش';
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return 'کاژێرێک لەمەوپێش';
    }
    return '$hours کاژێر لەمەوپێش';
  }

  @override
  String days(int days) {
    if (days == 1) {
      return 'ڕۆژێک لەمەوپێش';
    }
    return '$days ڕۆژ لەمەوپێش';
  }

  @override
  String months(int months) {
    if (months == 1) {
      return 'مانگێک لەمەوپێش';
    }
    return '$months مانگ لەمەوپێش';
  }

  @override
  String years(int years) {
    if (years == 1) {
      return 'ساڵێک لەمەوپێش';
    }
    return '$years ساڵ لەمەوپێش';
  }

  @override
  String wordSeparator() => ' ';
}

/// Kurdish short messages
class KuShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'ئێستا';

  @override
  String minutes(int minutes) => 'خولەک $minutes';

  @override
  String hours(int hours) => 'کاژێر $hours';

  @override
  String days(int days) => 'رۆژ $days';

  @override
  String months(int months) => 'مانگ $months';

  @override
  String years(int years) => 'ساڵ $years ';

  @override
  String wordSeparator() => ' ';
}
