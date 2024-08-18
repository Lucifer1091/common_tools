import 'package:flutter/material.dart';

import 'spaces.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    this.icon,
    this.selectedIcon,
    this.image,
    this.label,
    this.onTap,
    this.onTapDown,
    this.toolTip,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.labelStyle,
    this.disabledIconColor,
    this.disabledTextColor,
    this.disabledImageColorFilter = const ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    this.hoverColor,
    this.highlightColor,
    this.radius,
    this.isSelected = false,
  });

  /// Icon to display in button. Leave null to hide icon.
  final Widget? icon;

  /// Icon to display when its selected. Leave null to hide icon.
  final Widget? selectedIcon;

  /// Image to display between icon and label. Leave null to hide image.
  final Image? image;

  /// Text to display under icon. Leave null to hide text.
  final String? label;

  /// function to execute when user taps button. Leave null to disable button.
  final VoidCallback? onTap;

  /// To get the offset of the tap position
  final void Function(TapDownDetails, GlobalKey)? onTapDown;

  /// optional tooltip to display.
  final String? toolTip;

  /// cursor to display when user mouses over button
  ///
  /// Defaults to [SystemMouseCursors.click]
  final MouseCursor mouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool enableFeedback;

  // Check whether Icon is selected to change Icon color and text color
  final bool isSelected;

  /// text style to apply to label
  final TextStyle? labelStyle;

  /// The color of the icon when no onTap function is provided
  ///
  /// Defaults to [ThemeData.disabledColor]
  final Color? disabledIconColor;

  /// The color of the label text when no onTap function is provided
  ///
  /// Defaults to [ThemeData.disabledColor]
  final Color? disabledTextColor;

  /// The overlay color of the image when no onTap function is provided
  ///
  /// Defaults to greyscale color filter
  final ColorFilter? disabledImageColorFilter;

  /// The color for the button's icon when a pointer is hovering over it.
  ///
  /// Defaults to [ThemeData.hoverColor] of the ambient theme.
  final Color? hoverColor;

  /// The color of the button when in the down (pressed) state.
  ///
  /// Defaults to the Theme's highlight color, [ThemeData.highlightColor].
  final Color? highlightColor;

  /// The radius of the ink Splash
  ///
  /// Defaults to the [InkResponse] radius
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final widgetKey = GlobalKey();

    Color? disabledIconColor;
    Color? disabledTextColor;
    ColorFilter? disabledImageColorFilter;

    /// determine disabled status
    if (onTap == null) {
      disabledIconColor = this.disabledIconColor ?? theme.disabledColor;
      disabledTextColor = this.disabledTextColor ?? theme.disabledColor;
      disabledImageColorFilter = this.disabledImageColorFilter;
    }

    /// generate icon
    Widget iconWidget = Container();
    if (icon != null) {
      Widget iconChild = icon!;
      if (disabledIconColor != null) {
        iconChild = IconTheme.merge(
          data: IconThemeData(
            color: disabledIconColor,
          ),
          child: icon!,
        );
      }
      if (isSelected) {
        iconChild = IconTheme.merge(
          data: IconThemeData(
            color: highlightColor ?? theme.highlightColor,
          ),
          child: selectedIcon ?? icon!,
        );
      }

      iconWidget = Align(
        alignment: Alignment.topCenter,
        heightFactor: 1,
        child: iconChild,
      );
    }

    /// generate icon label
    Widget labelWidget = Container();
    if (label != null) {
      TextStyle customLabelStyle = labelStyle ?? const TextStyle();
      if (disabledTextColor != null) {
        customLabelStyle = customLabelStyle.copyWith(color: disabledTextColor);
      }
      if (isSelected) {
        customLabelStyle = customLabelStyle.copyWith(
          color: highlightColor ?? theme.highlightColor,
          fontWeight: FontWeight.w500,
        );
      }
      labelWidget = Text(
        label!,
        style: customLabelStyle,
      );
    }

    /// generate image
    Widget imageWidget = Container();
    if (image != null) {
      imageWidget = image!;
      if (disabledImageColorFilter != null) {
        // In this case ColorFilter will ignore transparent areas of your images.
        imageWidget = ColorFiltered(
          colorFilter: disabledImageColorFilter,
          child: image,
        );
      }
    }

    /// generate button
    Widget toolBarButton = InkResponse(
      key: widgetKey,
      onTap: onTap,
      onTapDown: (details) =>
          onTapDown != null ? onTapDown!(details, widgetKey) : null,
      canRequestFocus: onTap != null,
      hoverColor: hoverColor ?? theme.hoverColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      radius: radius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: Durations.short1,
            child: iconWidget,
          ),
          const Space.h4(),
          imageWidget,
          labelWidget,
        ],
      ),
    );

    /// conditionally wrap with tooltip
    if (toolTip != null) {
      toolBarButton = Tooltip(
        message: toolTip,
        preferBelow: false,
        child: toolBarButton,
      );
    }

    return toolBarButton;
  }
}
