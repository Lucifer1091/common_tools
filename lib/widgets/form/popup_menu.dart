// import 'package:flutter/material.dart';
//
// class CustomPopupMenu<T> extends StatelessWidget {
//   final T? selectedItem;
//   final void Function(T?)? onChanged;
//   final List<DropdownMenuItem<T>>? items;
//   final Widget? child;
//   final Color? iconColor;
//   final List<double>? customHeights;
//
//   const CustomPopupMenu({
//     super.key,
//     this.child,
//     required this.items,
//     this.onChanged,
//     this.selectedItem,
//     this.iconColor,
//     this.customHeights,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         dividerColor: Colors.white,
//         dividerTheme: const DividerThemeData(
//           color: AppColors.greyShade3,
//           thickness: 0.5,
//           space: 0,
//         ),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2(
//           customButton: IgnorePointer(
//             child: child ??
//                 Row(
//                   children: [
//                     Text(
//                       selectedItem.toString(),
//                       style: context.bodyMedium.copyWith(
//                         color: AppColors.blackShade1,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SpaceW4(),
//                     Icon(
//                       EneftyIcons.arrow_down_bold,
//                       size: 18,
//                       color: iconColor ??  context.primaryColor,
//                     ),
//                   ],
//                 ),
//           ),
//           items: items,
//           onChanged: onChanged,
//           dropdownStyleData: DropdownStyleData(
//             offset: const Offset(8, 0),
//             padding: EdgeInsets.zero,
//             width: 160,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4),
//               color: Colors.white,
//             ),
//             elevation: 8,
//           ),
//           menuItemStyleData: MenuItemStyleData(
//             customHeights: customHeights ??
//                 List<double>.generate(items?.length ?? 0, (_) => 40),
//           ),
//         ),
//       ),
//     );
//   }
// }
