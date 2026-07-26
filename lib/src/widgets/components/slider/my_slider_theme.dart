// ignore_for_file: prefer_asserts_with_message

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import './my_slider.dart';

typedef MyScaleFormatter = String Function(double value);

typedef OnSliderThemeDataUpdate =
    SliderThemeData Function(SliderThemeData sliderThemeData);

class MySliderThemeData {
  MySliderThemeData({
    required this.context,
    this.showScaleValue = false,
    this.showThumbValue = false,
    this.divisions,
    TextStyle? scaleTextStyle,
    TextStyle? disabledScaleTextStyle,
    TextStyle? thumbTextStyle,
    TextStyle? disabledThumbTextStyle,
    this.min = 0.0,
    this.max = 1.0,
    this.scaleFormatter,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this._sliderThemeData,
  }) : scaleTextStyle =
           scaleTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.foreground,
           ),
       disabledScaleTextStyle =
           disabledScaleTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.mutedForeground,
           ),
       thumbTextStyle =
           thumbTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.foreground,
           ),
       disabledThumbTextStyle =
           disabledThumbTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.mutedForeground,
           ),
       _capsule = false;

  MySliderThemeData.capsule({
    required this.context,
    this.showScaleValue = false,
    this.showThumbValue = false,
    this.divisions,
    TextStyle? scaleTextStyle,
    TextStyle? disabledScaleTextStyle,
    TextStyle? thumbTextStyle,
    TextStyle? disabledThumbTextStyle,
    this.min = 0.0,
    this.max = 1.0,
    this.scaleFormatter,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this._sliderThemeData,
  }) : scaleTextStyle =
           scaleTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.foreground,
           ),
       disabledScaleTextStyle =
           disabledScaleTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.mutedForeground,
           ),
       thumbTextStyle =
           thumbTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.foreground,
           ),
       disabledThumbTextStyle =
           disabledThumbTextStyle ??
           context.bodyMedium.copyWith(
             fontSize: 14,
             color: context.colorScheme.mutedForeground,
           ),
       _capsule = true;

  final bool showThumbValue;
  final TextStyle? thumbTextStyle;
  final TextStyle disabledThumbTextStyle;
  final bool showScaleValue;
  final MyScaleFormatter? scaleFormatter;
  final TextStyle? scaleTextStyle;
  final TextStyle disabledScaleTextStyle;
  final int? divisions;
  final double min;
  final double max;

  final SliderMeasureData sliderMeasureData = SliderMeasureData();
  SliderThemeData? _sliderThemeData;
  final BuildContext context;
  final bool _capsule;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  SliderThemeData get sliderThemeData {
    _sliderThemeData ??= _capsule ? capsule() : normal();
    return _sliderThemeData!;
  }

  void updateSliderThemeData(OnSliderThemeDataUpdate onSliderThemeDataUpdate) {
    _sliderThemeData = onSliderThemeDataUpdate(sliderThemeData);
  }

  SliderThemeData normal() {
    return SliderThemeData(
      trackHeight: 4,
      activeTrackColor: activeTrackColor ?? context.colorScheme.primary,
      inactiveTrackColor: inactiveTrackColor ?? context.colorScheme.secondary,
      disabledActiveTrackColor: context.colorScheme.primary.withValues(
        alpha: 0.5,
      ),
      disabledInactiveTrackColor: context.colorScheme.muted,
      activeTickMarkColor: context.colorScheme.primary,
      inactiveTickMarkColor: context.colorScheme.border,
      disabledActiveTickMarkColor: context.colorScheme.primary.withValues(
        alpha: 0.3,
      ),
      disabledInactiveTickMarkColor: context.colorScheme.muted,
      thumbColor: context.colorScheme.background,
      disabledThumbColor: context.colorScheme.muted,
      overlayShape: const MyNoOverlayShape(),
      tickMarkShape: MyRoundSliderTickMarkShape(themeData: this),
      thumbShape: MyRoundSliderThumbShape(context: context, themeData: this),
      trackShape: MyRoundedRectSliderTrackShape(themeData: this),
      rangeTickMarkShape: MyRoundRangeSliderTickMarkShape(themeData: this),
      rangeThumbShape: MyRoundRangeSliderThumbShape(
        context: context,
        themeData: this,
      ),
      rangeTrackShape: MyRoundedRectRangeSliderTrackShape(themeData: this),
      showValueIndicator: ShowValueIndicator.never,
    );
  }

  SliderThemeData capsule() {
    return SliderThemeData(
      trackShape: MyCapsuleRectSliderTrackShape(
        themeData: this,
        trackColorWhenShowScale: context.colorScheme.secondary,
      ),
      tickMarkShape: MyCapsuleSliderTickMarkShape(themeData: this),
      thumbShape: MyCapsuleSliderThumbShape(context: context, themeData: this),
      rangeTrackShape: MyCapsuleRectRangeSliderTrackShape(
        themeData: this,
        trackColorWhenShowScale: context.colorScheme.secondary,
      ),
      rangeTickMarkShape: MyCapsuleRangeSliderTickMarkShape(themeData: this),
      rangeThumbShape: MyCapsuleRangeSliderThumbShape(
        context: context,
        themeData: this,
      ),
      activeTickMarkColor: context.colorScheme.background,
      inactiveTickMarkColor: context.colorScheme.border,
      disabledActiveTickMarkColor: context.colorScheme.primary.withValues(
        alpha: 0.3,
      ),
      disabledInactiveTickMarkColor: context.colorScheme.muted,
      thumbColor: context.colorScheme.background,
      disabledThumbColor: context.colorScheme.muted,
      trackHeight: 24,
      activeTrackColor: activeTrackColor ?? context.colorScheme.primary,
      inactiveTrackColor: inactiveTrackColor ?? context.colorScheme.secondary,
      disabledActiveTrackColor: context.colorScheme.primary.withValues(
        alpha: 0.5,
      ),
      disabledInactiveTrackColor: context.colorScheme.muted,
      overlayShape: const MyNoOverlayShape(),
      showValueIndicator: ShowValueIndicator.never,
    );
  }

  MySliderThemeData copyWith({
    SliderThemeData? themeData,
    bool? showScaleValue,
    bool? showThumbValue,
    TextStyle? disabledScaleTextStyle,
    TextStyle? disabledThumbTextStyle,
    TextStyle? scaleTextStyle,
    TextStyle? thumbTextStyle,
    int? divisions,
    double? min,
    double? max,
    MyScaleFormatter? scaleFormatter,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
  }) {
    return MySliderThemeData(
      context: context,
      showScaleValue: showScaleValue ?? this.showScaleValue,
      showThumbValue: showThumbValue ?? this.showThumbValue,
      disabledScaleTextStyle:
          disabledScaleTextStyle ?? this.disabledScaleTextStyle,
      disabledThumbTextStyle:
          disabledThumbTextStyle ?? this.disabledThumbTextStyle,
      scaleTextStyle: scaleTextStyle ?? this.scaleTextStyle,
      thumbTextStyle: thumbTextStyle ?? this.thumbTextStyle,
      divisions: divisions ?? this.divisions,
      min: min ?? this.min,
      max: max ?? this.max,
      scaleFormatter: scaleFormatter ?? this.scaleFormatter,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
    );
  }
}

class SliderMeasureData {
  Rect? trackerRect;
  Offset? thumbCenter;
  Rect? thumbTextRect;
  Rect? startRangeThumbTextRect;
  Rect? endRangeThumbTextRect;
}

class MyRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const MyRoundedRectSliderTrackShape({required this.themeData});

  final MySliderThemeData themeData;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;

    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
    }

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // record size ,Use it when calculating thumb text position
    themeData.sliderMeasureData.trackerRect = trackRect;
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular(
      (trackRect.height + additionalActiveTrackHeight) / 2,
    );

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}

class MyRoundSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const MyRoundSliderThumbShape({
    required this.context,
    required this.themeData,
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 4.0,
    this.pressedElevation = 4.0,
  });

  final BuildContext context;

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  final MySliderThemeData themeData;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
      isEnabled ? enabledThumbRadius : _disabledThumbRadius,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final color = colorTween.evaluate(enableAnimation)!;
    final radius = radiusTween.evaluate(enableAnimation);

    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final evaluatedElevation = elevationTween.evaluate(activationAnimation);
    final path = Path()
      ..addArc(
        Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
        0,
        math.pi * 2,
      );

    final paintShadows = true;

    if (paintShadows) {
      canvas.drawShadow(
        path,
        const Color.fromRGBO(0, 0, 0, 0.5),
        evaluatedElevation,
        true,
      );
    }

    // draw thumb text
    if (themeData.showThumbValue &&
        themeData.sliderMeasureData.trackerRect != null) {
      final trackerRect = themeData.sliderMeasureData.trackerRect!;
      final ratio =
          (center.dx - trackerRect.left) /
          (trackerRect.right - trackerRect.left);
      // Calculate the value of the slider
      final value = (themeData.max - themeData.min) * ratio + themeData.min;
      // Formatted display
      final formatterValue = themeData.scaleFormatter == null
          ? value.toStringAsFixed(2)
          : themeData.scaleFormatter!(value);
      // Plot values
      final painter = TextPainter(
        text: TextSpan(
          text: formatterValue,
          style: enableAnimation.value > 0
              ? themeData.thumbTextStyle
              : themeData.disabledThumbTextStyle,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 100);

      final textPosition = Offset(
        center.dx - painter.width / 2,
        center.dy - painter.height - 14,
      );
      painter.paint(context.canvas, textPosition);
      themeData.sliderMeasureData.thumbTextRect = Rect.fromLTWH(
        center.dx - painter.width / 2,
        center.dy - painter.height - 14,
        painter.width,
        painter.height,
      );
    }
    final paint = Paint()..color = color;
    canvas
      ..drawCircle(center, radius, paint)
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = this.context.colorScheme.primary,
      );
  }
}

/// The system is used to draw Overlay. No drawing is done here, only the width
/// and height calculation of the slider is done
class MyNoOverlayShape extends SliderComponentShape {
  const MyNoOverlayShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 40);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class MyRoundSliderTickMarkShape extends SliderTickMarkShape {
  /// Create a slider tick mark that draws a circle.
  const MyRoundSliderTickMarkShape({
    required this.themeData,
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  final MySliderThemeData themeData;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    // The tick marks are tiny circles. If no radius is provided, then the
    // radius is defaulted to be a fraction of the
    // [SliderThemeData.trackHeight]. The fraction is 1/4.
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    Color? begin;
    Color? end;
    switch (textDirection) {
      case TextDirection.ltr:
        final isTickMarkRightOfThumb = center.dx > thumbCenter.dx;
        begin = isTickMarkRightOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkRightOfThumb
            ? sliderTheme.inactiveTickMarkColor
            : sliderTheme.activeTickMarkColor;
      case TextDirection.rtl:
        final isTickMarkLeftOfThumb = center.dx < thumbCenter.dx;
        begin = isTickMarkLeftOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkLeftOfThumb
            ? sliderTheme.inactiveTickMarkColor
            : sliderTheme.activeTickMarkColor;
    }
    final paint = Paint()
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius =
        getPreferredSize(isEnabled: isEnabled, sliderTheme: sliderTheme).width /
        2;
    if (tickMarkRadius > 0 && themeData.showScaleValue) {
      assert(themeData.divisions != null);
      final rect = sliderTheme.trackShape?.getPreferredRect(
        parentBox: parentBox,
        sliderTheme: sliderTheme,
      );
      if (rect != null && themeData.divisions! > 0) {
        // The height of the track
        final trackHeight = rect.bottom - rect.top;
        // The length from the leftmost scale center to the rightmost scale center
        final markWidth = (rect.right - rect.left) - trackHeight;
        // The starting point of the leftmost scale
        final markStart = rect.left + trackHeight / 2;
        // The width of each tick
        final perWidth = markWidth / themeData.divisions!;
        assert(perWidth > 0);
        // Calculate the current scale
        final index = ((center.dx - markStart) / perWidth).round();
        // Get the current scale value
        final value =
            themeData.min +
            index * ((themeData.max - themeData.min) / themeData.divisions!);
        // Format numeric value
        final valueFormatter = themeData.scaleFormatter != null
            ? themeData.scaleFormatter!(value)
            : value.toString();
        // Draw the value of the scale
        final painter = TextPainter(
          text: TextSpan(
            text: valueFormatter,
            style: enableAnimation.value > 0
                ? themeData.scaleTextStyle
                : themeData.disabledScaleTextStyle,
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout(maxWidth: 100);
        // drawn x
        var x = center.dx - painter.size.width / 2;
        if (index == 0) {
          x = center.dx - trackHeight;
        } else if (index == themeData.divisions) {
          x = center.dx - painter.size.width + trackHeight;
        }
        painter.paint(
          context.canvas,
          Offset(x, center.dy - painter.height - 14),
        );
      }
      // draw ticks
      context.canvas.drawCircle(center, tickMarkRadius, paint);
    }
  }
}

/// Base track shape that provides an implementation of [getPreferredRect] for
/// default sizing.
///
/// The height is set from [SliderThemeData.trackHeight] and the width of the
/// parent box less the larger of the widths of [SliderThemeData.rangeThumbShape] and
/// [SliderThemeData.overlayShape].
///
/// See also:
///
///  * [RectangularRangeSliderTrackShape], which is a track shape with sharp
///    rectangular edges
mixin TDBaseRangeSliderTrackShape {
  /// Returns a rect that represents the track bounds that fits within the
  /// [Slider].
  ///
  /// The width is the width of the [Slider] or [RangeSlider], but padded by
  /// the max of the overlay and thumb radius. The height is defined by the
  /// [SliderThemeData.trackHeight].
  ///
  /// The [Rect] is centered both horizontally and vertically within the slider
  /// bounds.
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(sliderTheme.rangeThumbShape != null);
    assert(sliderTheme.overlayShape != null);
    final thumbWidth = sliderTheme.rangeThumbShape!
        .getPreferredSize(isEnabled, isDiscrete)
        .width;
    final overlayWidth = sliderTheme.overlayShape!
        .getPreferredSize(isEnabled, isDiscrete)
        .width;
    final trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final trackLeft = offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackRight =
        trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final trackBottom = trackTop + trackHeight;
    final rect = Rect.fromLTRB(
      math.min(trackLeft, trackRight),
      trackTop,
      math.max(trackLeft, trackRight),
      trackBottom,
    );
    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    return rect;
  }
}

/// The default shape of a [MyRangeSlider]'s track.
///
/// It paints a solid colored rectangle with rounded edges, vertically centered
/// in the `parentBox`. The track rectangle extends to the bounds of the
/// `parentBox`, but is padded by the larger of [RoundSliderOverlayShape]'s
/// radius and [RoundRangeSliderThumbShape]'s radius. The height is defined by
/// the [SliderThemeData.trackHeight]. The color is determined by the
/// [RangeSlider]'s enabled state and the track segment's active state which are
/// defined by:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// {@macro flutter.material.RangeSliderTickMarkShape.paint.trackSegment}
///
/// ![A range slider widget, consisting of 5 divisions and showing the rounded rect range slider track shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/rounded_rect_range_slider_track_shape.png)
///
/// See also:
///
///  * [RangeSlider], for the component that is meant to display this shape.
///  * [SliderThemeData], where an instance of this class is set to inform the
///    slider of the visual details of the its track.
///  * [RangeSliderTrackShape], which can be used to create custom shapes for
///    the [RangeSlider]'s track.
///  * [RectangularRangeSliderTrackShape], for a similar track with sharp edges.
class MyRoundedRectRangeSliderTrackShape extends RangeSliderTrackShape
    with TDBaseRangeSliderTrackShape {
  /// Create a slider track with rounded outer edges.
  ///
  /// The middle track segment is the selected range and is active, and the two
  /// outer track segments are inactive.
  const MyRoundedRectRangeSliderTrackShape({required this.themeData});

  final MySliderThemeData themeData;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 0,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Offset leftThumbOffset;
    final Offset rightThumbOffset;
    switch (textDirection) {
      case TextDirection.ltr:
        leftThumbOffset = startThumbCenter;
        rightThumbOffset = endThumbCenter;
      case TextDirection.rtl:
        leftThumbOffset = endThumbCenter;
        rightThumbOffset = startThumbCenter;
    }
    final thumbSize = sliderTheme.rangeThumbShape!.getPreferredSize(
      isEnabled,
      isDiscrete,
    );
    final thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    themeData.sliderMeasureData.trackerRect = trackRect;

    final trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        leftThumbOffset.dx,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
      ),
      inactivePaint,
    );
    context.canvas.drawRect(
      Rect.fromLTRB(
        leftThumbOffset.dx,
        trackRect.top - (additionalActiveTrackHeight / 2),
        rightThumbOffset.dx,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
      ),
      activePaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rightThumbOffset.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );
  }
}

/// The default shape of a [RangeSlider]'s thumbs.
///
/// There is a shadow for the resting and pressed state.
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider thumb shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_thumb_shape.png)
///
/// See also:
///
///  * [RangeSlider], which includes thumbs defined by this shape.
///  * [SliderTheme], which can be used to configure the thumb shapes of all
///    range sliders in a widget subtree.
class MyRoundRangeSliderThumbShape extends RangeSliderThumbShape {
  /// Create a slider thumb that draws a circle.
  const MyRoundRangeSliderThumbShape({
    required this.context,
    required this.themeData,
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 3.0,
    this.pressedElevation = 3.0,
  });

  final BuildContext context;

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius].
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  final double pressedElevation;

  final MySliderThemeData themeData;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
      isEnabled ? enabledThumbRadius : _disabledThumbRadius,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final radius = radiusTween.evaluate(enableAnimation);
    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop ?? false) {
      final strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor!
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final color = colorTween.evaluate(enableAnimation)!;

    final evaluatedElevation = isPressed!
        ? elevationTween.evaluate(activationAnimation)
        : elevation;
    final shadowPath = Path()
      ..addArc(
        Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
        0,
        math.pi * 2,
      );

    final paintShadows = true;
    if (paintShadows) {
      canvas.drawShadow(
        shadowPath,
        const Color.fromRGBO(0, 0, 0, 0.5),
        evaluatedElevation,
        true,
      );
    }
    if (themeData.showThumbValue &&
        themeData.sliderMeasureData.trackerRect != null) {
      final trackerRect = themeData.sliderMeasureData.trackerRect!;
      final ratio =
          (center.dx - trackerRect.left) /
          (trackerRect.right - trackerRect.left);

      final value = (themeData.max - themeData.min) * ratio + themeData.min;

      final formatterValue = themeData.scaleFormatter == null
          ? value.toStringAsFixed(2)
          : themeData.scaleFormatter!(value);

      final painter = TextPainter(
        text: TextSpan(
          text: formatterValue,
          style: enableAnimation.value > 0
              ? themeData.thumbTextStyle
              : themeData.disabledThumbTextStyle,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 100);
      final textPosition = Offset(
        center.dx - painter.width / 2,
        center.dy - painter.height - 14,
      );
      painter.paint(context.canvas, textPosition);
      if (thumb == Thumb.start) {
        themeData.sliderMeasureData.startRangeThumbTextRect = Rect.fromLTWH(
          center.dx - painter.width / 2,
          center.dy - painter.height - 14,
          painter.width,
          painter.height,
        );
      } else {
        themeData.sliderMeasureData.endRangeThumbTextRect = Rect.fromLTWH(
          center.dx - painter.width / 2,
          center.dy - painter.height - 14,
          painter.width,
          painter.height,
        );
      }
    }

    canvas
      ..drawCircle(center, radius, Paint()..color = color)
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = this.context.colorScheme.primary,
      );
  }
}

/// The default shape of each [RangeSlider] tick mark.
///
/// Tick marks are only displayed if the slider is discrete, which can be done
/// by setting the [RangeSlider.divisions] to an integer value.
///
/// It paints a solid circle, centered on the track.
/// The color is determined by the [Slider]'s enabled state and track's active
/// states. These colors are defined in:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider tick mark shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_tick_mark_shape.png )
///
/// See also:
///
///  * [RangeSlider], which includes tick marks defined by this shape.
///  * [SliderTheme], which can be used to configure the tick mark shape of all
///    sliders in a widget subtree.
class MyRoundRangeSliderTickMarkShape extends RangeSliderTickMarkShape {
  /// Create a range slider tick mark that draws a circle.
  const MyRoundRangeSliderTickMarkShape({
    required this.themeData,
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  final MySliderThemeData themeData;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) {
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);

    final bool isBetweenThumbs;
    switch (textDirection) {
      case TextDirection.ltr:
        isBetweenThumbs =
            startThumbCenter.dx < center.dx && center.dx < endThumbCenter.dx;
      case TextDirection.rtl:
        isBetweenThumbs =
            endThumbCenter.dx < center.dx && center.dx < startThumbCenter.dx;
    }
    final begin = isBetweenThumbs
        ? sliderTheme.disabledActiveTickMarkColor
        : sliderTheme.disabledInactiveTickMarkColor;
    final end = isBetweenThumbs
        ? sliderTheme.activeTickMarkColor
        : sliderTheme.inactiveTickMarkColor;
    final paint = Paint()
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius =
        getPreferredSize(isEnabled: isEnabled, sliderTheme: sliderTheme).width /
        2;
    if (tickMarkRadius > 0 && themeData.showScaleValue) {
      assert(themeData.divisions != null);
      final rect = sliderTheme.rangeTrackShape?.getPreferredRect(
        parentBox: parentBox,
        sliderTheme: sliderTheme,
      );
      if (rect != null && themeData.divisions! > 0) {
        //轨道的高度
        final trackHeight = rect.bottom - rect.top;
        //最左边的刻度中心到最右边刻度中心的长度
        final markWidth = (rect.right - rect.left) - trackHeight;
        //最左边刻度的起点
        final markStart = rect.left + trackHeight / 2;
        //每个刻度的宽度
        final perWidth = markWidth / themeData.divisions!;
        assert(perWidth > 0);
        //计算当前是第几个刻度
        final index = ((center.dx - markStart) / perWidth).round();
        //获取当前刻度的值
        final value =
            themeData.min +
            index * ((themeData.max - themeData.min) / themeData.divisions!);
        //格式化数值
        final valueFormatter = themeData.scaleFormatter != null
            ? themeData.scaleFormatter!(value)
            : value.toString();
        //绘制刻度的值
        final painter = TextPainter(
          text: TextSpan(
            text: valueFormatter,
            style: enableAnimation.value > 0
                ? themeData.scaleTextStyle
                : themeData.disabledScaleTextStyle,
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout(maxWidth: 100);
        //绘制的x
        var x = center.dx - painter.size.width / 2;
        if (index == 0) {
          x = center.dx - trackHeight;
        } else if (index == themeData.divisions) {
          x = center.dx - painter.size.width + trackHeight;
        }
        painter.paint(
          context.canvas,
          Offset(x, center.dy - painter.height - 14),
        );
      }
      context.canvas.drawCircle(center, tickMarkRadius, paint);
    }
  }
}

mixin TDCapsuleTrackShape {
  Offset adjustThumbCenter(Offset thumbCenter, Rect trackRect) {
    final value = (thumbCenter.dx - trackRect.left) / trackRect.width;
    final x = value * (trackRect.width - 24) + trackRect.left + 12;
    return Offset(x, thumbCenter.dy);
  }
}

abstract interface class TDCapsuleRectThemeData {
  TDCapsuleRectThemeData({required this.themeData});
  final MySliderThemeData themeData;
}

mixin TDCapsuleRectAdjustment implements TDCapsuleRectThemeData {
  bool hasDivisions() {
    return themeData.divisions != null && themeData.divisions! > 0;
  }

  num extraPadding({num trackHeight = 24}) {
    if (hasDivisions()) return 0;

    return trackHeight / 2;
  }

  num trackPadding({num trackHeight = 24}) {
    if (hasDivisions()) return trackHeight / 2;

    return 0;
  }
}

class MyCapsuleRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape, TDCapsuleTrackShape, TDCapsuleRectAdjustment {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const MyCapsuleRectSliderTrackShape({
    required this.themeData,
    this.trackColorWhenShowScale = const Color(0xFFE7E7E7),
  });

  final Color trackColorWhenShowScale;

  @override
  final MySliderThemeData themeData;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final rect = super.getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final padding = extraPadding();
    final realRect = Rect.fromLTRB(
      rect.left + padding,
      rect.top,
      rect.right - padding,
      rect.bottom,
    );
    themeData.sliderMeasureData.trackerRect = realRect;
    return realRect;
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 3,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }
    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final showScale = themeData.showScaleValue;
    final activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: showScale ? trackColorWhenShowScale : sliderTheme.inactiveTrackColor,
    );
    final activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint activeTrackPaint;
    final Paint inactiveTrackPaint;

    switch (textDirection) {
      case TextDirection.ltr:
        activeTrackPaint = activePaint;
        inactiveTrackPaint = inactivePaint;
      case TextDirection.rtl:
        activeTrackPaint = inactivePaint;
        inactiveTrackPaint = activePaint;
    }

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    themeData.sliderMeasureData.trackerRect = trackRect;
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular(
      (trackRect.height - additionalActiveTrackHeight) / 2,
    );

    final padding = extraPadding();
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left - padding,
        trackRect.top,
        trackRect.right + padding,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactiveTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left - padding + additionalActiveTrackHeight,
        trackRect.top + additionalActiveTrackHeight,
        thumbCenter.dx,
        trackRect.bottom - additionalActiveTrackHeight,
        topLeft: activeTrackRadius,
        bottomLeft: activeTrackRadius,
      ),
      activeTrackPaint,
    );
    if (themeData.showScaleValue) {
      final inactiveSecondPaint = Paint()
        ..color = sliderTheme.inactiveTrackColor!;
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          thumbCenter.dx,
          trackRect.top + additionalActiveTrackHeight,
          trackRect.right + padding - additionalActiveTrackHeight,
          trackRect.bottom - additionalActiveTrackHeight,
          topRight: activeTrackRadius,
          bottomRight: activeTrackRadius,
        ),
        inactiveSecondPaint,
      );
    }
  }
}

class MyCapsuleSliderThumbShape extends SliderComponentShape
    with TDCapsuleRectAdjustment {
  /// Create a slider thumb that draws a circle.
  const MyCapsuleSliderThumbShape({
    required this.context,
    required this.themeData,
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 4.0,
    this.pressedElevation = 4.0,
  });

  final BuildContext context;

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  final MySliderThemeData themeData;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
      isEnabled ? enabledThumbRadius : _disabledThumbRadius,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final color = colorTween.evaluate(enableAnimation)!;
    final radius = radiusTween.evaluate(enableAnimation);

    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );
    final evaluatedElevation = elevationTween.evaluate(activationAnimation);
    final path = Path()
      ..addArc(
        Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
        0,
        math.pi * 2,
      );

    final paintShadows = true;

    if (paintShadows) {
      canvas.drawShadow(
        path,
        const Color.fromRGBO(0, 0, 0, 0.5),
        evaluatedElevation,
        true,
      );
    }
    // draw thumb text
    if (themeData.showThumbValue &&
        themeData.sliderMeasureData.trackerRect != null) {
      final trackerRect = themeData.sliderMeasureData.trackerRect!;
      final padding = trackPadding();
      final ratio =
          (center.dx - trackerRect.left - padding) /
          (trackerRect.right - trackerRect.left - padding * 2);
      //计算滑块的值
      final value = (themeData.max - themeData.min) * ratio + themeData.min;
      //格式化显示
      final formatterValue = themeData.scaleFormatter == null
          ? value.toStringAsFixed(2)
          : themeData.scaleFormatter!(value);
      //绘制数值
      final painter = TextPainter(
        text: TextSpan(
          text: formatterValue,
          style: enableAnimation.value > 0
              ? themeData.thumbTextStyle
              : themeData.disabledThumbTextStyle,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 100);
      painter.paint(
        context.canvas,
        Offset(
          center.dx - painter.size.width / 2,
          center.dy - painter.height - 14,
        ),
      );
    }
    final paint = Paint()..color = color;
    canvas
      ..drawCircle(center, radius, paint)
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = this.context.colorScheme.primary,
      );
  }
}

class MyCapsuleSliderTickMarkShape extends SliderTickMarkShape {
  /// Create a slider tick mark that draws a circle.
  const MyCapsuleSliderTickMarkShape({
    required this.themeData,
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  final MySliderThemeData themeData;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    // The tick marks are tiny circles. If no radius is provided, then the
    // radius is defaulted to be a fraction of the
    // [SliderThemeData.trackHeight]. The fraction is 1/4.
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    // Color? begin;
    // Color? end;
    // // final paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    // final paint = Paint()
    //   ..strokeWidth = 2
    //   ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius =
        getPreferredSize(isEnabled: isEnabled, sliderTheme: sliderTheme).width /
        2;
    var dx = center.dx;
    if (tickMarkRadius > 0 && themeData.showScaleValue) {
      assert(themeData.divisions != null);
      final rect = sliderTheme.trackShape?.getPreferredRect(
        parentBox: parentBox,
        sliderTheme: sliderTheme,
      );
      if (rect != null && themeData.divisions! > 0) {
        //轨道的高度
        final trackHeight = rect.bottom - rect.top;
        //最左边的刻度中心到最右边刻度中心的长度
        final markWidth = (rect.right - rect.left) - trackHeight;
        //最左边刻度的起点
        final markStart = rect.left + trackHeight / 2;
        //每个刻度的宽度
        final perWidth = markWidth / themeData.divisions!;
        assert(perWidth > 0);
        //计算当前是第几个刻度
        final index = ((center.dx - markStart) / perWidth).round();
        //获取当前刻度的值
        final value =
            themeData.min +
            index * ((themeData.max - themeData.min) / themeData.divisions!);
        //修正x坐标
        dx =
            rect.left +
            index * ((rect.right - rect.left) / themeData.divisions!);
        //格式化数值
        final valueFormatter = themeData.scaleFormatter != null
            ? themeData.scaleFormatter!(value)
            : value.toString();
        //绘制刻度的值
        final painter = TextPainter(
          text: TextSpan(
            text: valueFormatter,
            style: enableAnimation.value > 0
                ? themeData.scaleTextStyle
                : themeData.disabledScaleTextStyle,
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout(maxWidth: 100);
        final x = dx - painter.size.width / 2;
        painter.paint(
          context.canvas,
          Offset(x, center.dy - painter.height - 16),
        );

        // 第一个和最后一个不展示
        if (index > 0 && index < themeData.divisions!) {
          final isBetweenThumbs = thumbCenter.dx > center.dx;
          final begin = isBetweenThumbs
              ? sliderTheme.disabledActiveTickMarkColor
              : sliderTheme.disabledInactiveTickMarkColor;
          final end = isBetweenThumbs
              ? sliderTheme.activeTickMarkColor
              : sliderTheme.inactiveTickMarkColor;
          final paint = Paint()
            ..strokeWidth = 2
            ..color = ColorTween(
              begin: begin,
              end: end,
            ).evaluate(enableAnimation)!;
          context.canvas.drawLine(
            Offset(dx, themeData.sliderMeasureData.trackerRect!.top + 3),
            Offset(dx, themeData.sliderMeasureData.trackerRect!.bottom - 3),
            paint,
          );
        }
      }
    }
  }
}

/// The default shape of a [MyRangeSlider]'s track.
///
/// It paints a solid colored rectangle with rounded edges, vertically centered
/// in the `parentBox`. The track rectangle extends to the bounds of the
/// `parentBox`, but is padded by the larger of [RoundSliderOverlayShape]'s
/// radius and [RoundRangeSliderThumbShape]'s radius. The height is defined by
/// the [SliderThemeData.trackHeight]. The color is determined by the
/// [RangeSlider]'s enabled state and the track segment's active state which are
/// defined by:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// {@macro flutter.material.RangeSliderTickMarkShape.paint.trackSegment}
///
/// ![A range slider widget, consisting of 5 divisions and showing the rounded rect range slider track shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/rounded_rect_range_slider_track_shape.png)
///
/// See also:
///
///  * [RangeSlider], for the component that is meant to display this shape.
///  * [SliderThemeData], where an instance of this class is set to inform the
///    slider of the visual details of the its track.
///  * [RangeSliderTrackShape], which can be used to create custom shapes for
///    the [RangeSlider]'s track.
///  * [RectangularRangeSliderTrackShape], for a similar track with sharp edges.
class MyCapsuleRectRangeSliderTrackShape extends RangeSliderTrackShape
    with TDBaseRangeSliderTrackShape, TDCapsuleRectAdjustment {
  /// Create a slider track with rounded outer edges.
  ///
  /// The middle track segment is the selected range and is active, and the two
  /// outer track segments are inactive.
  const MyCapsuleRectRangeSliderTrackShape({
    required this.themeData,
    this.trackColorWhenShowScale = const Color(0xFFE7E7E7),
  });
  final Color trackColorWhenShowScale;

  @override
  final MySliderThemeData themeData;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final rect = super.getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final padding = extraPadding();
    return Rect.fromLTRB(
      rect.left + padding,
      rect.top,
      rect.right - padding,
      rect.bottom,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 3,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }
    final showScale = themeData.showScaleValue;
    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: showScale ? trackColorWhenShowScale : sliderTheme.inactiveTrackColor,
    );
    final activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Offset leftThumbOffset;
    final Offset rightThumbOffset;
    switch (textDirection) {
      case TextDirection.ltr:
        leftThumbOffset = startThumbCenter;
        rightThumbOffset = endThumbCenter;
      case TextDirection.rtl:
        leftThumbOffset = endThumbCenter;
        rightThumbOffset = startThumbCenter;
    }
    final thumbSize = sliderTheme.rangeThumbShape!.getPreferredSize(
      isEnabled,
      isDiscrete,
    );
    final thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    themeData.sliderMeasureData.trackerRect = trackRect;

    final trackRadius = Radius.circular(trackRect.height / 2);
    final padding = extraPadding();

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left - padding,
        trackRect.top,
        trackRect.right + padding,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );
    final activeTrackRadius = Radius.circular(
      trackRect.height / 2 - additionalActiveTrackHeight,
    );
    final inactiveSecondPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;
    if (showScale) {
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          trackRect.left + additionalActiveTrackHeight,
          trackRect.top + additionalActiveTrackHeight,
          rightThumbOffset.dx,
          trackRect.bottom - additionalActiveTrackHeight,
          topLeft: activeTrackRadius,
          bottomLeft: activeTrackRadius,
        ),
        inactiveSecondPaint,
      );
    }
    context.canvas.drawRect(
      Rect.fromLTRB(
        leftThumbOffset.dx,
        trackRect.top + additionalActiveTrackHeight,
        rightThumbOffset.dx,
        trackRect.bottom - additionalActiveTrackHeight,
      ),
      activePaint,
    );
    if (themeData.showScaleValue) {
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          rightThumbOffset.dx,
          trackRect.top + additionalActiveTrackHeight,
          trackRect.right - additionalActiveTrackHeight,
          trackRect.bottom - additionalActiveTrackHeight,
          topRight: activeTrackRadius,
          bottomRight: activeTrackRadius,
        ),
        inactiveSecondPaint,
      );
    }
  }
}

/// The default shape of a [RangeSlider]'s thumbs.
///
/// There is a shadow for the resting and pressed state.
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider thumb shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_thumb_shape.png)
///
/// See also:
///
///  * [RangeSlider], which includes thumbs defined by this shape.
///  * [SliderTheme], which can be used to configure the thumb shapes of all
///    range sliders in a widget subtree.
class MyCapsuleRangeSliderThumbShape extends RangeSliderThumbShape
    with TDCapsuleRectAdjustment {
  /// Create a slider thumb that draws a circle.
  const MyCapsuleRangeSliderThumbShape({
    required this.context,
    required this.themeData,
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 3.0,
    this.pressedElevation = 3.0,
  });

  final BuildContext context;

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius].
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  final double pressedElevation;

  @override
  final MySliderThemeData themeData;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
      isEnabled ? enabledThumbRadius : _disabledThumbRadius,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required SliderThemeData sliderTheme,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final radius = radiusTween.evaluate(enableAnimation);
    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop ?? false) {
      final strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor!
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final color = colorTween.evaluate(enableAnimation)!;

    final evaluatedElevation = isPressed!
        ? elevationTween.evaluate(activationAnimation)
        : elevation;
    final shadowPath = Path()
      ..addArc(
        Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
        0,
        math.pi * 2,
      );

    final paintShadows = true;
    if (paintShadows) {
      canvas.drawShadow(
        shadowPath,
        const Color.fromRGBO(0, 0, 0, 0.5),
        evaluatedElevation,
        true,
      );
    }
    if (themeData.showThumbValue &&
        themeData.sliderMeasureData.trackerRect != null) {
      final trackerRect = themeData.sliderMeasureData.trackerRect!;
      final padding = trackPadding();
      final ratio =
          (center.dx - trackerRect.left - padding) /
          (trackerRect.right - trackerRect.left - padding * 2);
      //计算滑块的值
      final value = (themeData.max - themeData.min) * ratio + themeData.min;
      //格式化显示
      final formatterValue = themeData.scaleFormatter == null
          ? value.toStringAsFixed(2)
          : themeData.scaleFormatter!(value);
      //绘制数值
      final painter = TextPainter(
        text: TextSpan(text: formatterValue, style: themeData.thumbTextStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 100);
      painter.paint(
        context.canvas,
        Offset(
          center.dx - painter.size.width / 2,
          center.dy - painter.height - 16,
        ),
      );
    }

    canvas
      ..drawCircle(center, radius, Paint()..color = color)
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = this.context.colorScheme.primary,
      );
  }
}

/// The default shape of each [RangeSlider] tick mark.
///
/// Tick marks are only displayed if the slider is discrete, which can be done
/// by setting the [RangeSlider.divisions] to an integer value.
///
/// It paints a solid circle, centered on the track.
/// The color is determined by the [Slider]'s enabled state and track's active
/// states. These colors are defined in:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider tick mark shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_tick_mark_shape.png )
///
/// See also:
///
///  * [RangeSlider], which includes tick marks defined by this shape.
///  * [SliderTheme], which can be used to configure the tick mark shape of all
///    sliders in a widget subtree.
class MyCapsuleRangeSliderTickMarkShape extends RangeSliderTickMarkShape {
  /// Create a range slider tick mark that draws a circle.
  const MyCapsuleRangeSliderTickMarkShape({
    required this.themeData,
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  final MySliderThemeData themeData;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) {
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);

    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius =
        getPreferredSize(isEnabled: isEnabled, sliderTheme: sliderTheme).width /
        2;
    var dx = center.dx;
    if (tickMarkRadius > 0 && themeData.showScaleValue) {
      assert(themeData.divisions != null);
      final rect = sliderTheme.rangeTrackShape?.getPreferredRect(
        parentBox: parentBox,
        sliderTheme: sliderTheme,
      );
      if (rect != null && themeData.divisions! > 0) {
        //轨道的高度
        final trackHeight = rect.bottom - rect.top;
        //最左边的刻度中心到最右边刻度中心的长度
        final markWidth = (rect.right - rect.left) - trackHeight;
        //最左边刻度的起点
        final markStart = rect.left + trackHeight / 2;
        //每个刻度的宽度
        final perWidth = markWidth / themeData.divisions!;
        assert(perWidth > 0);
        //计算当前是第几个刻度
        final index = ((center.dx - markStart) / perWidth).round();
        //获取当前刻度的值
        final value =
            themeData.min +
            index * ((themeData.max - themeData.min) / themeData.divisions!);
        //格式化数值
        final valueFormatter = themeData.scaleFormatter != null
            ? themeData.scaleFormatter!(value)
            : value.toString();
        //修正x坐标
        dx =
            rect.left +
            index * ((rect.right - rect.left) / themeData.divisions!);
        //绘制刻度的值
        final painter = TextPainter(
          text: TextSpan(
            text: valueFormatter,
            style: enableAnimation.value > 0
                ? themeData.scaleTextStyle
                : themeData.disabledScaleTextStyle,
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout(maxWidth: 100);
        final x = dx - painter.size.width / 2;
        painter.paint(
          context.canvas,
          Offset(x, center.dy - painter.height - 16),
        );

        // 第一个和最后一个不展示
        if (index > 0 && index < themeData.divisions!) {
          final bool isBetweenThumbs;
          switch (textDirection) {
            case TextDirection.ltr:
              isBetweenThumbs =
                  startThumbCenter.dx < center.dx &&
                  center.dx < endThumbCenter.dx;
            case TextDirection.rtl:
              isBetweenThumbs =
                  endThumbCenter.dx < center.dx &&
                  center.dx < startThumbCenter.dx;
          }
          final begin = isBetweenThumbs
              ? sliderTheme.disabledActiveTickMarkColor
              : sliderTheme.disabledInactiveTickMarkColor;
          final end = isBetweenThumbs
              ? sliderTheme.activeTickMarkColor
              : sliderTheme.inactiveTickMarkColor;
          final paint = Paint()
            ..strokeWidth = 2
            ..color = ColorTween(
              begin: begin,
              end: end,
            ).evaluate(enableAnimation)!;
          context.canvas.drawLine(
            Offset(dx, themeData.sliderMeasureData.trackerRect!.top + 3),
            Offset(dx, themeData.sliderMeasureData.trackerRect!.bottom - 3),
            paint,
          );
        }
      }
    }
  }
}
