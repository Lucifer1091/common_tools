part of 'constants.dart';

typedef Formatters = List<TextInputFormatter>;

/// A utility class for creating various input formatters for text fields.
///
/// The `InputFormat` class provides static methods to create formatters
/// that restrict input to specific formats such as numbers, decimals,
/// alphabets, etc. Each method returns a list of [TextInputFormatter]
/// which can be applied to text fields.
///
/// Example usage:
/// ```dart
/// // Apply number formatter with a maximum length of 8 characters
/// inputFormatters: InputFormat.number(max: 8);
///
/// // Apply email formatter with a maximum length of 100 characters
/// inputFormatters: InputFormat.email(max: 100);
/// ```
/// Remember Input Formatters can be chained so their order matters
/// means output of 1st formatter is used in 2nd formatter.
class InputFormat {
  InputFormat._();

  static final percentage = <TextInputFormatter>[
    // Replace comma with a period to ensure decimal consistency
    FilteringTextInputFormatter.deny(',', replacementString: '.'),

    // Allow numbers between 0 and 100 with up to two decimal places
    TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;

      // Allow empty input
      if (text.isEmpty) return newValue;

      // Validate numbers between 0 and 100 with up to two decimal places
      final regex = RegExp(r'^100$|^100\.0{0,2}$|^\d{1,2}(\.\d{0,2})?$');

      if (regex.hasMatch(text)) return newValue;

      // If invalid, return the old value
      return oldValue;
    }),
  ];

  /// Returns a list of [TextInputFormatter] that allows only numeric input.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.number(max: 8);
  /// ```
  static List<TextInputFormatter> number({int max = 8}) => <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(
      max,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    ),
  ];

  /// Returns a list of [TextInputFormatter] that allows only decimal input.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.decimal(max: 15);
  /// ```
  static List<TextInputFormatter> decimal({int max = 15}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a list of [TextInputFormatter] that allows decimal input with specified decimal places.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  /// The [dp] parameter specifies the number of decimal places.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.decimalWithDp(max: 15, dp: 2);
  /// ```
  static List<TextInputFormatter> decimalWithDp({int max = 15, int dp = 2}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(
          RegExp(
            r'(^\d*\.?\d{0,'
            '$dp'
            '}\$)',
          ),
        ),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a list of [TextInputFormatter] that allows signed decimal input with specified decimal places.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  /// The [dp] parameter specifies the number of decimal places.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.signNumber(max: 15, dp: 2);
  /// ```
  static List<TextInputFormatter> signNumber({int max = 15, int dp = 2}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(
          RegExp(
            r'^[-+]?\d*\.?\d{0,'
            '$dp'
            '}\$)',
          ),
        ),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a list of [TextInputFormatter] that allows only alphabetic input.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.alphabets(max: 30);
  /// ```
  static List<TextInputFormatter> alphabets({int max = 30}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a list of [TextInputFormatter] that allows alphanumeric input.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.alphaNumeric(max: 30);
  /// ```
  static List<TextInputFormatter> alphaNumeric({int max = 30}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a list of [TextInputFormatter] that allows phone number input.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.phoneNo(max: 10);
  /// ```
  static List<TextInputFormatter> phoneNo({int max = 10}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\+?\d*')),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a list of [TextInputFormatter] that allows email input.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.email(max: 100);
  /// ```
  static List<TextInputFormatter> email({int max = 100}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a list of [TextInputFormatter] that allows numeral input with basic arithmetic operators.
  ///
  /// The [max] parameter specifies the maximum length of the input.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.numeral(max: 15);
  /// ```
  static List<TextInputFormatter> numeral({int max = 15}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(RegExp("[0-9-+/*]")),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  /// Returns a [TextInputFormatter] that denies spaces.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.denySpace;
  /// ```
  static final List<TextInputFormatter> denySpace = <TextInputFormatter>[
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
  ];

  /// Returns a [TextInputFormatter] that denies leading spaces.
  ///
  /// Example usage:
  /// ```dart
  /// inputFormatters: InputFormat.denyStartSpace;
  /// ```
  static final List<TextInputFormatter> denyStartSpace = <TextInputFormatter>[
    NoLeadingSpaceFormatter(),
  ];
}

/// A text input formatter that removes leading spaces from input text.
///
/// This formatter ensures that any input text does not begin with a space
/// character by trimming leading spaces when detected.
///
/// Example usage:
/// ```dart
/// TextField(
///   inputFormatters: [
///     NoLeadingSpaceFormatter(),
///   ],
/// )
/// ```
class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimmedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimmedText,
        selection: newValue.selection.copyWith(
          baseOffset: math.min(
            trimmedText.length,
            newValue.selection.baseOffset,
          ),
          extentOffset: math.min(
            trimmedText.length,
            newValue.selection.extentOffset,
          ),
        ),
      );
    }

    return newValue;
  }
}

/// A text input formatter that does not allow spaces.
///
/// This formatter ensures that any input text does not contain a space
/// character by trimming trailing spaces when detected.
///
/// Example usage:
/// ```dart
/// TextField(
///   inputFormatters: [
///     NoSpaceFormatter(),
///   ],
/// )
/// ```
class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains(' ')) {
      final String trimedText = newValue.text.trimRight();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

/// A text input formatter for formatting IP address input.
///
/// This formatter ensures that the input text adheres to the format of an IPv4 address,
/// allowing only valid characters and ensuring correct placement of dots ('.') to separate
/// IP address octets. It also limits each octet to values between 0 and 255.
///
/// Example usage:
/// ```dart
/// TextField(
///   inputFormatters: [
///     IpAddressInputFormatter(),
///   ],
///   keyboardType: TextInputType.number,
///   decoration: InputDecoration(
///     labelText: 'Enter IP Address',
///   ),
/// )
/// ```
class IpAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int dotCounter = 0;
    var buffer = StringBuffer();
    String ipField = "";

    for (int i = 0; i < text.length; i++) {
      if (dotCounter < 4) {
        if (text[i] != ".") {
          ipField += text[i];
          if (ipField.length < 3) {
            buffer.write(text[i]);
          } else if (ipField.length == 3) {
            if (int.parse(ipField) <= 255) {
              buffer.write(text[i]);
            } else {
              if (dotCounter < 3) {
                buffer.write(".");
                dotCounter++;
                buffer.write(text[i]);
                ipField = text[i];
              }
            }
          } else if (ipField.length == 4) {
            if (dotCounter < 3) {
              buffer.write(".");
              dotCounter++;
              buffer.write(text[i]);
              ipField = text[i];
            }
          }
        } else {
          if (dotCounter < 3) {
            buffer.write(".");
            dotCounter++;
            ipField = "";
          }
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  const UpperCaseTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LowerCaseTextInputFormatter extends TextInputFormatter {
  const LowerCaseTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
