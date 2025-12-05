import 'package:flutter/material.dart';

class NumEditController<T extends num> extends TextEditingController {
  NumEditController({T? value, this.dp = 4}) {
    if (value != null) setValue(value);
  }

  NumEditController.int({T? value}) : dp = 0 {
    if (value != null) setValue(value);
  }

  /// The actual numeric value
  T? _value, previous;

  /// Number of decimal places to format when displaying
  final int dp;

  /// Get the original number
  T? get number => _value;

  /// Set a new number and update the text accordingly
  void setValue(T? newValue) {
    if (newValue == value) return;
    previous = _value;
    _value = newValue;

    if (newValue == null) {
      text = '';
    } else {
      text = _formatNumber(newValue);
    }
  }

  /// Internal helper to format number
  String _formatNumber(T value) {
    return value.toStringAsFixed(dp);
  }

  /// When user types manually, parse the value
  @override
  set text(String newText) {
    super.text = newText;
    _parseAndStore(newText);
  }

  /// Sets the underlying number value
  set number(T? number) {
    _value = number;
    final text = number == null ? '' : _formatNumber(number);
    super.value = value.copyWith(
      text: text,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  @override
  set value(TextEditingValue newValue) {
    assert(
      !newValue.composing.isValid || newValue.isComposingRangeValid,
      'New TextEditingValue $newValue has an invalid non-empty composing range '
      '${newValue.composing}. It is recommended to use a valid composing range, '
      'even for readonly text fields.',
    );
    _parseAndStore(newValue.text);
    super.value = newValue;
  }

  void _parseAndStore(String inputText) {
    final parsed = num.tryParse(inputText);
    _value = parsed as T?;
  }

  /// Select all the [text]
  void selectAll() {
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}
