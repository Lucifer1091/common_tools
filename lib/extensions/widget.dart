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
    double? widthFactor,
    double? heightFactor,
    bool enabled = true,
  }) =>
      enabled
          ? Center(
            widthFactor: widthFactor,
            heightFactor: heightFactor,
            child: this,
          )
          : this;

  Widget expanded({int flex = 1, bool enabled = true}) =>
      enabled ? Expanded(flex: flex, child: this) : this;

  Widget flexible({
    int flex = 1,
    FlexFit fit = FlexFit.loose,
    bool enabled = true,
  }) => enabled ? Flexible(flex: flex, fit: fit, child: this) : this;

  Widget padding({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? vertical,
    double? horizontal,
    bool enabled = true,
    Key? key,
  }) =>
      enabled
          ? Padding(
            key: key,
            padding: EdgeInsets.all(0).except(
              left: left,
              top: top,
              right: right,
              bottom: bottom,
              vertical: vertical,
              horizontal: horizontal,
            ),
            child: this,
          )
          : this;

  Widget opacity({required double opacity, bool enabled = true}) =>
      enabled ? Opacity(opacity: opacity, child: this) : this;

  Widget sizedBox({
    double? width,
    double? height,
    bool enabled = true,
    Key? key,
  }) =>
      enabled
          ? SizedBox(key: key, width: width, height: height, child: this)
          : this;

  Widget? showIfOrNull(bool condition) {
    if (condition) return this;

    return null;
  }

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
