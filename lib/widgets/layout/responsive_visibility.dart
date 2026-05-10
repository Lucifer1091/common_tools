import 'package:flutter/material.dart';

import 'adaptive_ui.dart';

/// Lazily shows a widget for selected adaptive breakpoints.
class ResponsiveVisibility extends StatelessWidget {
  /// Creates a responsive visibility widget.
  const ResponsiveVisibility({
    required this.builder,
    super.key,
    this.replacement,
    this.showCompact = true,
    this.showMedium = true,
    this.showExpanded = true,
    this.showLarge = true,
    this.showExtraLarge = true,
  });

  /// Shows [builder] only on compact breakpoints.
  const ResponsiveVisibility.compact({
    required this.builder,
    super.key,
    this.replacement,
  }) : showCompact = true,
       showMedium = false,
       showExpanded = false,
       showLarge = false,
       showExtraLarge = false;

  /// Shows [builder] only on medium breakpoints.
  const ResponsiveVisibility.medium({
    required this.builder,
    super.key,
    this.replacement,
  }) : showCompact = false,
       showMedium = true,
       showExpanded = false,
       showLarge = false,
       showExtraLarge = false;

  /// Shows [builder] only on expanded breakpoints.
  const ResponsiveVisibility.expanded({
    required this.builder,
    super.key,
    this.replacement,
  }) : showCompact = false,
       showMedium = false,
       showExpanded = true,
       showLarge = false,
       showExtraLarge = false;

  /// Shows [builder] only on large breakpoints.
  const ResponsiveVisibility.large({
    required this.builder,
    super.key,
    this.replacement,
  }) : showCompact = false,
       showMedium = false,
       showExpanded = false,
       showLarge = true,
       showExtraLarge = false;

  /// Shows [builder] only on extra-large breakpoints.
  const ResponsiveVisibility.extraLarge({
    required this.builder,
    super.key,
    this.replacement,
  }) : showCompact = false,
       showMedium = false,
       showExpanded = false,
       showLarge = false,
       showExtraLarge = true;

  /// Lazily builds the visible child.
  final WidgetBuilder builder;

  /// Lazily builds the replacement when the child is hidden.
  final WidgetBuilder? replacement;

  /// Whether to show [builder] on compact breakpoints.
  final bool showCompact;

  /// Whether to show [builder] on medium breakpoints.
  final bool showMedium;

  /// Whether to show [builder] on expanded breakpoints.
  final bool showExpanded;

  /// Whether to show [builder] on large breakpoints.
  final bool showLarge;

  /// Whether to show [builder] on extra-large breakpoints.
  final bool showExtraLarge;

  @override
  Widget build(BuildContext context) {
    final breakpoint = Breakpoint.of(context);

    if (_isVisible(breakpoint.type)) {
      return builder(context);
    }

    return replacement?.call(context) ?? const SizedBox.shrink();
  }

  bool _isVisible(BreakpointType type) {
    return switch (type) {
      BreakpointType.compact => showCompact,
      BreakpointType.medium => showMedium,
      BreakpointType.expanded => showExpanded,
      BreakpointType.large => showLarge,
      BreakpointType.extraLarge => showExtraLarge,
    };
  }
}
