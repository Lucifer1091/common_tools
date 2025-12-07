// // ignore_for_file: avoid_implementing_value_types

// import 'package:flutter/material.dart';

// import '../../../index.dart';

// abstract class AvatarWidget extends Widget {
//   const AvatarWidget({super.key});

//   double? get size;
//   double? get borderRadius;
// }

// class Avatar extends StatefulWidget implements AvatarWidget {
//   const Avatar({
//     required this.initials,
//     super.key,
//     this.backgroundColor,
//     this.size,
//     this.borderRadius,
//     this.badge,
//     this.badgeAlignment,
//     this.badgeGap,
//     this.provider,
//   });

//   Avatar.network({
//     required this.initials,
//     required String photoUrl,
//     super.key,
//     this.backgroundColor,
//     this.size,
//     this.borderRadius,
//     this.badge,
//     this.badgeAlignment,
//     this.badgeGap,
//     int? cacheWidth,
//     int? cacheHeight,
//   }) : provider = ResizeImage.resizeIfNeeded(
//          cacheWidth,
//          cacheHeight,
//          NetworkImage(photoUrl),
//        );

//   static String getInitials(String name) {
//     final List<String> parts = name.split(r'\s+');
//     if (parts.isEmpty) {
//       // get the first 2 characters (title cased)
//       final String first = name.substring(0, 1).toUpperCase();
//       if (name.length > 1) {
//         final String second = name.substring(1, 2).toUpperCase();
//         return first + second;
//       }
//       return first;
//     }
//     // get the first two characters
//     final String first = parts[0].substring(0, 1).toUpperCase();
//     if (parts.length > 1) {
//       final String second = parts[1].substring(0, 1).toUpperCase();
//       return first + second;
//     }
//     // append with the 2nd character of the first part
//     if (parts[0].length > 1) {
//       final String second = parts[0].substring(1, 2).toUpperCase();
//       return first + second;
//     }
//     return first;
//   }

//   final String initials;
//   final Color? backgroundColor;
//   @override
//   final double? size;
//   @override
//   final double? borderRadius;
//   final AvatarWidget? badge;
//   final AlignmentGeometry? badgeAlignment;
//   final double? badgeGap;
//   final ImageProvider? provider;

//   @override
//   _AvatarState createState() => _AvatarState();
// }

// class _AvatarState extends State<Avatar> {
//   Widget _build(BuildContext context) {
//     final double size = widget.size ?? 40;

//     final double borderRadius = widget.borderRadius ?? MyRadius.medium * size;

//     if (widget.provider != null) {
//       return SizedBox(
//         width: size,
//         height: size,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(borderRadius),
//           child: Image(
//             image: widget.provider!,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return _buildInitials(context, borderRadius);
//             },
//           ),
//         ),
//       );
//     }

//     return SizedBox(
//       width: size,
//       height: size,
//       child: _buildInitials(context, borderRadius),
//     );
//   }

//   Widget _buildInitials(BuildContext context, double borderRadius) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: widget.backgroundColor ?? context.colorScheme.muted,
//         borderRadius: BorderRadius.circular(borderRadius),
//       ),
//       child: FittedBox(
//         fit: BoxFit.fill,
//         child: Padding(
//           padding: EdgeInsets.all(8),
//           child: DefaultTextStyle.merge(
//             child: Center(child: Text(widget.initials)),
//             style: TextStyle(
//               color: context.colorScheme.foreground,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.badge == null) {
//       return _build(context);
//     }

//     final double size = widget.size ?? 40;

//     final double borderRadius = widget.borderRadius ?? MyRadius.medium * size;

//     final double badgeSize = widget.badge!.size ?? 12;

//     double offset = size / 2 - badgeSize / 2;
//     offset = offset / size;
//     final alignment =
//         widget.badgeAlignment ?? AlignmentDirectional(offset, offset);

//     final gap = widget.badgeGap ?? 4;

//     return AvatarGroup(
//       alignment: alignment,
//       gap: gap,
//       children: [
//         _AvatarWidget(
//           size: widget.badge!.size ?? 12,
//           borderRadius: widget.badge!.borderRadius,
//           child: widget.badge!,
//         ),
//         _AvatarWidget(
//           size: size,
//           borderRadius: borderRadius,
//           child: _build(context),
//         ),
//       ],
//     );
//   }
// }

// class AvatarBadge extends StatelessWidget implements AvatarWidget {
//   const AvatarBadge({
//     super.key,
//     this.child,
//     this.size,
//     this.borderRadius,
//     this.color,
//   });
//   @override
//   final double? size;
//   @override
//   final double? borderRadius;
//   final Widget? child;
//   final Color? color;

//   @override
//   Widget build(BuildContext context) {
//     final size = this.size ?? 12;
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: color ?? Theme.of(context).colorScheme.primary,
//         borderRadius: BorderRadius.circular(
//           borderRadius ?? MyRadius.medium * size,
//         ),
//       ),
//       child: child,
//     );
//   }
// }

// class _AvatarWidget extends StatelessWidget implements AvatarWidget {
//   const _AvatarWidget({required this.child, this.size, this.borderRadius});
//   @override
//   final double? size;
//   @override
//   final double? borderRadius;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return child;
//   }
// }

// class AvatarGroup extends StatelessWidget {
//   const AvatarGroup({
//     required this.alignment,
//     required this.children,
//     super.key,
//     this.gap,
//     this.clipBehavior,
//   });

//   factory AvatarGroup.toLeft({
//     required List<AvatarWidget> children,
//     Key? key,
//     double? gap,
//     double offset = 0.5,
//   }) {
//     return AvatarGroup(
//       key: key,
//       alignment: Alignment(offset, 0),
//       gap: gap,
//       children: children,
//     );
//   }

//   factory AvatarGroup.toRight({
//     required List<AvatarWidget> children,
//     Key? key,
//     double? gap,
//     double offset = 0.5,
//   }) {
//     return AvatarGroup(
//       key: key,
//       alignment: Alignment(-offset, 0),
//       gap: gap,
//       children: children,
//     );
//   }

//   factory AvatarGroup.toStart({
//     required List<AvatarWidget> children,
//     Key? key,
//     double? gap,
//     double offset = 0.5,
//   }) {
//     return AvatarGroup(
//       key: key,
//       alignment: AlignmentDirectional(offset, 0),
//       gap: gap,
//       children: children,
//     );
//   }

//   factory AvatarGroup.toEnd({
//     required List<AvatarWidget> children,
//     Key? key,
//     double? gap,
//     double offset = 0.5,
//   }) {
//     return AvatarGroup(
//       key: key,
//       alignment: AlignmentDirectional(-offset, 0),
//       gap: gap,
//       children: children,
//     );
//   }

//   factory AvatarGroup.toTop({
//     required List<AvatarWidget> children,
//     Key? key,
//     double? gap,
//     double offset = 0.5,
//   }) {
//     return AvatarGroup(
//       key: key,
//       alignment: Alignment(0, offset),
//       gap: gap,
//       children: children,
//     );
//   }

//   factory AvatarGroup.toBottom({
//     required List<AvatarWidget> children,
//     Key? key,
//     double? gap,
//     double offset = 0.5,
//   }) {
//     return AvatarGroup(
//       key: key,
//       alignment: Alignment(0, -offset),
//       gap: gap,
//       children: children,
//     );
//   }
//   final List<AvatarWidget> children;
//   final AlignmentGeometry alignment;
//   final double? gap;
//   final Clip? clipBehavior;

//   @override
//   Widget build(BuildContext context) {
//     final List<Positioned> children = [];
//     double currentX = 0;
//     double currentY = 0;
//     double currentWidth = 0;
//     double currentHeight = 0;
//     Rect rect = Rect.zero;
//     double currentBorderRadius = 0;

//     final Alignment resolved = alignment.optionallyResolve(context);

//     for (int i = 0; i < this.children.length; i++) {
//       final AvatarWidget avatar = this.children[i];
//       final double size = avatar.size ?? 40;
//       if (i == 0) {
//         children.add(Positioned(left: currentX, top: currentY, child: avatar));
//         rect = Rect.fromLTWH(currentX, currentY, size, size);
//         currentWidth = size;
//         currentHeight = size;
//         currentBorderRadius = avatar.borderRadius ?? MyRadius.medium * size;
//       } else {
//         final double width = size;
//         final double height = size;
//         final double widthDiff = currentWidth - width;
//         final double heightDiff = currentHeight - height;

//         final offsetWidth = -currentWidth * resolved.x;
//         final offsetHeight = -currentHeight * resolved.y;
//         final offsetWidthDiff = widthDiff * resolved.x;
//         final offsetHeightDiff = heightDiff * resolved.y;
//         final double x =
//             (widthDiff / 2) + offsetWidth + currentX + offsetWidthDiff;
//         final double y =
//             (heightDiff / 2) + offsetHeight + currentY + offsetHeightDiff;

//         // NOTE: child positions are not affected by gap

//         children.add(
//           Positioned(
//             left: x,
//             top: y,
//             width: size,
//             height: size,
//             child: ClipPath(
//               clipper: AvatarGroupClipper(
//                 borderRadius: currentBorderRadius,
//                 alignment: resolved,
//                 previousAvatarSize: currentWidth,
//                 gap: gap ?? 4,
//               ),
//               child: avatar,
//             ),
//           ),
//         );

//         currentX = x;
//         currentY = y;
//         currentWidth = size;
//         currentHeight = size;
//         currentBorderRadius = avatar.borderRadius ?? MyRadius.medium * size;

//         rect = rect.expandToInclude(Rect.fromLTWH(x, y, size, size));
//       }
//     }
//     return SizedBox(
//       width: rect.width,
//       height: rect.height,
//       child: Stack(
//         clipBehavior: clipBehavior ?? Clip.none,
//         alignment: Alignment.center,
//         children:
//             children.map((e) {
//               return Positioned(
//                 left: e.left! - rect.left,
//                 top: e.top! - rect.top,
//                 width: e.width,
//                 height: e.height,
//                 child: e.child,
//               );
//             }).toList(),
//       ),
//     );
//   }
// }

// class AvatarGroupClipper extends CustomClipper<Path> {
//   const AvatarGroupClipper({
//     required this.borderRadius,
//     required this.alignment,
//     required this.previousAvatarSize,
//     required this.gap,
//   });

//   final double borderRadius;
//   final Alignment alignment;
//   final double previousAvatarSize;
//   final double gap;

//   @override
//   Path getClip(Size size) {
//     // cut the avatar by the previous avatar
//     // avatars are rounded rectangles

//     final prevAvatarSize = previousAvatarSize;

//     final double widthDiff = size.width - prevAvatarSize;
//     final double heightDiff = size.height - prevAvatarSize;

//     // align both at center first
//     double left = widthDiff / 2;
//     double top = heightDiff / 2;

//     left += size.width * alignment.x;
//     top += size.height * alignment.y;

//     final Path path =
//         Path()
//           ..fillType = PathFillType.evenOdd
//           ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

//     if (borderRadius > 0) {
//       path.addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(
//             left - gap,
//             top - gap,
//             prevAvatarSize + gap * 2,
//             prevAvatarSize + gap * 2,
//           ),
//           Radius.circular(borderRadius + gap * 2),
//         ),
//       );
//     } else {
//       path.addRect(
//         Rect.fromLTWH(
//           left - gap,
//           top - gap,
//           prevAvatarSize + gap * 2,
//           prevAvatarSize + gap * 2,
//         ),
//       );
//     }
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant AvatarGroupClipper oldClipper) {
//     return oldClipper.borderRadius != borderRadius ||
//         oldClipper.alignment != alignment ||
//         oldClipper.previousAvatarSize != previousAvatarSize ||
//         oldClipper.gap != gap;
//   }
// }
