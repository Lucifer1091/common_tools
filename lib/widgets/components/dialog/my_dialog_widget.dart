import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

class MyDialogScaffold extends StatelessWidget {
  const MyDialogScaffold({
    required this.body,
    super.key,
    this.height,
    this.width,
    this.margin,
    this.showCloseButton,
    this.backgroundColor,
    this.radius,
  });

  final Widget body;
  final double? height, width;
  final EdgeInsetsGeometry? margin;
  final bool? showCloseButton;
  final Color? backgroundColor;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: width ?? 320,
          height: height,
          margin: margin ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor ?? context.colorScheme.popover,
            borderRadius: radius ?? MyBorderRadius.large,
            border: Border.all(color: context.colorScheme.border),
          ),
          child: Stack(
            children: [
              body,
              if (showCloseButton ?? false)
                Positioned(
                  top: 6,
                  right: 6,
                  child: MyGestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Center(
                        child: Icon(
                          LucideIcons.x,
                          size: 22,
                          color: context.colorScheme.popoverForeground,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDialogTitle extends StatelessWidget {
  const MyDialogTitle({super.key, this.title, this.titleColor});

  final Color? titleColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return MyText(
      title,
      textColor: titleColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      textAlign: TextAlign.center,
    );
  }
}

class MyDialogContent extends StatelessWidget {
  const MyDialogContent({
    super.key,
    this.content,
    this.contentColor,
    this.contentAlignment,
  });

  final AlignmentGeometry? contentAlignment;
  final Color? contentColor;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return MyText(
      content,
      textColor: contentColor,
      fontSize: 14,
      textAlign: switch (contentAlignment) {
        Alignment.centerLeft => TextAlign.left,
        Alignment.centerRight => TextAlign.right,
        _ => TextAlign.center,
      },
    );
  }
}

class MyDialogInfoWidget extends StatelessWidget {
  const MyDialogInfoWidget({
    super.key,
    this.title,
    this.titleColor,
    this.titleAlignment,
    this.contentAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.padding,
    this.fullscreen = false,
  });

  final String? title;
  final Color? titleColor;
  final AlignmentGeometry? titleAlignment, contentAlignment;
  final String? content;
  final Color? contentColor;
  final Widget? contentWidget;
  final double contentMaxHeight;
  final EdgeInsetsGeometry? padding;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    assert((title != null || content != null || contentWidget != null), '');

    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Align(
              alignment: titleAlignment ?? Alignment.center,
              child: MyText(
                title,
                textColor: titleColor ?? context.colorScheme.popoverForeground,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ),
          if (contentWidget != null || content != null)
            Container(
              padding: EdgeInsets.fromLTRB(
                0,
                (title != null && content != null) ? 8.0 : 0,
                0,
                0,
              ),
              constraints:
                  contentMaxHeight > 0
                      ? BoxConstraints(maxHeight: contentMaxHeight)
                      : null,
              child:
                  contentWidget ??
                  SingleChildScrollView(
                    child: Align(
                      alignment: contentAlignment ?? Alignment.center,
                      child: MyDialogContent(
                        content: content,
                        contentAlignment: contentAlignment,
                        contentColor:
                            contentColor ?? context.colorScheme.mutedForeground,
                      ),
                    ),
                  ),
            ).expanded(enabled: fullscreen),
        ],
      ),
    );
  }
}

class MyDialogShrinkButtons extends StatelessWidget {
  const MyDialogShrinkButtons({
    required this.rightBtn,
    this.leftBtn,
    this.padding,
    super.key,
  });

  final MyDialogButtonOptions? leftBtn;
  final MyDialogButtonOptions rightBtn;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (leftBtn != null)
            MyDialogButton(
              buttonText: leftBtn!.title,
              buttonTextColor: leftBtn!.titleColor,
              buttonTextSize: leftBtn!.titleSize,
              buttonStyle: leftBtn!.style,
              buttonType: leftBtn!.type,
              height: leftBtn!.height,
              buttonTextFontWeight: leftBtn!.fontWeight,
              isExpanded: false,
              onPressed: () {
                if (leftBtn!.action != null) {
                  leftBtn!.action!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          const Gap(12),
          MyDialogButton(
            buttonText: rightBtn.title,
            buttonTextColor: rightBtn.titleColor,
            buttonTextSize: rightBtn.titleSize,
            buttonStyle: rightBtn.style,
            buttonType: rightBtn.type,
            height: rightBtn.height,
            buttonTextFontWeight: rightBtn.fontWeight,
            isExpanded: false,
            onPressed: () {
              if (rightBtn.action != null) {
                rightBtn.action!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class MyDialogExpandedButtons extends StatelessWidget {
  const MyDialogExpandedButtons({
    required this.leftBtn,
    required this.rightBtn,
    this.padding,
    super.key,
  });

  final MyDialogButtonOptions leftBtn;
  final MyDialogButtonOptions rightBtn;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MyDialogButton(
              buttonText: leftBtn.title,
              buttonTextColor: leftBtn.titleColor,
              buttonTextSize: leftBtn.titleSize,
              buttonStyle: leftBtn.style,
              buttonType: leftBtn.type,
              height: leftBtn.height,
              buttonTextFontWeight: leftBtn.fontWeight,
              onPressed: () {
                if (leftBtn.action != null) {
                  leftBtn.action!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const Gap(12),
          Expanded(
            child: MyDialogButton(
              buttonText: rightBtn.title,
              buttonTextColor: rightBtn.titleColor,
              buttonTextSize: rightBtn.titleSize,
              buttonStyle: rightBtn.style,
              buttonType: rightBtn.type,
              height: rightBtn.height,
              buttonTextFontWeight: rightBtn.fontWeight,
              onPressed: () {
                if (rightBtn.action != null) {
                  rightBtn.action!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyDialogButton extends StatelessWidget {
  const MyDialogButton({
    required this.onPressed,
    super.key,
    this.buttonText,
    this.buttonTextColor,
    this.buttonTextSize,
    this.buttonTextFontWeight,
    this.buttonStyle,
    this.buttonType,
    this.height,
    this.width,
    this.isExpanded = true,
  });

  final String? buttonText;
  final Color? buttonTextColor;
  final double? buttonTextSize;
  final FontWeight? buttonTextFontWeight;
  final MyButtonStyle? buttonStyle;
  final MyButtonType? buttonType;
  final double? width;
  final double? height;
  final bool isExpanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onTap: onPressed,
      style: buttonStyle != null ? (states) => buttonStyle! : null,
      type: buttonType ?? MyButtonType.primary,
      text: buttonText,
      textStyle: TextStyle(
        fontWeight: buttonTextFontWeight ?? FontWeight.w400,
        color: buttonTextColor,
        fontSize: buttonTextSize ?? 14,
      ),
      width: width,
      height: height ?? 36,
      isExpanded: isExpanded,
      margin: EdgeInsets.zero,
    );
  }
}
