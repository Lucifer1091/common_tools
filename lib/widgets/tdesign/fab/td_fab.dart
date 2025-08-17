import 'package:flutter/material.dart';

import '../../../index.dart';

enum TDFabTheme { primary, defaultTheme, light, danger }

enum TDFabShape { circle, square }

enum TDFabSize { large, medium, small, extraSmall }

class TDFab extends StatelessWidget {
  const TDFab({
    super.key,
    this.theme = TDFabTheme.defaultTheme,
    this.shape = TDFabShape.circle,
    this.size = TDFabSize.large,
    this.text,
    this.onClick,
    this.icon,
  });

  final TDFabTheme theme;

  final TDFabShape shape;

  final TDFabSize size;

  final String? text;

  final Icon? icon;

  final VoidCallback? onClick;

  bool get showText => text != null && text != '';

  EdgeInsets getPadding() {
    switch (size) {
      case TDFabSize.large:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
            : const EdgeInsets.all(12);
      case TDFabSize.medium:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.all(10);
      case TDFabSize.small:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 5)
            : const EdgeInsets.all(7);
      case TDFabSize.extraSmall:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
            : const EdgeInsets.all(5);
    }
  }

  double getMinWidthOrHeight() {
    return switch (size) {
      TDFabSize.large => 48.0,
      TDFabSize.medium => 40.0,
      TDFabSize.small => 32.0,
      TDFabSize.extraSmall => 28.0,
    };
  }

  Color getBackgroundColor(BuildContext context) {
    switch (theme) {
      case TDFabTheme.primary:
        return ThemeColors.blue.shade600;
      case TDFabTheme.defaultTheme:
        return ThemeColors.neutral.shade200;
      case TDFabTheme.light:
        return ThemeColors.blue.shade50;
      case TDFabTheme.danger:
        return ThemeColors.error.shade500;
    }
  }

  Color getIconColor(BuildContext context) {
    switch (theme) {
      case TDFabTheme.primary:
        return Colors.white;
      case TDFabTheme.defaultTheme:
        return ThemeColors.neutral.shade900.withValues(alpha: 0.9);
      case TDFabTheme.light:
        return ThemeColors.blue.shade600;
      case TDFabTheme.danger:
        return Colors.white;
    }
  }

  double getIconSize() {
    return switch (size) {
      TDFabSize.large => 24.0,
      TDFabSize.medium => 20.0,
      TDFabSize.small => 18.0,
      TDFabSize.extraSmall => 18.0,
    };
  }

  double getFontSize() {
    return switch (size) {
      TDFabSize.large => 16.0,
      TDFabSize.medium => 16.0,
      TDFabSize.small => 14.0,
      TDFabSize.extraSmall => 14.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: InkWell(
        child: Container(
          padding: getPadding(),
          decoration: BoxDecoration(
            color: getBackgroundColor(context),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                blurRadius: 2.5,
                spreadRadius: -1.5,
                color: Colors.black.withValues(alpha: 0.1),
              ),
              BoxShadow(
                offset: const Offset(0, 8),
                blurRadius: 5,
                spreadRadius: 0.5,
                color: Colors.black.withValues(alpha: 0.06),
              ),
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 7,
                spreadRadius: 1,
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ],
            borderRadius:
                shape == TDFabShape.circle
                    ? BorderRadius.circular(24)
                    : BorderRadius.circular(6),
          ),
          height: getMinWidthOrHeight(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ??
                  Icon(
                    Icons.add_rounded,
                    size: getIconSize(),
                    color: getIconColor(context),
                  ),
              Visibility(visible: showText, child: const SizedBox(width: 4)),
              Visibility(
                visible: showText,
                child: TDText(
                  text ?? '',
                  style: TextStyle(
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    fontSize: getFontSize(),
                    color: getIconColor(context),
                    leadingDistribution: TextLeadingDistribution.even,
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
