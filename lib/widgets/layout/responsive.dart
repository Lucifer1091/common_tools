import 'package:flutter/material.dart';

import '../../common_tools.dart';
import 'adaptive_ui.dart';
import 'adaptive_widget.dart';

/// A widget that manages UI responsiveness based on predefined breakpoints.
///
/// This class provides utility methods to determine the current device size
/// and select appropriate widgets to render based on those sizes.
///
/// [showDeviceLogs] when set to true will print exact breakpoints in console
///
class Responsive extends AdaptiveWidget {
  const Responsive({
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
    this.showDeviceLogs = false,
    super.key,
  });

  final Widget compact;
  final Widget? medium;
  final Widget? expanded;
  final Widget? large;
  final Widget? extraLarge;

  final bool showDeviceLogs;

  /// Retrieves a value based on the current device size.
  ///
  /// Returns the appropriate value based on the current device size category.
  static T value<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    final Breakpoint breakpoint = context.readBreakpoint;

    if (breakpoint.isExtraLarge) {
      return extraLarge ?? large ?? expanded ?? medium ?? compact;
    } else if (breakpoint.isLarge) {
      return large ?? expanded ?? medium ?? compact;
    } else if (breakpoint.isExpanded) {
      return expanded ?? medium ?? compact;
    } else if (breakpoint.isMedium) {
      return medium ?? compact;
    } else {
      return compact;
    }
  }

  /// Executes a callback based on the current device size.
  ///
  /// Calls the appropriate callback function based on the current device size category.
  static void callback(
    BuildContext context, {
    required VoidCallback compact,
    VoidCallback? medium,
    VoidCallback? expanded,
    VoidCallback? large,
    VoidCallback? extraLarge,
  }) {
    final Breakpoint breakpoint = context.readBreakpoint;

    if (breakpoint.isExtraLarge) {
      (extraLarge ?? large ?? expanded ?? medium ?? compact)();
    } else if (breakpoint.isLarge) {
      (large ?? expanded ?? medium ?? compact)();
    } else if (breakpoint.isExpanded) {
      (expanded ?? medium ?? compact)();
    } else if (breakpoint.isMedium) {
      (medium ?? compact)();
    } else {
      compact();
    }
  }

  /// Creates a sample `Responsive` widget for testing purposes.
  static Responsive test() {
    return const Responsive(
      showDeviceLogs: true,
      compact: ColoredBox(color: Colors.red, child: Text('COMPACT')),
      medium: ColoredBox(color: Colors.blue, child: Text('MEDIUM')),
      expanded: ColoredBox(color: Colors.green, child: Text('EXPANDED')),
      large: ColoredBox(color: Colors.yellow, child: Text('LARGE')),
      extraLarge: ColoredBox(
        color: Colors.deepPurpleAccent,
        child: Text('EXTRA LARGE'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _showLog(context);
    return super.build(context);
  }

  void _showLog(BuildContext context) {
    if (!showDeviceLogs) return;

    final double height = context.height, width = context.width;

    String size(String title) => '$title => Width: $width, Height: $height';

    final String message = value<String>(
      context,
      compact: size('COMPACT'),
      medium: size('MEDIUM'),
      expanded: size('EXPANDED'),
      large: size('LARGE'),
      extraLarge: size('EXTRA LARGE'),
    );

    log.i(message);
  }

  @override
  Widget buildCopmact(BuildContext context) => compact;

  @override
  Widget? buildMedium(BuildContext context) => medium;

  @override
  Widget? buildExpanded(BuildContext context) => expanded;

  @override
  Widget? buildLarge(BuildContext context) => large;

  @override
  Widget? buildExtraLarge(BuildContext context) => extraLarge;
}
