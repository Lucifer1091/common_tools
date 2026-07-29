import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/shadows.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/widget.dart';
import '../text/my_text.dart';

enum MyBackTopStyle { circle, halfCircle }

class MyBackTop extends StatelessWidget {
  const MyBackTop({
    super.key,
    this.controller,
    this.style = MyBackTopStyle.circle,
    this.showText = false,
    this.duration,
    this.onTap,
    this.color,
    this.foreground,
  });

  final ScrollController? controller;
  final MyBackTopStyle style;
  final bool showText;
  final VoidCallback? onTap;
  final Duration? duration;
  final Color? color;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller != null && controller!.hasClients) {
          unawaited(
            controller!.animateTo(
              0,
              duration: duration ?? Durations.medium2,
              curve: Curves.easeIn,
            ),
          );
        }

        onTap?.call();
      },
      child: style == MyBackTopStyle.circle
          ? _buildCircleWidget(context)
          : _buildHalfCircleWidget(context),
    ).mouseRegion;
  }

  Widget _buildCircleWidget(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: EdgeInsets.symmetric(vertical: showText ? 6 : 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.colorScheme.border, width: 0.5),
        color: _getColor(context),
        boxShadow: MyBoxShadows.lg2,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              LucideIcons.arrowUpToLine,
              size: 20,
              color: _getForeground(context),
            ),
            Visibility(
              visible: showText,
              child: MyText(
                'Top',
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 10,
                  color: _getForeground(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfCircleWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 38),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getColor(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(999),
            bottomLeft: Radius.circular(999),
          ),
          border: Border.all(color: context.colorScheme.border, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.arrowUpToLine, size: 22, color: color),
            const SizedBox(width: 2),
            Visibility(
              visible: showText,
              child: SizedBox(
                height: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      'Back',
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 10,
                        color: _getForeground(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    MyText(
                      'Top',
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 10,
                        color: _getForeground(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    return color ?? context.colorScheme.secondary;
  }

  Color _getForeground(BuildContext context) {
    return foreground ?? context.colorScheme.secondaryForeground;
  }
}
