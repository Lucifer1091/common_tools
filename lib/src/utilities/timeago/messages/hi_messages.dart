import 'lookupmessages.dart';

/// Hindi Messages
class HiMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'पूर्व';
  @override
  String suffixFromNow() => 'अब से';
  @override
  String lessThanOneMinute(int seconds) => 'एक क्षण पहले';

  @override
  String minutes(int minutes) => '$minutes मिनट';

  @override
  String hours(int hours) => '$hours घंटे';

  @override
  String days(int days) => '$days दिन';

  @override
  String months(int months) => '$months महीने';

  @override
  String years(int years) => '$years वर्षों पहले';

  @override
  String wordSeparator() => ' ';
}

/// Hindi short Messages
class HiShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'अभी अभी';

  @override
  String minutes(int minutes) => '$minutes मि';

  @override
  String hours(int hours) => '$hours घं';

  @override
  String days(int days) => '$days दि';

  @override
  String months(int months) => '$months म';

  @override
  String years(int years) => '$years सा';

  @override
  String wordSeparator() => ' ';
}
