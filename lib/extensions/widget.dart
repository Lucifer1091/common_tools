part of 'extensions.dart';

extension WidgetExtensions on Widget {
  RepaintBoundary get repaintBoundary => RepaintBoundary(child: this);

  MouseRegion get mouseRegion =>
      MouseRegion(cursor: SystemMouseCursors.click, child: this);

  PreferredSize get preferredSize {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: this,
    );
  }

  Widget center({
    Key? key,
    double? widthFactor,
    double? heightFactor,
    bool enabled = true,
  }) =>
      Center(
        key: key,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: this,
      ).showIfOrNull(enabled) ??
      this;

  Widget expanded({int flex = 1, bool enabled = true}) =>
      Expanded(flex: flex, child: this).showIfOrNull(enabled) ?? this;

  Widget flexible({
    int flex = 1,
    FlexFit fit = FlexFit.loose,
    bool enabled = true,
  }) =>
      Flexible(flex: flex, fit: fit, child: this).showIfOrNull(enabled) ?? this;

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
  }) =>
      Padding(
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
      ).showIfOrNull(enabled) ??
      this;

  Widget opacity({required double opacity, bool enabled = true}) =>
      Opacity(opacity: opacity, child: this).showIfOrNull(enabled) ?? this;

  /// add rotation to parent widget
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

  /// add scaling to parent widget
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

  /// add translate to parent widget
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

  Widget sizedBox({
    double? width,
    double? height,
    bool enabled = true,
    Key? key,
  }) =>
      SizedBox(
        key: key,
        width: width,
        height: height,
        child: this,
      ).showIfOrNull(enabled) ??
      this;

  /// add FittedBox to parent widget
  Widget fit({BoxFit? fit, AlignmentGeometry? alignment}) {
    return FittedBox(
      fit: fit ?? BoxFit.contain,
      alignment: alignment ?? Alignment.center,
      child: this,
    );
  }

  /// Returns a widget that is shown conditionally based on the [condition].
  /// If [condition] is true, the widget is returned; otherwise, null is returned
  Widget? showIfOrNull(bool condition) {
    if (condition) return this;

    return null;
  }

  /// Returns a widget that is shown conditionally based on the [condition].
  /// If [condition] is true, the widget is returned; otherwise, an [EmptyPlaceholder] widget is returned.
  /// This is useful for cases where you want to display an empty placeholder when the condition is
  Widget showIfOrEmpty(bool condition) {
    if (condition) return this;

    return const EmptyPlaceholder();
  }

  /// Returns a widget that is disabled based on the [disable] parameter.
  /// If [disable] is true, the widget is rendered with reduced opacity using the [Opacity] widget.
  /// If [disable] is false or null, the widget is rendered normally.
  Widget disabled({bool disable = true, double opacity = 0.2}) => IgnorePointer(
    ignoring: disable,
    child: Opacity(opacity: disable ? opacity : 1, child: this),
  );

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
  }) =>
      GestureDetector(
        key: key,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        behavior:
            opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
        child: this,
      ).mouseRegion;

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

  SliverToBoxAdapter get sliverToBoxAdapter => SliverToBoxAdapter(child: this);

  SliverFillViewport get sliverFillViewPort =>
      SliverFillViewport(delegate: SliverChildListDelegate([this]));

  SliverFillRemaining get sliverFillRemaining =>
      SliverFillRemaining(fillOverscroll: true, child: this);
}

extension TextStyleX on TextStyle {
  /// A method to underline a text with a customizable [distance] between the text
  /// and underline. The [color], [thickness] and [style] can be set
  /// as the decorations of a [TextStyle].
  TextStyle underlined({
    Color? color,
    double distance = 1,
    double thickness = 1,
    TextDecorationStyle style = TextDecorationStyle.solid,
  }) {
    return copyWith(
      shadows: [
        Shadow(color: this.color ?? Colors.black, offset: Offset(0, -distance)),
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationThickness: thickness,
      decorationColor: color ?? this.color,
      decorationStyle: style,
    );
  }
}

/// Extension on IconData to create an Icon widget with customizable size and color.
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
  /// final editIcon = Icons.contact.edit(size: 24, color: Colors.blue);
  /// ```
  Icon edit({double? size, Color? color}) {
    return Icon(this, size: size, color: color);
  }
}

extension EdgeInsetsX on EdgeInsets {
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
