import 'package:flutter/foundation.dart';

import 'logger.dart';

/// A class to check all platforms supported by Flutter.
class MyPlatform {
  MyPlatform._();

  /// Returns `true` if the platform is Android.
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Returns `true` if the platform is iOS.
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Returns `true` if the platform is Web.
  static bool get isWeb => kIsWeb;

  /// Returns `true` if the platform is macOS.
  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// Returns `true` if the platform is Windows.
  static bool get isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  /// Returns `true` if the platform is Linux.
  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  /// Returns `true` if the platform is Fuchsia.
  static bool get isFuchsia =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.fuchsia;

  static bool get isApple => isIOS || isMacOS;
  static bool get isMobile => isIOS || isAndroid;
  static bool get isDesktop => isLinux || isMacOS || isWindows;
  static bool get isDesktopOrWeb => isDesktop || isWeb;

  /// Returns a string representing the current platform.
  static String get currentPlatform {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    if (isFuchsia) return 'Fuchsia';
    return 'Unknown';
  }

  static TargetPlatform get targetPlatform {
    if (isAndroid) return TargetPlatform.android;
    if (isIOS) return TargetPlatform.iOS;
    if (isMacOS) return TargetPlatform.macOS;
    if (isWindows) return TargetPlatform.windows;
    if (isLinux) return TargetPlatform.linux;
    if (isFuchsia) return TargetPlatform.fuchsia;
    return TargetPlatform.android;
  }

  /// Prints the current platform.
  static void printCurrentPlatform() {
    logger.info('Current platform: $currentPlatform');
  }
}
