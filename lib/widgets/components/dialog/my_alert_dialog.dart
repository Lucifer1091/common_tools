import 'package:flutter/material.dart';

import '../../../index.dart';

/// Pop-up Control
///
/// Supports horizontal or vertical button placement
/// Maximum of two buttons can be placed horizontally
class MyAlertDialog extends StatelessWidget {
  /// Dialog box with horizontal button arrangement
  ///
  /// If you don't pass a style parameter to [leftBtn] and [rightBtn], the default
  ///  style will be applied: a weak button on the left and a strong button on the right.
  const MyAlertDialog({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    this.radius,
    this.title,
    this.titleColor,
    this.content,
    this.contentColor,
    this.titleAlignment,
    this.contentAlignment,
    this.contentWidget,
    this.contentMaxHeight = 0,
    this.leftBtn,
    this.rightBtn,
    this.leftBtnAction,
    this.rightBtnAction,
    this.showCloseButton,
    this.padding,
    this.margin,
    this.buttonWidget,
  }) : assert((title != null || content != null || contentWidget != null), ''),
       _vertical = false,
       _buttons = null;

  /// Dialog box with vertical button arrangement
  ///
  /// The [buttons] parameter is required.
  const MyAlertDialog.vertical({
    required List<MyDialogButtonOptions> buttons,
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    this.radius,
    this.title,
    this.titleColor,
    this.titleAlignment,
    this.contentAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.showCloseButton,
    this.padding,
    this.margin,
    this.buttonWidget,
  }) : assert((title != null || content != null || contentWidget != null), ''),
       _vertical = true,
       leftBtn = null,
       rightBtn = null,
       _buttons = buttons,
       leftBtnAction = null,
       rightBtnAction = null;

  final double? height, width;
  final Color? backgroundColor;
  final BorderRadius? radius;
  final String? title;
  final Color? titleColor;
  final AlignmentGeometry? titleAlignment, contentAlignment;
  final Widget? contentWidget;
  final String? content;
  final Color? contentColor;

  /// The maximum height of the content, the default is 0, which means there is no height limit
  final double contentMaxHeight;
  final MyDialogButtonOptions? leftBtn;
  final MyDialogButtonOptions? rightBtn;
  final VoidCallback? leftBtnAction;
  final VoidCallback? rightBtnAction;
  final bool? showCloseButton;

  /// Whether the option is arranged vertically, the default is left and right
  final bool _vertical;

  /// Vertically arranged button list
  final List<MyDialogButtonOptions>? _buttons;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? buttonWidget;

  @override
  Widget build(BuildContext context) {
    return MyDialogScaffold(
      height: height,
      width: width,
      margin: margin,
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      radius: radius,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDialogInfoWidget(
            title: title,
            titleColor: titleColor,
            titleAlignment: titleAlignment,
            contentAlignment: contentAlignment,
            contentWidget: contentWidget,
            content: content,
            contentColor: contentColor,
            contentMaxHeight: contentMaxHeight,
            padding: padding,
          ),
          const Gap(24),
          if (_vertical)
            _verticalButtons(context)
          else
            _horizontalButtons(context),
        ],
      ),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    if (buttonWidget != null) return buttonWidget!;

    final left =
        leftBtn ??
        MyDialogButtonOptions(
          title: 'Cancel',
          type: MyButtonType.outline,
          action: leftBtnAction,
        );

    final right =
        rightBtn ??
        MyDialogButtonOptions(
          title: 'Confirm',
          titleColor: context.colorScheme.primaryForeground,
          action: rightBtnAction,
        );

    return MyDialogExpandedButtons(leftBtn: left, rightBtn: right);
  }

  Widget _verticalButtons(BuildContext context) {
    final widgets = <Widget>[];

    _buttons!.asMap().forEach((index, value) {
      final Widget btn = MyDialogButton(
        buttonText: value.title,
        buttonTextColor: value.titleColor,
        buttonTextSize: value.titleSize,
        height: value.height,
        buttonTextFontWeight: value.fontWeight ?? FontWeight.w600,
        buttonStyle: value.style,
        buttonType: value.type,
        onPressed: () {
          if (value.action != null) {
            value.action!();
          } else {
            Navigator.pop(context);
          }
        },
      );

      widgets.add(btn);
      if (index < _buttons.length - 1) {
        widgets.add(const Gap(12));
      }
    });

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(children: widgets),
    );
  }
}
