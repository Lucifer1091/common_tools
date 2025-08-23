import 'dart:math';

import 'package:flutter/material.dart';

import 'my_text.dart';

enum MyCircularTextDirection { clockwise, anticlockwise }

enum MyCircularTextPosition { outside, inside }

enum MyStartAngleAlignment { start, center, end }

class MyCircularTextItem {
  MyCircularTextItem({
    required this.text,
    this.space = 10,
    this.startAngle = 0,
    this.startAngleAlignment = MyStartAngleAlignment.start,
    this.direction = MyCircularTextDirection.clockwise,
  }) : assert(space >= 0, 'Space between characters must be non-negative.');

  /// Text
  final MyText text;

  /// Space between characters
  final double space;

  /// Text starting position
  final double startAngle;

  /// Text alignment around [startAngle]
  /// [MyStartAngleAlignment.start] text will starts from [startAngle]
  /// [MyStartAngleAlignment.center] text will be centered on [startAngle]
  /// [MyStartAngleAlignment.end] text will ends on [startAngle]
  final MyStartAngleAlignment startAngleAlignment;

  /// Text direction either clockwise or anticlockwise
  final MyCircularTextDirection direction;

  bool isChanged(MyCircularTextItem oldTextItem) {
    bool isTextChanged() {
      return oldTextItem.text.text != text.text ||
          oldTextItem.text.style != text.style;
    }

    return isTextChanged() ||
        oldTextItem.space != space ||
        oldTextItem.startAngle != startAngle ||
        oldTextItem.startAngleAlignment != startAngleAlignment ||
        oldTextItem.direction != direction;
  }
}

class MyCircularText extends StatelessWidget {
  const MyCircularText({
    required this.children,
    super.key,
    this.radius = 125,
    this.position = MyCircularTextPosition.inside,
    this.backgroundPaint,
  }) : assert(radius >= 0, 'Radius must be non-negative.');

  /// List of text
  final List<MyCircularTextItem> children;

  /// Circle radius
  final double radius;

  /// Text position either outside or inside circle
  final MyCircularTextPosition position;

  /// Background paint
  final Paint? backgroundPaint;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox.fromSize(
        size: Size(2 * radius, 2 * radius),
        child: CustomPaint(
          painter: _CircularTextPainter(
            children: children,
            position: position,
            backgroundPaint: backgroundPaint,
            textDirection: Directionality.of(context),
          ),
        ),
      ),
    );
  }
}

class _CircularTextPainter extends CustomPainter {
  _CircularTextPainter({
    required this.children,
    required this.textDirection,
    this.position = MyCircularTextPosition.inside,
    Paint? backgroundPaint,
  }) : backgroundPaint =
           backgroundPaint ?? (Paint()..color = Colors.transparent);

  final List<MyCircularTextItem> children;
  final MyCircularTextPosition position;
  final Paint backgroundPaint;
  final TextDirection textDirection;

  double _radius = 0;

  @override
  void paint(Canvas canvas, Size size) {
    _radius = min(size.width / 2, size.height / 2);
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..drawCircle(Offset.zero, _radius, backgroundPaint);

    for (final textItem in children) {
      canvas.save();
      final List<TextPainter> charPainters = [];
      final MyText text = textItem.text;

      for (final int rune in text.text!.runes) {
        charPainters.add(
          TextPainter(
            text: TextSpan(text: String.fromCharCode(rune), style: text.style),
            textDirection: textDirection,
          )..layout(),
        );
      }
      if (textItem.direction == MyCircularTextDirection.clockwise) {
        _paintTextClockwise(canvas, size, textItem, charPainters);
      } else {
        _paintTextAntiClockwise(canvas, size, textItem, charPainters);
      }
      canvas.restore();
    }
  }

  void _paintTextClockwise(
    Canvas canvas,
    Size size,
    MyCircularTextItem textItem,
    List<TextPainter> charPainters,
  ) {
    final bool hasStrokeStyle =
        backgroundPaint.style == PaintingStyle.stroke &&
        backgroundPaint.strokeWidth > 0.0;

    final double angleShift = _calculateAngleShift(
      textItem,
      charPainters.length,
    );
    canvas.rotate((textItem.startAngle + 90 - angleShift) * pi / 180);

    for (int i = 0; i < charPainters.length; i++) {
      final tp = charPainters[i];
      final x = -tp.width / 2;
      final y =
          position == MyCircularTextPosition.outside
              ? (-_radius - tp.height) -
                  (hasStrokeStyle ? backgroundPaint.strokeWidth / 2 : 0.0)
              : -_radius - (hasStrokeStyle ? tp.height / 2 : 0.0);

      tp.paint(canvas, Offset(x, y));
      canvas.rotate(textItem.space * pi / 180);
    }
  }

  void _paintTextAntiClockwise(
    Canvas canvas,
    Size size,
    MyCircularTextItem textItem,
    List<TextPainter> charPainters,
  ) {
    final bool hasStrokeStyle =
        backgroundPaint.style == PaintingStyle.stroke &&
        backgroundPaint.strokeWidth > 0.0;

    final double angleShift = _calculateAngleShift(
      textItem,
      charPainters.length,
    );
    canvas.rotate((textItem.startAngle - 90 + angleShift) * pi / 180);
    for (int i = 0; i < charPainters.length; i++) {
      final tp = charPainters[i];
      final x = -tp.width / 2;
      final y =
          position == MyCircularTextPosition.outside
              ? _radius +
                  (hasStrokeStyle ? backgroundPaint.strokeWidth / 2 : 0.0)
              : (_radius - tp.height) + (hasStrokeStyle ? tp.height / 2 : 0.0);

      tp.paint(canvas, Offset(x, y));
      canvas.rotate(-textItem.space * pi / 180);
    }
  }

  double _calculateAngleShift(MyCircularTextItem textItem, int textLength) {
    double angleShift = -1;
    switch (textItem.startAngleAlignment) {
      case MyStartAngleAlignment.start:
        angleShift = 0;
      case MyStartAngleAlignment.center:
        final int halfItemsLength = textLength ~/ 2;
        if (textLength.isEven) {
          angleShift =
              ((halfItemsLength - 1) * textItem.space) + (textItem.space / 2);
        } else {
          angleShift = halfItemsLength * textItem.space;
        }
      case MyStartAngleAlignment.end:
        angleShift = (textLength - 1) * textItem.space;
    }
    return angleShift;
  }

  @override
  bool shouldRepaint(_CircularTextPainter oldDelegate) {
    bool isTextItemsChanged() {
      bool isChanged = false;
      for (int i = 0; i < children.length; i++) {
        if (i >= oldDelegate.children.length ||
            children[i].isChanged(oldDelegate.children[i])) {
          isChanged = true;
          break;
        }
      }
      return isChanged;
    }

    bool isBackgroundPaintChanged() {
      return oldDelegate.backgroundPaint.color != backgroundPaint.color ||
          oldDelegate.backgroundPaint.style != backgroundPaint.style ||
          oldDelegate.backgroundPaint.strokeWidth !=
              backgroundPaint.strokeWidth;
    }

    return isTextItemsChanged() ||
        oldDelegate.position != position ||
        oldDelegate.textDirection != textDirection ||
        isBackgroundPaintChanged();
  }
}
