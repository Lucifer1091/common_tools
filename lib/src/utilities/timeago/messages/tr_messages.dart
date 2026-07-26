import 'lookupmessages.dart';

/// Turkish messages
class TrMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'önce';
  @override
  String suffixFromNow() => 'kaldı';
  @override
  String lessThanOneMinute(int seconds) => 'biraz';

  @override
  String minutes(int minutes) => '$minutes dakika';

  @override
  String hours(int hours) => '$hours saat';

  @override
  String days(int days) => '$days gün';

  @override
  String months(int months) => '$months ay';

  @override
  String years(int years) => '$years yıl';

  @override
  String wordSeparator() => ' ';
}

/// Turkish short Messages
class TrShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'şimdi';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 dk';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes dk';
    } else {
      return '$minutes dk';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 sa';
    } else if (hours > 1 && hours < 11) {
      return '~$hours sa';
    } else {
      return '$hours sa';
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
      return '1 yıl';
    } else if (years > 1 && years < 11) {
      return '~$years yıl';
    } else {
      return '$years yıl';
    }
  }

  @override
  String wordSeparator() => ' ';
}
