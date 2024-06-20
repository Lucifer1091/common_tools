part of 'extensions.dart';

extension StringConversions on String {
  int? toInt() => int.tryParse(this);
  double? toDouble() => double.tryParse(this);

  bool isNewLine() => '\n' == substring(length - 1);
  bool get isUrl => RegExp(r'https?://[a-zA-Z\d\-%_/=&?.]+').hasMatch(this);
  bool get isId => RegExp(r'[a-zA-Z\d\-%_/=&?.]+').hasMatch(this);

  String get capitalizeFirstLetter =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String get firstCharacterToLowerCase =>
      isNotEmpty ? '${this[0].toLowerCase()}${substring(1)}' : '';

  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalizeFirstLetter)
      .join(" ");

  String get toSnakeCase {
    return split('').mapWithIndex((index, character) {
      if (character == character.toUpperCase()) {
        return (index != 0 ? '_' : '') + character.toLowerCase();
      } else {
        return character;
      }
    }).join('');
  }

  String removeMaskFromPhoneNumber() {
    return length > 10
        ? substring(2, length).replaceAll(RegExp(r'\D'), '')
        : this;
  }

  String formatPhoneNumber({bool addCountryCode = false}) {
    return "${addCountryCode ? "+1" : ""} ${replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "(${m[1]}) ${m[2]}-${m[3]}")}";
  }

  /// Restrict the string to given length and add ... in the end
  String max({int maxLength = 10}) {
    return length > maxLength ? '${substring(0, maxLength)}...' : this;
  }

  bool toBool() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0"
            ? false
            : throwsUnsupportedError);
  }

  T stringToEnum<T>({required Iterable<T> values, T Function()? orElse}) {
    return values.firstWhere(
      (element) =>
          element != null &&
          toLowerCase() == (element as Enum).name.toLowerCase(),
      orElse: orElse,
    );
  }

  get throwsUnsupportedError => null;
}

extension StringConversionsX on String? {
  bool get isNum => double.tryParse(this ?? '') != null;
}
