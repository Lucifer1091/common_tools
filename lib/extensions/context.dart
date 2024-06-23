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
