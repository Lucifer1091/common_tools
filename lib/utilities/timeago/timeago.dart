import 'messages/ar_messages.dart';
import 'messages/az_messages.dart';
import 'messages/ca_messages.dart';
import 'messages/cs_messages.dart';
import 'messages/da_messages.dart';
import 'messages/de_messages.dart';
import 'messages/dv_messages.dart';
import 'messages/en_messages.dart';
import 'messages/es_messages.dart';
import 'messages/fa_messages.dart';
import 'messages/fr_messages.dart';
import 'messages/gr_messages.dart';
import 'messages/he_messages.dart';
import 'messages/hi_messages.dart';
import 'messages/hu_messages.dart';
import 'messages/id_messages.dart';
import 'messages/it_messages.dart';
import 'messages/ja_messages.dart';
import 'messages/km_messages.dart';
import 'messages/ko_messages.dart';
import 'messages/ku_messages.dart';
import 'messages/lookupmessages.dart';
import 'messages/nl_messages.dart';
import 'messages/pl_messages.dart';
import 'messages/ro_messages.dart';
import 'messages/ru_messages.dart';
import 'messages/sv_messages.dart';
import 'messages/ta_messages.dart';
import 'messages/th_messages.dart';
import 'messages/tr_messages.dart';
import 'messages/vi_messages.dart';
import 'messages/zh_messages.dart';

String _default = 'en';

Map<String, LookupMessages> _lookupMessagesMap = {
  'en': EnMessages(),
  'en_short': EnShortMessages(),
  'es': EsMessages(),
  'es_short': EsShortMessages(),
  'ar': ArMessages(),
  'ar_short': ArShortMessages(),
  'az': AzMessages(),
  'az_short': AzShortMessages(),
  'ca': CaMessages(),
  'ca_short': CaShortMessages(),
  'cs': CsMessages(),
  'cs_short': CsShortMessages(),
  'da': DaMessages(),
  'da_short': DaShortMessages(),
  'de': DeMessages(),
  'de_short': DeShortMessages(),
  'dv': DvMessages(),
  'dv_short': DvShortMessages(),
  'fa': FaMessages(),
  'fa_short': FaShortMessages(),
  'fr': FrMessages(),
  'fr_short': FrShortMessages(),
  'gr': GrMessages(),
  'gr_short': GrShortMessages(),
  'he': HeMessages(),
  'he_short': HeShortMessages(),
  'hi': HiMessages(),
  'hi_short': HiShortMessages(),
  'id': IdMessages(),
  'id_short': IdShortMessages(),
  'it': ItMessages(),
  'it_short': ItShortMessages(),
  'ja': JaMessages(),
  'ja_short': JaShortMessages(),
  'km': KmMessages(),
  'km_short': KmShortMessages(),
  'ko': KoMessages(),
  'ko_short': KoShortMessages(),
  'ku': KuMessages(),
  'ku_short': KuShortMessages(),
  'pl': PlMessages(),
  'pl_short': PlShortMessages(),
  'nl': NlMessages(),
  'nl_short': NlShortMessages(),
  'ro': RoMessages(),
  'ro_short': RoShortMessages(),
  'ru': RuMessages(),
  'ru_short': RuShortMessages(),
  'sv': SvMessages(),
  'sv_short': SvShortMessages(),
  'ta': TaMessages(),
  'ta_short': TaShortMessages(),
  'th': ThMessages(),
  'th_short': ThShortMessages(),
  'tr': TrMessages(),
  'tr_short': TrShortMessages(),
  'vi': ViMessages(),
  'vi_short': ViShortMessages(),
  'zh': ZhMessages(),
  'zh_short': ZhShortMessages(),
  'hu': HuMessages(),
  'hu_short': HuShortMessages(),
};

class TimeAgo {
  static String toUnitString(int value, {String? unit, String? langCode}) {
    final langCodeVal = langCode ?? _default;
    final messages = _lookupMessagesMap[langCodeVal] ?? EnMessages();

    switch (unit) {
      case 'year':
        return messages.years(value);
      case 'month':
        return messages.months(value);
      case 'day':
        return messages.days(value);
      case 'hour':
        return messages.hours(value);
      case 'minute':
      default:
        return messages.minutes(value);
    }
  }

  static String format(DateTime date,
      {String? locale, DateTime? clock, bool? allowFromNow}) {
    final localeVal = locale ?? _default;
    final allowNow = allowFromNow ?? false;
    final messages = _lookupMessagesMap[localeVal] ?? EnMessages();
    final clockTime = clock ?? DateTime.now();
    var elapsed =
        clockTime.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    String prefix, suffix;

    if (allowNow && elapsed < 0) {
      elapsed = date.isBefore(clockTime) ? elapsed : elapsed.abs();
      prefix = messages.prefixFromNow();
      suffix = messages.suffixFromNow();
    } else {
      prefix = messages.prefixAgo();
      suffix = messages.suffixAgo();
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45) {
      result = messages.lessThanOneMinute(seconds.round());
    } else if (seconds < 90) {
      result = messages.minutes(minutes.round());
    } else if (minutes < 45) {
      result = messages.minutes(minutes.round());
    } else if (minutes < 90) {
      result = messages.hours(hours.round());
    } else if (hours < 24) {
      result = messages.hours(hours.round());
    } else if (hours < 48) {
      result = messages.days(days.round());
    } else if (days < 30) {
      result = messages.days(days.round());
    } else if (days < 60) {
      result = messages.months(months.round());
    } else if (days < 365) {
      result = messages.months(months.round());
    } else if (years < 2) {
      result = messages.years(years.round());
    } else {
      result = messages.years(years.round());
    }

    return [prefix, result, suffix]
        .where((str) => str.isNotEmpty)
        .join(messages.wordSeparator());
  }
}
