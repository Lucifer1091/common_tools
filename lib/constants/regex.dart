part of 'constants.dart';

class Regex {
  Regex._();

  static RegExp email = RegExp(
      r"^((([a-z]|\d|[!#$%&'*+\-/=?^_`{|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#$%&'*+\-/=?^_`{|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)(((([\x20\x09])*(\x0d\x0a))?([\x20\x09])+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*((([\x20\x09])*(\x0d\x0a))?([\x20\x09])+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  static RegExp ipv4Maybe =
      RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');
  static RegExp ipv6 =
      RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');

  static RegExp date = RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');

  /// A regular expression that matches surrogate pairs in a string.
  ///
  /// Surrogate pairs are used in UTF-16 encoding to represent characters outside
  /// the Basic Multilingual Plane (BMP), which includes characters with code points
  /// from U+10000 to U+10FFFF. A surrogate pair consists of a high surrogate
  /// (U+D800 to U+DBFF) followed by a low surrogate (U+DC00 to U+DFFF).
  static RegExp surrogatePairsRegExp =
      RegExp(r'[\uD800-\uDBFF][\uDC00-\uDFFF]');

  static RegExp alpha = RegExp(r'^[a-zA-Z]+$');
  static RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  static RegExp hexadecimal = RegExp(r'^[0-9a-fA-F]+$');
  static RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  static RegExp base64 = RegExp(
      r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$');

  static RegExp creditCard = RegExp(
      r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$');

  static RegExp isbn10Maybe = RegExp(r'^(?:[0-9]{9}X|[0-9]{10})$');
  static RegExp isbn13Maybe = RegExp(r'^[0-9]{13}$');

  static Map<String, RegExp> uuid = {
    '3': RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$'),
    '4': RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
    '5': RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
    'all': RegExp(
        r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$')
  };

  /// A regular expression that matches full-width characters.
  ///
  /// This matches any character that is not:
  /// - ASCII characters (U+0020 to U+007E)
  /// - Half-width katakana (U+FF61 to U+FF9F)
  /// - Half-width Hangul (U+FFA0 to U+FFDC)
  /// - Half-width symbols (U+FFE8 to U+FFEE)
  /// - Digits (0-9)
  /// - Lowercase letters (a-z)
  /// - Uppercase letters (A-Z)
  static RegExp fullWidth = RegExp(
      r'[^\u0020-\u007E\uFF61-\uFF9F\uFFA0-\uFFDC\uFFE8-\uFFEE0-9a-zA-Z]');

  /// A regular expression that matches half-width characters.
  ///
  /// This includes:
  /// - ASCII characters (U+0020 to U+007E)
  /// - Half-width katakana (U+FF61 to U+FF9F)
  /// - Half-width Hangul (U+FFA0 to U+FFDC)
  /// - Half-width symbols (U+FFE8 to U+FFEE)
  /// - Digits (0-9)
  /// - Lowercase letters (a-z)
  /// - Uppercase letters (A-Z)
  static RegExp halfWidth = RegExp(
      r'[\u0020-\u007E\uFF61-\uFF9F\uFFA0-\uFFDC\uFFE8-\uFFEE0-9a-zA-Z]');

  static RegExp multibyte = RegExp(r'[^\x00-\x7F]');
  static RegExp ascii = RegExp(r'^[\x00-\x7F]+$');

  static RegExp image =
      RegExp(r'(http(s?):)([/|.\w\s-])*\.(?:jpg|gif|png|jpeg|bmp)');

  static RegExp audio = RegExp(r'.(mp3|wav|wma|amr|ogg)$');
  static RegExp video = RegExp(r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp|mkv)$');
  static RegExp txt = RegExp(r'.txt$');
  static RegExp doc = RegExp(r'.(doc|docx)$');
  static RegExp excel = RegExp(r'.(xls|xlsx)$');
  static RegExp ppt = RegExp(r'.(ppt|pptx)$');
  static RegExp apk = RegExp(r'.apk$');
  static RegExp pdf = RegExp(r'.pdf$');
  static RegExp html = RegExp(r'.html$');
}
