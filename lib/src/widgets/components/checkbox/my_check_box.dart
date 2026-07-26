import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../common/my_decorator.dart';
import '../../common/my_disabled.dart';
import '../../common/my_gesture_detector.dart';
import '../../form/focusable.dart';
import '../../packages/gap/src/widgets/gap.dart';
import '../divider/my_divider.dart';
import '../text/my_text.dart';
import './my_check_box_group.dart';
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
    this.subtitle,
    this.subtitleColor,
    this.subtitleStyle,
    this.subtitleMaxLine = 1,
    this.enabled = true,
    this.tristate = false,
    this.customIconBuilder,
    this.customContentBuilder,
    this.margin,
    this.insetSpacing = 16,
    this.shape,
    this.spacing,
    this.subtitlePadding,
    this.duration,
    this.backgroundColor,
    this.selectedColor,
    this.checkColor,
    this.size = MyCheckboxSize.small,
    this.cardMode = false,
    this.showDivider = true,
    this.contentDirection = MyContentDirection.right,
    this.onChanged,
    this.checkBoxLeftSpace,
    this.focus = const MyFocusableParams(),
  });

  /// When [MyCheckbox] is embedded in [MyCheckboxGroup], this value needs to
  /// be assigned, otherwise it will not be included in the Group management
  final String? id;

  final String? title;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final int? titleMaxLine;

  final String? subtitle;
  final Color? subtitleColor;
  final TextStyle? subtitleStyle;
  final int? subtitleMaxLine;

  final bool enabled;
  final bool? checked;
  final bool tristate;
  final bool cardMode;
  final bool showDivider;

  final EdgeInsets? margin;
  final double? insetSpacing;
  final double? spacing;
  final EdgeInsets? subtitlePadding;

  final MyCheckboxShape? shape;
  final MyCheckboxSize size;

  final MyContentDirection contentDirection;
  final ValueChanged<bool?>? onChanged;
  final IconBuilder? customIconBuilder;
  final ContentBuilder? customContentBuilder;

  final Duration? duration;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? checkColor;
  final double? checkBoxLeftSpace;
  final MyFocusableParams focus;

  @override
  State createState() => MyCheckboxState();

  Widget buildDefaultIcon(
    BuildContext context,
    MyCheckboxGroupState? groupState,
    bool? isChecked,
  ) {
    if (cardMode) return const SizedBox.shrink();

    final shape =
        this.shape ?? groupState?.widget.shape ?? MyCheckboxShape.circle;

    final size = this.size == MyCheckboxSize.small ? 20.0 : 24.0;

    return _MyCheckboxIcon(
      value: tristate ? isChecked : isChecked ?? false,
      size: size,
      shape: shape,
      fillColor: selectedColor,
      checkColor: checkColor,
    );
  }
}

class MyCheckboxState extends State<MyCheckbox> {
  FocusNode? _focusNode;

  FocusNode get focusNode => widget.focus.focusNode ?? _focusNode!;

  bool? checked;

  /// Cannot be unchecked. In strict mode of radioButton, you can only toggle but not uncheck.
  bool canNotCancel = false;

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
    if (widget.focus.focusNode == null) _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyCheckbox oldWidget) {
    checked = widget.checked;
    super.didUpdateWidget(oldWidget);
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

    final shape =
        widget.shape ?? groupState?.widget.shape ?? MyCheckboxShape.circle;

    final check = _buildCheckboxIcon(context, groupState, checked);

    Widget buildFocus(Widget child, [BorderRadius? radius]) {
      return Semantics(
        checked: widget.checked,
        focusable: widget.enabled,
        enabled: widget.enabled,
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.enter): () {
              if (!(canNotCancel && (checked ?? false))) {
                onValueChange(id, !(checked ?? false), groupState);
              }
            },
          },
          child: widget.enabled
              ? MyFocusable(
                  params: widget.focus.copyWith(focusNode: focusNode),
                  builder: (_, focused, child) {
                    final radius0 = shape == MyCheckboxShape.circle
                        ? MyBorderRadius.round
                        : MyBorderRadius.small;

                    return MyDecorator(
                      focused: focused,
                      radius: radius ?? radius0,
                      child: child,
                    );
                  },
                  child: child,
                )
              : child,
        ),
      );
    }

    final icon = check != null && !widget.cardMode ? buildFocus(check) : check;

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
                            widget.subtitle != null && widget.subtitle != '',
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: widget.insetSpacing ?? 16,
                            right: 16,
                          ),
                          child: MyText(
                            widget.subtitle ?? '',
                            maxLines: widget.subtitleMaxLine,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodyMedium.copyWith(
                              color:
                                  widget.subtitleColor ??
                                  context.colorScheme.mutedForeground,
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
                            widget.subtitle != null && widget.subtitle != '',
                        child: Padding(
                          padding:
                              widget.subtitlePadding ??
                              EdgeInsets.only(
                                top: widget.cardMode ? 4 : 0,
                                left: widget.cardMode ? 16 : 48,
                                right: widget.insetSpacing ?? 16,
                              ),
                          child: MyText(
                            widget.subtitle ?? '',
                            maxLines: widget.subtitleMaxLine,
                            overflow: TextOverflow.ellipsis,
                            style: (widget.subtitleStyle ?? context.bodyMedium)
                                .copyWith(
                                  color:
                                      widget.subtitleColor ??
                                      context.colorScheme.mutedForeground,
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
      current = MyDisabled(
        showForbiddenCursor: true,
        disabled: !widget.enabled,
        child: MyGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onValueChange(id, !(checked ?? false), groupState),
          child: current,
        ),
      );
    }

    final child = widget.cardMode && (checked ?? false)
        ? Stack(
            children: [
              ?current,
              Positioned(
                top: 0,
                left: 0,
                child: RadioCornerIcon(
                  length: 30,
                  radius: 4,
                  selectColor:
                      widget.selectedColor ?? context.colorScheme.primary,
                ),
              ),
            ],
          )
        : current;

    final container = Container(
      clipBehavior: widget.cardMode ? Clip.hardEdge : Clip.none,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.colorScheme.background,
        border: widget.cardMode
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
      child: child,
    );

    return widget.cardMode
        ? buildFocus(container, MyBorderRadius.medium)
        : container;
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
    });

    widget.onChanged?.call(checked);

    if (!focusNode.hasFocus) FocusScope.of(context).unfocus();
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
            color: widget.enabled
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

  double _spacing(MyCheckboxGroupState? groupState) {
    return widget.spacing ?? groupState?.widget.spacing ?? 12;
  }

  EdgeInsets _getPadding(MyCheckboxSize size) {
    if (widget.margin != null) return widget.margin!;

    if (widget.cardMode) return const EdgeInsets.only(top: 16);

    switch (size) {
      case MyCheckboxSize.small:
        return const EdgeInsets.only(top: 12, bottom: 12);
      case MyCheckboxSize.large:
        return const EdgeInsets.only(top: 16, bottom: 16);
    }
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
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -1,
            left: -1,
            child: CustomPaint(
              size: Size(length, length),
              painter: RadioCorner(
                length: length,
                radius: radius,
                fillColor: selectColor ?? context.colorScheme.primary,
              ),
            ),
          ),
          Positioned(
            top: 3,
            left: 2,
            child: Icon(
              LucideIcons.check,
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
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );

    final pi = 3.1415;

    final path = Path()
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
