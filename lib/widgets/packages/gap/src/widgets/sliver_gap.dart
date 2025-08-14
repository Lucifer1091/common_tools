import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../rendering/sliver_gap.dart';
import 'gap.dart';

/// A sliver that takes a fixed amount of space.
///
/// See also:
///
///  * [Gap], the render box version of this widget.
class SliverGap extends LeafRenderObjectWidget {
  /// Creates a sliver that takes a fixed [mainAxisExtent] of space.
  ///
  /// The [mainAxisExtent] must not be null and must be positive.
  const SliverGap(this.mainAxisExtent, {super.key, this.color})
    : assert(
        mainAxisExtent >= 0 && mainAxisExtent < double.infinity,
        'mainAxisExtent must be non-negative and less than infinity',
      );

  /// The amount of space this widget takes in the direction of the parent.
  ///
  /// Must not be null and must be positive.
  final double mainAxisExtent;

  /// The color used to fill the gap.
  final Color? color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverGap(mainAxisExtent: mainAxisExtent, color: color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverGap renderObject) {
    renderObject
      ..mainAxisExtent = mainAxisExtent
      ..color = color;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('mainAxisExtent', mainAxisExtent))
      ..add(ColorProperty('color', color));
  }
}

/// Animated version of [SliverGap] that gradually changes its values over a period of time.
///
/// The [SliverAnimatedGap] will automatically animate between the old and
/// new values of properties when they change using the provided curve and
/// duration. Properties that are null are not animated.
///
/// See also:
///
///  * [AnimatedGap], the [RenderBox] version of this widget.
class SliverAnimatedGap extends ImplicitlyAnimatedWidget {
  /// Creates a [SliverGap] that animates its parameters implicitly.
  ///
  /// The [curve] and [duration] arguments must not be null.
  const SliverAnimatedGap(
    this.mainAxisExtent, {
    required super.duration,
    super.key,
    this.color,
    super.curve,
    super.onEnd,
  }) : assert(
         mainAxisExtent >= 0 && mainAxisExtent < double.infinity,
         'mainAxisExtent must be non-negative and less than infinity',
       );

  /// {@macro sliverGap.mainAxisExtent}
  final double mainAxisExtent;

  /// {@macro sliverGap.color}
  final Color? color;

  @override
  AnimatedWidgetBaseState<SliverAnimatedGap> createState() =>
      _SliverAnimatedGapState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('mainAxisExtent', mainAxisExtent))
      ..add(ColorProperty('color', color, defaultValue: null));
  }
}

class _SliverAnimatedGapState
    extends AnimatedWidgetBaseState<SliverAnimatedGap> {
  Tween<double>? _mainAxisExtent;
  ColorTween? _color;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _mainAxisExtent =
        visitor(
              _mainAxisExtent,
              widget.mainAxisExtent,
              (value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _color =
        visitor(
              _color,
              widget.color,
              (value) => ColorTween(begin: value as Color),
            )
            as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final mainAxisExtent = _mainAxisExtent
        ?.evaluate(animation)
        .clamp(0.0, double.infinity);

    final color = _color?.evaluate(animation);

    return SliverGap(mainAxisExtent ?? 0, color: color);
  }
}
