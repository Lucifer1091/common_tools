// import 'dart:io';
// import 'dart:math';
//
// import 'package:common_tools/common_tools.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class CustomImage extends StatelessWidget {
//   final String? image;
//   final XFile? imageFile;
//
//   final BoxFit? fit;
//
//   final Color? backgroundColor;
//   final double radius;
//
//   final double? height;
//   final double? width;
//
//   final BoxShape? shape;
//
//   final VoidCallback? onTap;
//
//   final IconData? topLeft;
//   final VoidCallback? onTapTopLeft;
//
//   final Widget? bottomRight;
//   final IconData? bottomRightIcon;
//   final VoidCallback? onTapBottomRight;
//
//   final bool showBorder;
//   final Color? borderColor;
//   final double? borderWidth;
//
//   final Widget? emptyImagePlaceholder;
//
//   final bool cacheImage;
//
//   final Color? imageColor;
//
//   final Map<String, String>? httpHeaders;
//
//   const CustomImage({
//     super.key,
//     this.image,
//     this.imageFile,
//     this.fit,
//     this.backgroundColor,
//     this.radius = 12,
//     this.shape,
//     this.onTap,
//     this.topLeft,
//     this.onTapTopLeft,
//     this.bottomRight,
//     this.bottomRightIcon,
//     this.onTapBottomRight,
//     this.showBorder = false,
//     this.emptyImagePlaceholder,
//     this.cacheImage = true,
//     this.imageColor,
//     this.borderColor,
//     this.borderWidth,
//     this.httpHeaders,
//   })  : height = 0,
//         width = 0;
//
//   const CustomImage.circle({
//     super.key,
//     this.image,
//     this.imageFile,
//     this.fit,
//     this.backgroundColor,
//     this.radius = 50,
//     this.onTap,
//     this.topLeft,
//     this.onTapTopLeft,
//     this.bottomRight,
//     this.bottomRightIcon,
//     this.onTapBottomRight,
//     this.showBorder = false,
//     this.emptyImagePlaceholder,
//     this.cacheImage = true,
//     this.imageColor,
//     this.borderColor,
//     this.borderWidth,
//     this.httpHeaders,
//   })  : shape = BoxShape.circle,
//         height = 0,
//         width = 0;
//
//   const CustomImage.square({
//     super.key,
//     this.image,
//     this.imageFile,
//     this.fit,
//     this.backgroundColor,
//     this.radius = 14,
//     this.onTap,
//     this.topLeft,
//     this.onTapTopLeft,
//     this.bottomRight,
//     this.bottomRightIcon,
//     this.onTapBottomRight,
//     this.height = 50,
//     this.width = Sizes.WIDTH_50,
//     this.showBorder = false,
//     this.emptyImagePlaceholder,
//     this.cacheImage = true,
//     this.imageColor,
//     this.borderColor,
//     this.borderWidth,
//     this.httpHeaders,
//   }) : shape = BoxShape.rectangle;
//
//   @override
//   Widget build(BuildContext context) {
//     switch (shape) {
//       case BoxShape.rectangle:
//         return _buildSquareImage(context).repaintBoundary;
//
//       case BoxShape.circle:
//         return _buildCircleImage(context).repaintBoundary;
//
//       default:
//         return _buildImage().repaintBoundary;
//     }
//   }
//
//   Widget _buildCircleImage(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: showBorder
//                   ? borderColor ?? const Color(0xFFC0C0C0)
//                   : Colors.transparent,
//               width: borderWidth ?? 1,
//             ),
//             shape: BoxShape.circle,
//           ),
//           child: CircleAvatar(
//             backgroundColor: backgroundColor ?? Colors.white,
//             radius: radius,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(radius),
//               child: _buildImage(),
//             ),
//           ),
//         ),
//         if (bottomRight != null || bottomRightIcon != null)
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: bottomRight ??
//                 InkWell(
//                   onTap: onTapBottomRight,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 26 - 1,
//                     child: CircleAvatar(
//                       backgroundColor: AppColors.blueShade1,
//                       radius: 22,
//                       child: Icon(
//                         bottomRightIcon,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                 ),
//           )
//       ],
//     );
//   }
//
//   Widget _buildSquareImage(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//             borderRadius: BorderRadius.circular(radius),
//             border:
//                 showBorder ? Border.all(color: const Color(0xFFC0C0C0)) : null,
//             shape: BoxShape.rectangle,
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(radius - 1),
//             child: _buildImage(),
//           ),
//         ),
//         if (bottomRight != null || bottomRightIcon != null)
//           Positioned(
//             bottom: -12,
//             right: -12,
//             child: bottomRight ??
//                 InkWell(
//                   onTap: onTapBottomRight,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 22,
//                     child: CircleAvatar(
//                       backgroundColor: AppColors.blueShade1,
//                       radius: 18,
//                       child: Icon(
//                         bottomRightIcon,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                     ),
//                   ),
//                 ),
//           ),
//         if (topLeft != null)
//           Positioned(
//             top: -12,
//             left: -12,
//             child: InkWell(
//               onTap: onTapTopLeft,
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 22,
//                 child: CircleAvatar(
//                   backgroundColor: const Color(0xFFEF5256),
//                   radius: 18,
//                   child: Icon(
//                     topLeft,
//                     color: Colors.white,
//                     size: 22,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildImage() {
//     return GestureDetector(
//       onTap: onTap,
//       child: (UniversalPlatform.isWeb
//               ? _buildCacheNetworkImage()
//               : image != null
//                   ? _buildCacheNetworkImage()
//                   : imageFile != null
//                       ? _buildFileImage()
//                       : _buildImagePlaceHolder())
//           .handleException(
//         errorWidget: _buildImagePlaceHolder(),
//       ),
//     );
//   }
//
//   // Display Image from Url
//   Widget _buildCacheNetworkImage() {
//     return image == null && imageFile == null
//         ? _buildImagePlaceHolder()
//         : CachedNetworkImage(
//             // Important to let the widget rebuild on update
//             key: cacheImage ? null : ValueKey(Random().nextInt(100)),
//             color: imageColor,
//             imageUrl: image ?? imageFile?.path ?? '',
//             fit: fit ?? BoxFit.cover,
//             httpHeaders: httpHeaders,
//             height: radius * 2,
//             width: radius * 2,
//             errorWidget: (context, _, __) => _buildImagePlaceHolder(),
//             placeholder: (context, _) => Container(
//               color: AppColors.white,
//             ).shimmerWidget,
//           );
//   }
//
//   // Display Image when Picked from Image Picker before hitting the Api
//   Widget _buildFileImage() {
//     return Image.file(
//       // Important to let the widget rebuild on update
//       key: cacheImage ? null : ValueKey(Random().nextInt(100)),
//
//       File(imageFile!.path),
//       fit: fit ?? BoxFit.cover,
//       height: radius * 2,
//       width: radius * 2,
//       errorBuilder: (context, _, __) => _buildImagePlaceHolder(),
//     );
//   }
//
//   Widget _buildImagePlaceHolder() {
//     return emptyImagePlaceholder ??
//         Container(
//           height: shape == BoxShape.circle ? radius * 2 : height,
//           width: shape == BoxShape.circle ? radius * 2 : width,
//           padding: const EdgeInsets.all(8 / 2),
//           decoration: const BoxDecoration(color: AppColors.greyShade3),
//           child: emptyImagePlaceholder ??
//               const Icon(
//                 EneftyIcons.image_bold,
//                 color: Colors.white,
//                 size: 35,
//               ),
//         );
//   }
// }
