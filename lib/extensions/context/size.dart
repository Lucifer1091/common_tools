import 'package:flutter/material.dart';

import '../../widgets/layout/adaptive_ui.dart';
import '../../widgets/layout/responsive.dart';

extension ContextSizeExtension on BuildContext {
  /// Equivalent as `Navigator.of(context)`
  NavigatorState get navigator => Navigator.of(this);

  /// Equivalent as `MediaQuery.sizeOf(context)`
  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;

  double get height => size.height;

  /// Equivalent as `MediaQuery.of(context)`
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns padding for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Returns viewInsets for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  ///
  /// Use of this method will cause the given [BuildContext] to rebuild any time that
  /// the [MediaQueryData.viewInsets] property of the ancestor [MediaQuery] changes.
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// viewPadding
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// safeAreaTopPadding
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

  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  bool get isCompact => readBreakpoint.isCompact;
  bool get isMedium => readBreakpoint.isMedium;
  bool get isExpanded => readBreakpoint.isExpanded;
  bool get isLarge => readBreakpoint.isLarge;
  bool get isExtraLarge => readBreakpoint.isExtraLarge;

  T value<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return Responsive.value(
      this,
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  void callback<T>({
    required VoidCallback compact,
    VoidCallback? medium,
    VoidCallback? expanded,
    VoidCallback? large,
    VoidCallback? extraLarge,
  }) {
    return Responsive.callback(
      this,
      compact: compact,
      medium: medium,
      expanded: expanded,
      large: large,
      extraLarge: extraLarge,
    );
  }

  /// percent with
  double pw(double percent) => width * (percent / 100);

  /// percent height
  double ph(double percent) => height * (percent / 100);
}
