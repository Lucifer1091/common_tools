import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../index.dart';

class MySelectFormField<T> extends MyFormBuilderField<T> {
  MySelectFormField({
    /// {@macro MySelect.selectedOptionBuilder}
    required MySelectedOptionBuilder<T> selectedOptionBuilder,
    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,

    /// {@macro MySelect.options}
    Iterable<Widget>? options,

    /// {@macro MySelect.optionsBuilder}
    Widget? Function(BuildContext, int)? optionsBuilder,

    /// {@macro MySelect.placeholder}
    Widget? placeholder,

    /// {@macro MySelect.closeOnTapOutside}
    bool closeOnTapOutside = true,

    /// {@macro MySelect.minWidth}
    double? minWidth,

    /// {@macro MySelect.maxWidth}
    double? maxWidth,

    /// {@macro MySelect.maxHeight}
    double? maxHeight,

    /// {@macro MySelect.decoration}
    MyDecoration? decoration,

    /// {@macro MySelect.trailing}
    Widget? trailing,

    /// {@macro MySelect.padding}
    EdgeInsetsGeometry? padding,

    /// {@macro MySelect.optionsPadding}
    EdgeInsetsGeometry? optionsPadding,

    /// {@macro MySelect.showScrollToTopChevron}
    bool? showScrollToTopChevron,

    /// {@macro MySelect.showScrollToBottomChevron}
    bool? showScrollToBottomChevron,

    /// {@macro MySelect.scrollController}
    ScrollController? scrollController,

    /// {@macro MySelect.anchor}
    MyAnchorBase? anchor,

    /// {@macro MySelect.filter}
    ImageFilter? filter,

    /// {@macro MySelect.popoverController}
    MyPopoverController? popoverController,

    /// {@macro MySelect.header}
    Widget? header,

    /// {@macro MySelect.footer}
    Widget? footer,

    /// {@macro MySelect.allowDeselection}
    bool allowDeselection = false,

    /// {@macro MySelect.closeOnSelect}
    bool closeOnSelect = true,

    /// {@macro MyPopover.groupId}
    Object? groupId,

    /// {@macro MySelect.itemCount}
    int? itemCount,

    /// {@macro MySelect.shrinkWrap}
    bool? shrinkWrap,
    this.controller,

    /// {@macro MySelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,
  }) : super(
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderSelectState<T>;

           return MySelect<T>(
             options: options,
             allowDeselection: allowDeselection,
             optionsBuilder: optionsBuilder,
             selectedOptionBuilder: selectedOptionBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             initialValue: state.initialValue,
             enabled: state.enabled,
             onChanged: state.didChange,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
           );
         },
       );

  MySelectFormField.withSearch({
    required MySelectedOptionBuilder<T> selectedOptionBuilder,
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    MyDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    MyAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    String? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    MyPopoverController? popoverController,

    /// {@macro select.header}
    Widget? header,

    /// {@macro select.footer}
    Widget? footer,
    bool allowDeselection = false,
    bool closeOnSelect = true,

    /// {@macro MyPopover.groupId}
    Object? groupId,

    /// {@macro MySelect.itemCount}
    int? itemCount,

    /// {@macro MySelect.shrinkWrap}
    bool? shrinkWrap,

    /// {@macro MySelect.controller}
    this.controller,

    /// {@macro MySelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro MySelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro MySelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,
  }) : super(
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderSelectState<T>;

           return MySelect<T>.withSearch(
             options: options,
             allowDeselection: allowDeselection,
             optionsBuilder: optionsBuilder,
             selectedOptionBuilder: selectedOptionBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             initialValue: state.initialValue,
             enabled: state.enabled,
             onChanged: state.didChange,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
           );
         },
       );

  MySelectFormField.raw({
    required MySelectVariant variant,
    required MySelectedOptionBuilder<T> selectedOptionBuilder,
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxHeight,
    MyDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    MyAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    String? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    MyPopoverController? popoverController,

    /// {@macro select.header}
    Widget? header,

    /// {@macro select.footer}
    Widget? footer,
    bool allowDeselection = false,
    bool closeOnSelect = true,

    /// {@macro MyPopover.groupId}
    Object? groupId,

    /// {@macro MySelect.itemCount}
    int? itemCount,

    /// {@macro MySelect.shrinkWrap}
    bool? shrinkWrap,

    /// {@macro MySelect.controller}
    this.controller,

    /// {@macro MySelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro MySelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro MySelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,
  }) : assert(
         variant == MySelectVariant.primary ||
             variant == MySelectVariant.search,
         '''The variant is not supported. Use primary or search or use MySelectMultipleFormField instead.''',
       ),
       super(
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderSelectState<T>;

           return MySelect<T>.raw(
             variant: variant,
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionBuilder: selectedOptionBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             initialValue: state.initialValue,
             enabled: state.enabled,
             onChanged: state.didChange,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             allowDeselection: allowDeselection,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
           );
         },
       );

  /// {@macro MySelect.controller}
  final MySelectController<T>? controller;

  @override
  MyFormBuilderFieldState<MySelectFormField<T>, T> createState() =>
      _MyFormBuilderSelectState<T>();
}

class _MyFormBuilderSelectState<T>
    extends MyFormBuilderFieldState<MySelectFormField<T>, T> {
  MySelectController<T>? _controller;

  MySelectController<T> get controller =>
      widget.controller ??
      (_controller ??= MySelectController<T>(
        initialValue: {if (initialValue is T) initialValue as T},
      ));

  @override
  void initState() {
    super.initState();
    controller.addListener(onControllerChange);
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChange);
    _controller?.dispose();
    super.dispose();
  }

  void onControllerChange() {
    didChange(controller.value.firstOrNull);
  }

  @override
  void reset() {
    super.reset();
    controller.value = initialValue is T ? <T>{initialValue as T} : <T>{};
  }
}

class MySelectMultipleFormField<T> extends MyFormBuilderField<Set<T>> {
  MySelectMultipleFormField({
    required MySelectedOptionBuilder<List<T>> selectedOptionsBuilder,
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    MyDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    MyAnchorBase? anchor,
    ImageFilter? filter,
    MyPopoverController? popoverController,

    /// {@macro MySelect.header}
    Widget? header,

    /// {@macro MySelect.footer}
    Widget? footer,
    bool closeOnSelect = true,

    /// {@macro MySelect.allowDeselection}
    bool allowDeselection = true,
    this.controller,

    /// {@macro MySelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,
  }) : super(
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderSelectMultipleState<T>;

           return MySelect<T>.multiple(
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             enabled: state.enabled,
             onChanged: state.didChange,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             allowDeselection: allowDeselection,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
           );
         },
       );

  MySelectMultipleFormField.withSearch({
    required MySelectedOptionBuilder<List<T>> selectedOptionsBuilder,
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    MyDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    MyAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    String? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    MyPopoverController? popoverController,

    /// {@macro select.header}
    Widget? header,

    /// {@macro select.footer}
    Widget? footer,
    bool closeOnSelect = true,

    /// {@macro MySelect.allowDeselection}
    bool allowDeselection = true,
    this.controller,

    /// {@macro MySelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro MySelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro MySelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,
  }) : super(
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderSelectMultipleState<T>;

           return MySelect<T>.multipleWithSearch(
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             enabled: state.enabled,
             onChanged: state.didChange,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxWidth: maxWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             allowDeselection: allowDeselection,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
           );
         },
       );

  MySelectMultipleFormField.raw({
    required MySelectVariant variant,
    required MySelectedOptionBuilder<List<T>> selectedOptionsBuilder,
    super.id,
    super.key,
    super.onSaved,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.initialValue,
    super.focusNode,
    super.validator,
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    ValueChanged<String>? onSearchChanged,
    Widget? placeholder,
    bool closeOnTapOutside = true,
    double? minWidth,
    double? maxHeight,
    MyDecoration? decoration,
    Widget? trailing,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? optionsPadding,
    bool? showScrollToTopChevron,
    bool? showScrollToBottomChevron,
    ScrollController? scrollController,
    MyAnchorBase? anchor,
    ImageFilter? filter,
    Widget? searchDivider,
    Widget? searchInputLeading,
    String? searchPlaceholder,
    EdgeInsetsGeometry? searchPadding,
    Widget? search,
    bool? clearSearchOnClose,
    MyPopoverController? popoverController,

    /// {@macro select.header}
    Widget? header,

    /// {@macro select.footer}
    Widget? footer,
    bool allowDeselection = true,
    bool closeOnSelect = true,
    this.controller,

    /// {@macro MySelect.ensureSelectedVisible}
    bool? ensureSelectedVisible,

    /// {@macro MySelect.searchFocusNode}
    FocusNode? searchFocusNode,

    /// {@macro MySelect.onSearchSubmitted}
    ValueChanged<String>? onSearchSubmitted,
  }) : assert(
         variant == MySelectVariant.multiple ||
             variant == MySelectVariant.multipleWithSearch,
         '''The variant is not supported. Use multiple or multipleWithSearch or use MySelectFormField instead.''',
       ),
       super(
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderSelectMultipleState<T>;

           return MySelect<T>.raw(
             variant: variant,
             options: options,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             enabled: state.enabled,
             onMultipleChanged: state.didChange,
             closeOnTapOutside: closeOnTapOutside,
             anchor: anchor,
             minWidth: minWidth,
             maxHeight: maxHeight,
             decoration: state.decoration,
             trailing: trailing,
             padding: padding,
             optionsPadding: optionsPadding,
             showScrollToTopChevron: showScrollToTopChevron,
             showScrollToBottomChevron: showScrollToBottomChevron,
             scrollController: scrollController,
             filter: filter,
             onSearchChanged: onSearchChanged,
             searchDivider: searchDivider,
             searchInputLeading: searchInputLeading,
             searchPlaceholder: searchPlaceholder,
             searchPadding: searchPadding,
             search: search,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             allowDeselection: allowDeselection,
             closeOnSelect: closeOnSelect,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
           );
         },
       );

  /// {@macro MySelect.controller}
  final MySelectController<T>? controller;

  @override
  MyFormBuilderFieldState<MySelectMultipleFormField<T>, Set<T>> createState() =>
      _MyFormBuilderSelectMultipleState<T>();
}

class _MyFormBuilderSelectMultipleState<T>
    extends MyFormBuilderFieldState<MySelectMultipleFormField<T>, Set<T>> {
  MySelectController<T>? _controller;

  MySelectController<T> get controller =>
      widget.controller ??
      (_controller ??= MySelectController<T>(initialValue: initialValue));

  @override
  void initState() {
    super.initState();
    controller.addListener(onControllerChange);
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChange);
    _controller?.dispose();
    super.dispose();
  }

  void onControllerChange() {
    didChange(controller.value.toSet());
  }

  @override
  void reset() {
    super.reset();
    controller.value = initialValue ?? {};
  }
}
