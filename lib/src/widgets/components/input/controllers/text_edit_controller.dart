import 'package:flutter/widgets.dart';

/// An extension of [TextEditingController] that stores the previous value.
class TextEditController extends TextEditingController {
  TextEditController({super.text});

  TextEditController.fromValue(TextEditingValue super.value)
    : super.fromValue();

  TextEditingValue? previous;

  @override
  set value(TextEditingValue newValue) {
    if (newValue == value) return;
    previous = value;
    super.value = newValue;
  }

  bool get isEmpty => text.isEmpty;

  bool get isNotEmpty => text.isNotEmpty;

  int get length => text.length;

  void append(String input) => text = '$text$input';

  void appendNewLine(String input) => text = '$text\n$input';

  /// Select all the [text]
  void selectAll() {
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}
