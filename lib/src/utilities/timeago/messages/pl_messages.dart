import 'lookupmessages.dart';

/// Polish messgages
class PlMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'temu';
  @override
  String suffixFromNow() => 'od tego momentu';
  @override
  String lessThanOneMinute(int seconds) => 'przed chwilą';

  @override
  String minutes(int minutes) => _pluralize(minutes, 'minuty', 'minut');

  @override
  String hours(int hours) => _pluralize(hours, 'godziny', 'godzin');

  @override
  String days(int days) => '$days dni';

  @override
  String months(int months) => _pluralize(months, 'miesiące', 'miesięcy');

  @override
  String years(int years) => _pluralize(years, 'lata', 'lat');
  @override
  String wordSeparator() => ' ';

  String _pluralize(int n, String form1, String form2) {
    // Rules as per https://www.gnu.org/software/gettext/manual/html_node/Plural-forms.html
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
      return '$n $form1';
    }

    return '$n $form2';
  }
}

/// Polish short Messages
class PlShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'przed chwilą';
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
