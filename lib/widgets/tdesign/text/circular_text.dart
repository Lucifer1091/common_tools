import 'dart:math';

import 'package:flutter/material.dart';

enum CircularTextDirection { clockwise, anticlockwise }

enum CircularTextPosition { outside, inside }

enum StartAngleAlignment { start, center, end }

class TextItem {
  TextItem({
    required this.text,
    this.space = 10,
    this.startAngle = 0,
    this.startAngleAlignment = StartAngleAlignment.start,
    this.direction = CircularTextDirection.clockwise,
  }) : assert(space >= 0, 'Space between characters must be non-negative.');

  /// Text
  final Text text;

  /// Space between characters
  final double space;

  /// Text starting position
  final double startAngle;

  /// Text alignment around [startAngle]
  /// [StartAngleAlignment.start] text will starts from [startAngle]
  /// [StartAngleAlignment.center] text will be centered on [startAngle]
  /// [StartAngleAlignment.end] text will ends on [startAngle]
  final StartAngleAlignment startAngleAlignment;

  /// Text direction either clockwise or anticlockwise
  final CircularTextDirection direction;

  bool isChanged(TextItem oldTextItem) {
    bool isTextChanged() {
      return oldTextItem.text.data != text.data ||
          oldTextItem.text.style != text.style;
    }

    return isTextChanged() ||
        oldTextItem.space != space ||
        oldTextItem.startAngle != startAngle ||
        oldTextItem.startAngleAlignment != startAngleAlignment ||
        oldTextItem.direction != direction;
  }
}

class CircularText extends StatelessWidget {
  const CircularText({
    required this.children,
    super.key,
    this.radius = 125,
    this.position = CircularTextPosition.inside,
    this.backgroundPaint,
  }) : assert(radius >= 0, 'Radius must be non-negative.');

  /// List of text
  final List<TextItem> children;

  /// Circle radius
  final double radius;

  /// Text position either outside or inside circle
  final CircularTextPosition position;

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
    this.position = CircularTextPosition.inside,
    Paint? backgroundPaint,
  }) : backgroundPaint =
           backgroundPaint ?? (Paint()..color = Colors.transparent);

  final List<TextItem> children;
  final CircularTextPosition position;
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
      final Text text = textItem.text;

      for (final int rune in text.data!.runes) {
        charPainters.add(
          TextPainter(
            text: TextSpan(text: String.fromCharCode(rune), style: text.style),
            textDirection: textDirection,
          )..layout(),
        );
      }
      if (textItem.direction == CircularTextDirection.clockwise) {
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
    TextItem textItem,
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
          position == CircularTextPosition.outside
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
    TextItem textItem,
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
          position == CircularTextPosition.outside
              ? _radius +
                  (hasStrokeStyle ? backgroundPaint.strokeWidth / 2 : 0.0)
              : (_radius - tp.height) + (hasStrokeStyle ? tp.height / 2 : 0.0);

      tp.paint(canvas, Offset(x, y));
      canvas.rotate(-textItem.space * pi / 180);
    }
  }

  double _calculateAngleShift(TextItem textItem, int textLength) {
    double angleShift = -1;
    switch (textItem.startAngleAlignment) {
      case StartAngleAlignment.start:
        angleShift = 0;
      case StartAngleAlignment.center:
        final int halfItemsLength = textLength ~/ 2;
        if (textLength.isEven) {
          angleShift =
              ((halfItemsLength - 1) * textItem.space) + (textItem.space / 2);
        } else {
          angleShift = halfItemsLength * textItem.space;
        }
      case StartAngleAlignment.end:
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
