part of 'utilities.dart';

/// Utility class for system-level operations in a Flutter application.
///
/// Provides methods to manipulate system UI elements such as status bar, navigation bar,
/// screen orientation, and invoking native methods.
class SystemUtils {
  SystemUtils._();

  /// Change status bar Color and Brightness.
  ///
  /// This method sets the status bar color, system navigation bar color, status bar brightness,
  /// and status bar icon brightness after a specified delay.
  ///
  /// Example:
  /// ```dart
  /// // Set status bar to blue with light icons
  /// await SystemUtils.setStatusBarColor(
  ///   Colors.blue,
  ///   statusBarIconBrightness: Brightness.light,
  /// );
  /// ```
  static Future<void> setStatusBarColor(
    Color statusBarColor, {
    Color? systemNavigationBarColor,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
    int delayInMilliSeconds = 200,
  }) async {
    await Future.delayed(Duration(milliseconds: delayInMilliSeconds));

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        systemNavigationBarColor: systemNavigationBarColor,
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness ??
            (statusBarColor.isDark ? Brightness.light : Brightness.dark),
      ),
    );
  }

  /// Set the status bar to a dark theme.
  ///
  /// This method sets the status bar to a dark theme with dark icons.
  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  /// Set the status bar to a light theme.
  ///
  /// This method sets the status bar to a light theme with light icons.
  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  /// Show the status bar.
  ///
  /// This method manually enables the status bar.
  static Future<void> showStatusBar() async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Enter fullscreen mode (hides status bar and navigation bar).
  ///
  /// This method hides both the status bar and navigation bar to make the application fullscreen.
  static void enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  /// Exit fullscreen mode (makes status bar and navigation bar visible).
  ///
  /// This method makes both the status bar and navigation bar visible again after fullscreen mode.
  static void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Hide the status bar.
  ///
  /// This method manually hides the status bar.
  static Future<void> hideStatusBar() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  /// Set orientation to portrait mode.
  ///
  /// This method restricts screen orientation to portrait mode only.
  static void setOrientationPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  /// Set orientation to landscape mode.
  ///
  /// This method restricts screen orientation to landscape mode only.
  static void setOrientationLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /// Enable rotation to any orientation.
  ///
  /// This method allows the screen orientation to freely rotate between portrait and landscape modes.
  static void enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Invoke a native method and get the result asynchronously.
  ///
  /// This method invokes a platform-specific native method using method channels.
  /// Returns the result of type `T` returned by the native method.
  ///
  /// Example:
  /// ```dart
  /// // Invoke a native method named 'getDeviceInfo' with no arguments
  /// final deviceInfo = await SystemUtils.invokeNativeMethod<Map<String, dynamic>>(
  ///   'device_info',
  ///   'getDeviceInfo',
  /// );
  /// ```
  static Future<T?> invokeNativeMethod<T>(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    var platform = MethodChannel(channel);
    return await platform.invokeMethod<T>(method, arguments);
  }
}
