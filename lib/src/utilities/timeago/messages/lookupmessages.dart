/// [LookupMessages] template for any language
abstract class LookupMessages {
  /// Example: `prefixAgo()` 1 min `suffixAgo()`
  String prefixAgo();

  /// Example: `prefixFromNow()` 1 min `suffixFromNow()`
  String prefixFromNow();

  /// Example: `prefixAgo()` 1 min `suffixAgo()`
  String suffixAgo();

  /// Example: `prefixFromNow()` 1 min `suffixFromNow()`
  String suffixFromNow();

  /// Format when time is less than a minute
  String lessThanOneMinute(int seconds);

  /// Format when time is in minutes
  String minutes(int minutes);

  /// Format when time is in hours
  String hours(int hours);

  /// Format when time is in days
  String days(int days);

  /// Format when time is in months
  String months(int months);

  /// Format when time is in years
  String years(int years);

  /// word separator when words are concatenated
  String wordSeparator() => ' ';
}
