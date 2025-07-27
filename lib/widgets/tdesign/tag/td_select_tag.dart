import 'package:flutter/material.dart';

import 'td_tag.dart';
import 'td_tag_styles.dart';

/// Clickable label component, changes its own state internally when clicked
/// Supported styles: square/rounded/semicircle/with close icon
class TDSelectTag extends StatefulWidget {
  const TDSelectTag(
    this.text, {
    this.theme,
    this.icon,
    this.iconWidget,
    this.selectStyle,
    this.unSelectStyle,
    this.disableSelectStyle,
    this.onSelectChanged,
    this.isSelected = false,
    this.disableSelect = false,
    this.size = TDTagSize.medium,
    this.padding,
    this.isOutline = false,
    this.shape = TDTagShape.square,
    this.isLight = false,
    this.needCloseIcon = false,
    this.onCloseTap,
    this.fixedWidth,
    super.key,
  });

  final String text;

  final TDTagTheme? theme;

  final IconData? icon;

  final Widget? iconWidget;

  final TDTagStyle? selectStyle;

  final TDTagStyle? unSelectStyle;

  final TDTagStyle? disableSelectStyle;

  final ValueChanged<bool>? onSelectChanged;

  final bool isSelected;

  final bool disableSelect;

  final TDTagSize size;

  final EdgeInsets? padding;

  final bool isOutline;

  final TDTagShape shape;

  final bool isLight;

  final bool needCloseIcon;

  final GestureTapCallback? onCloseTap;

  final double? fixedWidth;

  @override
  _TDClickTagState createState() => _TDClickTagState();
}

class _TDClickTagState extends State<TDSelectTag> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = TDTag(
      widget.text,
      icon: widget.icon,
      iconWidget: widget.iconWidget,
      style: _getStyle(),
      size: widget.size,
      padding: widget.padding,
      needCloseIcon: widget.needCloseIcon,
      onCloseTap: widget.onCloseTap,
      fixedWidth: widget.fixedWidth,
    );

    if (!widget.disableSelect) {
      result = GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            widget.onSelectChanged?.call(_isSelected);
          });
        },
        child: result,
      );
    }

    return result;
  }

  TDTagStyle? _getStyle() {
    if (widget.disableSelect) return _getDisableSelectStyle();

    return _isSelected ? _getSelectStyle() : _getUnSelectStyle();
  }

  TDTagStyle _getDisableSelectStyle() {
    if (widget.disableSelectStyle != null) return widget.disableSelectStyle!;

    return TDTagStyle.generateDisableSelectStyle(
      widget.isOutline,
      widget.shape,
    );
  }

  TDTagStyle _getSelectStyle() {
    if (widget.selectStyle != null) return widget.selectStyle!;

    return widget.isOutline
        ? TDTagStyle.generateOutlineStyleByTheme(
          context,
          widget.theme,
          widget.isLight,
          widget.shape,
        )
        : TDTagStyle.generateFillStyleByTheme(
          context,
          widget.theme,
          widget.isLight,
          widget.shape,
        );
  }

  TDTagStyle _getUnSelectStyle() {
    if (widget.unSelectStyle != null) return widget.unSelectStyle!;

    return widget.isOutline
        ? TDTagStyle.generateOutlineStyleByTheme(
          context,
          TDTagTheme.defaultTheme,
          widget.isLight,
          widget.shape,
        )
        : TDTagStyle.generateFillStyleByTheme(
          context,
          TDTagTheme.defaultTheme,
          widget.isLight,
          widget.shape,
        );
  }

  @override
  void didUpdateWidget(covariant TDSelectTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
  }
}
