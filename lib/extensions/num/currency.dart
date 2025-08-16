import '../../index.dart';

extension CurrencyStringX on String? {
  String toPrice({bool withSymbol = false, String unit = r'$', int dp = 2}) =>
      _CurrencyExt.toPrice(this, withSymbol: withSymbol, dp: dp);

  String toPercentage({bool withSymbol = true, int dp = 0}) =>
      _CurrencyExt.toPercentage(this, withSymbol: withSymbol, dp: dp);
}

extension CurrencyNumX on num? {
  String toPrice({bool withSymbol = false, String unit = r'$', int dp = 2}) =>
      _CurrencyExt.toPrice(this, withSymbol: withSymbol, dp: dp);

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
