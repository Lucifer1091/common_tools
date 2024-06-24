// import 'package:flutter/material.dart';
//
// /* HOW TO USE :
//     MultiSelectPopup<String>(
//       controller: controller.unitController,
//       title: AppStrings.GENDER,
//       prefixIcon: Icons.male,
//       onChange: (selected) => controller.genderController.text = selected!,
//       items: controller.genderList,
//       asyncItems:(key) => Future Function
//       showSearchBox: false,
//       fit: FlexFit.loose,
//     ),
//  */
//
// class MultiSelectPopup<T> extends StatefulWidget {
//   final PopupType popupType;
//
//   final List<T> selectedItems;
//   final void Function(List<T>)? onChange;
//
//   final List<T>? items;
//   final Future<List<T>> Function(String)? asyncItems;
//   final bool Function(T, T)? compareFn;
//
//   final PopupItemBuilder<T>? itemBuilder;
//   final DropDownBuilder<List<T>>? dropdownBuilder;
//
//   final bool enabled;
//   final bool showSearchBox;
//   final bool showLoading;
//   final bool showLeadingWidget;
//   final bool showClearButton;
//   final double verticalPadding;
//   final FlexFit fit;
//   final double minHeight;
//   final double height;
//
//   // Parameters For Outside CustomTextFormField Tile
//   final String label;
//   final String? requiredErrorMessage;
//   final IconData? prefixIcon;
//   final Widget? prefixWidget;
//   final bool isRequired;
//   final Color? labelColor;
//   final Widget? title;
//   final String? requiredLabelCharacter;
//   final double? suffixIconSize;
//   final bool showSuffixIcon;
//
//   final double? borderRadius;
//   final Color? enabledBorderColor;
//   final Color? focusBorderColor;
//   final Color? errorBorderColor;
//
//   final String Function(T)? transformer;
//   final String? Function(List<T>?)? validator;
//   final bool Function(T)? disabledItemFn;
//
//   final GlobalKey<DropdownSearchState<T>>? controller;
//   final bool showValidator;
//   final double? errorFontSize;
//   final InputDecoration? inputDecoration;
//
//   final VoidCallback? onClear;
//
//   const MultiSelectPopup({
//     super.key,
//     required this.label,
//     this.labelColor,
//     this.controller,
//     this.onChange,
//     this.items,
//     this.asyncItems,
//     this.selectedItems = const [],
//     this.prefixIcon,
//     this.prefixWidget,
//     this.isRequired = false,
//     this.showSearchBox = false,
//     this.verticalPadding = 6,
//     this.compareFn,
//     this.transformer,
//     this.itemBuilder,
//     this.dropdownBuilder,
//     this.popupType = PopupType.dropdown,
//     this.fit = FlexFit.tight,
//     this.minHeight = 300,
//     this.enabled = true,
//     this.showLoading = false,
//     this.showLeadingWidget = true,
//     this.title,
//     this.borderRadius,
//     this.inputDecoration,
//     this.enabledBorderColor,
//     this.errorBorderColor,
//     this.validator,
//     this.disabledItemFn,
//     this.height = 8,
//     this.focusBorderColor,
//     this.requiredLabelCharacter,
//     this.suffixIconSize,
//     this.showSuffixIcon = true,
//     this.requiredErrorMessage,
//     this.showValidator = true,
//     this.showClearButton = true,
//     this.errorFontSize,
//     this.onClear,
//   });
//
//   InputDecoration? decoration(BuildContext context) {
//     return CustomTextFormField(
//       height: height,
//       focusBorderColor: focusBorderColor,
//       readOnly: false,
//       requiredLabelCharacter: requiredLabelCharacter ?? '*',
//       isRequired: isRequired,
//       labelColor: labelColor ?? Colors.black,
//       labelText: label,
//       prefixIcon: prefixIcon,
//       prefixWidget: prefixWidget,
//       suffixIcon: EneftyIcons.arrow_down_bold,
//       borderRadius: borderRadius,
//       enableBorderColor: enabledBorderColor,
//       errorBorderColor: errorBorderColor,
//       maxLines: 1,
//       errorFontSize: errorFontSize,
//     ).buildInputDecoration(context);
//   }
//
//   DropdownButtonProps dropdownButtonProps(BuildContext context) {
//     return DropdownButtonProps(
//       color: context.primaryColor,
//       padding: EdgeInsets.zero,
//       style: ButtonStyle(
//         shape: WidgetStateProperty.all(
//           RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.circular(borderRadius ?? 10),
//           ),
//         ),
//       ),
//       icon: !showSuffixIcon
//           ? const SizedBox.shrink()
//           : enabled
//               ? showLoading
//                   ? CustomLoading.cupertinoSmall
//                   : Icon(
//                       Icons.arrow_drop_down_circle_rounded,
//                       size: suffixIconSize ?? 30,
//                       color: AppColors.blueShade1,
//                     )
//               : showLoading
//                   ? CustomLoading.cupertinoSmall
//                   : const SizedBox.shrink(),
//     );
//   }
//
//   @override
//   State<MultiSelectPopup<T>> createState() => _MultiSelectPopupState<T>();
// }
//
// class _MultiSelectPopupState<T> extends State<MultiSelectPopup<T>> {
//   late final TextEditingController searchController;
//   late final GlobalKey<DropdownSearchState<T>> key;
//
//   bool get showClearButton =>
//       widget.controller != null && widget.showClearButton && widget.enabled;
//
//   @override
//   void initState() {
//     super.initState();
//     key = widget.controller ?? GlobalKey<DropdownSearchState<T>>();
//     searchController = TextEditingController();
//   }
//
//   bool? _popupBuilderSelection = false;
//
//   void handleCheckBoxState({bool updateState = true}) {
//     var selectedItem = key.currentState?.popupGetSelectedItems ?? [];
//     var isAllSelected = key.currentState?.popupIsAllItemSelected ?? false;
//     _popupBuilderSelection =
//         selectedItem.isEmpty ? false : (isAllSelected ? true : null);
//
//     if (updateState) setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     handleCheckBoxState(updateState: false);
//
//     switch (widget.popupType) {
//       case PopupType.bottomSheet:
//         return _buildMultiSelectionPopup(
//           context,
//           _buildMultiBottomSheetProps(context),
//         );
//       case PopupType.dialog:
//         return _buildMultiSelectionPopup(
//           context,
//           _buildMultiDialogProps(context),
//         );
//       case PopupType.dropdown:
//         return _buildMultiSelectionPopup(
//           context,
//           _buildMultiDropDownProps(context),
//         );
//     }
//   }
//
//   // Update BottomSheet Decorations according to the required UI.
//   ModalBottomSheetProps _buildModalBottomSheetProps(BuildContext context) {
//     return ModalBottomSheetProps(
//       backgroundColor: Colors.white,
//       constraints: BoxConstraints(
//         maxWidth: 600,
//         minHeight: widget.minHeight,
//       ),
//       clipBehavior: Clip.antiAlias,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//     );
//   }
//
//   // Update Dialog Decorations according to the required UI.
//   DialogProps _buildDialogProps(BuildContext context) {
//     return DialogProps(
//       backgroundColor: Colors.white,
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return PanaraAnimations.grow(animation, secondaryAnimation, child);
//       },
//     );
//   }
//
//   // Update DropDown Decorations according to the required UI.
//   MenuProps _buildDropDownProps(BuildContext context) {
//     return MenuProps(
//       backgroundColor: Colors.white,
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
//       ),
//     );
//   }
//
//   Widget _buildMultiSelectionPopup(
//     BuildContext context,
//     PopupPropsMultiSelection<T> popupProps,
//   ) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
//       child: DropdownSearch<T>.multiSelection(
//         key: key,
//         items: widget.items ?? [],
//         asyncItems: widget.asyncItems,
//         selectedItems: widget.selectedItems,
//         enabled: widget.enabled,
//         compareFn: widget.compareFn ?? (a, b) => a == b,
//         onChanged: (selected) {
//           searchController.clear();
//           if (widget.onChange != null && selected.isNotEmpty && mounted) {
//             widget.onChange!(selected);
//           }
//           setState(() {});
//         },
//         clearButtonProps: ClearButtonProps(
//           isVisible: showClearButton,
//           icon: const Icon(
//             EneftyIcons.close_circle_bold,
//             size: 20,
//             color: Color(0xff8e8e93),
//           ),
//           onPressed: () {
//             key.currentState?.clear();
//             widget.onClear?.call();
//           },
//         ),
//         validator: (value) {
//           if (widget.isRequired && widget.showValidator) {
//             if (value?.isEmpty ?? true) {
//               return '${widget.requiredErrorMessage ?? widget.label} is required.';
//             }
//
//             if (widget.validator != null) return widget.validator!(value);
//           } else {
//             if (value?.isNotEmpty ?? false) {
//               if (widget.validator != null) {
//                 return widget.validator!(value);
//               }
//             } else if (!widget.showValidator) {
//               return widget.validator?.call(value);
//             }
//           }
//
//           return null;
//         },
//         dropdownBuilder: (key.currentState?.getSelectedItems.isNotEmpty ??
//                 false)
//             ? widget.dropdownBuilder ??
//                 (ctx, items) {
//                   return Wrap(
//                     children: items.map((e) => buildChip(context, e)).toList(),
//                   );
//                 }
//             : null,
//         dropdownButtonProps: widget.dropdownButtonProps(context),
//         popupProps: popupProps,
//         dropdownDecoratorProps: dropDownTileProps(context),
//         borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
//       ),
//     );
//   }
//
//   PopupPropsMultiSelection<T> _buildMultiBottomSheetProps(
//     BuildContext context,
//   ) {
//     return PopupPropsMultiSelection.modalBottomSheet(
//       showSelectedItems: true,
//       showSearchBox: widget.showSearchBox,
//       isFilterOnline: false,
//       fit: widget.fit,
//       title: widget.title ??
//           ItemFilterHelper.buildSearchPopupTitle<T>(
//             widget.label,
//             controller: key,
//           ),
//       itemBuilder: widget.itemBuilder ?? _buildDropDownItem,
//       containerBuilder: (_, child) => Container(
//         color: Colors.white,
//         child: child,
//       ),
//       modalBottomSheetProps: _buildModalBottomSheetProps(context),
//       loadingBuilder: (_, __) {
//         return const Center(child: CustomLoader());
//       },
//       disabledItemFn: widget.disabledItemFn,
//       searchFieldProps: _buildSearchFieldProps(context),
//       emptyBuilder: (_, __) => const EmptyListIndicator(),
//       errorBuilder: (_, __, ___) => const GenericErrorIndicator(),
//       onDismissed: searchController.clear,
//       listViewProps: const ListViewProps(
//         padding: EdgeInsets.only(bottom: 24),
//       ),
//       selectionWidget: selectionWidget,
//       validationWidgetBuilder: confirmWidget,
//     );
//   }
//
//   PopupPropsMultiSelection<T> _buildMultiDialogProps(BuildContext context) {
//     return PopupPropsMultiSelection.dialog(
//       showSelectedItems: true,
//       showSearchBox: widget.showSearchBox,
//       isFilterOnline: false,
//       fit: widget.fit,
//       title: widget.title ??
//           StatefulBuilder(builder: (context, update) {
//             return ItemFilterHelper.buildSearchPopupTitle<T>(
//               widget.label,
//               controller: key,
//               trailing: CustomCheckBox(
//                 tristate: true,
//                 value: _popupBuilderSelection,
//                 size: 18,
//                 title: 'Select All ',
//                 titleStyle: context.titleSmall,
//                 showCheckAfterText: false,
//                 iconTitleSpacing: 8,
//                 onChanged: (bool? v) {
//                   v ??= false;
//
//                   if (v == true) {
//                     key.currentState?.popupSelectAllItems();
//                   } else if (v == false) {
//                     key.currentState?.popupDeselectAllItems();
//                   }
//                   handleCheckBoxState();
//                   update.call(() {});
//                 },
//               ),
//             );
//           }),
//       containerBuilder: (context, child) {
//         return _buildDefaultDialogStyle(child);
//       },
//       itemBuilder: widget.itemBuilder ?? _buildDropDownItem,
//       dialogProps: _buildDialogProps(context),
//       loadingBuilder: (_, __) {
//         return const Center(child: CustomLoader());
//       },
//       disabledItemFn: widget.disabledItemFn,
//       searchFieldProps: _buildSearchFieldProps(context),
//       emptyBuilder: (_, __) => const EmptyListIndicator(),
//       errorBuilder: (_, __, ___) => const GenericErrorIndicator(),
//       onDismissed: searchController.clear,
//       selectionWidget: selectionWidget,
//       validationWidgetBuilder: confirmWidget,
//     );
//   }
//
//   PopupPropsMultiSelection<T> _buildMultiDropDownProps(BuildContext context) {
//     return PopupPropsMultiSelection.menu(
//       showSelectedItems: true,
//       showSearchBox: widget.showSearchBox,
//       isFilterOnline: false,
//       fit: widget.fit,
//       title: widget.title,
//       itemBuilder: widget.itemBuilder ?? _buildDropDownItem,
//       menuProps: _buildDropDownProps(context),
//       loadingBuilder: (_, __) {
//         return const Center(child: CustomLoader());
//       },
//       disabledItemFn: widget.disabledItemFn,
//       searchFieldProps: _buildSearchFieldProps(context),
//       emptyBuilder: (_, __) => const EmptyListIndicator(),
//       errorBuilder: (_, __, ___) => const GenericErrorIndicator(),
//       onDismissed: searchController.clear,
//       selectionWidget: selectionWidget,
//       validationWidgetBuilder: confirmWidget,
//     );
//   }
//
//   Widget selectionWidget(BuildContext context, T item, bool selected) {
//     return const SizedBox.shrink();
//   }
//
//   Widget confirmWidget(BuildContext context, List<T> items) {
//     return CustomButton.solid(
//       backgroundColor: AppColors.blueShade1,
//       margin: const EdgeInsets.all(12).except(top: 8),
//       hasInfiniteWidth: false,
//       constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
//       radius: 10,
//       text: 'OK',
//       textColor: AppColors.white,
//       onTap: () {
//         key.currentState?.closeDropDownSearch();
//         key.currentState?.changeSelectedItems(items);
//       },
//     );
//   }
//
//   // Inside Custom Text Form Field to Search in Search Popup
//   TextFieldProps _buildSearchFieldProps(BuildContext context) {
//     return TextFieldProps(
//       controller: searchController,
//       decoration: CustomTextFormField(
//         controller: searchController,
//         floatingLabelBehavior: FloatingLabelBehavior.never,
//         labelText: AppStrings.SEARCH_HINT_TEXT,
//         textInputAction: TextInputAction.search,
//         keyboardType: TextInputType.text,
//         prefixIcon: EneftyIcons.search_normal_outline,
//         suffixIconColor: const Color(0xff8e8e93),
//         suffixIcon: EneftyIcons.close_circle_bold,
//         onSuffixTap: searchController.clear,
//         fillColor: AppColors.blueShade3,
//       ).buildInputDecoration(context),
//       cursorColor: context.primaryColor,
//       keyboardType: TextInputType.text,
//     );
//   }
//
//   // Outside Custom Text Form Field Tile onTap open Search Popup
//   DropDownDecoratorProps dropDownTileProps(BuildContext context) {
//     return DropDownDecoratorProps(
//       dropdownSearchDecoration: widget.inputDecoration ??
//           widget.decoration(context)?.copyWith(
//                 contentPadding: EdgeInsets.only(
//                   left: 8,
//                   right: 2,
//                   top: (key.currentState?.getSelectedItems.isEmpty ?? true)
//                       ? 0
//                       : widget.height,
//                   bottom: (key.currentState?.getSelectedItems.isEmpty ?? true)
//                       ? 0
//                       : widget.height,
//                 ),
//               ),
//       baseStyle: context.titleMedium.copyWith(
//         color: Colors.black,
//         fontWeight: FontWeight.w400,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
//
//   bool _isDisabled(T item) =>
//       widget.disabledItemFn != null && (widget.disabledItemFn!(item)) == true;
//
//   Widget _buildDropDownItem(
//     BuildContext context,
//     T title,
//     bool isSelected,
//   ) {
//     bool disabled = _isDisabled(title);
//     bool selected = disabled ? true : isSelected;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: ListTile(
//         enabled: disabled,
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16),
//         minVerticalPadding: 0,
//         visualDensity: const VisualDensity(vertical: -2.5),
//         selectedTileColor:
//             disabled ? AppColors.greyShade1 : context.fillColor,
//         selected: selected,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         leading: widget.showLeadingWidget
//             ? selected
//                 ? Icon(
//                     Icons.check_box_rounded,
//                     size: 22,
//                     color: disabled
//                         ? AppColors.greyShade1
//                         : context.primaryColor,
//                   )
//                 : Icon(
//                     Icons.check_box_outline_blank_rounded,
//                     size: 22,
//                     color: context.background,
//                   )
//             : null,
//         title: Text(
//           widget.transformer?.call(title) ?? title.toString(),
//           style: context.bodyLarge.copyWith(
//             color: disabled
//                 ? AppColors.greyShade1
//                 : selected
//                     ? context.primaryColor
//                     : context.bodyLarge.color,
//             fontWeight: FontWeight.w400,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     );
//   }
//
//   Container _buildDefaultDialogStyle(Widget child) {
//     return Container(
//       color:  context.primaryColor,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildChip(BuildContext context, T item) {
//     return Container(
//       height: 32,
//       padding: const EdgeInsets.only(left: 8, right: 1),
//       margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: AppColors.blueShade4,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Text(
//               widget.transformer?.call(item) ?? item.toString(),
//               style: Theme.of(context).textTheme.labelMedium,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           MaterialButton(
//             height: 20,
//             minWidth: 20,
//             shape: const CircleBorder(),
//             onPressed: () {
//               key.currentState?.removeItem(item);
//             },
//             padding: const EdgeInsets.all(12),
//             child: const Icon(Icons.close_outlined, size: 15),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }
