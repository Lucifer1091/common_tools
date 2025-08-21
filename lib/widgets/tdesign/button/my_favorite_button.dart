import 'package:flutter/material.dart';

import '../../../index.dart';

/// Creates a button that shows favorite state.
///
/// It displays favorite icon for in favorite and favorite_border for else.
class MyFavoriteButton extends StatefulWidget {
  const MyFavoriteButton({
    super.key,
    this.enabled = true,
    this.selected = false,
    this.onChanged,
    this.icon,
    this.iconColor = Colors.red,
    this.selectedIcon,
    this.selectedIconColor = Colors.red,
    this.duration = const Duration(milliseconds: 350),
    this.iconSize,
    this.focus = const MyFocusableParams(),
    this.width,
    this.height,
    this.size = MyButtonSize.medium,
    this.type = MyButtonType.ghost,
    this.shape = MyButtonShape.circle,
    this.style,
    this.padding,
  });

  final bool enabled;

  /// Whether the item is in favorites.
  final bool selected;

  final IconData? icon;

  /// Color of icon when the item is not in favorites.
  final Color iconColor;

  final IconData? selectedIcon;

  /// Color of icon when the item in favorites.
  final Color selectedIconColor;

  /// Duration for switching between favorite's states animation.
  final Duration duration;

  /// Callback for changes in favorite state.
  final BoolCallback? onChanged;

  /// Size for the icon.
  final double? iconSize;

  final double? width;

  final double? height;

  final MyButtonSize size;

  final MyButtonType type;

  final MyButtonShape shape;

  final MyButtonStyle? style;

  final EdgeInsets? padding;

  final MyFocusableParams focus;

  @override
  State<MyFavoriteButton> createState() => _MyFavoriteButtonState();
}

class _MyFavoriteButtonState extends State<MyFavoriteButton> {
  bool isInFavorite = false;

  @override
  void initState() {
    super.initState();
    isInFavorite = widget.selected;
  }

  void _onChange() {
    setState(() {
      isInFavorite = !isInFavorite;
      widget.onChanged?.call(isInFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyButton(
      enabled: widget.enabled,
      focus: widget.focus,
      width: widget.width,
      height: widget.height,
      size: widget.size,
      type: widget.type,
      shape: widget.shape,
      style: widget.style,
      padding: widget.padding,
      onTap: _onChange,
      iconWidget: AnimatedSwitcher(
        duration: widget.duration,
        transitionBuilder: (child, anim) {
          return ScaleTransition(scale: anim, child: child);
        },
        child:
            isInFavorite
                ? Icon(
                  widget.icon ?? Icons.favorite_rounded,
                  color: widget.selectedIconColor,
                  key: const ValueKey('icon1'),
                  size: widget.iconSize ?? _getSize(),
                )
                : Icon(
                  widget.selectedIcon ?? Icons.favorite_border_rounded,
                  color: widget.iconColor,
                  key: const ValueKey('icon2'),
                  size: widget.iconSize ?? _getSize(),
                ),
      ),
    );
  }

  double _getSize() {
    return switch (widget.size) {
      MyButtonSize.extraLarge => 24,
      MyButtonSize.large => 20,
      MyButtonSize.medium => 20,
      MyButtonSize.small => 18,
      MyButtonSize.extraSmall => 18,
    };
  }
}
