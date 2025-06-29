// // ignore_for_file: use_compare_without_case
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../extensions/string/string_util_extensions.dart';
// import 'safe_debug_print.dart';

// /// A utility class for safely launching URLs with comprehensive error handling
// /// and validation.
// ///
// /// This class provides methods to safely launch different types of URLs
// /// including web URLs, email addresses, phone numbers, and SMS.
// abstract final class SafeUrlLauncher {
//   /// Safely launches a URL with fallback support and proper validation.
//   ///
//   /// [url] The URL string to launch
//   /// [preferredMode] The preferred launch mode
//   /// (defaults to externalApplication)
//   /// [fallbackMode] The fallback launch mode if preferred fails
//   /// (defaults to inAppWebView)
//   /// [webOnlyWindowName] Window name for web-only launches
//   ///
//   /// Returns true if the URL was successfully launched, false otherwise.
//   static Future<bool> launch(
//     String? url, {
//     LaunchMode preferredMode = LaunchMode.externalApplication,
//     LaunchMode? fallbackMode = LaunchMode.inAppWebView,
//     String? webOnlyWindowName,
//   }) async {
//     if (!isValidUrl(url)) {
//       safeDebugLog('Invalid URL provided: $url');
//       return false;
//     }

//     try {
//       final Uri? uri = Uri.tryParse(url ?? '');
//       if (uri == null) {
//         safeDebugLog('Failed to parse URL: $url');
//         return false;
//       }

//       final bool canLaunch = await canLaunchUrl(uri);
//       if (!canLaunch) {
//         safeDebugLog('Cannot launch URL: $url');
//         return false;
//       }

//       // Try preferred mode first
//       try {
//         final bool launched = await launchUrl(
//           uri,
//           mode: preferredMode,
//           webOnlyWindowName: webOnlyWindowName,
//         );

//         if (launched) {
//           safeDebugLog('Successfully launched URL with preferred mode: $url');
//           return true;
//         }
//       } catch (e) {
//         safeDebugLog('Preferred launch mode failed for URL: $url - $e');
//       }

//       // Try fallback mode if preferred failed and fallback is provided
//       if (fallbackMode != null && fallbackMode != preferredMode) {
//         try {
//           final bool launched = await launchUrl(
//             uri,
//             mode: fallbackMode,
//             webOnlyWindowName: webOnlyWindowName,
//           );

//           if (launched) {
//             safeDebugLog('Successfully launched URL with fallback mode: $url');
//             return true;
//           }
//         } catch (e) {
//           safeDebugLog('Fallback launch mode also failed for URL: $url - $e');
//         }
//       }

//       safeDebugLog('All launch attempts failed for URL: $url');
//       return false;
//     } catch (e, stackTrace) {
//       safeDebugLog(
//         'Exception occurred while launching URL: $url - $e',
//         stackTrace: stackTrace,
//       );
//       return false;
//     }
//   }

//   /// Launches a URL with user feedback via SnackBar.
//   ///
//   /// [context] The BuildContext for showing feedback
//   /// [url] The URL string to launch
//   /// [errorMessage] Custom error message to show on failure
//   /// [preferredMode] The preferred launch mode
//   /// [fallbackMode] The fallback launch mode
//   ///
//   /// Shows a SnackBar with error message if launch fails.
//   static Future<void> launchWithFeedback(
//     BuildContext? context,
//     String? url, {
//     String? errorMessage,
//     LaunchMode preferredMode = LaunchMode.externalApplication,
//     LaunchMode? fallbackMode = LaunchMode.inAppWebView,
//   }) async {
//     if (context == null || !context.mounted) {
//       // Still attempt to launch even without context
//       await launch(
//         url,
//         preferredMode: preferredMode,
//         fallbackMode: fallbackMode,
//       );
//       return;
//     }

//     final bool success = await launch(
//       url,
//       preferredMode: preferredMode,
//       fallbackMode: fallbackMode,
//     );

//     if (!success && context.mounted) {
//       final String message =
//           errorMessage ?? 'Could not open link. Please try again later.';

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Theme.of(context).colorScheme.error,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   /// Safely launches a web URL in the browser.
//   ///
//   /// [url] The web URL to launch
//   /// [webOnlyWindowName] Optional window name for web platforms
//   ///
//   /// Returns true if successfully launched, false otherwise.
//   static Future<bool> launchWebUrl(
//     String? url, {
//     String? webOnlyWindowName,
//   }) async {
//     if (!_isValidWebUrl(url)) {
//       safeDebugLog('Invalid web URL provided: $url');
//       return false;
//     }

//     return launch(url, webOnlyWindowName: webOnlyWindowName);
//   }

//   /// Safely launches an email client with pre-filled email address.
//   ///
//   /// [email] The email address
//   /// [subject] Optional email subject
//   /// [body] Optional email body
//   ///
//   /// Returns true if successfully launched, false otherwise.
//   static Future<bool> launchEmail(
//     String? email, {
//     String? subject,
//     String? body,
//   }) async {
//     if (!_isValidEmail(email)) {
//       safeDebugLog('Invalid email address provided: $email');
//       return false;
//     }

//     final StringBuffer mailtoBuffer = StringBuffer('mailto:$email');
//     final List<String> queryParams = <String>[];

//     if (!subject.isNullEmpty) {
//       final String safeSubject = subject ?? '';
//       queryParams.add('subject=${Uri.encodeComponent(safeSubject)}');
//     }

//     if (!body.isNullEmpty) {
//       final String safeBody = body ?? '';
//       queryParams.add('body=${Uri.encodeComponent(safeBody)}');
//     }

//     if (queryParams.isNotEmpty) {
//       mailtoBuffer.write('?${queryParams.join('&')}');
//     }

//     return _launchUri(mailtoBuffer.toString());
//   }

//   /// Safely launches the phone dialer with a phone number.
//   ///
//   /// [phoneNumber] The phone number to dial
//   ///
//   /// Returns true if successfully launched, false otherwise.
//   static Future<bool> launchPhone(String? phoneNumber) async {
//     if (!_isValidPhoneNumber(phoneNumber)) {
//       safeDebugLog('Invalid phone number provided: $phoneNumber');
//       return false;
//     }

//     final String cleanedNumber = _cleanPhoneNumber(phoneNumber ?? '');
//     final String telUrl = 'tel:$cleanedNumber';
//     return _launchUri(telUrl);
//   }

//   /// Safely launches SMS with a phone number and optional message.
//   ///
//   /// [phoneNumber] The phone number to send SMS to
//   /// [message] Optional SMS message content
//   ///
//   /// Returns true if successfully launched, false otherwise.
//   static Future<bool> launchSms(String? phoneNumber, {String? message}) async {
//     if (!_isValidPhoneNumber(phoneNumber)) {
//       safeDebugLog('Invalid phone number provided for SMS: $phoneNumber');
//       return false;
//     }

//     final String cleanedNumber = _cleanPhoneNumber(phoneNumber ?? '');
//     String smsUrl = 'sms:$cleanedNumber';

//     if (!message.isNullEmpty) {
//       final String safeMessage = message ?? '';
//       smsUrl += '?body=${Uri.encodeComponent(safeMessage)}';
//     }

//     return _launchUri(smsUrl);
//   }

//   /// Checks if a URL can be launched without actually launching it.
//   ///
//   /// [url] The URL to check
//   ///
//   /// Returns true if the URL can be launched, false otherwise.
//   static Future<bool> canLaunch(String? url) async {
//     if (!isValidUrl(url)) {
//       return false;
//     }

//     try {
//       final Uri? uri = Uri.tryParse(url ?? '');
//       if (uri == null) return false;

//       return await canLaunchUrl(uri);
//     } catch (e, stackTrace) {
//       safeDebugLog(
//         'Exception occurred while checking if URL can be launched: $url - $e',
//         stackTrace: stackTrace,
//       );
//       return false;
//     }
//   }

//   /// Internal method to launch URI safely.
//   static Future<bool> _launchUri(String urlString) async {
//     try {
//       final Uri? uri = Uri.tryParse(urlString);
//       if (uri == null) {
//         safeDebugLog('Failed to parse URI: $urlString');
//         return false;
//       }

//       final bool canLaunch = await canLaunchUrl(uri);
//       if (!canLaunch) {
//         safeDebugLog('Cannot launch URI: $urlString');
//         return false;
//       }

//       final bool launched = await launchUrl(uri);
//       if (launched) {
//         safeDebugLog('Successfully launched URI: $urlString');
//       } else {
//         safeDebugLog('Failed to launch URI: $urlString');
//       }

//       return launched;
//     } catch (e, stackTrace) {
//       safeDebugLog(
//         'Exception occurred while launching URI: $urlString - $e',
//         stackTrace: stackTrace,
//       );
//       return false;
//     }
//   }

//   /// Validates if a string is a valid URL.
//   ///
//   /// Checks for proper URL format with scheme and authority (for web URLs)
//   /// or validates special schemes like mailto, tel, sms.
//   static bool isValidUrl(String? url) {
//     if (url.isNullEmpty) return false;

//     try {
//       final Uri? uri = Uri.tryParse(url ?? '');
//       if (uri == null || !uri.hasScheme) return false;

//       final String scheme = uri.scheme.toLowerCase();

//       // For special schemes, just check if they have scheme
//       if (scheme == 'mailto' || scheme == 'tel' || scheme == 'sms') {
//         return true;
//       }

//       // For web URLs, require authority (domain)
//       if (scheme == 'http' || scheme == 'https') {
//         return uri.hasAuthority && uri.host.isNotEmpty;
//       }

//       // For other schemes, require either authority or path
//       return uri.hasAuthority || uri.path.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Validates if a string is a valid web URL (http/https).
//   static bool _isValidWebUrl(String? url) {
//     if (!isValidUrl(url)) return false;

//     try {
//       final Uri? uri = Uri.tryParse(url ?? '');
//       if (uri == null) return false;

//       final String scheme = uri.scheme.toLowerCase();
//       return scheme == 'http' || scheme == 'https';
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Validates if a string is a valid email address.
//   static bool _isValidEmail(String? email) {
//     if (email.isNullEmpty) return false;

//     final RegExp emailRegex = RegExp(
//       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//     );

//     final String safeEmail = email ?? '';
//     return emailRegex.hasMatch(safeEmail.trim());
//   }

//   /// Validates if a string is a valid phone number.
//   static bool _isValidPhoneNumber(String? phoneNumber) {
//     if (phoneNumber.isNullEmpty) return false;

//     final String cleaned = _cleanPhoneNumber(phoneNumber ?? '');
//     if (cleaned.isEmpty) return false;

//     // Check if the cleaned number contains only digits and
//     // has reasonable length
//     final RegExp phoneRegex = RegExp(r'^\+?\d{7,15}$');
//     return phoneRegex.hasMatch(cleaned);
//   }

//   /// Cleans a phone number by removing all non-digit characters except +.
//   static String _cleanPhoneNumber(String phoneNumber) {
//     return phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
//   }
// }
