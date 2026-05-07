import 'package:flutter/material.dart';

import 'adaptive_ui.dart';

/// Base class for building different widgets at each [BreakpointType].
abstract class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakpointLayoutBuilder(builder: _buildForBreakpoint);
  }

  Widget _buildForBreakpoint(BuildContext context, Breakpoint breakpoint) {
    return switch (breakpoint.type) {
      BreakpointType.compact => buildCompact(context),
      BreakpointType.medium => buildMedium(context) ?? buildCompact(context),
      BreakpointType.expanded =>
        buildExpanded(context) ?? buildMedium(context) ?? buildCompact(context),
      BreakpointType.large =>
        buildLarge(context) ??
            buildExpanded(context) ??
            buildMedium(context) ??
            buildCompact(context),
      BreakpointType.extraLarge =>
        buildExtraLarge(context) ??
            buildLarge(context) ??
            buildExpanded(context) ??
            buildMedium(context) ??
            buildCompact(context),
    };
  }

  /// Builds the compact layout.
  Widget buildCompact(BuildContext context);

  /// Builds the medium layout, or falls back to [buildCompact].
  Widget? buildMedium(BuildContext context) => null;

  /// Builds the expanded layout, or falls back to the nearest smaller layout.
  Widget? buildExpanded(BuildContext context) => null;

  /// Builds the large layout, or falls back to the nearest smaller layout.
  Widget? buildLarge(BuildContext context) => null;

  /// Builds the extra-large layout, or falls back to the nearest smaller layout.
  Widget? buildExtraLarge(BuildContext context) => null;
}
