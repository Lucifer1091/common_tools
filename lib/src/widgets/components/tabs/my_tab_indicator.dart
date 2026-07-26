import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/iterable/validators.dart';

enum MyTabIndicatorPosition { center, top, bottom }

enum MyTabIndicatorSize { tiny, normal, full }

enum MyTabIndicatorType { none, dot, line, material, capsule }

class MyTabIndicator extends Decoration {
  const MyTabIndicator(
    this.context, {
    this.height,
    this.width,
    this.color,
    this.gradient,
    this.radius,
    this.strokeWidth = 2,
    this.style = PaintingStyle.fill,
    this.insets = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.type = MyTabIndicatorType.line,
    this.size = MyTabIndicatorSize.tiny,
    this.position = MyTabIndicatorPosition.bottom,
  });

  final BuildContext context;
  final double? height;
  final double? width;
  final MyTabIndicatorType type;
  final MyTabIndicatorSize size;
  final Color? color;
  final List<Color>? gradient;
  final double? radius;
  final double strokeWidth;
  final PaintingStyle style;
  final EdgeInsetsGeometry insets;
  final MyTabIndicatorPosition position;

  @override
  final EdgeInsetsGeometry padding;

  MyTabIndicator copyWith({
    BuildContext? context,
    double? height,
    double? width,
    MyTabIndicatorType? type,
    MyTabIndicatorSize? size,
    Color? color,
    List<Color>? gradient,
    double? radius,
    double? strokeWidth,
    PaintingStyle? style,
    EdgeInsetsGeometry? insets,
    MyTabIndicatorPosition? position,
    EdgeInsetsGeometry? padding,
  }) {
    return MyTabIndicator(
      context ?? this.context,
      height: height ?? this.height,
      width: width ?? this.width,
      type: type ?? this.type,
      size: size ?? this.size,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      radius: radius ?? this.radius,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      style: style ?? this.style,
      insets: insets ?? this.insets,
      position: position ?? this.position,
      padding: padding ?? this.padding,
    );
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    if (type == MyTabIndicatorType.dot) {
      return _DotIndicatorPainter(this, onChanged);
    } else if (type == MyTabIndicatorType.line) {
      if (size == MyTabIndicatorSize.tiny) {
        return _TabIndicatorPainter(
          copyWith(width: width ?? 20, radius: radius ?? 4),
          onChanged,
        );
      } else {
        return _TabIndicatorPainter(this, onChanged);
      }
    } else if (type == MyTabIndicatorType.material) {
      return _MaterialIndicatorPainter(this, onChanged);
    } else if (type == MyTabIndicatorType.capsule) {
      return _TabIndicatorPainter(
        copyWith(
          position: MyTabIndicatorPosition.center,
          height: height ?? 36,
          radius: radius ?? 100,
        ),
        onChanged,
      );
    }

    return _NoIndicatorPainter();
  }
}

class _MaterialIndicatorPainter extends BoxPainter {
  _MaterialIndicatorPainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  final MyTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, '');

    final double tabWidth = configuration.size!.width;
    final double tabHeight = configuration.size!.height;
    final double indicatorHeight = decoration.height ?? 4;

    double left = offset.dx + decoration.padding.horizontal;
    double width = tabWidth - decoration.padding.horizontal * 2;

    if (decoration.size == MyTabIndicatorSize.tiny) {
      width = decoration.width ?? 20;
      left = offset.dx + tabWidth / 2 - width / 2;
    } else if (decoration.size == MyTabIndicatorSize.normal) {
      width = decoration.width ?? (tabWidth - 16);
      left = offset.dx + 6;
    }

    final bool isBottom = decoration.position == MyTabIndicatorPosition.bottom;

    final double top = offset.dy + (isBottom ? tabHeight - indicatorHeight : 0);

    final Rect rect = Rect.fromLTWH(left, top, width, indicatorHeight);

    final Paint paint = Paint()
      ..color = decoration.color ?? decoration.context.colorScheme.primary
      ..style = decoration.style
      ..strokeWidth = decoration.strokeWidth
      ..strokeCap = StrokeCap.round;

    if (decoration.gradient != null && decoration.gradient.isNotBlank) {
      paint.shader = ui.Gradient.linear(
        Offset(rect.left, 0),
        Offset(rect.right, 0),
        decoration.gradient!,
      );
    }

    final double radiusTop = isBottom ? decoration.radius ?? 8 : 0;
    final double radiusBottom = !isBottom ? decoration.radius ?? 8 : 0;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: Radius.circular(radiusTop),
        topLeft: Radius.circular(radiusTop),
        bottomRight: Radius.circular(radiusBottom),
        bottomLeft: Radius.circular(radiusBottom),
      ),
      paint,
    );
  }
}

class _TabIndicatorPainter extends BoxPainter {
  _TabIndicatorPainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  final MyTabIndicator decoration;

  double get indicatorHeight => decoration.height ?? 3;
  double get indicatorWidth => decoration.width ?? 0;
  double get indicatorRadius => decoration.radius ?? 2;
  EdgeInsetsGeometry get padding => decoration.padding;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = padding.resolve(textDirection).deflateRect(rect);

    double width = indicatorWidth > 0 ? indicatorWidth : indicator.width;

    if (decoration.type != MyTabIndicatorType.capsule &&
        decoration.size == MyTabIndicatorSize.tiny) {
      width = decoration.width ?? 20;
    } else if (decoration.size == MyTabIndicatorSize.normal) {
      width = decoration.width ?? (width - 16);
    }

    final double height = indicatorHeight > 0
        ? indicatorHeight
        : indicator.height;
    final double left = (indicator.left + indicator.right - width) * 0.5;
    double top;

    switch (decoration.position) {
      case MyTabIndicatorPosition.top:
        top = indicator.top;
      case MyTabIndicatorPosition.bottom:
        top = indicator.bottom - height;
      case MyTabIndicatorPosition.center:
        top = (indicator.height - height) * 0.5;
    }
    return Rect.fromLTWH(left, top, width, height);
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, '');

    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = _indicatorRectFor(rect, textDirection);

    final Paint paint = Paint()
      ..color = decoration.color ?? decoration.context.colorScheme.primary
      ..style = decoration.style
      ..strokeWidth = decoration.strokeWidth
      ..strokeCap = StrokeCap.round;

    if (decoration.gradient != null && decoration.gradient.isNotBlank) {
      paint.shader = ui.Gradient.linear(
        Offset(rect.left, 0),
        Offset(rect.right, 0),
        decoration.gradient!,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(indicator, Radius.circular(indicatorRadius)),
      paint,
    );
  }
}

class _DotIndicatorPainter extends BoxPainter {
  _DotIndicatorPainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  final MyTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, '');

    final Rect rect = offset & configuration.size!;
    final TextDirection? textDirection = configuration.textDirection;
    final Rect indicator = decoration.insets
        .resolve(textDirection)
        .deflateRect(rect);

    final double x = indicator.left + indicator.width / 2;
    double y;

    switch (decoration.position) {
      case MyTabIndicatorPosition.top:
        y = indicator.top;
      case MyTabIndicatorPosition.bottom:
        y = indicator.bottom;
      case MyTabIndicatorPosition.center:
        y = indicator.top + indicator.height / 2;
    }

    final Paint paint = Paint()
      ..color = decoration.color ?? decoration.context.colorScheme.primary
      ..style = decoration.style
      ..strokeWidth = decoration.strokeWidth
      ..strokeCap = StrokeCap.round;

    if (decoration.gradient != null && decoration.gradient.isNotBlank) {
      paint.shader = ui.Gradient.linear(
        Offset(rect.left, 0),
        Offset(rect.right, 0),
        decoration.gradient!,
      );
    }

    canvas.drawCircle(Offset(x, y), decoration.radius ?? 3, paint);
  }
}

class _NoIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
