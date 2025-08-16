import 'package:flutter/material.dart';

import 'adaptive_ui.dart';

/// AdaptiveWidget : Widget that adapts to the screen size by creating multiple
/// widgets for different screen sizes.
/// It has breakpoints for small mobile, medium mobile, large mobile, small
/// tablet and large tablet.
/// These breakpoints are based on the smallest width of the screen.
abstract class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakpointLayoutBuilder(
      builder: (context, breakpoint) {
        return switch (breakpoint.type) {
          BreakpointType.compact => buildCopmact(context),
          BreakpointType.medium =>
            buildMedium(context) ?? buildCopmact(context),
          BreakpointType.expanded =>
            buildExpanded(context) ??
                buildMedium(context) ??
                buildCopmact(context),
          BreakpointType.large =>
            buildLarge(context) ??
                buildExpanded(context) ??
                buildMedium(context) ??
                buildCopmact(context),
          BreakpointType.extraLarge =>
            buildExtraLarge(context) ??
                buildLarge(context) ??
                buildExpanded(context) ??
                buildMedium(context) ??
                buildCopmact(context),
        };
      },
    );
  }

  /// It will be called as default widget for small or medium mobile devices.
  Widget buildCopmact(BuildContext context);

  /// If this method is not implemented, [buildCopmact] will be called.
  Widget? buildMedium(BuildContext context) => null;

  /// If this method is not implemented, [buildMedium] will be called.
  /// If [buildMedium] is not implemented, [buildCopmact] will be called.
  Widget? buildExpanded(BuildContext context) => null;

  /// If this method is not implemented, [buildExpanded] will be called.
  /// If [buildExpanded] is not implemented, [buildMedium] will be called.
  /// If [buildMedium] is not implemented, [buildCopmact] will be called.
  Widget? buildLarge(BuildContext context) => null;

  /// If this method is not implemented, [buildLarge] will be called.
  /// If [buildLarge] is not implemented, [buildExpanded] will be called.
  /// If [buildExpanded] is not implemented, [buildMedium] will be called.
  /// If [buildMedium] is not implemented, [buildCopmact] will be called.
  Widget? buildExtraLarge(BuildContext context) => null;
}
