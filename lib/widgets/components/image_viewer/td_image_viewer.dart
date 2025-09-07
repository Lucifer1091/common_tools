// import 'package:flutter/material.dart';

// import '../../../index.dart';
// import 'td_image_viewer_widget.dart';

// class TDImageViewer {
//   TDImageViewer._();

//   static Future<void> showImageViewer<T>({
//     required BuildContext context,
//     required List<dynamic> images,
//     List<String>? labels,
//     bool? closeBtn = true,
//     bool? deleteBtn = false,
//     bool? showIndex = false,
//     bool? loop = false,
//     bool? autoplay = false,
//     int? duration,
//     Color? bgColor,
//     Color? navBarBgColor,
//     Color? iconColor,
//     TextStyle? labelStyle,
//     TextStyle? indexStyle,
//     Color? modalBarrierColor,
//     bool? barrierDismissible,
//     int? defaultIndex,
//     double? width,
//     double? height,
//     OnIndexChange? onIndexChange,
//     OnClose? onClose,
//     OnDelete? onDelete,
//     bool? ignoreDeleteError,
//     OnImageTap? onTap,
//     OnLongPress? onLongPress,
//     LeftItemBuilder? leftItemBuilder,
//     RightItemBuilder? rightItemBuilder,
//   }) async {
//     modalBarrierColor ??= ThemeColors.neutral.shade900;
//     await showDialog<T>(
//       context: context,
//       barrierDismissible: barrierDismissible ?? false,
//       barrierColor: modalBarrierColor,
//       useSafeArea: false,
//       builder: (context) {
//         return TDImageViewerWidget(
//           images: images,
//           labels: labels,
//           closeBtn: closeBtn,
//           deleteBtn: deleteBtn,
//           showIndex: showIndex,
//           loop: loop,
//           autoplay: autoplay,
//           duration: duration,
//           bgColor: bgColor,
//           navBarBgColor: navBarBgColor,
//           iconColor: iconColor,
//           labelStyle: labelStyle,
//           indexStyle: indexStyle,
//           defaultIndex: defaultIndex,
//           onIndexChange: onIndexChange,
//           width: width,
//           height: height,
//           onClose: onClose,
//           onDelete: onDelete,
//           ignoreDeleteError: ignoreDeleteError,
//           onTap: onTap,
//           onLongPress: onLongPress,
//           leftItemBuilder: leftItemBuilder,
//           rightItemBuilder: rightItemBuilder,
//         );
//       },
//     );
//   }
// }
