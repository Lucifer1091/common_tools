import 'dart:math';

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyNonAnimatedExpandIcon extends StatelessWidget {
  const MyNonAnimatedExpandIcon({
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
    return TweenAnimationBuilder(
      tween: isExpanded ? Tween(begin: 1.0, end: 0) : Tween(begin: 0, end: 1.0),
      duration: kDefaultDuration,
      builder: (context, value, child) {
        return Padding(
          padding: padding,
          child: Transform.rotate(
            angle: value * pi,
            child: IconTheme(
              data: IconThemeData(color: context.colorScheme.mutedForeground),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 24,
                color: getIconColor(context),
              ),
            ),
          ),
        );
      },
    );
    // return IconButton(
    //   padding: padding,
    //   iconSize: 24,
    //   color: getIconColor(context),
    //   onPressed: null,
    //   icon:
    //       isExpanded
    //           ? const Icon(Icons.expand_less)
    //           : const Icon(Icons.expand_more),
    // );
  }
}
