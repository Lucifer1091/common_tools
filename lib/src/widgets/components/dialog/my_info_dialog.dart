import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../packages/gap/src/widgets/gap.dart';
import './my_dialog_widget.dart';

/// A popup control with only one button
///
/// Button styles support plain and text
class MyInfoDialog extends StatelessWidget {
  const MyInfoDialog({
    super.key,
    this.action,
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
    this.buttonText,
    this.buttonTextColor,
    this.showCloseButton,
    this.padding,
    this.margin,
    this.buttonWidget,
  }) : assert(
         (title != null || content != null || contentWidget != null),
         'Title, content or contentWidget cannot be empty at the same time',
       );

  final double? height, width;
  final String? title;
  final Color? titleColor;
  final AlignmentGeometry? titleAlignment, contentAlignment;
  final Widget? contentWidget;
  final String? content;
  final Color? contentColor;
  final double contentMaxHeight;
  final String? buttonText;
  final Color? buttonTextColor;
  final VoidCallback? action;
  final Color? backgroundColor;
  final BorderRadius? radius;
  final bool? showCloseButton;
  final EdgeInsets? padding;
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: MyDialogInfoWidget(
                    title: title,
                    titleColor: titleColor,
                    titleAlignment: titleAlignment,
                    contentAlignment: contentAlignment,
                    contentWidget: contentWidget,
                    content: content,
                    contentColor: contentColor,
                    // When contentMaxHeight is not set, use 60% of the screen
                    // as the maximum height and allow scrolling
                    contentMaxHeight: contentMaxHeight > 0
                        ? contentMaxHeight
                        : constraints.maxHeight * 0.6,
                    padding: padding,
                  ),
                ),
              ),
              const Gap(24),
              _buildButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (buttonWidget != null) return buttonWidget!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: MyDialogButton(
        buttonText: buttonText ?? 'OK',
        buttonTextColor:
            buttonTextColor ?? context.colorScheme.primaryForeground,
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
