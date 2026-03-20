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

    /// {@macro MySelect.items}
    MySelectItemDelegate? items,

    /// {@macro MySelect.itemsBuilder}
    MySelectItemsBuilder<T>? itemsBuilder,

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

    /// {@macro MySelect.popupWidth}
    MySelectPopupWidth popupWidth = MySelectPopupWidth.matchTrigger,

    /// {@macro MySelect.loadingBuilder}
    WidgetBuilder? loadingBuilder,

    /// {@macro MySelect.emptyBuilder}
    WidgetBuilder? emptyBuilder,

    /// {@macro MySelect.errorBuilder}
    MySelectErrorBuilder? errorBuilder,
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
             items: items,
             itemsBuilder: itemsBuilder,
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
             popupWidth: popupWidth,
             loadingBuilder: loadingBuilder,
             emptyBuilder: emptyBuilder,
             errorBuilder: errorBuilder,
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
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    MySelectItemDelegate? items,
    MySelectItemsBuilder<T>? itemsBuilder,
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
    TextEditingController? searchController,
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

    /// {@macro MySelect.popupWidth}
    MySelectPopupWidth popupWidth = MySelectPopupWidth.matchTrigger,

    /// {@macro MySelect.loadingBuilder}
    WidgetBuilder? loadingBuilder,

    /// {@macro MySelect.emptyBuilder}
    WidgetBuilder? emptyBuilder,

    /// {@macro MySelect.errorBuilder}
    MySelectErrorBuilder? errorBuilder,

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
             items: items,
             itemsBuilder: itemsBuilder,
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
             searchController: searchController,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             popupWidth: popupWidth,
             loadingBuilder: loadingBuilder,
             emptyBuilder: emptyBuilder,
             errorBuilder: errorBuilder,
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
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    MySelectItemDelegate? items,
    MySelectItemsBuilder<T>? itemsBuilder,
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
    TextEditingController? searchController,
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

    /// {@macro MySelect.popupWidth}
    MySelectPopupWidth popupWidth = MySelectPopupWidth.matchTrigger,

    /// {@macro MySelect.loadingBuilder}
    WidgetBuilder? loadingBuilder,

    /// {@macro MySelect.emptyBuilder}
    WidgetBuilder? emptyBuilder,

    /// {@macro MySelect.errorBuilder}
    MySelectErrorBuilder? errorBuilder,

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
             items: items,
             itemsBuilder: itemsBuilder,
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
             searchController: searchController,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             allowDeselection: allowDeselection,
             closeOnSelect: closeOnSelect,
             groupId: groupId,
             itemCount: itemCount,
             shrinkWrap: shrinkWrap,
             popupWidth: popupWidth,
             loadingBuilder: loadingBuilder,
             emptyBuilder: emptyBuilder,
             errorBuilder: errorBuilder,
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
  bool _isSyncingController = false;

  MySelectController<T> get controller =>
      widget.controller ??
      (_controller ??= MySelectController<T>(
        initialValue: {if (initialValue is T) initialValue as T},
      ));

  @override
  void initState() {
    super.initState();
    controller.addListener(onControllerChange);
    if (widget.controller != null) {
      onControllerChange();
    }
  }

  @override
  void didUpdateWidget(covariant MySelectFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    oldWidget.controller?.removeListener(onControllerChange);

    if (oldWidget.controller == null && widget.controller != null) {
      _controller?.dispose();
      _controller = null;
    } else if (oldWidget.controller != null && widget.controller == null) {
      _controller = MySelectController<T>(initialValue: _fieldValueAsSet());
    }

    controller.addListener(onControllerChange);

    if (widget.controller != null) {
      onControllerChange();
    } else {
      _syncControllerWithValue();
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    if (!_isSyncingController) {
      _syncControllerWithValue();
    }
  }

  void onControllerChange() {
    if (_isSyncingController) return;

    final controllerValue = controller.value.firstOrNull;
    if (controllerValue != value) {
      didChange(controllerValue);
    }
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChange);
    _controller?.dispose();
    super.dispose();
  }

  Set<T> _fieldValueAsSet() => value is T ? <T>{value as T} : <T>{};

  void _syncControllerWithValue() {
    final nextValue = _fieldValueAsSet();
    if (_sameSelection(controller.value, nextValue)) return;

    _isSyncingController = true;
    controller.value = nextValue;
    _isSyncingController = false;
  }

  bool _sameSelection(Set<T> a, Set<T> b) {
    return identical(a, b) || (a.length == b.length && a.containsAll(b));
  }
}

class MySelectMultipleFormField<T> extends MyFormBuilderField<Set<T>> {
  MySelectMultipleFormField({
    MySelectedOptionBuilder<List<T>>? selectedOptionsBuilder,
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
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    MySelectItemDelegate? items,
    MySelectItemsBuilder<T>? itemsBuilder,
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

    /// {@macro MySelect.popupWidth}
    MySelectPopupWidth popupWidth = MySelectPopupWidth.matchTrigger,

    /// {@macro MySelect.loadingBuilder}
    WidgetBuilder? loadingBuilder,

    /// {@macro MySelect.emptyBuilder}
    WidgetBuilder? emptyBuilder,

    /// {@macro MySelect.errorBuilder}
    MySelectErrorBuilder? errorBuilder,

    /// {@macro MySelect.selectedChipBuilder}
    MySelectedChipBuilder<T>? selectedChipBuilder,
  }) : super(
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderSelectMultipleState<T>;

           return MySelect<T>.multiple(
             options: options,
             items: items,
             itemsBuilder: itemsBuilder,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             selectedChipBuilder: selectedChipBuilder,
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
             popupWidth: popupWidth,
             loadingBuilder: loadingBuilder,
             emptyBuilder: emptyBuilder,
             errorBuilder: errorBuilder,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
           );
         },
       );

  MySelectMultipleFormField.withSearch({
    MySelectedOptionBuilder<List<T>>? selectedOptionsBuilder,
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
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    MySelectItemDelegate? items,
    MySelectItemsBuilder<T>? itemsBuilder,
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
    TextEditingController? searchController,
    bool? clearSearchOnClose,
    MyPopoverController? popoverController,

    /// {@macro select.header}
    Widget? header,

    /// {@macro select.footer}
    Widget? footer,
    bool closeOnSelect = true,

    /// {@macro MySelect.allowDeselection}
    bool allowDeselection = true,

    /// {@macro MySelect.popupWidth}
    MySelectPopupWidth popupWidth = MySelectPopupWidth.matchTrigger,

    /// {@macro MySelect.loadingBuilder}
    WidgetBuilder? loadingBuilder,

    /// {@macro MySelect.emptyBuilder}
    WidgetBuilder? emptyBuilder,

    /// {@macro MySelect.errorBuilder}
    MySelectErrorBuilder? errorBuilder,

    /// {@macro MySelect.selectedChipBuilder}
    MySelectedChipBuilder<T>? selectedChipBuilder,
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
             items: items,
             itemsBuilder: itemsBuilder,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             selectedChipBuilder: selectedChipBuilder,
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
             searchController: searchController,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             closeOnSelect: closeOnSelect,
             allowDeselection: allowDeselection,
             popupWidth: popupWidth,
             loadingBuilder: loadingBuilder,
             emptyBuilder: emptyBuilder,
             errorBuilder: errorBuilder,
             controller: state.controller,
             ensureSelectedVisible: ensureSelectedVisible,
             searchFocusNode: searchFocusNode,
             onSearchSubmitted: onSearchSubmitted,
           );
         },
       );

  MySelectMultipleFormField.raw({
    required MySelectVariant variant,
    MySelectedOptionBuilder<List<T>>? selectedOptionsBuilder,
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
    Iterable<Widget>? options,

    /// The builder for the options of the [MySelect].
    Widget? Function(BuildContext, int)? optionsBuilder,
    MySelectItemDelegate? items,
    MySelectItemsBuilder<T>? itemsBuilder,
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
    TextEditingController? searchController,
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

    /// {@macro MySelect.popupWidth}
    MySelectPopupWidth popupWidth = MySelectPopupWidth.matchTrigger,

    /// {@macro MySelect.loadingBuilder}
    WidgetBuilder? loadingBuilder,

    /// {@macro MySelect.emptyBuilder}
    WidgetBuilder? emptyBuilder,

    /// {@macro MySelect.errorBuilder}
    MySelectErrorBuilder? errorBuilder,

    /// {@macro MySelect.selectedChipBuilder}
    MySelectedChipBuilder<T>? selectedChipBuilder,
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
             items: items,
             itemsBuilder: itemsBuilder,
             optionsBuilder: optionsBuilder,
             selectedOptionsBuilder: selectedOptionsBuilder,
             selectedChipBuilder: selectedChipBuilder,
             focusNode: state.focusNode,
             placeholder: placeholder,
             enabled: state.enabled,
             onMultipleChanged: state.didChange,
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
             searchController: searchController,
             clearSearchOnClose: clearSearchOnClose,
             popoverController: popoverController,
             header: header,
             footer: footer,
             allowDeselection: allowDeselection,
             closeOnSelect: closeOnSelect,
             popupWidth: popupWidth,
             loadingBuilder: loadingBuilder,
             emptyBuilder: emptyBuilder,
             errorBuilder: errorBuilder,
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
  bool _isSyncingController = false;

  MySelectController<T> get controller =>
      widget.controller ??
      (_controller ??= MySelectController<T>(initialValue: initialValue));

  @override
  void initState() {
    super.initState();
    controller.addListener(onControllerChange);
    if (widget.controller != null) {
      onControllerChange();
    }
  }

  @override
  void didUpdateWidget(covariant MySelectMultipleFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    oldWidget.controller?.removeListener(onControllerChange);

    if (oldWidget.controller == null && widget.controller != null) {
      _controller?.dispose();
      _controller = null;
    } else if (oldWidget.controller != null && widget.controller == null) {
      _controller = MySelectController<T>(initialValue: _fieldValueAsSet());
    }

    controller.addListener(onControllerChange);

    if (widget.controller != null) {
      onControllerChange();
    } else {
      _syncControllerWithValue();
    }
  }

  @override
  void didChange(Set<T>? value) {
    super.didChange(value);
    if (!_isSyncingController) {
      _syncControllerWithValue();
    }
  }

  void onControllerChange() {
    if (_isSyncingController) return;

    final controllerValue = controller.value.toSet();
    if (!_sameSelection(controllerValue, _fieldValueAsSet())) {
      didChange(controllerValue);
    }
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChange);
    _controller?.dispose();
    super.dispose();
  }

  Set<T> _fieldValueAsSet() => (value ?? <T>{}).toSet();

  void _syncControllerWithValue() {
    final nextValue = _fieldValueAsSet();
    if (_sameSelection(controller.value, nextValue)) return;

    _isSyncingController = true;
    controller.value = nextValue;
    _isSyncingController = false;
  }

  bool _sameSelection(Set<T> a, Set<T> b) {
    return identical(a, b) || (a.length == b.length && a.containsAll(b));
  }
}
