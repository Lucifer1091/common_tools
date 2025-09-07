import 'package:flutter/material.dart';

import '../button/my_button.dart';
import '../divider/my_divider.dart';
import 'td_dialog.dart';
import 'td_dialog_widget.dart';

/// A popup control with only one button
///
/// Button styles support plain and text
class TDConfirmDialog extends StatelessWidget {
  const TDConfirmDialog({
    super.key,
    this.action,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
    this.title,
    this.titleColor = const Color(0xE6000000),
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.buttonText,
    this.buttonTextColor,
    this.buttonStyle = TDDialogButtonStyle.normal,
    this.showCloseButton,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
    this.buttonWidget,
  });

  final String? title;

  final Color titleColor;

  final AlignmentGeometry? titleAlignment;

  final Widget? contentWidget;

  final String? content;

  final Color? contentColor;

  /// The maximum height of the content, the default is 0, which means there is no height limit
  final double contentMaxHeight;

  final String? buttonText;

  final Color? buttonTextColor;

  final VoidCallback? action;

  final Color backgroundColor;

  final TDDialogButtonStyle buttonStyle;

  final double radius;

  /// Close button in the upper right corner
  final bool? showCloseButton;

  final EdgeInsets? padding;

  final Widget? buttonWidget;

  Widget _buildButton(BuildContext context) {
    if (buttonWidget != null) return buttonWidget!;

    if (buttonStyle == TDDialogButtonStyle.text) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyDivider(height: 23, color: Colors.transparent),
          const MyDivider(height: 1),
          TDDialogButton(
            buttonText: buttonText ?? 'Ok',
            buttonTextColor: buttonTextColor,
            buttonType: MyButtonType.text,
            height: 56,
            onPressed: () {
              if (action != null) {
                action!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: TDDialogButton(
          buttonText: buttonText ?? 'Ok',
          buttonTextColor: buttonTextColor,
          onPressed: () {
            if (action != null) {
              action!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      (title != null || content != null || contentWidget != null),
      '// Title and content cannot be empty at the same time',
    );

    return TDDialogScaffold(
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      radius: radius,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: TDDialogInfoWidget(
                    title: title,
                    titleColor: titleColor,
                    titleAlignment: titleAlignment,
                    contentWidget: contentWidget,
                    content: content,
                    contentColor: contentColor,
                    // When contentMaxHeight is not set, use 60% of the screen
                    // as the maximum height and allow scrolling
                    contentMaxHeight:
                        contentMaxHeight > 0
                            ? contentMaxHeight
                            : constraints.maxHeight * 0.6,
                    padding: padding,
                  ),
                ),
              ),
              _buildButton(context),
            ],
          );
        },
      ),
    );
  }
}
