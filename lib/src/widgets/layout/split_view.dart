import 'package:flutter/material.dart';

/// Shows navigation beside content when enough width is available.
class SplitView extends StatelessWidget {
  const SplitView({
    required this.navigationBuilder,
    required this.contentBuilder,
    super.key,
    this.breakpoint = 600,
    this.navigationWidth = 300,
  }) : assert(breakpoint >= 0, 'breakpoint must be non-negative'),
       assert(navigationWidth >= 0, 'navigationWidth must be non-negative');

  final WidgetBuilder navigationBuilder;
  final WidgetBuilder contentBuilder;
  final double breakpoint;
  final double navigationWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useSplitLayout =
            constraints.hasBoundedWidth && constraints.maxWidth >= breakpoint;

        if (!useSplitLayout) return contentBuilder(context);

        final effectiveNavigationWidth = navigationWidth.clamp(
          0.0,
          constraints.maxWidth,
        );

        return Row(
          children: [
            SizedBox(
              width: effectiveNavigationWidth,
              child: navigationBuilder(context),
            ),
            Expanded(child: contentBuilder(context)),
          ],
        );
      },
    );
  }
}
