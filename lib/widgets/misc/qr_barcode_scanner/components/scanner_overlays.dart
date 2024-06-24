import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// [BlurCutout] provides a custom painter for leaving a hole with some
/// fuzziness.
class BlurCutout extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double blurRadius = 14;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Radius radius = Radius.circular(blurRadius);
    RRect rRect = RRect.fromRectAndRadius(rect, radius);
    canvas.drawRRect(
      rRect,
      Paint()
        ..blendMode = BlendMode.xor
        // The mask filter gives some fuzziness to the cutout.
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius),
    );
  }

  @override
  bool shouldRepaint(BlurCutout oldDelegate) => false;

  static BackdropFilter backDropFilter({
    required double width,
    required double height,
  }) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        alignment: Alignment.center,
        // Choose Colors.black.withOpacity(0.3) here if you want a shadow effect in addition to blurring.
        color: Colors.transparent,
        // This part is new, creating the cutout.
        child: CustomPaint(
          size: Size(width, height),
          painter: BlurCutout(),
        ),
      ),
    );
  }
}

class ScanAreaShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  late final double _cutOutBottomOffset;

  ScanAreaShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    double cutOutBottomOffset = 0,
  })  : _cutOutBottomOffset = cutOutBottomOffset,
        cutOutWidth = cutOutWidth ?? cutOutSize ?? 250,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 250 {
    assert(
      borderLength <=
          min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
      "Border can't be larger than ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );
    assert(
      (cutOutWidth == null && cutOutHeight == null) ||
          (cutOutSize == null && cutOutWidth != null && cutOutHeight != null),
      'Use only cutOutWidth and cutOutHeight or only cutOutSize',
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final borderLength = this.borderLength >
            min(this.cutOutHeight, this.cutOutHeight) / 2 + borderWidth * 2
        ? borderWidthSize / 2
        : this.borderLength;
    final cutOutWidth =
        this.cutOutWidth < width ? this.cutOutWidth : width - borderOffset;
    final cutOutHeight =
        this.cutOutHeight < height ? this.cutOutHeight : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - cutOutWidth / 2 + borderOffset,
      -_cutOutBottomOffset +
          rect.top +
          height / 2 -
          cutOutHeight / 2 +
          borderOffset,
      cutOutWidth - borderOffset * 2,
      cutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + borderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + borderLength,
          cutOutRect.top + borderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.bottom - borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - borderLength,
          cutOutRect.left + borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return ScanAreaShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }

  static Center build({required double width, required double height}) {
    return Center(
      child: Container(
        decoration: ShapeDecoration(
          shape: ScanAreaShape(
            borderColor: Colors.red,
            overlayColor: const Color(0xFF040404).withOpacity(0.58),
            borderRadius: 14,
            borderLength: 30,
            borderWidth: 16,
            cutOutWidth: width,
            cutOutHeight: height,
          ),
        ),
      ),
    );
  }
}

class ScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;
  final double height;

  const ScannerAnimation({
    required this.stopped,
    super.key,
    required this.width,
    required this.height,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * height * 0.28) + 16;

    Color color1 = const Color(0xffE86A6D).withOpacity(0.3);
    Color color2 = const Color(0xffE86A6D).withOpacity(0.1);

    if (animation.status == AnimationStatus.reverse) {
      color1 = const Color(0xffE86A6D).withOpacity(0.1);
      color2 = const Color(0xffE86A6D).withOpacity(0.3);
    }
    return Positioned(
      bottom: scorePosition,
      left: width * .20,
      child: Opacity(
        opacity: (stopped) ? 0.0 : 1.0,
        child: Padding(
          padding: EdgeInsets.only(bottom: height * 0.33),
          child: Column(
            children: [
              if (animation.status != AnimationStatus.reverse) buildScanBar(),
              Container(
                height: 20.0,
                width: width + 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.1, 0.9],
                    colors: [color1, color2],
                  ),
                ),
              ),
              if (animation.status == AnimationStatus.reverse) buildScanBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildScanBar() {
    return Row(
      children: [
        Container(
          height: 5,
          width: 5,
          decoration: const BoxDecoration(
            color: Color(0xffD43034),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          height: 2,
          width: width - 2,
          decoration: const BoxDecoration(
            color: Color(0xffD43034),
          ),
        ),
        Container(
          height: 5,
          width: 5,
          decoration: const BoxDecoration(
            color: Color(0xffD43034),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
