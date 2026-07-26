import 'package:flutter/material.dart';

import 'adaptive_ui.dart';
import 'adaptive_widget.dart';

/// Renders the nearest matching widget for the active breakpoint.
class Responsive extends AdaptiveWidget {
  const Responsive({
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
    super.key,
  });

  final Widget compact;
  final Widget? medium;
  final Widget? expanded;
  final Widget? large;
  final Widget? extraLarge;

  /// Lazily builds only the selected breakpoint branch.
  static Widget builder({
    required WidgetBuilder compact,
    WidgetBuilder? medium,
    WidgetBuilder? expanded,
    WidgetBuilder? large,
    WidgetBuilder? extraLarge,
  }) {
    return _ResponsiveBuilder(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// Retrieves a value for the active breakpoint.
  static T value<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
    bool listen = true,
  }) {
    final breakpoint = Breakpoint.of(context, listen: listen);
    return breakpoint.resolve<T>(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// Executes a callback for the active breakpoint.
  static void callback(
    BuildContext context, {
    required VoidCallback compact,
    VoidCallback? medium,
    VoidCallback? expanded,
    VoidCallback? large,
    VoidCallback? extraLarge,
    bool listen = false,
  }) {
    final breakpoint = Breakpoint.of(context, listen: listen);
    breakpoint
        .resolve<VoidCallback>(
          compact: compact,
          medium: medium,
          expanded: expanded,
          large: large,
          extraLarge: extraLarge,
        )
        .call();
  }

  @override
  Widget buildCompact(BuildContext context) => compact;

  @override
  Widget? buildMedium(BuildContext context) => medium;

  @override
  Widget? buildExpanded(BuildContext context) => expanded;

  @override
  Widget? buildLarge(BuildContext context) => large;

  @override
  Widget? buildExtraLarge(BuildContext context) => extraLarge;
}

class _ResponsiveBuilder extends AdaptiveWidget {
  const _ResponsiveBuilder({
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;
  final WidgetBuilder? large;
  final WidgetBuilder? extraLarge;

  @override
  Widget buildCompact(BuildContext context) => compact(context);

  @override
  Widget? buildMedium(BuildContext context) => medium?.call(context);

  @override
  Widget? buildExpanded(BuildContext context) => expanded?.call(context);

  @override
  Widget? buildLarge(BuildContext context) => large?.call(context);

  @override
  Widget? buildExtraLarge(BuildContext context) => extraLarge?.call(context);
}
