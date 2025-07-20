import 'package:flutter/material.dart';

class TdNonAnimatedExpandIcon extends StatelessWidget {
  const TdNonAnimatedExpandIcon({
    required this.isExpanded,
    required this.padding,
    super.key,
  });

  final bool isExpanded;
  final EdgeInsets padding;

  Color getIconColor(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return Colors.black54;
      case Brightness.dark:
        return Colors.white60;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      iconSize: 24,
      color: getIconColor(context),
      onPressed: null,
      icon:
          isExpanded
              ? const Icon(Icons.expand_less)
              : const Icon(Icons.expand_more),
    );
  }
}
