import 'package:flutter/material.dart';

import '../../widgets/layout/adaptive_ui.dart';

extension ContextSizeExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;

  double get height => size.height;

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

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  double get statusBarHeight => padding.top;

  /// software keyboard height
  double get keyboardHeight => viewInsets.bottom;

  /// Returns true if keyboard is visible
  bool get isKeyboardShowing => viewInsets.bottom > 0;

  double get appBarHeight => mediaQuery.padding.top + kToolbarHeight;

  /// safeAreaBottomPadding
  double get bottomBarHeight => padding.bottom;

  /// return screen devicePixelRatio
  double get pixelRatio => mediaQuery.devicePixelRatio;

  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  Breakpoint get _currentBreakpoint =>
      maybeReadBreakpoint ?? Breakpoint.forWidth(width);

  bool get isCompact => _currentBreakpoint.isCompact;
  bool get isMedium => _currentBreakpoint.isMedium;
  bool get isExpanded => _currentBreakpoint.isExpanded;
  bool get isLarge => _currentBreakpoint.isLarge;
  bool get isExtraLarge => _currentBreakpoint.isExtraLarge;

  T value<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    final breakpoint = _currentBreakpoint;
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

  void callback({
    required VoidCallback compact,
    VoidCallback? medium,
    VoidCallback? expanded,
    VoidCallback? large,
    VoidCallback? extraLarge,
  }) {
    final breakpoint = _currentBreakpoint;
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

  /// percent with
  double pw(double percent) => width * (percent / 100);

  /// percent height
  double ph(double percent) => height * (percent / 100);
}
