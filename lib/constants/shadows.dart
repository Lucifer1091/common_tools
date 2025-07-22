import 'package:flutter/material.dart';

class BoxShadows {
  const BoxShadows._();

  static List<BoxShadow>? get all => const [
    BoxShadow(
      color: Color(0x0d000000),
      blurRadius: 8,
      spreadRadius: 2,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0f000000),
      blurRadius: 10,
      spreadRadius: 1,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x1a000000),
      blurRadius: 5,
      spreadRadius: -3,
      offset: Offset(0, 5),
    ),
  ];

  static List<BoxShadow>? get base => const [
    BoxShadow(
      color: Color(0xff0D0000),
      blurRadius: 10,
      spreadRadius: 1,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0xff140000),
      blurRadius: 5,
      spreadRadius: 1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0xff1f0000),
      blurRadius: 4,
      spreadRadius: -1,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow>? get middle => const [
    BoxShadow(
      color: Color(0xff0d0000),
      blurRadius: 14,
      spreadRadius: 2,
      offset: Offset(0, 3),
    ),
    BoxShadow(
      color: Color(0xff0f0000),
      blurRadius: 10,
      spreadRadius: 1,
      offset: Offset(0, 8),
    ),
    BoxShadow(color: Color(0xff1a0000), blurRadius: 5, spreadRadius: -3),
  ];

  static List<BoxShadow>? get top => const [
    BoxShadow(
      color: Color(0xff0d0000),
      blurRadius: 30,
      spreadRadius: 5,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0xff0a0000),
      blurRadius: 24,
      spreadRadius: 2,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: Color(0xff140000),
      blurRadius: 10,
      spreadRadius: -5,
      offset: Offset(0, 8),
    ),
  ];
}
