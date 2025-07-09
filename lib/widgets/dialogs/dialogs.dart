// import 'package:flutter/material.dart';

// class Dialogs {
//   Dialogs._();

//   static const Duration animationDuration = Durations.short1;

//   static Future<T?> custom<T>({
//     required Widget content,
//     BuildContext? context,
//     bool barrierDismissible = true,
//     double? width,
//     double? height,
//     Alignment? alignment,
//     bool showTopRightDialog = false,
//     EdgeInsets? margin,
//     String? title,
//     Widget? footer,
//     Widget? trailingWidget,
//     bool isDialogScrollable = false,
//     bool showSendButton = false,
//     VoidCallback? onSave,
//     VoidCallback? onCloseTap,
//     String? saveButtonText,
//     Object? saveButtonIcon,
//     Object? saveButtonCustom,
//     double? headerHeight,
//     Duration? duration,
//     double? radius,
//   }) {
//     return showGeneralDialog<T>(
//       context: context ?? Get.context!,
//       barrierLabel: '',
//       barrierDismissible: barrierDismissible,
//       transitionDuration: duration ?? animationDuration,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return showTopRightDialog
//             ? PanaraAnimations.fromLeft(animation, secondaryAnimation, child)
//             : PanaraAnimations.grow(animation, secondaryAnimation, child);
//       },
//       pageBuilder: (animation, secondaryAnimation, child) {
//         final buildDialogContent = _buildDialogContent(
//           title,
//           content,
//           footer,
//           trailingWidget,
//           height,
//           width,
//           alignment,
//           showSendButton,
//           onSave,
//           saveButtonText,
//           saveButtonIcon,
//           saveButtonCustom,
//           headerHeight,
//           onCloseTap,
//           null,
//           radius,
//         );

//         return Padding(
//           padding: margin ?? EdgeInsets.zero,
//           child:
//               isDialogScrollable
//                   ? Center(
//                     child: SingleChildScrollView(child: buildDialogContent),
//                   )
//                   : buildDialogContent,
//         );
//       },
//     );
//   }

//   static Future<T?> fullscreen<T>({
//     Duration? duration,
//     required Widget content,
//   }) {
//     final dialog = Dialog.fullscreen(child: content);

//     return showGeneralDialog<T>(
//       context: Get.context!,
//       barrierLabel: '',
//       transitionDuration: duration ?? animationDuration,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return PanaraAnimations.grow(animation, secondaryAnimation, child);
//       },
//       pageBuilder: (animation, secondaryAnimation, child) {
//         return dialog;
//       },
//     );
//   }

//   static Widget _buildDialogContent(
//     String? title,
//     Widget content,
//     Widget? footer,
//     Widget? trailingWidget,
//     double? height,
//     double? width,
//     Alignment? alignment,
//     bool showSendButton,
//     VoidCallback? onSave,
//     String? saveButtonText,
//     Object? saveButtonIcon,
//     Object? saveButtonCustom,
//     double? headerHeight,
//     VoidCallback? onCloseTap,
//     Widget? fancy,
//     double? radius,
//   ) {
//     return buildDialogContainer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (title != null) ...[
//             buildDialogHeader(
//               title: title,
//               onSave: onSave,
//               saveButtonText: saveButtonText,
//               showSendButton: showSendButton,
//               saveButtonIcon: saveButtonIcon,
//               saveButtonCustom: saveButtonCustom,
//               headerHeight: headerHeight,
//               onCloseTap: onCloseTap,
//               trailingWidget: trailingWidget,
//             ),
//             const Divider(color: AppColors.greyShade4, height: 1),
//           ],
//           if (fancy != null)
//             Center(
//               child: Column(children: [fancy, content.expanded()]),
//             ).expanded()
//           else
//             content.expanded(),
//           if (footer != null) ...[
//             const Divider(color: AppColors.greyShade4, height: 1),
//             footer,
//           ],
//         ],
//       ),
//       height: height,
//       width: width,
//       alignment: alignment,
//       radius: radius,
//     );
//   }

//   static Widget buildDialogHeader({
//     required String title,
//     VoidCallback? onSave,
//     String? saveButtonText,
//     Object? saveButtonIcon,
//     Object? saveButtonCustom,
//     double? headerHeight,
//     required bool showSendButton,
//     bool showCloseButton = true,
//     VoidCallback? onClearAllTap,
//     VoidCallback? onCloseTap,
//     bool showCloseText = false,
//     Widget? trailingWidget,
//   }) {
//     return SizedBox(
//       width: double.maxFinite,
//       height: headerHeight ?? 50,
//       child: Stack(
//         children: [
//           if (showCloseButton)
//             Positioned(
//               left: Sizes.PADDING_6,
//               top: Sizes.PADDING_6,
//               bottom: Sizes.PADDING_6,
//               child: Center(
//                 child: TextButton(
//                   onPressed: onCloseTap ?? () => Get.close(1),
//                   child:
//                       showCloseText
//                           ? Text('Close', style: Get.textTheme.titleSmall!)
//                           : const Icon(
//                             EneftyIcons.close_outline,
//                             color: Color(0xFF817272),
//                             size: Sizes.ICON_SIZE_30,
//                           ),
//                 ),
//               ),
//             ),
//           if (onClearAllTap != null)
//             Positioned(
//               left: !showCloseButton ? 16 : 60,
//               top: Sizes.PADDING_6,
//               bottom: Sizes.PADDING_6,
//               child: Center(
//                 child: TextButton(
//                   onPressed: onClearAllTap,
//                   child: Text(
//                     'Clear',
//                     style: Get.textTheme.titleMedium
//                         ?.copyWith(color: AppColors.blueShade1)
//                         .underlined(
//                           color: AppColors.blueShade1,
//                           distance: 2,
//                           thickness: 2,
//                         ),
//                   ),
//                 ),
//               ),
//             ),
//           Center(
//             child: Text(
//               title,
//               style: Get.context!.titleLarge.copyWith(
//                 fontWeight: FontWeight.w500,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.center,
//             ),
//           ),
//           if (onSave != null) ...[
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 6.0),
//                 child: TextButton(
//                   onPressed: onSave,
//                   child:
//                       saveButtonCustom != null
//                           ? const Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child: CustomButton.solid(
//                               backgroundColor: AppColors.blueShade1,
//                               text: AppStrings.SAVE,
//                               icon: Icon(
//                                 Icons.save_alt,
//                                 color: AppColors.white,
//                               ),
//                               borderWidth: 0.2,
//                               borderColor: AppColors.blackShade13,
//                               textStyle: TextStyle(
//                                 fontSize: Sizes.TEXT_SIZE_14,
//                                 color: AppColors.white,
//                               ),
//                               // onTap: () => onCloseTap,
//                               hasInfiniteWidth: false,
//                               radius: 8.0,
//                               constraints: BoxConstraints(
//                                 maxWidth: Sizes.WIDTH_100,
//                                 maxHeight: Sizes.HEIGHT_50,
//                                 minHeight: Sizes.HEIGHT_50,
//                                 minWidth: Sizes.WIDTH_100,
//                               ),
//                             ),
//                           )
//                           : Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               if (saveButtonIcon != null)
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 4.0),
//                                   child:
//                                       (saveButtonIcon is IconData)
//                                           ? Icon(
//                                             saveButtonIcon,
//                                             color: AppColors.blueShade1,
//                                             size: 23,
//                                           )
//                                           : Image.asset(
//                                             saveButtonIcon as String,
//                                             width: 23,
//                                             height: 23,
//                                             color: AppColors.blueShade1,
//                                           ),
//                                 ),
//                               Text(
//                                 saveButtonText ??
//                                     (showSendButton
//                                         ? AppStrings.SEND
//                                         : AppStrings.SAVE),
//                                 style: Get.context!.titleMedium.copyWith(
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.blueShade1,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                 ),
//               ),
//             ),
//           ],
//           if (trailingWidget != null)
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 6.0),
//                 child: trailingWidget,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   static Future<T?> confirmation<T>({
//     String? title,
//     required String message,
//     String? imagePath,
//     double? imageSize,
//     String? confirmButtonText,
//     String? cancelButtonText,
//     required VoidCallback onTapConfirm,
//     VoidCallback? onTapCancel,
//     PanaraDialogType? panaraDialogType,
//     Color? color,
//     Color? textColor,
//     Color? buttonTextColor,
//     EdgeInsets? padding,
//     bool noImage = false,
//     double? width,
//     double? height,
//     bool barrierDismissible = true,
//   }) async {
//     return await showGeneralDialog<T>(
//       context: Get.context!,
//       barrierLabel: '',
//       barrierDismissible: barrierDismissible,
//       transitionDuration: animationDuration,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return PanaraAnimations.grow(animation, secondaryAnimation, child);
//       },
//       pageBuilder: (animation, secondaryAnimation, child) {
//         return buildDialogContainer(
//           child: PanaraConfirmDialogWidget(
//             title: title,
//             message: message,
//             confirmButtonText: confirmButtonText ?? "Yes",
//             cancelButtonText: cancelButtonText ?? "No",
//             color: color ?? AppColors.kPrimary,
//             onTapCancel: onTapCancel ?? () => Get.close(0),
//             onTapConfirm: onTapConfirm,
//             panaraDialogType: panaraDialogType ?? PanaraDialogType.custom,
//             textColor: textColor,
//             buttonTextColor: buttonTextColor,
//             imagePath: imagePath,
//             imageSize: imageSize,
//             margin: EdgeInsets.zero,
//             padding: padding,
//             noImage: noImage,
//           ),
//           height: height,
//           width: width,
//         );
//       },
//     );
//   }

//   static Future<T?> info<T>({
//     String? title,
//     required String message,
//     String? imagePath,
//     double? imageSize,
//     String? buttonText,
//     VoidCallback? onTapDismiss,
//     PanaraDialogType? panaraDialogType,
//     Color? color,
//     Color? textColor,
//     Color? buttonTextColor,
//     EdgeInsets? padding,
//     bool noImage = false,
//     double? width,
//     double? height,
//     bool barrierDismissible = true,
//   }) async {
//     return await showGeneralDialog<T>(
//       context: Get.context!,
//       barrierLabel: '',
//       barrierDismissible: barrierDismissible,
//       transitionDuration: animationDuration,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return PanaraAnimations.grow(animation, secondaryAnimation, child);
//       },
//       pageBuilder: (animation, secondaryAnimation, child) {
//         return buildDialogContainer(
//           child: PanaraInfoDialogWidget(
//             title: title,
//             message: message,
//             buttonText: buttonText ?? "Ok",
//             color: color ?? AppColors.kPrimary,
//             onTapDismiss: onTapDismiss ?? () => Get.close(0),
//             panaraDialogType: panaraDialogType ?? PanaraDialogType.custom,
//             textColor: textColor,
//             buttonTextColor: buttonTextColor,
//             imagePath: imagePath,
//             imageSize: imageSize,
//             margin: EdgeInsets.zero,
//             padding: padding,
//             noImage: noImage,
//           ),
//           height: height,
//           width: width,
//         );
//       },
//     );
//   }

//   static Dialog buildDialogContainer({
//     required Widget child,
//     double? width,
//     double? height,
//     Alignment? alignment,
//     double? radius,
//   }) {
//     return Dialog(
//       insetPadding: const EdgeInsets.symmetric(horizontal: Sizes.PADDING_16),
//       alignment: alignment ?? Alignment.center,
//       backgroundColor: AppColors.kPrimary,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(radius ?? Sizes.RADIUS_32),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(radius ?? Sizes.RADIUS_32),
//         child: Padding(
//           padding: const EdgeInsets.only(left: Sizes.PADDING_8),
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: width ?? 340,
//               maxHeight: height ?? 340,
//               minWidth: width ?? 340,
//               minHeight: height ?? 340,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(radius ?? Sizes.RADIUS_32),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(radius ?? Sizes.RADIUS_32),
//               child: child,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   static Future<void> delete({
//     double? width,
//     double? height,
//     required Function onTapConfirm,
//     String? descriptionMessage,
//     title,
//   }) async {
//     Dialogs.confirmation(
//       height: height,
//       width: width,
//       title: title ?? "Delete Confirmation",
//       message: descriptionMessage ?? "Are you sure you want to delete?",
//       onTapConfirm: () {
//         Get.close(0);
//         onTapConfirm();
//       },
//       onTapCancel: () => Get.close(0),
//     );
//   }

//   static Future<void> aligned(
//     BuildContext context, {
//     double? height,
//     double? width,
//     required Widget content,
//     EdgeInsetsGeometry? padding,
//     BorderRadiusGeometry? borderRadius,
//     bool barrierDismissible = true,
//     Color? barrierColor,
//     bool showTriangle = false,
//     Color? triangleColor,
//     double? trianglePadding,
//     AlignmentGeometry alignment = Alignment.topRight,
//   }) {
//     return showDialog(
//       context: context,
//       barrierColor: barrierColor,
//       barrierDismissible: barrierDismissible,
//       builder: (BuildContext context) {
//         final width0 = (width ?? 400);
//         final height0 = (height ?? 550);

//         return Align(
//           alignment: alignment,
//           child: Padding(
//             padding: padding ?? const EdgeInsets.only(top: 95, right: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 if (showTriangle)
//                   Padding(
//                     padding: EdgeInsets.only(right: trianglePadding ?? 15),
//                     child: ClipPath(
//                       clipper: TriangleClipper(),
//                       child: Container(
//                         clipBehavior: Clip.none,
//                         color: triangleColor ?? AppColors.white,
//                         height: 10,
//                         width: 15,
//                       ),
//                     ),
//                   ),
//                 ClipRRect(
//                   borderRadius:
//                       borderRadius ??
//                       const BorderRadius.all(Radius.circular(8)),
//                   child: SizedBox(
//                     width: width0 / Layout.instance.scaleFactor,
//                     height: height0 / Layout.instance.scaleFactor,
//                     child: FittedBox(
//                       fit: BoxFit.contain,
//                       child: SizedBox(
//                         width: width0,
//                         height: height0,
//                         child: content,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   static Future<void> verification({
//     String? title,
//     required String message,
//     required Widget child,
//     required VoidCallback onConfirm,
//     double? width,
//     double? height,
//     String? cancelText,
//     String? confirmText,
//     IconData? icon,
//     Color? iconColor,
//   }) async {
//     await Dialogs.custom(
//       height: height ?? 450,
//       width: width,
//       content: Align(
//         alignment: Alignment.center,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             constraints: BoxConstraints(maxWidth: max(width ?? 0, 340)),
//             margin: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Icon(
//                   icon ?? EneftyIcons.tick_circle_outline,
//                   color: iconColor ?? const Color(0xff0FBB91),
//                   size: 84,
//                 ),
//                 const SizedBox(height: 24),
//                 if (title != null)
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       height: 1.2,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 const SizedBox(height: 5),
//                 Text(
//                   message,
//                   style: const TextStyle(
//                     height: 1.5,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 child,
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Material(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         child: InkWell(
//                           onTap: Get.back,
//                           borderRadius: BorderRadius.circular(10),
//                           child: Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: AppColors.blueShade1),
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.transparent,
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               cancelText ?? 'Cancel',
//                               textAlign: TextAlign.center,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.blueShade1,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 24),
//                     Expanded(
//                       flex: 1,
//                       child: Material(
//                         color: AppColors.blueShade1,
//                         borderRadius: BorderRadius.circular(10),
//                         child: InkWell(
//                           onTap: onConfirm,
//                           borderRadius: BorderRadius.circular(10),
//                           child: Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.transparent,
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               confirmText ?? 'OK',
//                               textAlign: TextAlign.center,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   static Future<T?> fancy<T>({
//     required Widget content,

//     // For Image or Icon
//     required Object icon,
//     required String header,
//     required String subtitle,

//     //
//     bool barrierDismissible = true,
//     double? width,
//     double? height,
//     Alignment? alignment,
//     bool showTopRightDialog = false,
//     EdgeInsets? margin,
//     String? title,
//     Widget? footer,
//     Widget? trailingWidget,
//     bool isDialogScrollable = false,
//     bool showSendButton = false,
//     VoidCallback? onSave,
//     VoidCallback? onCloseTap,
//     String? saveButtonText,
//     Object? saveButtonIcon,
//     Object? saveButtonCustom,
//     double? headerHeight,
//     Duration? duration,
//     double? radius,
//   }) {
//     return showGeneralDialog<T>(
//       context: Get.context!,
//       barrierLabel: '',
//       barrierDismissible: barrierDismissible,
//       transitionDuration: duration ?? animationDuration,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return showTopRightDialog
//             ? PanaraAnimations.fromLeft(animation, secondaryAnimation, child)
//             : PanaraAnimations.grow(animation, secondaryAnimation, child);
//       },
//       pageBuilder: (animation, secondaryAnimation, child) {
//         final buildDialogContent = _buildDialogContent(
//           title,
//           content,
//           footer,
//           trailingWidget,
//           height,
//           width,
//           alignment,
//           showSendButton,
//           onSave,
//           saveButtonText,
//           saveButtonIcon,
//           saveButtonCustom,
//           headerHeight,
//           onCloseTap,
//           buildFancyHeader(icon: icon, title: header, message: subtitle),
//           radius,
//         );

//         return Padding(
//           padding: margin ?? EdgeInsets.zero,
//           child:
//               isDialogScrollable
//                   ? Center(
//                     child: SingleChildScrollView(child: buildDialogContent),
//                   )
//                   : buildDialogContent,
//         );
//       },
//     );
//   }

//   static Widget buildFancyHeader({
//     Object? icon,
//     String? title,
//     String? message,
//   }) {
//     return Column(
//       children: [
//         const SpaceH32(),
//         if (icon != null) ...[
//           if (icon is String) ...[
//             if (icon.contains('svg')) ...[
//               SvgPicture.asset(
//                 icon,
//                 height: 80,
//                 width: 80,
//                 colorFilter: const ColorFilter.mode(
//                   AppColors.kPrimary,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ] else ...[
//               Image.asset(
//                 icon,
//                 height: 80,
//                 width: 80,
//                 color: AppColors.kPrimary,
//               ),
//             ],
//           ] else if (icon is IconData) ...[
//             Icon(icon, color: AppColors.kPrimary, size: 100),
//           ] else if (icon is Widget) ...[
//             icon,
//           ],
//         ],
//         const SpaceH16(),
//         if (title != null) ...[
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               title,
//               textAlign: TextAlign.center,
//               style: Get.context?.titleLarge,
//             ),
//           ),
//           const SpaceH24(),
//         ],
//         if (message != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               message,
//               textAlign: TextAlign.center,
//               style: Get.context?.bodyMedium,
//             ),
//           ),
//       ],
//     );
//   }

//   static Future<T?> transparent<T>({
//     required Widget content,
//     bool barrierDismissible = true,
//   }) async {
//     return await Get.dialog<T>(
//       Container(
//         color: Colors.black.withValues(alpha: 0.7),
//         child: Center(child: content),
//       ),
//       barrierColor: Colors.transparent,
//       barrierDismissible: barrierDismissible,
//     );
//   }

//   static Future<T?> draggable<T>({
//     Duration? duration,
//     double? width,
//     double? height,
//     Alignment? alignment,
//     bool barrierDismissible = true,
//     required Widget content,
//   }) {
//     return showGeneralDialog<T>(
//       context: Get.context!,
//       barrierLabel: '',
//       barrierDismissible: barrierDismissible,
//       transitionDuration: duration ?? animationDuration,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return PanaraAnimations.grow(animation, secondaryAnimation, child);
//       },
//       pageBuilder: (animation, secondaryAnimation, child) {
//         return FloatingDialog(
//           child: buildDialogContainer(
//             child: content,
//             height: height,
//             width: width,
//             alignment: alignment,
//           ),
//         );
//       },
//     );
//   }
// }

// class TriangleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.moveTo(size.width / 2, 0.0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0.0, size.height);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(TriangleClipper oldClipper) => false;
// }
