part of 'extensions.dart';

extension ContextExtension on BuildContext {
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

  /// return screen devicePixelRatio
  double get pixelRatio => mediaQuery.devicePixelRatio;

  /// Returns viewInsets for the nearest MediaQuery ancestor or
  /// throws an exception, if no such ancestor exists.
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  ThemeData get theme => Theme.of(this);

  bool get isDark => theme.brightness == Brightness.dark;

  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  bool get isCompact => Responsive.isCompact(this);
  bool get isMedium => Responsive.isMedium(this);
  bool get isExpanded => Responsive.isExpanded(this);
  bool get isLarge => Responsive.isLarge(this);
  bool get isExtraLarge => Responsive.isExtraLarge(this);

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

  /// Request focus to given FocusNode
  void requestFocus(FocusNode focus) => FocusScope.of(this).requestFocus(focus);

  /// Request focus to given FocusNode
  void unFocus(FocusNode focus) => focus.unfocus();

  /// Hide Keyboard
  void unFocusKeyboard() => FocusScope.of(this).unfocus();

  /// Hide soft keyboard
  void hideKeyboard() => FocusScope.of(this).requestFocus(FocusNode());

  /// Returns DefaultTextStyle.of(context)
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  /// Returns Form.of(context)
  FormState? get formState => Form.of(this);

  /// Returns Scaffold.of(context)
  ScaffoldState get scaffoldState => Scaffold.of(this);

  /// Returns Overlay.of(context)
  OverlayState? get overlayState => Overlay.of(this);

  /// returns brightness
  Brightness get platformBrightness => mediaQuery.platformBrightness;

  /// Return the height of status bar
  double get statusBarHeight => mediaQuery.padding.top;

  double get appBarHeight => mediaQuery.padding.top + kToolbarHeight;

  /// Return the height of navigation bar
  double get navigationBarHeight => MediaQuery.of(this).padding.bottom;

  /// Open Drawer
  void openDrawer() => Scaffold.of(this).openDrawer();

  /// Hide Drawer
  void openEndDrawer() => Scaffold.of(this).openEndDrawer();

  /// Returns true if keyboard is visible
  bool get isKeyboardShowing => viewInsets.bottom > 0;

  // Context Colors
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;
  Color get canvasColor => theme.canvasColor;
  Color get cardColor => theme.cardColor;
  Color get primaryColor => theme.primaryColor;
  Color get primaryColorDark => theme.disabledColor;
  Color get dividerColor => theme.dividerColor;
  Color get disabledColor => theme.primaryColorDark;
  Color get hoverColor => theme.hoverColor;

  // Material 3 Colors
  Color get secondary => theme.colorScheme.secondary;
  Color get onSecondary => theme.colorScheme.onSecondary;
  Color get surface => theme.colorScheme.surface;
  Color get onSurface => theme.colorScheme.onSurface;
  Color get primary => theme.colorScheme.primary;
  Color get onPrimary => theme.colorScheme.onPrimary;
  Color get errorColor => theme.colorScheme.error;

  Color get fillColor => theme.inputDecorationTheme.fillColor!;
  Color get iconColor => theme.iconTheme.color!;
  Color get textColor => theme.textTheme.titleLarge!.color!;
  Color get progressIndicatorColor => theme.progressIndicatorTheme.color!;

  InputDecorationTheme get inputDecorationTheme => theme.inputDecorationTheme;

  InputBorder get enabledBorder => inputDecorationTheme.enabledBorder!;
  InputBorder get focusedBorder => inputDecorationTheme.focusedBorder!;
  InputBorder get errorBorder => inputDecorationTheme.errorBorder!;
  InputBorder get focusedErrorBorder =>
      inputDecorationTheme.focusedErrorBorder!;
  InputBorder get disableBorder => inputDecorationTheme.disabledBorder!;

  // Context Text Styles
  TextStyle get displayLarge => theme.textTheme.displayLarge!;
  TextStyle get displayMedium => theme.textTheme.displayMedium!;
  TextStyle get displaySmall => theme.textTheme.displaySmall!;

  TextStyle get headlineLarge => theme.textTheme.headlineLarge!;
  TextStyle get headlineMedium => theme.textTheme.headlineMedium!;
  TextStyle get headlineSmall => theme.textTheme.headlineSmall!;

  TextStyle get titleLarge => theme.textTheme.titleLarge!;
  TextStyle get titleMedium => theme.textTheme.titleMedium!;
  TextStyle get titleSmall => theme.textTheme.titleSmall!;

  TextStyle get labelLarge => theme.textTheme.labelLarge!;
  TextStyle get labelMedium => theme.textTheme.labelMedium!;
  TextStyle get labelSmall => theme.textTheme.labelSmall!;

  TextStyle get bodyLarge => theme.textTheme.bodyLarge!;
  TextStyle get bodyMedium => theme.textTheme.bodyMedium!;
  TextStyle get bodySmall => theme.textTheme.bodySmall!;
}


// import 'package:flutter/material.dart';

// extension BuildContextX on BuildContext {
//   /// get theme
//   ThemeData get theme => Theme.of(this);

//   /// get colorScheme
//   ColorScheme get colorScheme => Theme.of(this).colorScheme;

//   /// check isDarkTheme enabled
//   bool get isDarkTheme =>
//       theme.brightness == Brightness.dark ||
//       colorScheme.brightness == Brightness.dark;

//   /// get brightness
//   Brightness get brightness => theme.brightness;

//   /// get textTheme
//   TextTheme get textTheme => Theme.of(this).textTheme;

//   /// display large style
//   TextStyle? get displayLarge => textTheme.displayLarge;

//   /// display medium style
//   TextStyle? get displayMedium => textTheme.displayMedium;

//   /// display small style
//   TextStyle? get displaySmall => textTheme.displaySmall;

//   /// headline large style
//   TextStyle? get headlineLarge => textTheme.headlineLarge;

//   /// headline medium style
//   TextStyle? get headlineMedium => textTheme.headlineMedium;

//   /// headline small style
//   TextStyle? get headlineSmall => textTheme.headlineSmall;

//   /// title large style
//   TextStyle? get titleLarge => textTheme.titleLarge;

//   /// title medium style
//   TextStyle? get titleMedium => textTheme.titleMedium;

//   /// title small style
//   TextStyle? get titleSmall => textTheme.titleSmall;

//   /// label large style
//   TextStyle? get labelLarge => textTheme.labelLarge;

//   /// label medium style
//   TextStyle? get labelMedium => textTheme.labelMedium;

//   /// label small style
//   TextStyle? get labelSmall => textTheme.labelSmall;

//   /// body large style
//   TextStyle? get bodyLarge => textTheme.bodyLarge;

//   /// body medium style
//   TextStyle? get bodyMedium => textTheme.bodyMedium;

//   /// body small style
//   TextStyle? get bodySmall => textTheme.bodySmall;

//   /// colorscheme colors
//   /// primary colors
//   Color get primaryColor => colorScheme.primary;
//   Color get onPrimaryColor => colorScheme.onPrimary;
//   Color get primaryContainerColor => colorScheme.primaryContainer;
//   Color get onPrimaryContainerColor => colorScheme.onPrimaryContainer;

//   /// secondary colors
//   Color get secondaryColor => colorScheme.secondary;
//   Color get onSecondaryColor => colorScheme.onSecondary;
//   Color get secondaryContainerColor => colorScheme.secondaryContainer;
//   Color get onSecondaryContainerColor => colorScheme.onSecondaryContainer;

//   /// tertiary color
//   Color get tertiaryColor => colorScheme.tertiary;
//   Color get onTertiaryColor => colorScheme.onTertiary;
//   Color get tertiaryContainerColor => colorScheme.tertiaryContainer;
//   Color get onTertiaryContainerColor => colorScheme.onTertiaryContainer;

//   /// surface color
//   Color get surfaceColor => colorScheme.surface;
//   Color get onSurfaceColor => colorScheme.onSurface;

//   /// surface variant color
//   Color get surfaceVariantColor => colorScheme.surfaceContainerHighest;
//   Color get onSurfaceVariantColor => colorScheme.onSurfaceVariant;

//   /// inverse colors
//   Color get inverseSurfaceColor => colorScheme.inverseSurface;
//   Color get onInverseSurfaceColor => colorScheme.onInverseSurface;

//   /// background color
//   Color get backgroundColor => colorScheme.surface;
//   Color get onBackgroundContainerColor => colorScheme.onSurface;

//   /// outline color
//   Color get outlineColor => colorScheme.outline;
//   Color get outlineVariantColor => colorScheme.outlineVariant;

//   /// error colors
//   Color get errorColor => colorScheme.error;
//   Color get onErrorColor => colorScheme.onError;
//   Color get errorContainerColor => colorScheme.errorContainer;
//   Color get onErrorContainerColor => colorScheme.onErrorContainer;

//   /// get size
//   Size get size => MediaQuery.sizeOf(this);

//   /// media query
//   MediaQueryData get mq => MediaQuery.of(this);

//   /// screen width
//   double get width => size.width;

//   /// screen height
//   double get height => size.height;

//   /// window padding
//   /// The parts of the display that are partially obscured by system UI,
//   /// typically by the hardware display "notches" or the system status bar.
//   EdgeInsets get padding => MediaQuery.paddingOf(this);

//   /// Returns viewInsets for the nearest MediaQuery ancestor or
//   /// throws an exception, if no such ancestor exists.
//   ///
//   /// Use of this method will cause the given [BuildContext] to rebuild any time that
//   /// the [MediaQueryData.viewInsets] property of the ancestor [MediaQuery] changes.
//   EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

//   /// viewPadding
//   EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

//   /// safeAreaBottomPadding
//   double get bottomBarHeight => padding.bottom;

//   /// safeAreaTopPadding
//   double get statusBarHeight => padding.top;

//   /// software keyboard height
//   double get keyboardHeight => viewInsets.bottom;

//   /// get platform brightness
//   ///
//   /// this will return platform brightness from nearest MediaQuery widget if not available then it will return Brightness.light
//   Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

//   ///percent with
//   double pw(double percent) {
//     return width * (percent / 100);
//   }

//   ///percent height
//   double ph(double percent) {
//     return height * (percent / 100);
//   }

//   /// remove keyboard focus
//   void removeFocus() {
//     if (hasFocus) {
//       FocusManager.instance.primaryFocus?.unfocus();
//     }
//   }

//   /// check whether keyboard has focus or not
//   bool get hasFocus =>
//       FocusScope.of(this).hasFocus || FocusScope.of(this).hasPrimaryFocus;

//   /// extension to get value according to theme
//   T themedValue<T>(T light, [T? dark]) {
//     return isDarkTheme ? (dark ?? light) : light;
//   }
// }