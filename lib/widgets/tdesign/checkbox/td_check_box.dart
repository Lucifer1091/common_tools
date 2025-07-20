import 'package:flutter/material.dart';

import '../../../common_tools.dart';
import '../../layout/no_widget.dart';
import '../divider/td_divider.dart';
import '../text/td_text.dart';
import 'td_check_box_group.dart';

enum TDCheckboxStyle { circle, square, check }

enum TDContentDirection { left, right }

enum TDCheckBoxSize { large, small }

typedef IconBuilder = Widget? Function(BuildContext context, bool checked);

typedef ContentBuilder =
    Widget Function(BuildContext context, bool checked, String? content);

typedef OnCheckValueChanged = void Function(bool selected);

class TDCheckbox extends StatefulWidget {
  const TDCheckbox({
    this.id,
    super.key,
    this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.enable = true,
    this.checked = false,
    this.titleMaxLine,
    this.subTitleMaxLine = 1,
    this.customIconBuilder,
    this.customContentBuilder,
    this.insetSpacing = 16,
    this.style,
    this.spacing,
    this.backgroundColor,
    this.selectColor,
    this.disableColor,
    this.size = TDCheckBoxSize.small,
    this.cardMode = false,
    this.showDivider = true,
    this.contentDirection = TDContentDirection.right,
    this.onCheckBoxChanged,
    this.titleColor,
    this.subTitleColor,
    this.checkBoxLeftSpace,
  });

  /// When [TDCheckbox] is embedded in [TDCheckboxGroup], this value needs to
  /// be assigned, otherwise it will not be included in the Group management
  final String? id;

  final String? title;

  final TextStyle? titleStyle;

  final String? subTitle;

  final TextStyle? subTitleStyle;

  final bool enable;

  final bool checked;

  final int? titleMaxLine;

  final int? subTitleMaxLine;

  final double? insetSpacing;

  final double? spacing;

  final TDCheckboxStyle? style;

  final TDCheckBoxSize size;

  final bool cardMode;

  final bool showDivider;

  final TDContentDirection contentDirection;

  final OnCheckValueChanged? onCheckBoxChanged;

  final IconBuilder? customIconBuilder;

  final ContentBuilder? customContentBuilder;

  final Color? backgroundColor;

  final Color? selectColor;

  final Color? disableColor;

  final Color? titleColor;

  final Color? subTitleColor;

  final double? checkBoxLeftSpace;

  @override
  State createState() => TDCheckboxState();

  Widget buildDefaultIcon(
    BuildContext context,
    TDCheckboxGroupState? groupState,
    bool isChecked,
  ) {
    if (cardMode) return const NoWidget();

    final size = 24.0;
    final style =
        this.style ?? groupState?.widget.style ?? TDCheckboxStyle.circle;

    final unselectedColor =
        style == TDCheckboxStyle.check
            ? Colors.transparent
            : ThemeColors.neutral.shade300;

    return Icon(
      style == TDCheckboxStyle.circle
          ? isChecked
              ? Icons.check_circle
              : Icons.circle
          : style == TDCheckboxStyle.square
          ? isChecked
              ? Icons.check_box_rounded
              : Icons.check_box_outline_blank_rounded
          : isChecked
          ? Icons.check
          : Icons.check,
      size: size,
      color:
          !enable
              ? (isChecked
                  ? (disableColor ?? const Color.fromARGB(255, 17, 98, 141))
                  : unselectedColor)
              : isChecked
              ? selectColor ?? ThemeColors.blue.shade600
              : unselectedColor,
    );
  }
}

class TDCheckboxState extends State<TDCheckbox> {
  bool checked = false;
  bool _pressed = false;

  /// Cannot be unchecked. In strict mode of radioButton, you can only toggle but not uncheck.
  bool canNotCancel = false;

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
  }

  @override
  void didUpdateWidget(TDCheckbox oldWidget) {
    checked = widget.checked;
    super.didUpdateWidget(oldWidget);
  }

  double _spacing(TDCheckboxGroupState? groupState) {
    return widget.spacing ?? groupState?.widget.spacing ?? 8;
  }

  EdgeInsets _getPadding(TDCheckBoxSize size) {
    if (widget.cardMode) {
      return const EdgeInsets.only(top: 16);
    }
    switch (size) {
      case TDCheckBoxSize.small:
        return const EdgeInsets.only(top: 12, bottom: 12);
      case TDCheckBoxSize.large:
        return const EdgeInsets.only(top: 16, bottom: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Checks if it is contained in a TDCheckboxGroup. If so, the state is managed by the Group.
    final groupState = TDCheckboxGroupInherited.of(context)?.state;
    final id = widget.id;
    //  Only CheckBox with id set will be included in Group management
    if (groupState != null && id != null) {
      // The priority of obtaining the checked state of the CheckBox embedded in the CheckBoxGroup:
      // 1.The checkedIds set in the CheckBoxGroup contains the current id
      // 2.There is no checkedIds attribute, and it has not been checked, so the
      //   checked attribute set by the current CheckedBox is used
      // 3.The state after the user checks
      checked = groupState.getCheckBoxStateById(id, checked);
    }

    final icon = _buildCheckboxIcon(context, groupState, checked);

    final content = _buildContent(context, groupState, checked);

    if (icon == null && content == null) {
      throw Exception('Icon and content cannot both be null!');
    }

    Widget? current;

    if (icon == null) {
      current = content;
    } else {
      current = icon;

      if (content != null) {
        final spacing = _spacing(groupState);
        final contentDirection =
            groupState?.widget.contentDirection ?? widget.contentDirection;
        switch (contentDirection) {
          case TDContentDirection.left:
            current = Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: _getPadding(widget.size),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: widget.insetSpacing ?? 16,
                              ),
                              child: content,
                            ),
                          ),
                          SizedBox(width: spacing),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: icon,
                          ),
                        ],
                      ),
                      Visibility(
                        visible:
                            widget.subTitle != null && widget.subTitle != '',
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: widget.insetSpacing ?? 16,
                            right: 16,
                          ),
                          child: TDText(
                            widget.subTitle ?? '',
                            maxLines: widget.subTitleMaxLine,
                            overflow: TextOverflow.ellipsis,

                            style: context.bodyMedium?.copyWith(
                              color:
                                  widget.enable
                                      ? (widget.subTitleColor ??
                                          ThemeColors.neutral.shade700)
                                      : ThemeColors.neutral.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.cardMode && widget.showDivider,
                  child: const TDDivider(margin: EdgeInsets.only(left: 16)),
                ),
              ],
            );
          case TDContentDirection.right:
            current = Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: _getPadding(widget.size),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: widget.checkBoxLeftSpace ?? 16,
                            ),
                            child: icon,
                          ),
                          SizedBox(width: widget.cardMode ? 0 : spacing),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: widget.insetSpacing ?? 16,
                              ),
                              child: content,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible:
                            widget.subTitle != null && widget.subTitle != '',
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: widget.cardMode ? 4 : 0,
                            left: widget.cardMode ? 16 : 48,
                            right: widget.insetSpacing ?? 16,
                          ),
                          child: TDText(
                            widget.subTitle ?? '',
                            maxLines: widget.subTitleMaxLine,
                            overflow: TextOverflow.ellipsis,
                            style: (widget.subTitleStyle ?? context.bodyMedium)
                                ?.copyWith(
                                  color:
                                      widget.enable
                                          ? (widget.subTitleColor ??
                                              ThemeColors.neutral.shade700)
                                          : ThemeColors.neutral.shade600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.cardMode && widget.showDivider,
                  child: const TDDivider(margin: EdgeInsets.only(left: 48)),
                ),
              ],
            );
        }
      }
    }

    if (!(canNotCancel && checked)) {
      if (_pressed) {
        current = Opacity(opacity: 0.68, child: current);
      }

      current = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (detail) {
          _pressState(true);
        },
        onTapUp: (detail) {
          _pressState(false);
        },
        onTapCancel: () {
          _pressState(false);
        },
        onTap: () {
          onValueChange(id, !checked, groupState);
        },
        child: current,
      );
    }

    return Container(
      clipBehavior: widget.cardMode ? Clip.hardEdge : Clip.none,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        border:
            widget.cardMode
                ? checked
                    ? Border.all(
                      width: 1.5,
                      color: widget.selectColor ?? ThemeColors.blue.shade600,
                    )
                    : Border.all(width: 1.5, color: Colors.transparent)
                : null,
        borderRadius:
            widget.cardMode ? const BorderRadius.all(Radius.circular(6)) : null,
      ),
      child: Stack(
        children: [
          current ?? const NoWidget(),
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: widget.cardMode && checked,
              child: RadioCornerIcon(
                length: 28,
                radius: 4,
                selectColor: widget.selectColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pressState(bool pressed) {
    if (!widget.enable) return;

    _pressed = pressed;
    setState(() {});
  }

  void onValueChange(String? id, bool value, TDCheckboxGroupState? groupState) {
    if (!widget.enable) return;

    setState(() {
      checked = value;
      if (groupState != null && id != null) {
        groupState.toggle(id, checked);
      }
      widget.onCheckBoxChanged?.call(checked);
    });
  }

  Widget? _buildContent(
    BuildContext context,
    TDCheckboxGroupState? groupState,
    bool checked,
  ) {
    final title = widget.title;
    final customContent =
        widget.customContentBuilder ?? groupState?.widget.customContentBuilder;

    var content = customContent?.call(context, checked, title);

    if (content == null) {
      if (title != null || customContent != null && title != null) {
        content = TDText(
          title,
          maxLines: widget.titleMaxLine ?? groupState?.widget.titleMaxLine,
          overflow: TextOverflow.ellipsis,
          textColor:
              widget.enable
                  ? (widget.titleColor ?? ThemeColors.neutral.shade900)
                  : ThemeColors.neutral.shade600,
          style: (widget.titleStyle ?? context.bodyLarge)?.copyWith(
            color:
                widget.enable
                    ? (widget.titleColor ?? ThemeColors.neutral.shade900)
                    : ThemeColors.neutral.shade600,
          ),
        );
      }
    }

    return content;
  }

  Widget? _buildCheckboxIcon(
    BuildContext context,
    TDCheckboxGroupState? groupState,
    bool isCheck,
  ) {
    final iconBuilder =
        widget.customIconBuilder ?? groupState?.widget.customIconBuilder;
    if (iconBuilder != null) {
      return iconBuilder.call(context, isCheck);
    }
    return widget.buildDefaultIcon(context, groupState, isCheck);
  }
}

class RadioCornerIcon extends StatelessWidget {
  const RadioCornerIcon({
    required this.length,
    required this.radius,
    required this.selectColor,
    super.key,
  });

  final double length;
  final double radius;
  final Color? selectColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: length,
      height: length,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          CustomPaint(
            painter: RadioCorner(
              length: length,
              radius: radius,
              fillColor: selectColor ?? ThemeColors.blue.shade600,
            ),
          ),
          const Positioned(
            top: 3,
            left: 2,
            child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class RadioCorner extends CustomPainter {
  RadioCorner({
    required this.length,
    required this.radius,
    required this.fillColor,
  });

  final double length;
  final double radius;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 1
          ..color = fillColor
          ..style = PaintingStyle.fill;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    final pi = 3.1415;

    final path =
        Path()
          ..moveTo(0, radius)
          ..addArc(rect, 180 * (pi / 180.0), 90 * (pi / 180.0))
          ..moveTo(radius, 0)
          ..lineTo(length, 0)
          ..lineTo(0, length)
          ..lineTo(0, radius);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
