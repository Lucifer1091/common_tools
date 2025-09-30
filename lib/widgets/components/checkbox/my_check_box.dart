import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

part 'my_check_icon.dart';

enum MyCheckboxShape { circle, square, check }

enum MyContentDirection { left, right }

enum MyCheckboxSize { large, small }

typedef IconBuilder = Widget? Function(BuildContext context, bool? checked);

typedef ContentBuilder =
    Widget Function(BuildContext context, bool? checked, String? content);

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({
    this.id,
    super.key,
    this.checked,
    this.title,
    this.titleColor,
    this.titleStyle,
    this.titleMaxLine,
    this.subTitle,
    this.subTitleColor,
    this.subTitleStyle,
    this.subTitleMaxLine = 1,
    this.enabled = true,
    this.tristate = false,
    this.customIconBuilder,
    this.customContentBuilder,
    this.insetSpacing = 16,
    this.shape,
    this.spacing,
    this.duration,
    this.backgroundColor,
    this.selectedColor,
    this.disabledColor,
    this.size = MyCheckboxSize.small,
    this.cardMode = false,
    this.showDivider = true,
    this.contentDirection = MyContentDirection.right,
    this.onChanged,
    this.checkBoxLeftSpace,
  });

  /// When [MyCheckbox] is embedded in [MyCheckboxGroup], this value needs to
  /// be assigned, otherwise it will not be included in the Group management
  final String? id;

  final String? title;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final int? titleMaxLine;

  final String? subTitle;
  final Color? subTitleColor;
  final TextStyle? subTitleStyle;
  final int? subTitleMaxLine;

  final bool enabled;
  final bool? checked;
  final bool tristate;
  final bool cardMode;
  final bool showDivider;

  final double? insetSpacing;
  final double? spacing;

  final MyCheckboxShape? shape;
  final MyCheckboxSize size;

  final MyContentDirection contentDirection;
  final ValueChanged<bool?>? onChanged;
  final IconBuilder? customIconBuilder;
  final ContentBuilder? customContentBuilder;

  final Duration? duration;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? disabledColor;
  final double? checkBoxLeftSpace;

  @override
  State createState() => MyCheckboxState();

  Widget buildDefaultIcon(
    BuildContext context,
    MyCheckboxGroupState? groupState,
    bool? isChecked,
  ) {
    if (cardMode) return const NoWidget();

    final shape =
        this.shape ?? groupState?.widget.shape ?? MyCheckboxShape.circle;

    final isCheck = shape == MyCheckboxShape.check;

    final size =
        this.size == MyCheckboxSize.small
            ? isCheck
                ? 15.0
                : 18.0
            : isCheck
            ? 20.0
            : 24.0;

    return _MyCheckboxIcon(
      value: tristate ? isChecked : isChecked ?? false,
      size: size,
      shape: shape,
      enabled: enabled,
      fillColor: selectedColor,
      checkColor: selectedColor,
      disabledColor: disabledColor,
    );
  }
}

class MyCheckboxState extends State<MyCheckbox> {
  bool? checked;
  bool _pressed = false;

  /// Cannot be unchecked. In strict mode of radioButton, you can only toggle but not uncheck.
  bool canNotCancel = false;

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
  }

  @override
  void didUpdateWidget(MyCheckbox oldWidget) {
    checked = widget.checked;
    if (mounted) setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  double _spacing(MyCheckboxGroupState? groupState) {
    return widget.spacing ?? groupState?.widget.spacing ?? 8;
  }

  EdgeInsets _getPadding(MyCheckboxSize size) {
    if (widget.cardMode) return const EdgeInsets.only(top: 16);

    switch (size) {
      case MyCheckboxSize.small:
        return const EdgeInsets.only(top: 12, bottom: 12);
      case MyCheckboxSize.large:
        return const EdgeInsets.only(top: 16, bottom: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Checks if it is contained in a MyCheckboxGroup. If so, the state is managed by the Group.
    final groupState = MyCheckboxGroupInherited.of(context)?.state;
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
          case MyContentDirection.left:
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
                          Gap(spacing),
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
                          child: MyText(
                            widget.subTitle ?? '',
                            maxLines: widget.subTitleMaxLine,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodyMedium.copyWith(
                              color:
                                  widget.enabled
                                      ? (widget.subTitleColor ??
                                          context.colorScheme.mutedForeground)
                                      : context.colorScheme.mutedForeground
                                          .withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.cardMode && widget.showDivider,
                  child: const MyDivider(margin: EdgeInsets.only(left: 16)),
                ),
              ],
            );
          case MyContentDirection.right:
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
                            left: widget.cardMode ? 16 : 44,
                            right: widget.insetSpacing ?? 16,
                          ),
                          child: MyText(
                            widget.subTitle ?? '',
                            maxLines: widget.subTitleMaxLine,
                            overflow: TextOverflow.ellipsis,
                            style: (widget.subTitleStyle ?? context.bodyMedium)
                                .copyWith(
                                  color:
                                      widget.enabled
                                          ? (widget.subTitleColor ??
                                              context
                                                  .colorScheme
                                                  .mutedForeground)
                                          : context.colorScheme.mutedForeground
                                              .withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !widget.cardMode && widget.showDivider,
                  child: const MyDivider(margin: EdgeInsets.only(left: 48)),
                ),
              ],
            );
        }
      }
    }

    if (!(canNotCancel && (checked ?? false))) {
      if (_pressed) current = Opacity(opacity: 0.68, child: current);

      current = MyGestureDetector(
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
          onValueChange(id, !(checked ?? false), groupState);
        },
        child: current,
      );
    }

    return Container(
      clipBehavior: widget.cardMode ? Clip.hardEdge : Clip.none,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.colorScheme.background,
        border:
            widget.cardMode
                ? checked ?? false
                    ? Border.all(
                      width: 1.5,
                      color:
                          widget.selectedColor ?? context.colorScheme.primary,
                    )
                    : Border.all(width: 1.5, color: Colors.transparent)
                : null,
        borderRadius: widget.cardMode ? MyBorderRadius.medium : null,
      ),
      child: Stack(
        children: [
          if (current != null) current,
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: widget.cardMode && (checked ?? false),
              child: RadioCornerIcon(
                length: 28,
                radius: 4,
                selectColor:
                    widget.selectedColor ?? context.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pressState(bool pressed) {
    if (!widget.enabled) return;

    _pressed = pressed;
    setState(() {});
  }

  void onValueChange(
    String? id,
    bool? value,
    MyCheckboxGroupState? groupState,
  ) {
    if (!widget.enabled) return;

    setState(() {
      checked = value;
      if (groupState != null && id != null) {
        groupState.toggle(id, checked);
      }
      widget.onChanged?.call(checked);
    });
  }

  Widget? _buildContent(
    BuildContext context,
    MyCheckboxGroupState? groupState,
    bool? checked,
  ) {
    final title = widget.title;
    final customContent =
        widget.customContentBuilder ?? groupState?.widget.customContentBuilder;

    var content = customContent?.call(context, checked, title);

    if (content == null) {
      if (title != null || customContent != null && title != null) {
        content = MyText(
          title,
          maxLines: widget.titleMaxLine ?? groupState?.widget.titleMaxLine,
          overflow: TextOverflow.ellipsis,
          style: (widget.titleStyle ?? context.bodyLarge).copyWith(
            color:
                widget.enabled
                    ? (widget.titleColor ?? context.colorScheme.foreground)
                    : context.colorScheme.mutedForeground,
          ),
        );
      }
    }

    return content;
  }

  Widget? _buildCheckboxIcon(
    BuildContext context,
    MyCheckboxGroupState? groupState,
    bool? isCheck,
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
              fillColor: selectColor ?? context.colorScheme.primary,
            ),
          ),
          Positioned(
            top: 3,
            left: 2,
            child: Icon(
              Icons.check_rounded,
              size: 14,
              color: context.colorScheme.primaryForeground,
            ),
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
