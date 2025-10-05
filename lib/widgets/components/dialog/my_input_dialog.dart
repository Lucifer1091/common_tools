import 'package:flutter/material.dart';

import 'my_dialog_config.dart';
import 'my_dialog_widget.dart';

class MyInputDialog extends StatelessWidget {
  const MyInputDialog({
    required this.textEditingController,
    super.key,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
    this.title,
    this.titleColor = const Color(0xE6000000),
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.hintText = '',
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
    this.showCloseButton,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
    this.buttonWidget,
    this.customInputWidget,
  }) : assert((title != null || content != null || contentWidget != null), '');

  final Color backgroundColor;

  final double radius;

  final String? title;

  final Color titleColor;

  final AlignmentGeometry? titleAlignment;

  final Widget? contentWidget;

  final String? content;

  final String? hintText;

  final Color? contentColor;

  final TextEditingController textEditingController;

  final MyDialogButtonOptions? leftBtn;

  final MyDialogButtonOptions? rightBtn;

  final bool? showCloseButton;

  final EdgeInsets? padding;

  final Widget? buttonWidget;

  final Widget? customInputWidget;

  @override
  Widget build(BuildContext context) {
    return MyDialogScaffold(
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      radius: radius,
      body: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyDialogInfoWidget(
              title: title,
              titleColor: titleColor,
              titleAlignment: titleAlignment,
              contentWidget: contentWidget,
              content: content,
              contentColor: contentColor,
              padding: padding,
            ),
            SizedBox(
              child:
                  customInputWidget != null
                      ? customInputWidget!
                      : Container(
                        color: Colors.white,
                        height: 48,
                        margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: TextField(
                          controller: textEditingController,
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                            hintText: hintText,
                            hintStyle: const TextStyle(
                              color: Color(0x66000000),
                            ),
                            fillColor: const Color(0xFFF3F3F3),
                            filled: true,
                            // labelText: '左上角',
                          ),
                        ),
                      ),
            ),
            _horizontalButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    if (buttonWidget != null) {
      return buttonWidget!;
    }
    final left =
        leftBtn ??
        MyDialogButtonOptions(
          title: 'Cancel',
          titleColor: const Color(0xE6000000),
          fontWeight: FontWeight.normal,
          action: null,
          height: 56,
        );
    final right =
        rightBtn ??
        MyDialogButtonOptions(
          title: 'Confirm',
          action: null,
          fontWeight: FontWeight.w600,
          height: 56,
        );
    return HorizontalTextButtons(leftBtn: left, rightBtn: right);
  }
}
