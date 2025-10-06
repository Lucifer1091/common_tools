import 'package:flutter/material.dart';

import '../../../index.dart';

class MyInputDialog extends StatelessWidget {
  const MyInputDialog({
    required this.textEditingController,
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
    this.hintText = '',
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
    this.leftBtnAction,
    this.rightBtnAction,
    this.showCloseButton,
    this.padding,
    this.margin,
    this.buttonWidget,
    this.customInputWidget,
  }) : assert((title != null || content != null || contentWidget != null), '');

  final double? height, width;
  final Color? backgroundColor;
  final BorderRadius? radius;
  final String? title;
  final Color? titleColor;
  final AlignmentGeometry? titleAlignment, contentAlignment;
  final Widget? contentWidget;
  final String? content;
  final String? hintText;
  final Color? contentColor;
  final TextEditingController textEditingController;
  final MyDialogButtonOptions? leftBtn;
  final MyDialogButtonOptions? rightBtn;
  final VoidCallback? leftBtnAction;
  final VoidCallback? rightBtnAction;
  final bool? showCloseButton;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? buttonWidget;
  final Widget? customInputWidget;

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
            padding: padding,
          ),
          if (customInputWidget != null)
            customInputWidget!
          else
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                borderRadius: MyBorderRadius.medium,
              ),
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: TextField(
                controller: textEditingController,
                autofocus: true,
                cursorColor: context.colorScheme.primary,
                style: TextStyle(
                  color: context.colorScheme.secondaryForeground,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  border: OutlineInputBorder(
                    borderRadius: MyBorderRadius.medium,
                    borderSide: BorderSide.none,
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: context.colorScheme.mutedForeground,
                  ),
                  fillColor: context.colorScheme.secondary,
                  filled: true,
                ),
              ),
            ),
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
          titleColor: context.colorScheme.popoverForeground,
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
}
