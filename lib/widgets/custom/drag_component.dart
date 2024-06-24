// import 'package:flutter/material.dart';
//
// class DragComponent extends StatefulWidget {
//   final String title;
//   final String icon;
//   final void Function()? onTap;
//   const DragComponent({
//     super.key,
//     required this.title,
//     required this.icon,
//     this.onTap,
//   });
//
//   @override
//   State<DragComponent> createState() => _DragComponentState();
// }
//
// class _DragComponentState extends State<DragComponent> {
//   double bottom = 80;
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: bottom,
//       right: 0,
//       child: Draggable(
//         data: '3',
//         axis: Axis.vertical,
//         feedback: SizedBox(width: 228, child: Center(child: _buildWidget())),
//         childWhenDragging: Container(),
//         child: _buildWidget(),
//         onDragEnd: (v) {
//           if (v.offset.dy > 40 && v.offset.dy < Get.size.height) {
//             setState(() => bottom = Get.size.height - v.offset.dy);
//           } else if (v.offset.dy < 40) {
//             setState(() => bottom = Get.size.height - 80);
//           } else if (v.offset.dy > Get.size.height) {
//             setState(() => bottom = 0);
//           }
//         },
//       ),
//     );
//   }
//
//   Container _buildWidget() {
//     return Container(
//       width: 200,
//       height: 52,
//       decoration: BoxDecoration(
//         color: AppColors.blueShade1,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(32),
//           bottomLeft: Radius.circular(32),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF73C9EF).withOpacity(0.50),
//             offset: const Offset(0, 9),
//             blurRadius: 12,
//           )
//         ],
//       ),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               widget.icon,
//               scale: 2.5,
//             ),
//             const SpaceW12(),
//             Text(
//               widget.title,
//               style: Get.textTheme.titleSmall!.copyWith(
//                 color: AppColors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
