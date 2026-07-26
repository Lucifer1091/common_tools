import 'package:flutter/material.dart';

class MyRadius {
  MyRadius._();

  static const double small = 3;
  static const double medium = 6;
  static const double large = 9;
  static const double extraLarge = 12;
  static const double round = 9999;
}

class MyRadi {
  MyRadi._();

  static const small = Radius.circular(MyRadius.small);
  static const medium = Radius.circular(MyRadius.medium);
  static const large = Radius.circular(MyRadius.large);
  static const extraLarge = Radius.circular(MyRadius.extraLarge);
  static const round = Radius.circular(MyRadius.round);
}

class MyBorderRadius {
  const MyBorderRadius._();

  static const small = BorderRadius.all(MyRadi.small);
  static const medium = BorderRadius.all(MyRadi.medium);
  static const large = BorderRadius.all(MyRadi.large);
  static const extraLarge = BorderRadius.all(MyRadi.extraLarge);
  static const round = BorderRadius.all(MyRadi.round);
}
