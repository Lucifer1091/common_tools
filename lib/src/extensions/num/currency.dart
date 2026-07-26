import '../string/converters.dart';
import '../string/validators.dart';

/// Currency/percentage formatting helpers for nullable numeric strings.
extension CurrencyStringX on String? {
  /// Formats this numeric string as a fixed-decimal price.
  ///
  /// Non-numeric input falls back to zero formatting.
  ///
  /// Example:
  /// ```dart
  /// '12.5'.toPrice(withSymbol: true); // $ 12.50
  /// 'x'.toPrice(withSymbol: true); // $ 0.00
  /// ```
  String toPrice({bool withSymbol = false, String unit = r'$', int dp = 2}) =>
      _CurrencyExt.toPrice(this, withSymbol: withSymbol, unit: unit, dp: dp);

  /// Formats this numeric string as a percentage.
  ///
  /// Non-numeric input falls back to zero formatting.
  String toPercentage({bool withSymbol = true, int dp = 0}) =>
      _CurrencyExt.toPercentage(this, withSymbol: withSymbol, dp: dp);
}

/// Currency/percentage formatting helpers for nullable numeric values.
extension CurrencyNumX on num? {
  /// Formats this value as a fixed-decimal price.
  ///
  /// `null` falls back to zero formatting.
  String toPrice({bool withSymbol = false, String unit = r'$', int dp = 2}) =>
      _CurrencyExt.toPrice(this, withSymbol: withSymbol, unit: unit, dp: dp);

  /// Formats this value as a percentage.
  ///
  /// `null` falls back to zero formatting.
  String toPercentage({bool withSymbol = true, int dp = 0}) =>
      _CurrencyExt.toPercentage(this, withSymbol: withSymbol, dp: dp);
}

class _CurrencyExt {
  _CurrencyExt._();

  static String toPrice(
    Object? value, {
    bool withSymbol = false,
    String unit = r'$',
    int dp = 2,
  }) {
    if (value.toString().isNum) {
      return '${withSymbol ? '$unit ' : ''}${value.toString().toDouble().toStringAsFixed(dp)}';
    } else {
      return '${withSymbol ? '$unit ' : ''}0${dp == 0 ? '' : '.'}${'0' * dp}';
    }
  }

  static String toPercentage(
    Object? value, {
    bool withSymbol = true,
    int dp = 0,
  }) {
    if (value.toString().isNum) {
      return '${value.toString().toDouble().toStringAsFixed(dp)}${withSymbol ? ' %' : ''}';
    } else {
      return '0${dp == 0 ? '' : '.'}${'0' * dp}${withSymbol ? ' %' : ''}';
    }
  }
}
