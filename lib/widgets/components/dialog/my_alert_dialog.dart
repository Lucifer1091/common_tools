import 'package:flutter/material.dart';

import '../button/my_button.dart';
import '../divider/my_divider.dart';
import 'my_dialog_config.dart';
import 'my_dialog_widget.dart';

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
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
    this.title,
    this.titleColor = const Color(0xE6000000),
    this.content,
    this.contentColor,
    this.titleAlignment,
    this.contentWidget,
    this.contentMaxHeight = 0,
    this.leftBtn,
    this.rightBtn,
    this.leftBtnAction,
    this.rightBtnAction,
    this.showCloseButton,
    MyDialogButtonStyle buttonStyle = MyDialogButtonStyle.normal,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
    this.buttonWidget,
  }) : assert((title != null || content != null || contentWidget != null), ''),
       _vertical = false,
       _buttons = null,
       _buttonStyle = buttonStyle;

  /// Dialog box with vertical button arrangement
  ///
  /// The [buttons] parameter is required. The default style for vertical
  /// buttons is [MyButtonTheme.primary].
  const MyAlertDialog.vertical({
    required List<MyDialogButtonOptions> buttons,
    super.key,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
    this.title,
    this.titleColor = Colors.black,
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.showCloseButton,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
    this.buttonWidget,
  }) : _vertical = true,
       leftBtn = null,
       rightBtn = null,
       _buttons = buttons,
       _buttonStyle = MyDialogButtonStyle.normal,
       leftBtnAction = null,
       rightBtnAction = null;

  final Color backgroundColor;

  final double radius;

  final String? title;

  final Color titleColor;

  final AlignmentGeometry? titleAlignment;

  final Widget? contentWidget;

  final String? content;

  final Color? contentColor;

  /// The maximum height of the content, the default is 0, which means there is no height limit
  final double contentMaxHeight;

  final MyDialogButtonOptions? leftBtn;

  final MyDialogButtonOptions? rightBtn;

  final VoidCallback? leftBtnAction;

  final VoidCallback? rightBtnAction;

  /// Display the close button in the upper right corner
  final bool? showCloseButton;

  /// Whether the option is arranged vertically, the default is left and right
  final bool _vertical;

  /// Vertically arranged button list
  final List<MyDialogButtonOptions>? _buttons;

  /// Button style
  ///
  /// Supports both standard and text buttons
  /// Text buttons only support horizontal layout
  /// The styles in [leftBtn] and [rightBtn] override this setting.
  final MyDialogButtonStyle _buttonStyle;

  final EdgeInsets? padding;

  final Widget? buttonWidget;

  @override
  Widget build(BuildContext context) {
    // Title and content cannot be empty at the same time
    return MyDialogScaffold(
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
            contentWidget: contentWidget,
            content: content,
            contentColor: contentColor,
            contentMaxHeight: contentMaxHeight,
            padding: padding,
          ),
          const MyDivider(height: 24, color: Colors.transparent),
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
        MyDialogButtonOptions(title: 'Confirm', action: rightBtnAction);
    return _buttonStyle == MyDialogButtonStyle.text
        ? HorizontalTextButtons(leftBtn: left, rightBtn: right)
        : HorizontalNormalButtons(leftBtn: left, rightBtn: right);
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
        widgets.add(const MyDivider(height: 12, color: Colors.transparent));
      }
    });

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(children: widgets),
    );
  }
}
