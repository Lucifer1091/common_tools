import 'package:flutter/material.dart';

import '../../../index.dart';
import '../button/td_button.dart';
import '../button/td_button_style.dart';
import '../divider/td_divider.dart';
import '../text/td_text.dart';
import 'td_dialog.dart';

class TDDialogScaffold extends StatelessWidget {
  const TDDialogScaffold({
    required this.body,
    super.key,
    this.showCloseButton,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
  });

  final Widget body;

  final bool? showCloseButton;

  final Color backgroundColor;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 311,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Stack(
            children: [
              body,
              if (showCloseButton ?? false)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 22,
                          color: ThemeColors.neutral.shade700,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class TDDialogTitle extends StatelessWidget {
  const TDDialogTitle({super.key, this.title, this.titleColor = Colors.black});

  final Color titleColor;

  final String? title;

  @override
  Widget build(BuildContext context) {
    return TDText(
      title,
      textColor: titleColor,
      fontWeight: FontWeight.w600,
      style: TextStyle(fontSize: 16, height: 24, color: titleColor),
      textAlign: TextAlign.center,
    );
  }
}

class TDDialogContent extends StatelessWidget {
  const TDDialogContent({
    super.key,
    this.content,
    this.contentColor = const Color(0x99000000),
  });

  final Color contentColor;

  final String? content;

  @override
  Widget build(BuildContext context) {
    return TDText(
      content,
      textColor: contentColor,
      style: TextStyle(fontSize: 16, height: 24, color: contentColor),
      textAlign: TextAlign.center,
    );
  }
}

class TDDialogInfoWidget extends StatelessWidget {
  const TDDialogInfoWidget({
    super.key,
    this.title,
    this.titleColor = Colors.black,
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
  });

  final String? title;

  final Color titleColor;

  final AlignmentGeometry? titleAlignment;

  final Widget? contentWidget;

  final String? content;

  final Color? contentColor;

  final double contentMaxHeight;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    assert((title != null || content != null || contentWidget != null), '');
    return Container(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Align(
              alignment: titleAlignment ?? Alignment.center,
              child: TDText(
                title,
                textColor: titleColor,
                fontWeight: FontWeight.w600,
                style: TextStyle(fontSize: 18, height: 26, color: titleColor),
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
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: TDDialogContent(
                        content: content,
                        contentColor: contentColor ?? const Color(0x99000000),
                      ),
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}

class HorizontalNormalButtons extends StatelessWidget {
  const HorizontalNormalButtons({
    required this.leftBtn,
    required this.rightBtn,
    super.key,
  });

  final TDDialogButtonOptions leftBtn;

  final TDDialogButtonOptions rightBtn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TDDialogButton(
              buttonText: leftBtn.title,
              buttonTextColor: leftBtn.titleColor,
              buttonTextSize: leftBtn.titleSize,
              buttonStyle: leftBtn.style,
              buttonType: leftBtn.type,
              buttonTheme: leftBtn.theme,
              height: leftBtn.height,
              buttonTextFontWeight: leftBtn.fontWeight ?? FontWeight.w600,
              onPressed: () {
                if (leftBtn.action != null) {
                  leftBtn.action!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const TDDivider(width: 12, color: Colors.transparent),
          Expanded(
            child: TDDialogButton(
              buttonText: rightBtn.title,
              buttonTextColor: rightBtn.titleColor,
              buttonTextSize: rightBtn.titleSize,
              buttonStyle: rightBtn.style,
              buttonType: rightBtn.type,
              buttonTheme: rightBtn.theme,
              height: rightBtn.height,
              buttonTextFontWeight: rightBtn.fontWeight ?? FontWeight.w600,
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

class HorizontalTextButtons extends StatelessWidget {
  const HorizontalTextButtons({
    required this.leftBtn,
    required this.rightBtn,
    super.key,
  });

  final TDDialogButtonOptions leftBtn;

  final TDDialogButtonOptions rightBtn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TDDivider(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TDDialogButton(
                buttonText: leftBtn.title,
                buttonTextColor: leftBtn.titleColor,
                buttonTextSize: leftBtn.titleSize,
                buttonStyle: leftBtn.style,
                buttonType: leftBtn.type ?? TDButtonType.text,
                buttonTheme: leftBtn.theme,
                // fix： The button height does not fill the container.
                height: 56,
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
            const TDDivider(width: 1, height: 56),
            Expanded(
              child: TDDialogButton(
                buttonText: rightBtn.title,
                buttonTextColor: rightBtn.titleColor,
                buttonTextSize: rightBtn.titleSize,
                buttonStyle: rightBtn.style,
                buttonType: rightBtn.type ?? TDButtonType.text,
                buttonTheme: rightBtn.theme ?? TDButtonTheme.primary,
                height: 56,
                buttonTextFontWeight: rightBtn.fontWeight ?? FontWeight.w600,
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
      ],
    );
  }
}

class TDDialogButton extends StatelessWidget {
  const TDDialogButton({
    required this.onPressed,
    super.key,
    this.buttonText,
    this.buttonTextColor,
    this.buttonTextSize,
    this.buttonTextFontWeight = FontWeight.w600,
    this.buttonStyle,
    this.buttonType,
    this.buttonTheme,
    this.height = 40.0,
    this.width,
    this.isBlock = true,
  });

  final String? buttonText;

  final Color? buttonTextColor;

  final double? buttonTextSize;

  final FontWeight? buttonTextFontWeight;

  final TDButtonStyle? buttonStyle;

  final TDButtonType? buttonType;

  final TDButtonTheme? buttonTheme;

  final double? width;

  final double? height;

  final bool isBlock;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TDButton(
      onTap: onPressed,
      style: buttonStyle,
      type: buttonType ?? TDButtonType.fill,
      theme: buttonTheme,
      text: buttonText,
      textStyle: TextStyle(
        fontWeight: buttonTextFontWeight,
        color: buttonTextColor,
        fontSize: buttonTextSize,
      ),
      width: width,
      height: height,
      isBlock: isBlock,
      margin: EdgeInsets.zero,
    );
  }
}
