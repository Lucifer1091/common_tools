import 'package:flutter/material.dart';

class MyBoxShadows {
  const MyBoxShadows._();

  static const sm = [
    BoxShadow(color: Color(0x0d000000), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const regular = [
    BoxShadow(color: Color(0x1a000000), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];

  static const md = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  static const lg = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
  ];

  static const lg2 = [
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

  static const xl = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
    ),
  ];

  static const xl2 = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ];

  static const inner = [
    BoxShadow(
      color: Color(0x0d000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
  ];
}
