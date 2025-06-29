import 'package:flutter/material.dart';
import 'optimized_card.dart';

class OptimizedListTile extends StatelessWidget {
  const OptimizedListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.contentPadding,
    this.margin,
    this.padding,
    this.horizontalSpace,
    this.shouldShowCardShadow = true,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? horizontalSpace;
  final bool shouldShowCardShadow;

  @override
  Widget build(BuildContext context) {
    return OptimizedCard(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      margin: margin,
      shouldShowCustomShadow: shouldShowCardShadow,
      child: Row(
        children: [
          if (leading != null)
            Container(padding: contentPadding, child: leading),
          SizedBox(width: horizontalSpace ?? 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(padding: contentPadding, child: title),
                if (subtitle != null)
                  Container(padding: contentPadding, child: subtitle),
              ],
            ),
          ),
          SizedBox(width: horizontalSpace ?? 6),
          if (trailing != null)
            Container(padding: contentPadding, child: trailing),
        ],
      ),
    );
  }
}
