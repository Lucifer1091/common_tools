import 'lookupmessages.dart';

/// Russian messages
class RuMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'через';
  @override
  String suffixAgo() => 'назад';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'минуту';

  @override
  String minutes(int minutes) => '$minutes ${_convert(minutes, 'minutes')}';

  @override
  String hours(int hours) => '$hours ${_convert(hours, 'hours')}';

  @override
  String days(int days) => '$days ${_convert(days, 'days')}';

  @override
  String months(int months) => '$months ${_convert(months, 'months')}';

  @override
  String years(int years) => '$years ${_convert(years, 'years')}';
  @override
  String wordSeparator() => ' ';

  String _convert(int number, String type) {
    final mod = number % 10;
    final modH = number % 100;

    if (mod == 1 && modH != 11) {
      switch (type) {
        case 'minutes':
          return 'минуту';
        case 'hours':
          return 'час';
        case 'days':
          return 'день';
        case 'months':
          return 'месяц';
        case 'years':
          return 'год';
        default:
          return '';
      }
    } else if (<int>[2, 3, 4].contains(mod) &&
        !<int>[12, 13, 14].contains(modH)) {
      switch (type) {
        case 'minutes':
          return 'минуты';
        case 'hours':
          return 'часа';
        case 'days':
          return 'дня';
        case 'months':
          return 'месяца';
        case 'years':
          return 'года';
        default:
          return '';
      }
    }
    switch (type) {
      case 'minutes':
        return 'минут';
      case 'hours':
        return 'часов';
      case 'days':
        return 'дней';
      case 'months':
        return 'месяцев';
      case 'years':
        return 'лет';
      default:
        return '';
    }
  }
}

class RuShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'только что';

  @override
  String minutes(int minutes) => '$minutes мин.';

  @override
  String hours(int hours) => '$hours ч.';

  @override
  String days(int days) => '$days д.';

  @override
  String months(int months) => '$months мес.';

  @override
  String years(int years) => '$years г.';
  @override
  String wordSeparator() => ' ';
}
