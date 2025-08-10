import 'package:flutter/widgets.dart';

class TDRadius {
  TDRadius._();

  static const double small = 3;

  static const double medium = 6;

  static const double large = 9;

  static const double extraLarge = 12;

  static const double round = 9999;
}

class TDBorderRadius {
  TDBorderRadius._();

  static BorderRadius small = BorderRadius.circular(TDRadius.small);

  static BorderRadius medium = BorderRadius.circular(TDRadius.medium);

  static BorderRadius large = BorderRadius.circular(TDRadius.large);

  static BorderRadius extraLarge = BorderRadius.circular(TDRadius.extraLarge);

  static BorderRadius round = BorderRadius.circular(TDRadius.round);
}
