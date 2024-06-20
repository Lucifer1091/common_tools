part of 'constants.dart';

typedef Formatters = List<TextInputFormatter>;

// Remember Input Formatters can be chained so their order matters
// means output of 1st formatter is used in 2nd formatter.
class InputFormat {
  InputFormat._();

  static Formatters number({int max = 8}) => <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters decimal({int max = 15}) => <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters decimalWithDp({int max = 15, int dp = 2}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        // FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
        FilteringTextInputFormatter.allow(
          RegExp(r'(^\d*\.?\d{0,' '$dp' '}'),
        ),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters signNumber({int max = 15, int dp = 2}) =>
      <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        // FilteringTextInputFormatter.allow(RegExp(r'^[-,+]?\d*\.?\d{0,2}'))
        FilteringTextInputFormatter.allow(
          RegExp(r'^[-,+]?\d*\.?\d{0,' '$dp' '}'),
        ),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters alphabets({int max = 30}) => <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters alphaNumeric({int max = 30}) => <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters phoneNo({int max = 10}) => <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\+?\d*')),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters email({int max = 100}) => <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static Formatters numeral({int max = 15}) => <TextInputFormatter>[
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(RegExp("[0-9-+/*]")),
        LengthLimitingTextInputFormatter(
          max,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ];

  static final denySpace = <TextInputFormatter>[
    FilteringTextInputFormatter.deny(RegExp(r'\s')),
  ];

  static final denyStartSpace = <TextInputFormatter>[NoLeadingSpaceFormatter()];
}

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
        selection: TextSelection(
          baseOffset: trimmedText.length,
          extentOffset: trimmedText.length,
        ),
      );
    }

    return newValue;
  }
}

class IpAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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
        selection: TextSelection.collapsed(offset: string.length));
  }
}
