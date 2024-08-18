part of 'extensions.dart';

extension CurrencyStringX on String? {
  String toPrice({bool withSymbol = false, String unit = r'$', int dp = 2}) =>
      CurrencyExt.toPrice(this, withSymbol: withSymbol, dp: dp);

  String toCost({bool withSymbol = false, String unit = r'$'}) =>
      CurrencyExt.toCost(this, withSymbol: withSymbol);

  String toPercentage({bool withSymbol = true, int dp = 0}) =>
      CurrencyExt.toPercentage(this, withSymbol: withSymbol, dp: dp);
}

extension CurrencyNumX on num? {
  String toPrice({bool withSymbol = false, String unit = r'$', int dp = 2}) =>
      CurrencyExt.toPrice(this, withSymbol: withSymbol, dp: dp);

  String toCost({bool withSymbol = false, String unit = r'$'}) =>
      CurrencyExt.toCost(this, withSymbol: withSymbol);

  String toPercentage({bool withSymbol = true, int dp = 0}) =>
      CurrencyExt.toPercentage(this, withSymbol: withSymbol, dp: dp);
}

class CurrencyExt {
  CurrencyExt._();

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

  static String toCost(
    Object? value, {
    bool withSymbol = false,
    String unit = r'$',
  }) {
    if (value.toString().isNum) {
      return '${withSymbol ? '$unit ' : ''}${value.toString().toDouble().toStringAsFixed(4)}';
    } else {
      return '${withSymbol ? '$unit ' : ''}0.0000';
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
