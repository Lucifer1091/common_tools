import 'lookupmessages.dart';

/// Tamil messages
class TaMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'முன்னர்';
  @override
  String suffixFromNow() => 'கழித்து';
  @override
  String lessThanOneMinute(int seconds) => 'சில நொடிகள்';

  @override
  String minutes(int minutes) => '$minutes நிமிடங்கள்';

  @override
  String hours(int hours) => '$hours மணி நேரங்கள்';

  @override
  String days(int days) => '$days நாட்கள்';

  @override
  String months(int months) => '$months மாதங்கள்';

  @override
  String years(int years) => '$years ஆண்டுகள்';

  @override
  String wordSeparator() => ' ';
}

/// Tamil short Messages
class TaShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'இப்போது';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return '1 நிமிடம்';
    } else if (minutes > 1 && minutes < 11) {
      return '~$minutes நிமிடங்கள்';
    } else {
      return '$minutes நிமிடங்கள்';
    }
  }

  @override
  String hours(int hours) {
    if (hours == 1) {
      return '1 மணி';
    } else if (hours > 1 && hours < 11) {
      return '~$hours மணி';
    } else {
      return '$hours மணி';
    }
  }

  @override
  String days(int days) {
    if (days == 1) {
      return '1 நாள்';
    } else if (days > 1 && days < 11) {
      return '~$days நாட்கள்';
    } else {
      return '$days நாட்கள்';
    }
  }

  @override
  String months(int months) {
    if (months == 1) {
      return '1 மாதம்';
    } else if (months > 1 && months < 11) {
      return '~$months மாதங்கள்';
    } else {
      return '$months மாதங்கள்';
    }
  }

  @override
  String years(int years) {
    if (years == 1) {
      return '1 ஆண்டு';
    } else if (years > 1 && years < 11) {
      return '~$years ஆண்டுகள்';
    } else {
      return '$years ஆண்டுகள்';
    }
  }

  @override
  String wordSeparator() => ' ';
}
