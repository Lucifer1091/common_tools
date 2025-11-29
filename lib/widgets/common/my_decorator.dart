import 'package:flutter/material.dart';

import '../../index.dart';

class MyDecorator extends StatelessWidget {
  const MyDecorator({
    super.key,
    this.enabled = true,
    this.child,
    this.focused = false,
    this.borderWidth,
    this.offset,
    this.radius,
    this.decoration,
  });

  /// The child to decorate.
  final Widget? child;

  /// Whether the child has focus, defaults to false.
  final bool focused;

  /// Whether to show border around the child, defaults to true.
  final bool enabled;

  /// The width of the border around the child, defaults to 1.0.
  final double? borderWidth;

  /// The offset of the border around the child, defaults to 0.0.
  final double? offset;

  /// The radius of the border around the child, defaults to 0.0.
  final BorderRadius? radius;

  /// The decoration to apply to the child.
  final MyDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    final effectiveDecoration = MyDecoration(
      secondaryFocusedBorder: MyBorder.all(
        color: context.colorScheme.primary,
        width: 2,
        offset: offset ?? 3.5,
        radius: radius != null ? radius! * 1.5 : MyBorderRadius.large,
      ),
    ).merge(decoration);

    final effectiveFallbackToBorder =
        effectiveDecoration.fallbackToBorder ?? true;

    final effectiveDisableSecondaryBorder =
        effectiveDecoration.disableSecondaryBorder ??
        !context.enableFocusOutline;

    final hasError = effectiveDecoration.hasError ?? false;

    final fallbackBorder = switch (focused) {
      true => effectiveDecoration.focusedBorder,
      false => effectiveDecoration.border,
    };

    var border = switch (hasError) {
      true => effectiveDecoration.errorBorder,
      false => fallbackBorder,
    };

    if (effectiveFallbackToBorder && border == null) {
      border = fallbackBorder ?? effectiveDecoration.border;
    }

    final fallbackSecondaryBorder = switch (focused) {
      true => effectiveDecoration.secondaryFocusedBorder,
      false => effectiveDecoration.secondaryBorder,
    };

    var secondaryBorder = switch (hasError) {
      true => effectiveDecoration.secondaryErrorBorder,
      false => fallbackSecondaryBorder,
    };

    if (effectiveFallbackToBorder && secondaryBorder == null) {
      secondaryBorder =
          fallbackSecondaryBorder ?? effectiveDecoration.secondaryBorder;
    }

    final primaryDecoration = switch (border) {
      final MyRoundedSuperellipseBorder border => ShapeDecoration(
        color: effectiveDecoration.color,
        image: effectiveDecoration.image,
        shadows: effectiveDecoration.shadows,
        gradient: effectiveDecoration.gradient,
        shape: border.toBorder(
          textDirection: textDirection,
          defaultRadius: radius ?? BorderRadius.zero,
        ),
      ),
      final MyBorder? border => BoxDecoration(
        border: true == border?.hasBorder ? border?.toBorder() : null,
        borderRadius:
            effectiveDecoration.shape == BoxShape.circle
                ? null
                : border?.radius,
        color: effectiveDecoration.color,
        shape: effectiveDecoration.shape ?? BoxShape.rectangle,
        backgroundBlendMode: effectiveDecoration.backgroundBlendMode,
        boxShadow: effectiveDecoration.shadows,
        gradient: effectiveDecoration.gradient,
        image: effectiveDecoration.image,
      ),
    };

    Widget decorated = Container(
      decoration: primaryDecoration,
      padding: border?.padding,
      child: child,
    );

    if (enabled &&
        secondaryBorder != null &&
        !effectiveDisableSecondaryBorder) {
      decorated = Padding(
        padding: secondaryBorder.padding ?? EdgeInsets.zero,
        child: CustomPaint(
          foregroundPainter: _MyOutwardBorderPainter(
            border: secondaryBorder.toBorder(),
            offset: secondaryBorder.offset ?? 0,
            radius:
                secondaryBorder.radius?.resolve(textDirection) ??
                BorderRadius.zero,
            textDirection: textDirection,
          ),
          child: decorated,
        ),
      );
    }

    return decorated;
  }
}

/// A [CustomPainter] that paints a border outward from the given rectangle.
class _MyOutwardBorderPainter extends CustomPainter {
  const _MyOutwardBorderPainter({
    required this.border,
    required this.offset,
    required this.radius,
    required this.textDirection,
  });

  /// The border to paint.
  final Border border;

  /// The offset to inflate the border by.
  final double offset;

  /// The radius of the border.
  final BorderRadius? radius;

  /// The text direction to use when painting the border.
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    border.paint(
      canvas,
      (Offset.zero & size).inflate(offset),
      borderRadius: radius,
      textDirection: textDirection,
    );
  }

  @override
  bool shouldRepaint(covariant _MyOutwardBorderPainter oldDelegate) {
    return border != oldDelegate.border ||
        offset != oldDelegate.offset ||
        radius != oldDelegate.radius ||
        textDirection != oldDelegate.textDirection;
  }
}
