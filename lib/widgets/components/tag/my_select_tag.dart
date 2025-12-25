import 'package:flutter/material.dart';

import 'my_tag.dart';
import 'my_tag_styles.dart';

/// Clickable label component, changes its own state internally when clicked
/// Supported styles: square/rounded/semicircle/with close icon
class MySelectTag extends StatefulWidget {
  const MySelectTag(
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
    this.size = MyTagSize.medium,
    this.padding,
    this.isOutline = false,
    this.shape = MyTagShape.square,
    this.needCloseIcon = false,
    this.onCloseTap,
    this.fixedWidth,
    super.key,
  });

  final String text;
  final MyTagTheme? theme;
  final IconData? icon;
  final Widget? iconWidget;
  final MyTagStyle? selectStyle;
  final MyTagStyle? unSelectStyle;
  final MyTagStyle? disableSelectStyle;
  final ValueChanged<bool>? onSelectChanged;
  final bool isSelected;
  final bool disableSelect;
  final MyTagSize size;
  final EdgeInsets? padding;
  final bool isOutline;
  final MyTagShape shape;
  final bool needCloseIcon;
  final GestureTapCallback? onCloseTap;
  final double? fixedWidth;

  @override
  _MyClickTagState createState() => _MyClickTagState();
}

class _MyClickTagState extends State<MySelectTag> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = MyTag(
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

  MyTagStyle? _getStyle() {
    if (widget.disableSelect) return _geMyisableSelectStyle();

    return _isSelected ? _getSelectStyle() : _getUnSelectStyle();
  }

  MyTagStyle _geMyisableSelectStyle() {
    if (widget.disableSelectStyle != null) return widget.disableSelectStyle!;

    return MyTagStyle.generateDisableSelectStyle(
      context,
      widget.isOutline,
      widget.shape,
    );
  }

  MyTagStyle _getSelectStyle() {
    if (widget.selectStyle != null) return widget.selectStyle!;

    return widget.isOutline
        ? MyTagStyle.generateOutlineStyleByTheme(
          context,
          widget.theme,
          widget.shape,
        )
        : MyTagStyle.generateFillStyleByTheme(
          context,
          widget.theme,
          widget.shape,
        );
  }

  MyTagStyle _getUnSelectStyle() {
    if (widget.unSelectStyle != null) return widget.unSelectStyle!;

    return widget.isOutline
        ? MyTagStyle.generateOutlineStyleByTheme(
          context,
          MyTagTheme.defaults,
          widget.shape,
        )
        : MyTagStyle.generateFillStyleByTheme(
          context,
          MyTagTheme.defaults,
          widget.shape,
        );
  }

  @override
  void didUpdateWidget(covariant MySelectTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
  }
}
