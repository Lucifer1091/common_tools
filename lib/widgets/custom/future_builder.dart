// import 'package:flutter/material.dart';
//
// class CustomFutureBuilder<T> extends StatelessWidget {
//   final Future<T> future;
//   final AsyncWidgetBuilder<T> hasDataBuilder;
//   final double loaderSize;
//   final Widget? customLoader;
//   final String? errorTitle;
//   final String? errorSubtitle;
//   final double? noContentPadding;
//   final Widget? reloadWidget;
//   final bool showNoContentBackground;
//
//   const CustomFutureBuilder({
//     super.key,
//     required this.future,
//     required this.hasDataBuilder,
//     this.loaderSize = 30,
//     this.customLoader,
//     this.errorTitle,
//     this.errorSubtitle = 'Failed to Retrieve your data.',
//     this.noContentPadding,
//     this.reloadWidget,
//     this.showNoContentBackground = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<T>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return customLoader ??
//               Center(
//                 child: CircularProgressIndicator(
//                   color: context.primaryColor,
//                 ),
//               );
//         } else if (snapshot.connectionState == ConnectionState.active ||
//             snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError || snapshot.data == null) {
//             log10.e(snapshot.error);
//             return reloadWidget ?? const GenericErrorIndicator();
//             // NoContent(
//             //   title: errorTitle ?? "Content Not Found !!",
//             //   subtitle: errorSubtitle!,
//             //   padding: noContentPadding ?? 32,
//             //   showBackground: showNoContentBackground,
//             // );
//           } else if (snapshot.hasData) {
//             if (snapshot.data == [] || GetUtils.isBlank(snapshot.data)!) {
//               return reloadWidget ?? const GenericErrorIndicator();
//               // NoContent(
//               //   title: errorTitle ?? "Content Not Found !!",
//               //   subtitle: errorSubtitle!,
//               //   padding: noContentPadding ?? 32,
//               //   showBackground: showNoContentBackground,
//               // );
//             } else {
//               return hasDataBuilder(context, snapshot);
//             }
//           } else {
//             return Center(
//               child: Text(
//                 errorSubtitle!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }
//         } else {
//           return Center(
//             child: Text(
//               'State: ${snapshot.connectionState}',
//               style: TextStyle(color: context.primaryColor),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A wrapper around [FutureBuilder] which makes it easy to display
/// the various states of fetching data asynchronous.
///
/// There are 4 possible states:
/// 1. The snapshot is loading:
/// --> shows the [loadingIndicator].
///
/// 2. The snapshot is loaded:
/// --> shows the widget returned by the [dataBuilder].
///
/// 3. The snapshots data is loaded but empty (only works on Iterable/Map):
/// --> shows [SnapshotStateInfo] with the [isEmptyText] and [isEmptyIcon].
///
/// 4. The snapshot has an error:
/// --> shows [SnapshotStateInfo] with the [errorText], [errorIcon] and the error message.
/// NOTE: For safety reasons the snapshots error message is only shown in debug mode.
///
/// Have a look at the [example](https://github.com/devj3ns/fleasy/blob/main/example/lib/main.dart) to see this widget in action.
class EasyFutureBuilder<T> extends StatelessWidget {
  /// Creates an [EasyFutureBuilder] which is a wrapper around [FutureBuilder]
  /// that makes it easy to display the various states of fetching data asynchronous.
  ///
  /// See the [documentation page](https://pub.dev/documentation/fleasy/latest/fleasy/EasyFutureBuilder-class.html) for more details.
  const EasyFutureBuilder({
    required this.future,
    required this.dataBuilder,
    super.key,
    this.errorText = 'Oops, something went wrong.',
    this.errorIcon = Icons.error_rounded,
    this.isEmptyText = 'There is nothing to display.',
    this.isEmptyIcon = Icons.close_rounded,
    this.textStyle,
    this.iconStyle,
    this.loadingIndicator = const CircularProgressIndicator(),
  });

  /// The asynchronous computation to which this builder is currently connected.
  final Future<T> future;

  /// The widget which displays the snapshot's data when it's loaded.
  final Widget Function(BuildContext context, T data) dataBuilder;

  /// The text which is shown when the snapshot has an error.
  ///
  /// The style is taken from the [TextTheme] (bodyText2) of your [ThemeData]
  /// or - if defined - from [textStyle].
  final String errorText;

  /// The icon which is shown when the snapshot has an error.
  ///
  /// The style is taken from the [IconThemeData] of your [ThemeData]
  /// or - if defined - from [iconStyle].
  final IconData errorIcon;

  /// The text which is shown when the snapshots data is empty.
  ///
  /// The style is taken from the [TextTheme] (bodyText2) of your [ThemeData]
  /// or - if defined - from [textStyle].
  final String isEmptyText;

  /// The icon which is shown when the snapshots data is empty.
  ///
  /// The style is taken from the [IconThemeData] of your [ThemeData]
  /// or - if defined - from [iconStyle].
  final IconData isEmptyIcon;

  /// TextStyle used for the  [isEmptyText], [errorText] and error message.
  ///
  /// By default the [TextTheme] (bodyText2) of your [ThemeData] is used.
  final TextStyle? textStyle;

  /// [IconThemeData] used for the [isEmptyIcon].
  ///
  /// By default the [IconThemeData] of your [ThemeData] is used.
  final IconThemeData? iconStyle;

  /// The widget which is shown while fetching the snapshots data.
  final Widget loadingIndicator;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            throw snapshot.error!;
          }

          return SnapshotStateInfo(
            text: errorText,
            textStyle: textStyle,
            icon: errorIcon,
            iconStyle: iconStyle,
            errorMessage: snapshot.error.toString(),
          );
        } else if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator;
          } else if (snapshot.data == null && null is T) {
            return dataBuilder(context, snapshot.data as T);
          } else {
            if (kDebugMode) {
              throw snapshot.error!;
            }

            return SnapshotStateInfo(
              text: errorText,
              textStyle: textStyle,
              icon: errorIcon,
              iconStyle: iconStyle,
              errorMessage: snapshot.error?.toString(),
            );
          }
        } else {
          final isEmpty = snapshot.data is Iterable
              ? (snapshot.data! as Iterable).isEmpty
              : snapshot.data is Map
                  ? (snapshot.data! as Map).isEmpty
                  : false;

          return isEmpty
              ? SnapshotStateInfo(
                  text: isEmptyText,
                  textStyle: textStyle,
                  icon: isEmptyIcon,
                  iconStyle: iconStyle,
                )
              : dataBuilder(context, snapshot.data as T);
        }
      },
    );
  }
}

/// Widget used by the [EasyFutureBuilder] and [EasyStreamBuilder] to show
/// that the [Future]/[Stream]'s data is empty or has an error.
///
/// It shows an icon, a text and an error message
/// (if one is defined and the app runs in debug mode).
class SnapshotStateInfo extends StatelessWidget {
  const SnapshotStateInfo({
    required this.text,
    required this.icon,
    super.key,
    this.textStyle,
    this.iconStyle,
    this.errorMessage,
  });

  /// The text shown under the [icon].
  final String text;

  /// The [TextStyle] for the [text].
  ///
  /// By default the bodyText2 text style of your [TextTheme] is used.
  final TextStyle? textStyle;

  /// The icon shown above the [text].
  final IconData icon;

  /// The [IconThemeData] for the [icon].
  ///
  /// By default the [IconThemeData] of your [ThemeData] is used
  /// (with an overwritten size value of 40).
  final IconThemeData? iconStyle;

  /// The error message shown under the [text].
  ///
  /// NOTE: For safety reasons the error message is only shown in debug mode.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();

    // return Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(Insets.m),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         FaIcon(
    //           icon,
    //           color: iconStyle?.color,
    //           size: iconStyle?.size ?? 40,
    //         ),
    //         const SizedBox(height: Insets.m),
    //         SelectableText(
    //           text,
    //           style: textStyle,
    //           textAlign: TextAlign.center,
    //         ),
    //         if (kDebugMode && errorMessage.isNotBlank) ...[
    //           const SizedBox(height: Insets.m),
    //           SelectableText(
    //             errorMessage!,
    //             style: textStyle,
    //             textAlign: TextAlign.center,
    //           ),
    //         ]
    //       ],
    //     ),
    //   ),
    // );
  }
}
