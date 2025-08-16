import '../index.dart';

class Regex {
  Regex._();

  static RegExp email = RegExp(
    r"^((([a-z]|\d|[!#$%&'*+\-/=?^_`{|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#$%&'*+\-/=?^_`{|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)(((([\x20\x09])*(\x0d\x0a))?([\x20\x09])+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*((([\x20\x09])*(\x0d\x0a))?([\x20\x09])+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
  );

  static RegExp phone = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

  static RegExp password = RegExp(
    r'^(?=.*([A-Z]){1,})(?=.*[!@#$&*]{1,})(?=.*[0-9]{1,})(?=.*[a-z]{1,}).{8,100}$',
  );

  static RegExp ipv4Maybe = RegExp(
    r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$',
  );
  static RegExp ipv6 = RegExp(
    r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$',
  );

  /// MAC Address RegExp
  ///
  /// Example: 00:0a:95:9d:68:16
  static RegExp macAddress = RegExp(
    r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$',
  );

  /// Escaped character RegExp
  ///
  /// Example: \t, \n, \r, \v, \f
  static RegExp escapedChar = RegExp(r'[\t\n\r\v\f]');

  static RegExp whiteSpaces = RegExp(r'\s+');

  static RegExp alpha = RegExp(r'^[a-zA-Z]+$');
  static RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  static RegExp hexadecimal = RegExp(r'^[0-9a-fA-F]+$');
  static RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  static RegExp base64 = RegExp(
    r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$',
  );

  static RegExp creditCard = RegExp(
    r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$',
  );

  static RegExp isbn10Maybe = RegExp(r'^(?:[0-9]{9}X|[0-9]{10})$');
  static RegExp isbn13Maybe = RegExp(r'^[0-9]{13}$');

  /// SHA1 regex
  ///
  /// Example: 2fd4e1c67a2d28fced849ee1bb76e7391b93eb12
  static RegExp sha1 = RegExp(
    r'^(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})$',
  );

  /// SHA256 regex
  ///
  /// Example: 2fd4e1c67a2d28fced849ee1bb76e7391b93eb12
  static RegExp sha256 = RegExp(
    r'^([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}$',
  );

  static Map<String, RegExp> uuid = {
    '3': RegExp(
      r'^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$',
    ),
    '4': RegExp(
      r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$',
    ),
    '5': RegExp(
      r'^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$',
    ),
    'all': RegExp(
      r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$',
    ),
  };

  static RegExp guid = RegExp(
    r'^(\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}{0,1})$',
  );

  static RegExp multibyte = RegExp(r'[^\x00-\x7F]');
  static RegExp ascii = RegExp(r'^[\x00-\x7F]+$');

  static RegExp imageUrl = RegExp(
    r'(http(s?):)([/|.\w\s-])*\.(?:jpg|gif|png|jpeg|bmp|webp)',
  );

  /// Image RegExp
  ///
  /// Example: test.jpg
  static RegExp image = RegExp(
    r'.(jpg|gif|png|jpeg|bmp|webp)$',
    caseSensitive: false,
  );
  static RegExp mimeTypeImage = RegExp(r'^image\/.*$');

  static RegExp svg = RegExp(r'.svg$');
  static RegExp mimeTypeSvg = RegExp(r'^image\/svg\+xml$');

  static RegExp audio = RegExp(r'.(mp3|wav|wma|amr|ogg|wav|flac|aac)$');
  static RegExp mimeTypeAudio = RegExp(r'^audio\/.*$');

  static RegExp video = RegExp(
    r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp|mkv|flv|mov|webm)$',
  );
  static RegExp mimeTypeVideo = RegExp(r'^video\/.*$');

  static RegExp txt = RegExp(r'.(txt|rtf)$');
  static RegExp mimeTypeTxt = RegExp(r'^(application\/rtf|text\/plain)$');

  static RegExp doc = RegExp(r'.(doc|docx)$');
  static RegExp mimeTypeDoc = RegExp(
    r'^application\/(msword|application/vnd.openxmlformats-officedocument.wordprocessingml.document)$',
  );

  static RegExp csv = RegExp(r'.csv$');
  static RegExp mimeTypeCsv = RegExp(r'^text\/(csv|comma-separated-values)$');

  static RegExp excel = RegExp(r'.(xls|xlsx)$');
  static RegExp mimeTypeExcel = RegExp(
    r'^application\/(vnd.ms-excel|vnd.openxmlformats-officedocument.spreadsheetml.sheet)$',
  );

  static RegExp ppt = RegExp(r'.(ppt|pptx)$');
  static RegExp mimeTypePpt = RegExp(
    r'^application\/(vnd.ms-powerpoint|vnd.openxmlformats-officedocument.presentationml.presentation)$',
  );

  static RegExp pdf = RegExp(r'.pdf$');
  static RegExp mimeTypePdf = RegExp(r'^application\/pdf$');

  static RegExp json = RegExp(r'.json$');
  static RegExp mimeTypeJson = RegExp(r'^application\/json$');

  static RegExp archive = RegExp(r'.(zip|rar|7z|tar|gz)$');
  static RegExp mimeTypeArchive = RegExp(
    r'^application\/(zip|x-tar|x-gzip|x-bzip2)$',
  );

  static RegExp xml = RegExp(r'.xml$');
  static RegExp mimeTypeXml = RegExp(r'^(application\/xml|text\/xml)$');

  static RegExp date = RegExp(
    r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$',
  );

  static Map<String, String> dateFormats = {
    r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}':
        'yyyy-MM-dd HH:mm:ss', // Example: 2022-01-14 12:34:56
    r'\w{3}, \w{3} \d{1,2}, \d{2}':
        "EEE, MMM d, 'yy", // Example: Fri, Jan 14, '22
    r'\w+ \d{1,2}, \d{4}': 'MMMM dd, yyyy', // Example: January 14, 2022
    r'\d{2}/\d{2}/\d{4}': 'MM/dd/yyyy', // Example: 01/14/2022
    r'\d{2}-\d{2}-\d{4}': 'dd-MM-yyyy', // Example: 14-01-2022
    r'\d{2}:\d{2} [APap][Mm]': 'hh:mm a', // Example: 12:34 PM
    r'\w+ \d{4}': 'MMMM yyyy', // Example: January 2022
    r'\w{3}, \d{1,2} \w{3} \d{4}':
        'EEE, dd MMM yyyy HH:mm:ss', // Example: Fri, 14 Jan 2022 12:34:56
    r'\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2}':
        'dd/MM/yyyy HH:mm:ss', // Example: 14/01/2022 12:34:56
    r'\d{4}-\d{2}-\d{2}': 'yyyy-MM-dd', // Example: 2022-01-14 (Date only)
    r'\d{1,2} \w{3} \d{4}': 'd MMM yyyy', // Example: 22 Sep 2023
    r'\w{3}, \d{1,2} \w{3} \d{2}': "EEE, d MMM 'yy", // Example: Fri, 22 Sep '23
    r'\d{2}:\d{2}': 'HH:mm', // Example: 12:34 (Time only)
    r'\d{1,2}/\d{1,2}/\d{2}': 'M/d/yy', // Example: 9/22/23
    r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}':
        'yyyy-MM-ddTHH:mm:ss', // Example: 2022-01-14T12:34:56
    r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z':
        'yyyy-MM-ddTHH:mm:ssZ', // Example: 2022-01-14T12:34:56Z
    r'^\d{4}-\d{2}-\d{2}$': 'yyyy-MM-dd', // Example: 2022-01-14
    r'^\d{2}/\d{2}/\d{4}$': 'MM/dd/yyyy', // Example: 01/14/2022
    r'^\d{2}\.\d{2}\.\d{4}$': 'MM.dd.yyyy', // Example: 01.14.2022
    r'^\d{2}\s\d{2}\s\d{4}$': 'MM dd yyyy', // Example: 01 14 2022
    r'^\d{4}/\d{2}/\d{2}$': 'yyyy/MM/dd', // Example: 2022/01/14
    r'^\d{4}\.\d{2}\.\d{2}$': 'yyyy.MM.dd', // Example: 2022.01.14
    r'^\d{4}\s\d{2}\s\d{2}$': 'yyyy MM dd', // Example: 2022 01 14
    r'^\d{2}-\d{2}-\d{4}$': 'dd-MM-yyyy', // Example: 14-01-2022
    r'^\d{2}/\d{2}/\d{2}$': 'dd/MM/yy', // Example: 14/01/22
    r'^\d{2}\.\d{2}\.\d{2}$': 'dd.MM.yy', // Example: 14.01.22
    r'^\d{2}\s\d{2}\s\d{2}$': 'dd MM yy', // Example: 14 01 22
    r'^\d{4}-\d{1,2}-\d{1,2}$': 'yyyy-M-d', // Example: 2022-1-14
    r'^\d{2}/\d{1,2}/\d{1,2}$': 'MM/d/yy', // Example: 01/1/22
    r'^\d{2}\.\d{1,2}\.\d{1,2}$': 'MM.d.yy', // Example: 01.1.22
    r'^\d{2}\s\d{1,2}\s\d{1,2}$': 'MM d yy', // Example: 01 1 22
    r'^\d{1,2}-\d{1,2}-\d{4}$': 'd-M-yyyy', // Example: 14-1-2022
    r'^\d{1,2}/\d{1,2}/\d{4}$': 'd/M/yyyy', // Example: 14/1/2022
    r'^\d{1,2}\.\d{1,2}\.\d{4}$': 'd.M.yyyy', // Example: 14.1.2022
    r'^\d{1,2}\s\d{1,2}\s\d{4}$': 'd M yyyy', // Example: 14 1 2022
    r'^\d{1,2} \w+ \d{4}$': 'd MMMM yyyy', // Example: 29 April 1999
    r'^\d{1,2} \w{3} \d{4}$': 'dd MMM yyyy', // Example: 29 Apr 1999
    r'^\d{8}$': 'yyyyMMdd', // Example: 20220114
    r'^\d{6}$': 'yyMMdd', // Example: 220114
  };
}

abstract class RegexMatcher {
  const RegexMatcher._();

  /// Matches the input with the given pattern
  static bool match(
    String? input, {
    RegExp? regex,
    String? pattern,
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) {
    if (input.isBlank || (regex == null && pattern == null)) return false;

    return (regex ??
            RegExp(
              pattern ?? '',
              multiLine: multiLine,
              caseSensitive: caseSensitive,
              unicode: unicode,
              dotAll: dotAll,
            ))
        .hasMatch(input!);
  }

  /// matches the input with the given patterns
  static bool matchMultiple(String? input, List<RegExp> patterns) {
    if (input.isBlank) return false;

    for (final pattern in patterns) {
      if (pattern.hasMatch(input!)) return true;
    }
    return false;
  }

  /// Matches the input with the given pattern for the given file type
  static bool matchFile(String input, RegexFileType type) {
    return switch (type) {
      RegexFileType.image => matchMultiple(input, [
        Regex.image,
        Regex.mimeTypeImage,
      ]),
      RegexFileType.svg => matchMultiple(input, [Regex.svg, Regex.mimeTypeSvg]),
      RegexFileType.audio => matchMultiple(input, [
        Regex.audio,
        Regex.mimeTypeAudio,
      ]),
      RegexFileType.video => matchMultiple(input, [
        Regex.video,
        Regex.mimeTypeVideo,
      ]),
      RegexFileType.txt => matchMultiple(input, [Regex.txt, Regex.mimeTypeTxt]),
      RegexFileType.doc => matchMultiple(input, [Regex.doc, Regex.mimeTypeDoc]),
      RegexFileType.csv => matchMultiple(input, [Regex.csv, Regex.mimeTypeCsv]),
      RegexFileType.excel => matchMultiple(input, [
        Regex.excel,
        Regex.mimeTypeExcel,
      ]),
      RegexFileType.ppt => matchMultiple(input, [Regex.ppt, Regex.mimeTypePpt]),
      RegexFileType.pdf => matchMultiple(input, [Regex.pdf, Regex.mimeTypePdf]),
      RegexFileType.json => matchMultiple(input, [
        Regex.json,
        Regex.mimeTypeJson,
      ]),
      RegexFileType.archive => matchMultiple(input, [
        Regex.archive,
        Regex.mimeTypeArchive,
      ]),
      RegexFileType.xml => matchMultiple(input, [Regex.xml, Regex.mimeTypeXml]),
    };
  }
}

enum RegexFileType {
  image,
  svg,
  audio,
  video,
  txt,
  doc,
  csv,
  excel,
  ppt,
  pdf,
  json,
  archive,
  xml,
}
