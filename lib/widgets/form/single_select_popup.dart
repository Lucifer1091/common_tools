// import 'package:flutter/material.dart';
//
// /* HOW TO USE :
//     SingleSelectPopup<String>(
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
// enum PopupType { dropdown, bottomSheet, dialog }
//
// /// NOTE : While using custom Model we need to override toString function
// /// or provide [transformer] to select a variable from object such as user.name
// /// to get the title
// typedef PopupItemBuilder<T> = Widget Function(
//   BuildContext context,
//   T item,
//   bool selected,
// );
//
// typedef DropDownBuilder<T> = Widget Function(BuildContext context, T? item);
//
// class SingleSelectPopup<T> extends StatefulWidget {
//   final PopupType popupType;
//
//   final T? selectedItem;
//   final void Function(T?)? onChange;
//
//   final List<T>? items;
//   final Future<List<T>> Function(String)? asyncItems;
//   final bool Function(T, T)? compareFn;
//
//   final PopupItemBuilder<T>? itemBuilder;
//   final DropDownBuilder<T>? dropdownBuilder;
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
//   final String? Function(T?)? validator;
//   final bool Function(T)? disabledItemFn;
//
//   final GlobalKey<DropdownSearchState<T>>? controller;
//   final bool showValidator;
//   final double? errorFontSize;
//   final InputDecoration? inputDecoration;
//
//   final VoidCallback? onClear;
//
//   const SingleSelectPopup({
//     super.key,
//     required this.label,
//     this.labelColor,
//     this.controller,
//     this.onChange,
//     this.items,
//     this.asyncItems,
//     this.selectedItem,
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
//   // Outside Custom Text Form Field Tile onTap open Search Popup
//   DropDownDecoratorProps dropDownTileProps(BuildContext context) {
//     return DropDownDecoratorProps(
//       dropdownSearchDecoration: inputDecoration ?? decoration(context),
//       baseStyle: context.titleMedium.copyWith(
//         color: Colors.black,
//         fontWeight: FontWeight.w400,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
//
//   DropdownButtonProps dropdownButtonProps(BuildContext context) {
//     return DropdownButtonProps(
//       color: context.colorScheme.primaryColor,
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
//   State<SingleSelectPopup<T>> createState() => _SingleSelectPopupState<T>();
// }
//
// class _SingleSelectPopupState<T> extends State<SingleSelectPopup<T>> {
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
//   @override
//   Widget build(BuildContext context) {
//     switch (widget.popupType) {
//       case PopupType.bottomSheet:
//         return _buildSingleSelectionPopup(
//           context,
//           _buildSingleBottomSheetProps(context),
//         );
//       case PopupType.dialog:
//         return _buildSingleSelectionPopup(
//           context,
//           _buildSingleDialogProps(context),
//         );
//       case PopupType.dropdown:
//         return _buildSingleSelectionPopup(
//           context,
//           _buildSingleDropDownProps(context),
//         );
//     }
//   }
//
//   Widget _buildSingleSelectionPopup(
//     BuildContext context,
//     PopupProps<T> popupProps,
//   ) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
//       child: DropdownSearch<T>(
//         key: key,
//         items: widget.items ?? [],
//         asyncItems: widget.asyncItems,
//         selectedItem: widget.selectedItem,
//         enabled: widget.enabled,
//         itemAsString: widget.transformer,
//         compareFn: widget.compareFn ?? (a, b) => a == b,
//         onChanged: (selected) {
//           searchController.clear();
//           if (widget.onChange != null && selected != null && mounted) {
//             widget.onChange!(selected);
//           }
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
//             if (value?.toString().trim().isEmpty ?? true) {
//               return '${widget.requiredErrorMessage ?? widget.label} is required.';
//             }
//
//             if (widget.validator != null) {
//               return widget.validator!(value);
//             }
//           } else {
//             if (value?.toString().isNotEmpty ?? false) {
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
//         dropdownBuilder: widget.dropdownBuilder != null &&
//                 key.currentState?.getSelectedItem != null
//             ? widget.dropdownBuilder
//             : null,
//         dropdownButtonProps: widget.dropdownButtonProps(context),
//         popupProps: popupProps,
//         dropdownDecoratorProps: widget.dropDownTileProps(context),
//         borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
//       ),
//     );
//   }
//
//   PopupProps<T> _buildSingleBottomSheetProps(BuildContext context) {
//     return PopupProps.modalBottomSheet(
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
//     );
//   }
//
//   PopupProps<T> _buildSingleDialogProps(BuildContext context) {
//     return PopupProps.dialog(
//       showSelectedItems: true,
//       showSearchBox: widget.showSearchBox,
//       isFilterOnline: false,
//       fit: widget.fit,
//       title: widget.title ??
//           ItemFilterHelper.buildSearchPopupTitle<T>(
//             widget.label,
//             controller: key,
//           ),
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
//     );
//   }
//
//   PopupProps<T> _buildSingleDropDownProps(BuildContext context) {
//     return PopupProps.menu(
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
//     );
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
//       cursorColor: context.colorScheme.primaryColor,
//       keyboardType: TextInputType.text,
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
//                     Icons.radio_button_checked_rounded,
//                     size: 22,
//                     color: disabled
//                         ? AppColors.greyShade1
//                         : context.colorScheme.primaryColor,
//                   )
//                 : Icon(
//                     Icons.radio_button_unchecked_rounded,
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
//                     ? context.colorScheme.primaryColor
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
//       color:  context.colorScheme.primaryColor,
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
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }
