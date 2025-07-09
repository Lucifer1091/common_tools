// import 'package:url_launcher/url_launcher.dart';

// class UrlLauncher {
//   UrlLauncher._();

//   static Future<void> makePhoneCall({String? phone}) async {
//     bool hasCallSupport = false;

//     await canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
//       hasCallSupport = result;
//     });

//     if (phone != null && hasCallSupport) {
//       final Uri launchUri = Uri(scheme: 'tel', path: phone);
//       await launchUrl(launchUri);
//     }
//   }

//   static String? _encodeQueryParameters(Map<String, String> params) {
//     return params.entries
//         .map(
//           (MapEntry<String, String> e) =>
//               '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
//         )
//         .join('&');
//   }

//   static Future<void> composeMail({String? email, String? subject}) async {
//     if (email != null) {
//       final Uri emailLaunchUri = Uri(
//         scheme: 'mailto',
//         path: email,
//         query: _encodeQueryParameters(<String, String>{
//           'subject': subject ?? 'Customer Support',
//         }),
//       );

//       await launchUrl(emailLaunchUri);
//     }
//   }

//   static Future<void> launch(String url, {bool isNewTab = true}) async {
//     if (!await launchUrl(
//       Uri.parse(url),
//       webOnlyWindowName: isNewTab ? '_blank' : '_self',
//     )) {
//       SnackBars.error(message: 'Failed to open the link.');
//     }
//   }
// }
