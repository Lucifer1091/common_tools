import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    required this.navigationBuilder,
    required this.contentBuilder,
    super.key,
    this.breakpoint = 600,
    this.navigationWidth = 300,
  });
  
  final WidgetBuilder navigationBuilder;
  final WidgetBuilder contentBuilder;
  final double breakpoint;
  final double navigationWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth >= breakpoint) {
      // * wide screen: navigation on the left, content on the right
      return Row(
        children: [
          SizedBox(width: navigationWidth, child: navigationBuilder(context)),
          // if you want, add a divider here
          Expanded(child: contentBuilder(context)),
        ],
      );
    } else {
      // * show content only (handle navigation with a drawer or similar)
      return contentBuilder(context);
    }
  }
}
