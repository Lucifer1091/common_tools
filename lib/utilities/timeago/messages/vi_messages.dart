import 'lookupmessages.dart';

/// Vietnamese messages
class ViMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'trước';
  @override
  String suffixFromNow() => 'nữa';
  @override
  String lessThanOneMinute(int seconds) => 'một tháng';

  @override
  String minutes(int minutes) => '$minutes phút';

  @override
  String hours(int hours) => '$hours tiếng';

  @override
  String days(int days) => '$days ngày';

  @override
  String months(int months) => '$months tháng';

  @override
  String years(int years) => '$years năm';

  @override
  String wordSeparator() => ' ';
}

/// Vietnamese short messages
class ViShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'bây giờ';

  @override
  String minutes(int minutes) => '$minutes ph';

  @override
  String hours(int hours) => '$hours h';

  @override
  String days(int days) => '$days ngày';

  @override
  String months(int months) => '$months tháng';

  @override
  String years(int years) => '$years năm';

  @override
  String wordSeparator() => ' ';
}
