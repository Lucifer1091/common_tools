import 'dart:async';
import 'dart:math';
import 'dart:ui' show PathMetric, Tangent;

import 'package:flutter/material.dart';

import '../../../../index.dart';

part 'activity_indicator.dart';
part 'ball_pulse_sync.dart';
part 'ball_spin_fade.dart';
part 'basic_indicators.dart';
part 'cardio_indicator.dart';
part 'clock_indicator.dart';
part 'pacman_indicator.dart';
part 'square_indicator.dart';
part 'text_loader.dart';
part 'trefoil_indicator.dart';
part 'triangle_indicator.dart';
part 'wobble_indicator.dart';

abstract class MyLoaderIcon {
  const MyLoaderIcon({this.options = const MyLoaderOptions()});

  final MyLoaderOptions options;

  Widget buildIcon(BuildContext context, MyLoaderOptions? options);

  static const MyLoaderIcon circle = MyCircleLoader();
  static const MyLoaderIcon dots = MyDotsLoader();
  static const MyLoaderIcon spin = MySpinLoader();
  static const MyLoaderIcon triangle = MyTriangleLoader();
  static const MyLoaderIcon square = MySquareLoader();
  static const MyLoaderIcon line = MyLineLoader();
  static const MyLoaderIcon cardio = MyCardioLoader();
  static const MyLoaderIcon clock = MyClockLoader();
  static const MyLoaderIcon activity = MyActivityLoader();
  static const MyLoaderIcon wobble = MyWobbleLoader();
  static const MyLoaderIcon pacman = MyPacmanLoader();
  static const MyLoaderIcon text = MyTextLoader();
  static const MyLoaderIcon trefoil = MyTrefoilLoader();
}

class MyCircleLoader extends MyLoaderIcon {
  const MyCircleLoader({super.options, this.size});

  final double? size;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _MyCircleIndicator(size: size, options: options.merge(defaults));
}

class MyDotsLoader extends MyLoaderIcon {
  const MyDotsLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 400),
    ),
    this.radius,
    this.extent,
    this.spacing,
  });

  final double? radius;
  final double? extent;
  final double? spacing;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _BallPulseSync(
        radius: radius,
        extent: extent,
        spacing: spacing,
        options: options.merge(defaults),
      );
}

class MyTriangleLoader extends MyLoaderIcon {
  const MyTriangleLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 1500),
    ),
    this.size,
  });

  final double? size;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _TriangleIndicator(size: size, options: options.merge(defaults));
}

class MySquareLoader extends MyLoaderIcon {
  const MySquareLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 1500),
    ),
    this.size,
  });

  final double? size;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _SquareIndicator(size: size, options: options.merge(defaults));
}

class MyLineLoader extends MyLoaderIcon {
  const MyLineLoader({super.options, this.height, this.borderRadius});

  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _MyLinearIndicator(
        height: height,
        borderRadius: borderRadius,
        options: options.merge(defaults),
      );
}

class MySpinLoader extends MyLoaderIcon {
  const MySpinLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 500),
    ),
    this.radius,
    this.minBallRadius,
    this.maxBallRadius,
    this.minBallAlpha,
    this.maxBallAlpha,
  });

  final double? radius;
  final double? minBallRadius;
  final double? maxBallRadius;
  final double? minBallAlpha;
  final double? maxBallAlpha;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _BallSpinFade(
        radius: radius,
        minBallRadius: minBallRadius,
        maxBallRadius: maxBallRadius,
        minBallAlpha: minBallAlpha,
        maxBallAlpha: maxBallAlpha,
        options: options.merge(defaults),
      );
}

class MyCardioLoader extends MyLoaderIcon {
  const MyCardioLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 1750),
    ),
    this.size,
  });

  final double? size;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _CardioLoader(size: size, options: options.merge(defaults));
}

class MyClockLoader extends MyLoaderIcon {
  const MyClockLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 2000),
    ),
    this.size,
  });

  final double? size;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _ClockIndicator(size: size, options: options.merge(defaults));
}

class MyActivityLoader extends MyLoaderIcon {
  const MyActivityLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 500),
    ),
    this.radius,
    this.minLineWidth,
    this.maxLineWidth,
    this.minLineHeight,
    this.maxLineHeight,
    this.minBallAlpha,
    this.maxBallAlpha,
  });

  final double? radius;
  final double? minLineWidth;
  final double? maxLineWidth;
  final double? minLineHeight;
  final double? maxLineHeight;
  final double? minBallAlpha;
  final double? maxBallAlpha;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _ActivityIndicator(
        radius: radius,
        minLineWidth: minLineWidth,
        maxLineWidth: maxLineWidth,
        minLineHeight: minLineHeight,
        maxLineHeight: maxLineHeight,
        minBallAlpha: minBallAlpha,
        maxBallAlpha: maxBallAlpha,
        options: options.merge(defaults),
      );
}

class MyWobbleLoader extends MyLoaderIcon {
  const MyWobbleLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 1000),
    ),
    this.height,
    this.width,
  });

  final double? height;
  final double? width;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _LineWobbleIndicator(
        height: height,
        width: width,
        options: options.merge(defaults),
      );
}

class MyPacmanLoader extends MyLoaderIcon {
  const MyPacmanLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 325),
    ),
    this.radius,
    this.beanRadius,
  });

  final double? radius;
  final double? beanRadius;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _PacmanIndicator(
        radius: radius,
        beanRadius: beanRadius,
        options: options.merge(defaults),
      );
}

class MyTextLoader extends MyLoaderIcon {
  const MyTextLoader({
    super.options = const MyLoaderOptions(
      duration: Duration(milliseconds: 1500),
    ),
    this.size,
    this.style,
  });

  final double? size;
  final TextStyle? style;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _TextLoader(size: size, style: style, options: options.merge(defaults));
}

class MyTrefoilLoader extends MyLoaderIcon {
  const MyTrefoilLoader({
    super.options = const MyLoaderOptions(duration: Duration(seconds: 3)),
    this.size,
  });

  final double? size;

  @override
  Widget buildIcon(BuildContext context, MyLoaderOptions? defaults) =>
      _TrefoilLoader(size: size, options: options.merge(defaults));
}
