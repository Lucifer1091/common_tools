import 'package:flutter/material.dart';

import '../../widgets/layout/adaptive_ui.dart';

/// Convenience accessors for common size and breakpoint operations on
/// [BuildContext].
///
/// This extension wraps frequently used `MediaQuery` and adaptive-layout calls
/// into concise getters/methods.
///
/// Example:
/// ```dart
/// final double cardWidth = context.value<double>(
///   compact: context.pw(92),
///   medium: 500,
///   expanded: 640,
/// );
/// ```
extension ContextSizeExtension on BuildContext {
  /// Returns the nearest [NavigatorState] if found else null.
  NavigatorState? get navigator => Navigator.maybeOf(this);

  /// Returns the current logical screen size from [MediaQuery].
  Size get size => MediaQuery.sizeOf(this);

  /// Returns `size.width`.
  double get width => size.width;

  /// Returns `size.height`.
  double get height => size.height;

  /// Returns the nearest [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns padding for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Returns the [TextScaler] from [MediaQuery].
  TextScaler get textScaler => MediaQuery.textScalerOf(this);

  /// Returns viewInsets for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  ///
  /// Use of this method will cause the given [BuildContext] to rebuild any time that
  /// the [MediaQueryData.viewInsets] property of the ancestor [MediaQuery] changes.
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Returns [MediaQueryData.viewPadding] for this context.
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// Returns `true` when the soft keyboard is currently visible.
  bool get isKeyboardShowing => viewInsets.bottom > 0;

  /// Returns status-bar top padding plus [kToolbarHeight].
  ///
  /// Useful as an estimated full app-bar occupied vertical space.
  double get appBarHeight => mediaQuery.padding.top + kToolbarHeight;

  /// Returns [MediaQueryData.devicePixelRatio].
  double get pixelRatio => mediaQuery.devicePixelRatio;

  /// Returns the current device orientation.
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// Returns `true` when [orientation] is [Orientation.landscape].
  bool get isLandscape => orientation == Orientation.landscape;

  /// Returns `true` when [orientation] is [Orientation.portrait].
  bool get isPortrait => orientation == Orientation.portrait;

  /// Returns the active adaptive [Breakpoint].

  /// Returns `true` when the active breakpoint is compact.
  bool get isCompact => watchBreakpoint.isCompact;

  /// Returns `true` when the active breakpoint is medium.
  bool get isMedium => watchBreakpoint.isMedium;

  /// Returns `true` when the active breakpoint is expanded.
  bool get isExpanded => watchBreakpoint.isExpanded;

  /// Returns `true` when the active breakpoint is large.
  bool get isLarge => watchBreakpoint.isLarge;

  /// Returns `true` when the active breakpoint is extra large.
  bool get isExtraLarge => watchBreakpoint.isExtraLarge;

  /// Resolves a value based on the current adaptive breakpoint.
  ///
  /// Fallback order:
  /// - Extra-large: `extraLarge -> large -> expanded -> medium -> compact`
  /// - Large: `large -> expanded -> medium -> compact`
  /// - Expanded: `expanded -> medium -> compact`
  /// - Medium: `medium -> compact`
  /// - Compact: `compact`
  ///
  /// Example:
  /// ```dart
  /// final int columns = context.value<int>(
  ///   compact: 1,
  ///   medium: 2,
  ///   expanded: 3,
  /// );
  /// ```
  T value<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
    bool listen = true,
  }) {
    final breakpoint = Breakpoint.of(this, listen: listen);
    return breakpoint.resolve<T>(
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// Executes a callback chosen by the current adaptive breakpoint.
  ///
  /// Uses the same fallback chain as [value].
  ///
  /// Example:
  /// ```dart
  /// context.callback(
  ///   compact: () => debugPrint('mobile'),
  ///   expanded: () => debugPrint('desktop'),
  /// );
  /// ```
  void callback({
    required VoidCallback compact,
    VoidCallback? medium,
    VoidCallback? expanded,
    VoidCallback? large,
    VoidCallback? extraLarge,
    bool listen = false,
  }) {
    final breakpoint = Breakpoint.of(this, listen: listen);
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

  /// Returns [percent] of the current screen width.
  ///
  /// For example, `pw(50)` returns half of [width].
  double pw(double percent) => width * (percent / 100);

  /// Returns [percent] of the current screen height.
  ///
  /// For example, `ph(50)` returns half of [height].
  double ph(double percent) => height * (percent / 100);
}
