import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import '../../index.dart';

/// Fluent widget wrappers for quick composition.
extension WidgetExtensions on Widget {
  /// Wraps this widget with [RepaintBoundary].
  RepaintBoundary get repaintBoundary => RepaintBoundary(child: this);

  /// Wraps this widget with a clickable [MouseRegion].
  MouseRegion get mouseRegion {
    return MouseRegion(cursor: SystemMouseCursors.click, child: this);
  }

  /// Wraps this widget in a [PreferredSize] with default toolbar height.
  PreferredSize get preferredSize {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: this,
    );
  }

  /// Wraps this widget in [Center].
  ///
  /// Returns this widget unchanged when [enabled] is `false`.
  Widget center({
    Key? key,
    double? widthFactor,
    double? heightFactor,
    bool enabled = true,
  }) {
    if (!enabled) return this;
    return Center(
      key: key,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// Wraps this widget in [Expanded].
  ///
  /// Returns this widget unchanged when [enabled] is `false`.
  Widget expanded({int flex = 1, bool enabled = true}) {
    if (!enabled) return this;
    return Expanded(flex: flex, child: this);
  }

  /// Wraps this widget in [Flexible].
  ///
  /// Returns this widget unchanged when [enabled] is `false`.
  Widget flexible({
    int flex = 1,
    FlexFit fit = FlexFit.loose,
    bool enabled = true,
  }) {
    if (!enabled) return this;
    return Flexible(flex: flex, fit: fit, child: this);
  }

  /// Wraps this widget in [Padding].
  ///
  /// You can provide [all], axis-level ([vertical]/[horizontal]), or side-level
  /// values; more specific values override broader ones.
  /// Returns this widget unchanged when [enabled] is `false`.
  Widget padding({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? vertical,
    double? horizontal,
    bool enabled = true,
    Key? key,
  }) {
    if (!enabled) return this;
    return Padding(
      key: key,
      padding: EdgeInsets.all(all ?? 0).except(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        vertical: vertical,
        horizontal: horizontal,
      ),
      child: this,
    );
  }

  /// Wraps this widget with [ColoredBox].
  Widget colored({required Color color}) {
    return ColoredBox(color: color, child: this);
  }

  /// Wraps this widget in [Opacity].
  ///
  /// Returns this widget unchanged when [enabled] is `false`.
  Widget opacity({required double opacity, bool enabled = true}) {
    if (!enabled) return this;
    return Opacity(opacity: opacity, child: this);
  }

  /// Wraps this widget in [Align].
  Widget align({AlignmentGeometry? align}) {
    return Align(alignment: align ?? Alignment.center, child: this);
  }

  /// Wraps this widget in [Transform.rotate].
  Widget rotate({
    required double angle,
    bool transformHitTests = true,
    Offset? origin,
  }) {
    return Transform.rotate(
      origin: origin,
      angle: angle,
      transformHitTests: transformHitTests,
      child: this,
    );
  }

  /// Wraps this widget in [Transform.scale].
  Widget scale({
    required double scale,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
  }) {
    return Transform.scale(
      scale: scale,
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      child: this,
    );
  }

  /// Wraps this widget in [Transform.translate].
  Widget translate({
    required Offset offset,
    bool transformHitTests = true,
    Key? key,
  }) {
    return Transform.translate(
      offset: offset,
      transformHitTests: transformHitTests,
      key: key,
      child: this,
    );
  }

  /// Wraps this widget in [SizedBox].
  ///
  /// Returns this widget unchanged when [enabled] is `false`.
  Widget sizedBox({
    double? width,
    double? height,
    bool enabled = true,
    Key? key,
  }) {
    if (!enabled) return this;
    return SizedBox(key: key, width: width, height: height, child: this);
  }

  /// Wraps this widget in [FittedBox].
  Widget fit({BoxFit? fit, AlignmentGeometry? alignment}) {
    return FittedBox(
      fit: fit ?? BoxFit.contain,
      alignment: alignment ?? Alignment.center,
      child: this,
    );
  }

  /// Returns a widget that is shown conditionally based on the [condition].
  /// If [condition] is true, returns this widget; otherwise `null`.
  Widget? showIfOrNull(bool condition) {
    if (condition) return this;

    return null;
  }

  /// Returns a widget that is shown conditionally based on the [condition].
  /// If [condition] is true, returns this widget; otherwise [NoWidget].
  Widget showIfOrEmpty(bool condition) {
    if (condition) return this;

    return const SizedBox.shrink();
  }

  /// Returns a widget that is disabled based on the [disable] parameter.
  /// If [disable] is true, the widget is rendered with reduced opacity using the [Opacity] widget.
  /// If [disable] is false, the widget is rendered normally.
  Widget disabled({bool disable = true, double opacity = 0.2}) => IgnorePointer(
    ignoring: disable,
    child: Opacity(opacity: disable ? opacity : 1, child: this),
  );

  /// Wraps this widget in a [ConstrainedBox].
  ConstrainedBox constrained({
    double maxWidth = 450,
    double maxHeight = double.infinity,
    double? minHeight,
    double? minWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        minHeight: minHeight ?? 0,
        minWidth: minWidth ?? 0,
      ),
      child: this,
    );
  }

  /// Wraps the widget in a [GestureDetector] to handle tap and double-tap events.
  /// The [onTap] and [onDoubleTap] callbacks are optional.
  /// The [opaque] parameter determines the hit test behavior.
  Widget clickable({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    Key? key,
    bool opaque = true,
  }) {
    if (onTap == null && onDoubleTap == null) return this;

    return MyGestureDetector(
      key: key,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      child: this,
    );
  }

  /// Wraps this widget in [Tooltip].
  ///
  /// Set [showRichText] to render custom rich tooltip content.
  Tooltip tooltip({
    required String msg,
    bool showRichText = false,
    bool preferBelow = true,
    double? height,
    double? width,
  }) => Tooltip(
    message: showRichText ? null : msg,
    constraints: BoxConstraints(minHeight: height ?? 0),
    richMessage:
        showRichText
            ? WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(maxWidth: width ?? 300),
                child: Text(msg),
              ),
            )
            : null,
    decoration:
        showRichText
            ? const BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            )
            : null,
    preferBelow: preferBelow,
    child: this,
  );

  /// Applies foreground blur to this widget using [ImageFiltered].
  Widget blur({double? x, double? y}) => ImageFiltered(
    imageFilter: ImageFilter.blur(sigmaX: x ?? 3, sigmaY: y ?? 3),
    child: this,
  );

  /// Applies backdrop blur behind this widget.
  Widget bgBlur({double blurRadius = 10, double? sigmaX, double? sigmaY}) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: sigmaX ?? blurRadius,
        sigmaY: sigmaY ?? blurRadius,
      ),
      child: this,
    );
  }

  /// Applies a [ShaderMask] with [gradient] to this widget.
  Widget gradient(Gradient gradient, [BlendMode? blendMode]) => ShaderMask(
    shaderCallback: (Rect bounds) {
      return gradient.createShader(bounds);
    },
    blendMode: blendMode ?? BlendMode.dstIn,
    child: this,
  );

  /// Wraps this widget in [SliverToBoxAdapter].
  SliverToBoxAdapter get sliverToBoxAdapter => SliverToBoxAdapter(child: this);

  /// Wraps this widget in [SliverFillViewport].
  SliverFillViewport get sliverFillViewPort =>
      SliverFillViewport(delegate: SliverChildListDelegate([this]));

  /// Wraps this widget in [SliverFillRemaining] with overscroll fill enabled.
  SliverFillRemaining get sliverFillRemaining =>
      SliverFillRemaining(fillOverscroll: true, child: this);
}

/// Extra text-style helpers.
extension TextStyleX on TextStyle {
  /// A method to underline a text with a customizable [distance] between the text
  /// and underline. The [color], [thickness] and [style] can be set
  /// as the decorations of a [TextStyle].
  TextStyle underlined({
    bool enabled = true,
    Color? color,
    double distance = 1,
    double thickness = 1,
    TextDecorationStyle style = TextDecorationStyle.solid,
  }) {
    return enabled
        ? copyWith(
          shadows: [
            Shadow(
              color: this.color ?? Colors.black,
              offset: Offset(0, -distance),
            ),
          ],
          color: Colors.transparent,
          decoration: TextDecoration.underline,
          decorationThickness: thickness,
          decorationColor: color ?? this.color,
          decorationStyle: style,
        )
        : this;
  }
}

/// Helper to create an [Icon] directly from [IconData].
extension IconExtension on IconData {
  /// Creates an Icon widget using the current IconData with optional size and color.
  ///
  /// This extension simplifies the creation of Icon widgets with the given IconData, size, and color.
  ///
  /// Parameters:
  ///   - size: The size of the icon. If not provided, it uses the default size defined in the Icon widget.
  ///   - color: The color of the icon. If not provided, it uses the default color defined in the Icon widget.
  ///
  /// Example:
  /// ```dart
  /// final editIcon = Icons.edit.edit(size: 24, color: Colors.blue);
  /// ```
  Icon edit({double? size, Color? color}) {
    return Icon(this, size: size, color: color);
  }
}

/// EdgeInsets copy helper with selective overrides.
extension EdgeInsetsX on EdgeInsets {
  /// Returns a copy with selected side/axis values replaced.
  ///
  /// Axis values ([vertical]/[horizontal]) take precedence over side values.
  EdgeInsets except({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    return copyWith(
      top: vertical ?? top ?? this.top,
      bottom: vertical ?? bottom ?? this.bottom,
      left: horizontal ?? left ?? this.left,
      right: horizontal ?? right ?? this.right,
    );
  }
}
