// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../extensions/string/converters.dart';
import '../../extensions/string/validators.dart';
import '../../localization/my_translations.dart';
import '../my_platform.dart';
import '_url_launcher_file_stub.dart'
    if (dart.library.io) '_url_launcher_file_io.dart'
    as file_system;

/// Package-owned URL launch mode.
///
/// This keeps `url_launcher` implementation types out of the public API.
enum MyLaunchMode {
  platformDefault,
  inAppWebView,
  inAppBrowserView,
  externalApplication,
  externalNonBrowserApplication,
}

/// Configuration used when [MyLaunchMode.inAppWebView] is selected.
@immutable
class MyWebViewConfiguration {
  const MyWebViewConfiguration({
    this.enableJavaScript = true,
    this.enableDomStorage = true,
    this.headers = const <String, String>{},
  });

  final bool enableJavaScript;
  final bool enableDomStorage;
  final Map<String, String> headers;
}

/// Configuration used when [MyLaunchMode.inAppBrowserView] is selected.
@immutable
class MyBrowserConfiguration {
  const MyBrowserConfiguration({this.showTitle = false});

  final bool showTitle;
}

/// Safe helpers for launching URLs, email, phone, SMS, and desktop files.
abstract final class UrlLauncher {
  /// Safely launches [url].
  ///
  /// By default this calls `launchUrl` directly and returns `false` on failure.
  /// Set [checkCanLaunch] only when the caller specifically needs a preflight
  /// availability check.
  static Future<bool> launch(
    String? url, {
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    MyWebViewConfiguration webViewConfiguration =
        const MyWebViewConfiguration(),
    MyBrowserConfiguration browserConfiguration =
        const MyBrowserConfiguration(),
    String? webOnlyWindowName,
    bool checkCanLaunch = false,
    bool? isNewTab,
  }) async {
    final Uri? uri = _parseUri(url);
    if (uri == null) {
      _debugLog('Invalid URL provided: $url');
      return false;
    }

    return launchUri(
      uri,
      mode: mode,
      fallbackMode: fallbackMode,
      webViewConfiguration: webViewConfiguration,
      browserConfiguration: browserConfiguration,
      webOnlyWindowName:
          webOnlyWindowName ?? _webWindowNameFromNewTab(isNewTab),
      checkCanLaunch: checkCanLaunch,
    );
  }

  /// Safely launches [uri].
  ///
  /// [fallbackMode] is attempted only when [mode] fails or throws.
  static Future<bool> launchUri(
    Uri? uri, {
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    MyWebViewConfiguration webViewConfiguration =
        const MyWebViewConfiguration(),
    MyBrowserConfiguration browserConfiguration =
        const MyBrowserConfiguration(),
    String? webOnlyWindowName,
    bool checkCanLaunch = false,
  }) async {
    if (!_isValidUri(uri)) {
      _debugLog('Invalid URI provided: $uri');
      return false;
    }

    final Uri launchUri = uri!;
    if (checkCanLaunch && !await canLaunchUri(launchUri)) {
      _debugLog('No handler reported for URI: $launchUri');
      return false;
    }

    final bool launched = await _tryLaunch(
      launchUri,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      browserConfiguration: browserConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );

    if (launched) return true;

    if (fallbackMode == null || fallbackMode == mode) return false;

    return _tryLaunch(
      launchUri,
      mode: fallbackMode,
      webViewConfiguration: webViewConfiguration,
      browserConfiguration: browserConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
  }

  /// Launches a web URL, optionally adding an `https://` scheme.
  static Future<bool> launchWebUrl(
    String? url, {
    bool addHttpsScheme = true,
    bool newTab = true,
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    MyWebViewConfiguration webViewConfiguration =
        const MyWebViewConfiguration(),
    MyBrowserConfiguration browserConfiguration =
        const MyBrowserConfiguration(),
    String? webOnlyWindowName,
    bool checkCanLaunch = false,
  }) {
    final Uri? uri = _parseWebUri(url, addHttpsScheme: addHttpsScheme);
    if (uri == null) {
      _debugLog('Invalid web URL provided: $url');
      return Future<bool>.value(false);
    }

    return launchUri(
      uri,
      mode: mode,
      fallbackMode: fallbackMode,
      webViewConfiguration: webViewConfiguration,
      browserConfiguration: browserConfiguration,
      webOnlyWindowName: webOnlyWindowName ?? (newTab ? '_blank' : '_self'),
      checkCanLaunch: checkCanLaunch,
    );
  }

  /// Launches the default mail app with a composed email.
  static Future<bool> launchEmail(
    String? email, {
    String? subject,
    String? body,
    List<String> cc = const <String>[],
    List<String> bcc = const <String>[],
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    bool checkCanLaunch = false,
  }) {
    final String? normalizedEmail = _normalizeEmail(email);
    final List<String>? normalizedCc = _normalizeEmails(cc);
    final List<String>? normalizedBcc = _normalizeEmails(bcc);
    if (normalizedEmail == null ||
        normalizedCc == null ||
        normalizedBcc == null) {
      _debugLog('Invalid email launch target provided: $email');
      return Future<bool>.value(false);
    }

    final Map<String, String> queryParameters = <String, String>{
      if (subject.isNotBlank) 'subject': subject!.trim(),
      if (body.isNotBlank) 'body': body!.trim(),
      if (normalizedCc.isNotEmpty) 'cc': normalizedCc.join(','),
      if (normalizedBcc.isNotEmpty) 'bcc': normalizedBcc.join(','),
    };
    final Uri uri = Uri(
      scheme: 'mailto',
      path: normalizedEmail,
      query: _encodeQueryParameters(queryParameters),
    );

    return launchUri(
      uri,
      mode: mode,
      fallbackMode: fallbackMode,
      checkCanLaunch: checkCanLaunch,
    );
  }

  /// Launches the default phone dialer with [phoneNumber].
  static Future<bool> launchPhone(
    String? phoneNumber, {
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    bool checkCanLaunch = false,
  }) {
    final String? cleanedNumber = _normalizePhoneNumber(phoneNumber);
    if (cleanedNumber == null) {
      _debugLog('Invalid phone number provided: $phoneNumber');
      return Future<bool>.value(false);
    }

    return launchUri(
      Uri(scheme: 'tel', path: cleanedNumber),
      mode: mode,
      fallbackMode: fallbackMode,
      checkCanLaunch: checkCanLaunch,
    );
  }

  /// Launches the default SMS app with [phoneNumber] and optional [message].
  static Future<bool> launchSms(
    String? phoneNumber, {
    String? message,
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    bool checkCanLaunch = false,
  }) {
    final String? cleanedNumber = _normalizePhoneNumber(phoneNumber);
    if (cleanedNumber == null) {
      _debugLog('Invalid phone number provided for SMS: $phoneNumber');
      return Future<bool>.value(false);
    }

    final Uri uri = Uri(
      scheme: 'sms',
      path: cleanedNumber,
      query: _encodeQueryParameters(<String, String>{
        if (message.isNotBlank) 'body': message!.trim(),
      }),
    );

    return launchUri(
      uri,
      mode: mode,
      fallbackMode: fallbackMode,
      checkCanLaunch: checkCanLaunch,
    );
  }

  /// Launches a desktop file or folder using the platform default app.
  static Future<bool> launchFilePath(
    String? path, {
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    bool checkCanLaunch = false,
  }) {
    final String? trimmedPath = path.getOrNull();
    if (trimmedPath == null || !MyPlatform.isDesktop) {
      _debugLog('Invalid or unsupported file launch path: $path');
      return Future<bool>.value(false);
    }

    if (!file_system.filePathExists(trimmedPath)) {
      _debugLog('File launch path does not exist: $trimmedPath');
      return Future<bool>.value(false);
    }

    return launchUri(
      file_system.fileUri(trimmedPath),
      mode: mode,
      fallbackMode: fallbackMode,
      checkCanLaunch: checkCanLaunch,
    );
  }

  /// Launches [url] and shows a SnackBar only when launch fails.
  static Future<bool> launchWithFeedback(
    BuildContext? context,
    String? url, {
    String? errorMessage,
    MyLaunchMode mode = MyLaunchMode.platformDefault,
    MyLaunchMode? fallbackMode,
    MyWebViewConfiguration webViewConfiguration =
        const MyWebViewConfiguration(),
    MyBrowserConfiguration browserConfiguration =
        const MyBrowserConfiguration(),
    String? webOnlyWindowName,
    bool checkCanLaunch = false,
  }) async {
    final bool success = await launch(
      url,
      mode: mode,
      fallbackMode: fallbackMode,
      webViewConfiguration: webViewConfiguration,
      browserConfiguration: browserConfiguration,
      webOnlyWindowName: webOnlyWindowName,
      checkCanLaunch: checkCanLaunch,
    );

    if (!success && context != null && context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            errorMessage ?? MyTranslations.of(context).linkLaunchFailed,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return success;
  }

  /// Checks whether [url] can be handled by the platform.
  static Future<bool> canLaunch(String? url) async {
    final Uri? uri = _parseUri(url);
    if (uri == null) {
      return false;
    }

    return canLaunchUri(uri);
  }

  /// Checks whether [uri] can be handled by the platform.
  static Future<bool> canLaunchUri(Uri? uri) async {
    if (!_isValidUri(uri)) {
      return false;
    }

    try {
      return await launcher.canLaunchUrl(uri!);
    } catch (error, stackTrace) {
      _debugLog(
        'Exception occurred while checking URI support: $uri - $error',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Checks whether the current platform supports [mode].
  static Future<bool> supportsMode(MyLaunchMode mode) async {
    try {
      return await launcher.supportsLaunchMode(_toLauncherMode(mode));
    } catch (error, stackTrace) {
      _debugLog(
        'Exception occurred while checking launch mode support: $mode - $error',
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}

Future<bool> _tryLaunch(
  Uri uri, {
  required MyLaunchMode mode,
  required MyWebViewConfiguration webViewConfiguration,
  required MyBrowserConfiguration browserConfiguration,
  String? webOnlyWindowName,
}) async {
  try {
    final bool launched = await launcher.launchUrl(
      uri,
      mode: _toLauncherMode(mode),
      webViewConfiguration: launcher.WebViewConfiguration(
        enableJavaScript: webViewConfiguration.enableJavaScript,
        enableDomStorage: webViewConfiguration.enableDomStorage,
        headers: webViewConfiguration.headers,
      ),
      browserConfiguration: launcher.BrowserConfiguration(
        showTitle: browserConfiguration.showTitle,
      ),
      webOnlyWindowName: webOnlyWindowName,
    );
    if (!launched) {
      _debugLog('Failed to launch URI: $uri');
    }
    return launched;
  } catch (error, stackTrace) {
    _debugLog(
      'Exception occurred while launching URI: $uri - $error',
      stackTrace: stackTrace,
    );
    return false;
  }
}

Uri? _parseUri(String? url) {
  final String? trimmedUrl = url.getOrNull();
  if (trimmedUrl == null) return null;

  final Uri? uri = Uri.tryParse(trimmedUrl);
  if (!_isValidUri(uri)) return null;

  return uri;
}

Uri? _parseWebUri(String? url, {required bool addHttpsScheme}) {
  final String? trimmedUrl = url.getOrNull();
  if (trimmedUrl == null) return null;

  final Uri? firstPass = Uri.tryParse(trimmedUrl);
  final bool hasScheme = firstPass?.hasScheme ?? false;
  final String normalizedUrl = hasScheme || !addHttpsScheme
      ? trimmedUrl
      : 'https://$trimmedUrl';
  final Uri? uri = Uri.tryParse(normalizedUrl);

  if (!_isValidWebUri(uri)) return null;

  return uri;
}

bool _isValidUri(Uri? uri) {
  if (uri == null || !uri.hasScheme) return false;

  final String scheme = uri.scheme.toLowerCase();
  if (scheme == 'http' || scheme == 'https') {
    return _isValidWebUri(uri);
  }

  if (scheme == 'mailto' || scheme == 'tel' || scheme == 'sms') {
    return uri.path.trim().isNotEmpty;
  }

  if (scheme == 'file') {
    return uri.path.trim().isNotEmpty;
  }

  return uri.hasAuthority || uri.path.trim().isNotEmpty;
}

bool _isValidWebUri(Uri? uri) {
  if (uri == null) return false;

  final String scheme = uri.scheme.toLowerCase();
  return (scheme == 'http' || scheme == 'https') &&
      uri.hasAuthority &&
      uri.host.trim().isNotEmpty;
}

String? _normalizeEmail(String? email) {
  final String? trimmedEmail = email.getOrNull();
  if (trimmedEmail == null) return null;

  return trimmedEmail.isEmail ? trimmedEmail : null;
}

List<String>? _normalizeEmails(List<String> emails) {
  final List<String> normalizedEmails = <String>[];
  for (final String email in emails) {
    final String? normalizedEmail = _normalizeEmail(email);
    if (normalizedEmail == null) return null;

    normalizedEmails.add(normalizedEmail);
  }
  return normalizedEmails;
}

String? _normalizePhoneNumber(String? phoneNumber) {
  final String? phone = phoneNumber.getOrNull();
  if (phone == null) return null;

  final bool hasLeadingPlus = phone.startsWith('+');
  final String digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 9 || digits.length > 15) return null;

  return '${hasLeadingPlus ? '+' : ''}$digits';
}

launcher.LaunchMode _toLauncherMode(MyLaunchMode mode) {
  return switch (mode) {
    MyLaunchMode.platformDefault => launcher.LaunchMode.platformDefault,
    MyLaunchMode.inAppWebView => launcher.LaunchMode.inAppWebView,
    MyLaunchMode.inAppBrowserView => launcher.LaunchMode.inAppBrowserView,
    MyLaunchMode.externalApplication => launcher.LaunchMode.externalApplication,
    MyLaunchMode.externalNonBrowserApplication =>
      launcher.LaunchMode.externalNonBrowserApplication,
  };
}

String? _encodeQueryParameters(Map<String, String> params) {
  if (params.isEmpty) return null;

  return params.entries
      .map(
        (MapEntry<String, String> entry) =>
            '${Uri.encodeComponent(entry.key)}='
            '${Uri.encodeComponent(entry.value)}',
      )
      .join('&');
}

String? _webWindowNameFromNewTab(bool? isNewTab) {
  if (isNewTab == null) return null;

  return isNewTab ? '_blank' : '_self';
}

void _debugLog(String message, {StackTrace? stackTrace}) {
  assert(() {
    debugPrint(message);
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
    return true;
  }(), 'Debug logging closure should always return true.');
}
