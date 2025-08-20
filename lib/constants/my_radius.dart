import 'package:flutter/material.dart';

class MyRadius {
  MyRadius._();

  static const double small = 3;

  static const double medium = 6;

  static const double large = 9;

  static const double extraLarge = 12;

  static const double round = 9999;
}

class MyBorderRadius {
  MyBorderRadius._();

  static BorderRadius small = BorderRadius.circular(MyRadius.small);

  static BorderRadius medium = BorderRadius.circular(MyRadius.medium);

  static BorderRadius large = BorderRadius.circular(MyRadius.large);

  static BorderRadius extraLarge = BorderRadius.circular(MyRadius.extraLarge);

  static BorderRadius round = BorderRadius.circular(MyRadius.round);
}
