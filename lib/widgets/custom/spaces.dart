import 'package:flutter/material.dart';

/// A wrapper around SizedBox for creating consistent gaps in the UI.
///
/// By using [Space] instead of [SizedBox], you reduce boilerplate code and ensure
/// consistency in spacing throughout your UI. This class provides a set of predefined
/// width and height gaps for easy use.
///
/// Examples:
/// Space.w4() = SizedBox(width: 4.0)
/// Space.h8() = SizedBox(height: 8.0)
class Space extends SizedBox {
  // Widths

  /// A space with a custom width.
  const Space.w({required double width, super.key}) : super(width: width);

  /// A space with a width of 2
  const Space.w2({super.key, super.width = 2});

  /// A space with a width of 4
  const Space.w4({super.key, super.width = 4});

  /// A space with a width of 8
  const Space.w8({super.key, super.width = 8});

  /// A space with a width of 10
  const Space.w10({super.key, super.width = 10});

  /// A space with a width of 12
  const Space.w12({super.key, super.width = 12});

  /// A space with a width of 16
  const Space.w16({super.key, super.width = 16});

  /// A space with a width of 20
  const Space.w20({super.key, super.width = 20});

  /// A space with a width of 24
  const Space.w24({super.key, super.width = 24});

  /// A space with a width of 30
  const Space.w30({super.key, super.width = 30});

  /// A space with a width of 36
  const Space.w36({super.key, super.width = 36});

  /// A space with a width of 40
  const Space.w40({super.key, super.width = 40});

  /// A space with a width of 48
  const Space.w48({super.key, super.width = 48});

  /// A space with a width of 60
  const Space.w60({super.key, super.width = 60});

  /// A space with a width of 80
  const Space.w80({super.key, super.width = 80});

  /// A space with a width of 90
  const Space.w90({super.key, super.width = 90});

  /// A space with a width of 100
  const Space.w100({super.key, super.width = 100});

  // Heights

  /// A space with a custom height.
  const Space.h({required double height, super.key}) : super(height: height);

  /// A space with a height of 2
  const Space.h2({super.key, super.height = 2});

  /// A space with a height of 4
  const Space.h4({super.key, super.height = 4});

  /// A space with a height of 8
  const Space.h8({super.key, super.height = 8});

  /// A space with a height of 10
  const Space.h10({super.key, super.height = 10});

  /// A space with a height of 12
  const Space.h12({super.key, super.height = 12});

  /// A space with a height of 14
  const Space.h14({super.key, super.height = 14});

  /// A space with a height of 16
  const Space.h16({super.key, super.height = 16});

  /// A space with a height of 20
  const Space.h20({super.key, super.height = 20});

  /// A space with a height of 24
  const Space.h24({super.key, super.height = 24});

  /// A space with a height of 30
  const Space.h30({super.key, super.height = 30});

  /// A space with a height of 32
  const Space.h32({super.key, super.height = 32});

  /// A space with a height of 36
  const Space.h36({super.key, super.height = 36});

  /// A space with a height of 40
  const Space.h40({super.key, super.height = 40});

  /// A space with a height of 44
  const Space.h44({super.key, super.height = 44});

  /// A space with a height of 48
  const Space.h48({super.key, super.height = 48});

  /// A space with a height of 60
  const Space.h60({super.key, super.height = 60});

  /// A space with a height of 96
  const Space.h96({super.key, super.height = 96});

  /// A space with a height of 120
  const Space.h120({super.key, super.height = 120});

  /// A space with a height of 180
  const Space.h180({super.key, super.height = 180});

  /// A space with a height of 200
  const Space.h200({super.key, super.height = 200});
}
