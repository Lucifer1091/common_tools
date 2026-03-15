import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

const kDefaultSelectMinWidth = 128.0;
const kDefaultSelectMaxHeight = 384.0;

/// Builder for the selected option widget in [MySelect].
typedef MySelectedOptionBuilder<T> =
    Widget Function(BuildContext context, T value);

/// Controls the selection state of a [MySelect] widget.
///
/// It extends [ValueNotifier] to provide reactive updates when the selected
/// values change.
class MySelectController<T> extends ValueNotifier<Set<T>> {
  MySelectController({Set<T>? initialValue}) : super(initialValue ?? {});
}

/// Defines the different variants of the [MySelect] widget.
enum MySelectVariant { primary, search, multiple, multipleWithSearch }

/// A customizable select dropdown widget with various variants and options.
///
/// It supports single and multiple selection, search functionality, and
/// extensive customization through various properties.
class MySelect<T> extends StatefulWidget {
  /// Creates a [MySelect] with the primary variant.
  const MySelect({
    required this.selectedOptionBuilder,
    super.key,
    this.options,
    this.optionsBuilder,
    this.popoverController,
    this.enabled = true,
    this.placeholder,
    this.placeholderStyle,
    this.initialValue,
    this.onChanged,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
    this.popoverReverseDuration,
    this.ensureSelectedVisible,
  }) : variant = MySelectVariant.primary,
       initialValues = const {},
       onSearchChanged = null,
       searchDivider = null,
       searchPlaceholder = null,
       searchInputLeading = null,
       onMultipleChanged = null,
       searchPadding = null,
       selectedOptionsBuilder = null,
       search = null,
       clearSearchOnClose = false,
       searchFocusNode = null,
       onSearchSubmitted = null,
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       );

  /// Creates a [MySelect] with the search variant.
  const MySelect.withSearch({
    required this.selectedOptionBuilder,
    super.key,
    this.options,
    this.optionsBuilder,
    this.onSearchChanged,
    this.onChanged,
    this.popoverController,
    this.searchDivider,
    this.searchInputLeading,
    this.searchPlaceholder,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose,
    this.enabled = true,
    this.placeholder,
    this.placeholderStyle,
    this.initialValue,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.closeOnSelect = true,
    this.allowDeselection = false,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
    this.popoverReverseDuration,
    this.ensureSelectedVisible,
    this.searchFocusNode,
    this.onSearchSubmitted,
  }) : variant = MySelectVariant.search,
       selectedOptionsBuilder = null,
       onMultipleChanged = null,
       initialValues = const {},
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       ),
       assert(
         search != null || onSearchChanged != null,
         'Either search or onSearchChanged must be provided',
       );

  /// Creates a [MySelect] with the multiple select variant.
  const MySelect.multiple({
    required this.selectedOptionsBuilder,
    super.key,
    this.options,
    this.optionsBuilder,
    this.popoverController,
    this.enabled = true,
    this.placeholder,
    this.placeholderStyle,
    this.initialValues = const {},
    ValueChanged<Set<T>>? onChanged,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = true,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
    this.popoverReverseDuration,
    this.ensureSelectedVisible,
  }) : variant = MySelectVariant.multiple,
       onSearchChanged = null,
       initialValue = null,
       selectedOptionBuilder = null,
       searchDivider = null,
       searchPlaceholder = null,
       searchInputLeading = null,
       searchPadding = null,
       search = null,
       clearSearchOnClose = false,
       onChanged = null,
       onMultipleChanged = onChanged,
       searchFocusNode = null,
       onSearchSubmitted = null,
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       );

  /// Creates a [MySelect] with the multiple select and search variant.
  const MySelect.multipleWithSearch({
    required this.selectedOptionsBuilder,
    super.key,
    this.options,
    this.optionsBuilder,
    this.onSearchChanged,
    ValueChanged<Set<T>>? onChanged,
    this.popoverController,
    this.searchDivider,
    this.searchInputLeading,
    this.searchPlaceholder,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose,
    this.enabled = true,
    this.placeholder,
    this.placeholderStyle,
    this.initialValues = const {},
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.allowDeselection = true,
    this.closeOnSelect = true,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
    this.popoverReverseDuration,
    this.ensureSelectedVisible,
    this.searchFocusNode,
    this.onSearchSubmitted,
  }) : variant = MySelectVariant.multipleWithSearch,
       selectedOptionBuilder = null,
       onChanged = null,
       onMultipleChanged = onChanged,
       initialValue = null,
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       ),
       assert(
         search != null || onSearchChanged != null,
         'Either search or onSearchChanged must be provided',
       );

  /// Creates a [MySelect] with a raw variant, allowing full customization.
  const MySelect.raw({
    required this.variant,
    super.key,
    this.options,
    this.optionsBuilder,
    this.selectedOptionBuilder,
    this.selectedOptionsBuilder,
    this.popoverController,
    this.onSearchChanged,
    this.searchDivider,
    this.searchInputLeading,
    this.searchPlaceholder,
    this.searchPadding,
    this.search,
    this.clearSearchOnClose,
    this.enabled = true,
    this.placeholder,
    this.placeholderStyle,
    this.initialValue,
    this.initialValues = const {},
    this.onChanged,
    this.onMultipleChanged,
    this.focusNode,
    this.closeOnTapOutside = true,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.decoration,
    this.trailing,
    this.padding,
    this.optionsPadding,
    this.showScrollToBottomChevron,
    this.showScrollToTopChevron,
    this.scrollController,
    this.anchor,
    this.shadows,
    this.filter,
    this.header,
    this.footer,
    this.allowDeselection = false,
    this.closeOnSelect = true,
    this.groupId,
    this.itemCount,
    this.shrinkWrap,
    this.controller,
    this.popoverReverseDuration,
    this.ensureSelectedVisible,
    this.searchFocusNode,
    this.onSearchSubmitted,
  }) : assert(
         variant == MySelectVariant.primary || onSearchChanged != null,
         'onSearchChanged must be provided when variant is search',
       ),
       assert(
         options != null || optionsBuilder != null,
         'Either options or optionsBuilder must be provided',
       ),
       assert(
         (selectedOptionBuilder != null) ^ (selectedOptionsBuilder != null),
         '''Either selectedOptionBuilder or selectedOptionsBuilder must be provided''',
       );

  /// {@template MySelect.controller}
  /// The controller of the [MySelect].
  /// {@endtemplate}
  final MySelectController<T>? controller;

  /// {@template MySelect.onChanged}
  /// The callback that is called when the value of the [MySelect] changes.
  ///
  /// This is used for single selection [MySelect] variants.
  /// {@endtemplate}
  final ValueChanged<T?>? onChanged;

  /// {@template MySelect.onMultipleChanged}
  /// The callback that is called when the values of the [MySelect] changes.
  /// Called only the variant is [MySelect.multiple].
  /// {@endtemplate}
  final ValueChanged<Set<T>>? onMultipleChanged;

  /// {@template MySelect.allowDeselection}
  /// Whether the [MySelect] allows deselection, defaults to
  /// `false`.
  /// {@endtemplate}
  final bool allowDeselection;

  /// {@template MySelect.enabled}
  /// Whether the [MySelect] is enabled.
  ///
  /// When disabled, the select cannot be interacted with and visually appears
  /// disabled. Defaults to `true`.
  /// {@endtemplate}
  final bool enabled;

  /// {@template MySelect.initialValue}
  /// The initially selected value for single select [MySelect] variants.
  ///
  /// Defaults to `null`.
  /// {@endtemplate}
  final T? initialValue;

  /// {@template MySelect.initialValues}
  /// The initial values of the [MySelect], defaults to `[]`.
  /// {@endtemplate}
  final Set<T> initialValues;

  /// {@template MySelect.placeholder}
  /// The widget to display as a placeholder when no option is selected.
  ///
  /// Typically a [Text] widget prompting the user to make a selection.
  /// {@endtemplate}
  final Widget? placeholder;

  /// {@template MySelect.placeholderStyle}
  /// The text style to apply by default to the placeholder widget.
  /// If the placeholder contains a [Text] widget, this style will be merged
  /// with its existing style.
  /// {@endtemplate}
  final TextStyle? placeholderStyle;

  /// {@template MySelect.selectedOptionBuilder}
  /// Builder function for rendering the currently selected option in single
  /// select [MySelect] variants.
  ///
  /// This function is called with the current [BuildContext] and the selected
  /// value of type `T`.
  /// {@endtemplate}
  final MySelectedOptionBuilder<T>? selectedOptionBuilder;

  /// {@template MySelect.selectedOptionsBuilder}
  /// Builder function for rendering the currently selected options in multiple
  /// select [MySelect] variants.
  ///
  /// This function is called with the current [BuildContext] and a list of
  /// selected values of type `T`.
  /// {@endtemplate}
  final MySelectedOptionBuilder<List<T>>? selectedOptionsBuilder;

  /// {@template MySelect.options}
  /// An iterable of widgets representing the selectable options.
  ///
  /// Use this for a small, static set of options. For larger or dynamic lists,
  /// consider using [optionsBuilder] for better performance.
  ///
  /// Each widget in this iterable should typically be a [MyOption] widget.
  /// {@endtemplate}
  final Iterable<Widget>? options;

  /// {@template MySelect.optionsBuilder}
  /// A builder function for creating options widgets on demand.
  ///
  /// This is efficient for large or dynamically generated lists of options, as
  /// it only builds options that are currently visible.
  ///
  /// The builder is called with the [BuildContext] and the index of the option
  /// to build. It should return a widget, typically a [MyOption].
  /// {@endtemplate}
  final Widget? Function(BuildContext, int)? optionsBuilder;

  /// {@template MySelect.focusNode}
  /// The focus node to control the focus state of the [MySelect].
  ///
  /// If null, a default [FocusNode] will be created internally.
  /// {@endtemplate}
  final FocusNode? focusNode;

  /// {@template MySelect.closeOnTapOutside}
  /// Whether to close the select popover when tapping outside of it.
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  final bool closeOnTapOutside;

  /// {@template MySelect.minWidth}
  /// The minimum width of the select input and popover.
  ///
  /// Defaults to `max(kDefaultSelectMinWidth, constraints.minWidth)`.
  /// The actual minimum width will be the maximum of this value and the
  /// intrinsic minimum width of the widget.
  /// {@endtemplate}
  final double? minWidth;

  /// {@template MySelect.maxWidth}
  /// The maximum width of the select input and popover.
  ///
  /// Defaults to `double.infinity`.
  /// {@endtemplate}
  final double? maxWidth;

  /// {@template MySelect.maxHeight}
  /// The maximum height of the select popover.
  ///
  /// Defaults to `kDefaultSelectMaxHeight`.
  /// {@endtemplate}
  final double? maxHeight;

  /// {@template MySelect.decoration}
  /// The visual decoration of the select input.
  ///
  /// Uses [MyDecoration] to define borders, colors, and more.
  /// {@endtemplate}
  final MyDecoration? decoration;

  /// {@template MySelect.trailing}
  /// The widget to display at the end of the select input, typically an icon.
  ///
  /// Defaults to a chevron-down icon.
  /// {@endtemplate}
  final Widget? trailing;

  /// {@template MySelect.padding}
  /// The padding around the content of the select input.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template MySelect.optionsPadding}
  /// The padding around the options within the popover.
  ///
  /// Defaults to `EdgeInsets.all(4)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? optionsPadding;

  /// {@template MySelect.showScrollToTopChevron}
  /// Whether to display a chevron icon at the top of the popover when
  /// scrollable. Defaults to `true`.
  /// {@endtemplate}
  final bool? showScrollToTopChevron;

  /// {@template MySelect.showScrollToBottomChevron}
  /// Whether to display a chevron icon at the bottom of the popover when
  /// scrollable. Defaults to `true`.
  /// {@endtemplate}
  final bool? showScrollToBottomChevron;

  /// {@template MySelect.scrollController}
  /// The scroll controller for the options list in the popover.
  ///
  /// If null, a default [ScrollController] will be created internally.
  /// {@endtemplate}
  final ScrollController? scrollController;

  /// {@template MySelect.anchor}
  /// The anchor configuration for positioning the popover relative to the
  /// select input.
  ///
  /// Defaults to `MyAnchorAuto(offset: Offset(0, 4))`
  /// {@endtemplate}
  final MyAnchorBase? anchor;

  /// {@template MySelect.variant}
  /// The variant of the [MySelect] widget, determining its behavior and
  /// appearance.
  ///
  /// See [MySelectVariant] for available variants.
  /// Defaults to [MySelectVariant.primary] for the default constructor.
  /// {@endtemplate}
  final MySelectVariant variant;

  /// {@template MySelect.onSearchChanged}
  /// Callback function invoked when the search query changes in search-enabled
  /// [MySelect] variants.
  ///
  /// Provides the current search string as an argument.
  /// {@endtemplate}
  final ValueChanged<String>? onSearchChanged;

  /// {@template MySelect.searchDivider}
  /// Widget to display as a divider between the search input and the options
  /// list
  /// in search-enabled [MySelect] variants.
  ///
  /// Defaults to a Divider with height 1.
  /// {@endtemplate}
  final Widget? searchDivider;

  /// {@template MySelect.searchInputLeading}
  /// Widget to display at the leading edge of the search input field.
  ///
  /// Typically an icon, like a search icon.
  /// {@endtemplate}
  final Widget? searchInputLeading;

  /// {@template MySelect.searchPlaceholder}
  /// Placeholder text to display in the search input field when no query is
  /// entered.
  /// {@endtemplate}
  final String? searchPlaceholder;

  /// {@template MySelect.searchPadding}
  /// Padding around the search input field.
  ///
  /// Defaults to `EdgeInsets.all(12)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? searchPadding;

  /// {@template MySelect.search}
  /// A completely customizable search input widget.
  ///
  /// If provided, this widget will be used instead of the default [MyInput]
  /// for search functionality.
  /// {@endtemplate}
  final Widget? search;

  /// {@template MySelect.clearSearchOnClose}
  /// Whether to clear the search input when the popover is closed.
  ///
  /// Defaults to `true`. Can be overridden by `MyThemeData.selectTheme`.
  /// {@endtemplate}
  final bool? clearSearchOnClose;

  /// {@macro MyPopover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro MyPopover.filter}
  final ImageFilter? filter;

  /// {@template MySelect.popoverController}
  /// Controller for managing the visibility and behavior of the popover.
  ///
  /// If null, a default [MyPopoverController] is created internally.
  /// {@endtemplate}
  final MyPopoverController? popoverController;

  /// {@template MySelect.header}
  /// Widget to display at the top of the popover, above the options list.
  ///
  /// Useful for titles or additional information.
  /// {@endtemplate}
  final Widget? header;

  /// {@template MySelect.footer}
  /// Widget to display at the bottom of the popover, below the options list.
  ///
  /// Useful for actions or additional information.
  /// {@endtemplate}
  final Widget? footer;

  /// {@template MySelect.closeOnSelect}
  /// Whether to automatically close the popover when an option is selected.
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  final bool closeOnSelect;

  /// {@template MySelect.groupId}
  /// Group ID for the popover, used for managing popover visibility in groups.
  ///
  /// See [MyPopover.groupId] for more details.
  /// {@endtemplate}
  final Object? groupId;

  /// {@template MySelect.itemCount}
  /// The number of items to display when using [optionsBuilder].
  ///
  /// Required when using [optionsBuilder] to determine the scrollable extent.
  /// {@endtemplate}
  final int? itemCount;

  /// {@template MySelect.shrinkWrap}
  /// Whether the options list should shrink-wrap its content.
  ///
  /// Defaults to `false`. Set to `true` for smaller lists to reduce popover
  /// size.
  /// {@endtemplate}
  final bool? shrinkWrap;

  /// {@template MySelect.popoverReverseDuration}
  /// The duration of the popover's exit animation.
  ///
  /// Defaults to [Duration.zero ].
  /// {@endtemplate}
  final Duration? popoverReverseDuration;

  /// {@template MySelect.ensureSelectedVisible}
  /// Whether to automatically scroll the options list to ensure the selected
  /// option is visible when the popover opens.
  /// Defaults to true if the variant is [MySelectVariant.primary] or
  /// [MySelectVariant.search], false otherwise.
  /// {@endtemplate}
  final bool? ensureSelectedVisible;

  /// {@template MySelect.searchFocusNode}
  /// Focus node for the search input field in search-enabled variants.
  /// If null, a default [FocusNode] will be created internally.
  /// {@endtemplate}
  final FocusNode? searchFocusNode;

  /// {@template MySelect.onSearchSubmitted}
  /// Callback function invoked when the search query is submitted in
  /// search-enabled
  /// [MySelect] variants.
  /// Provides the current search string as an argument.
  /// {@endtemplate}
  final ValueChanged<String>? onSearchSubmitted;

  @override
  MySelectState<T> createState() => MySelectState();
}

class MySelectState<T> extends State<MySelect<T>> {
  FocusNode? internalFocusNode;
  FocusNode? _internalSearchFocusNode;

  // ignore: use_late_for_private_fields_and_variables
  MySelectController<T>? _controller;

  MySelectController<T> get controller => widget.controller ?? _controller!;

  MyPopoverController? _popoverController;

  MyPopoverController get popoverController =>
      widget.popoverController ??
      (_popoverController ??= MyPopoverController());

  ScrollController? _scrollController;

  final showScrollToBottom = ValueNotifier(false);
  final showScrollToTop = ValueNotifier(false);
  bool shouldAnimateToTop = false;
  bool shouldAnimateToBottom = false;

  FocusNode get focusNode => widget.focusNode ?? internalFocusNode!;
  FocusNode get searchFocusNode =>
      widget.searchFocusNode ?? (_internalSearchFocusNode ??= FocusNode());

  ScrollController get scrollController =>
      widget.scrollController ?? _scrollController!;

  bool get ensureSelectedVisible =>
      widget.ensureSelectedVisible ??
      (widget.variant == MySelectVariant.primary ||
          widget.variant == MySelectVariant.search);

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = MySelectController<T>(
        initialValue: {
          if (widget.initialValue is T) widget.initialValue as T,
          ...widget.initialValues,
        },
      );
    }

    if (widget.scrollController == null) {
      _scrollController = ScrollController();
    }
    if (widget.focusNode == null) internalFocusNode = FocusNode();

    // react to the scroll position
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;
      showScrollToBottom.value =
          scrollController.offset < scrollController.position.maxScrollExtent;
      showScrollToTop.value = scrollController.offset > 0;
    });

    final hasSearch =
        widget.variant == MySelectVariant.search ||
        widget.variant == MySelectVariant.multipleWithSearch;
    if (hasSearch) {
      popoverController.addListener(() {
        if (popoverController.isOpen) return;
        final effectiveClearSearchOnClose = widget.clearSearchOnClose ?? true;

        if (effectiveClearSearchOnClose) {
          widget.onSearchChanged?.call('');
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant MySelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      if (widget.initialValue is T) {
        controller.value
          ..clear()
          ..add(widget.initialValue as T);
      }
    }
    if (widget.initialValues != oldWidget.initialValues) {
      controller.value
        ..clear()
        ..addAll(widget.initialValues);
    }
  }

  @override
  void dispose() {
    _internalSearchFocusNode?.dispose();
    _popoverController?.dispose();
    internalFocusNode?.dispose();
    _scrollController?.dispose();
    showScrollToBottom.dispose();
    showScrollToTop.dispose();
    super.dispose();
  }

  Future<void> animateToTop() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    while (shouldAnimateToTop) {
      shouldAnimateToTop = scrollController.offset > 0;
      await scrollController.animateTo(
        max(scrollController.offset - 30, 0),
        duration: const Duration(milliseconds: 20),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> animateToBottom() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    while (shouldAnimateToBottom) {
      shouldAnimateToBottom =
          scrollController.offset < scrollController.position.maxScrollExtent;
      await scrollController.animateTo(
        min(
          scrollController.offset + 30,
          scrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 20),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void select(T value) {
    final isMultiSelection =
        widget.variant == MySelectVariant.multiple ||
        widget.variant == MySelectVariant.multipleWithSearch;

    final prevSelection = controller.value.toSet();
    if (widget.closeOnSelect) popoverController.hide();
    setState(() {
      if (!isMultiSelection) controller.value.clear();
      if (widget.allowDeselection && prevSelection.contains(value)) {
        controller.value.remove(value);
      } else {
        controller.value.add(value);
      }
    });

    final nextSelection = controller.value.toSet();
    final selectionChanged =
        prevSelection.length != nextSelection.length ||
        !prevSelection.containsAll(nextSelection);

    if (widget.closeOnSelect) {
      focusNode.requestFocus();
    }

    if (selectionChanged) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      controller.notifyListeners();
      if (isMultiSelection) {
        widget.onMultipleChanged?.call(controller.value.toSet());
      } else {
        widget.onChanged?.call(controller.value.firstOrNull);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    final effectiveDecoration = MyDecoration(
      border: MyBorder.all(
        radius: MyBorderRadius.medium,
        color: context.colorScheme.input,
        width: 1,
      ),
    ).merge(widget.decoration);

    final decorationHorizontalPadding =
        (effectiveDecoration.border?.padding?.horizontal ?? 0.0) +
        (effectiveDecoration.secondaryBorder?.padding?.horizontal ?? 0.0);

    final effectivePadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    final effectiveShowScrollToTopChevron =
        widget.showScrollToTopChevron ?? true;

    final effectiveShowScrollToBottomChevron =
        widget.showScrollToBottomChevron ?? true;

    final effectivePopoverReverseDuration =
        widget.popoverReverseDuration ?? Duration.zero;

    final effectiveAnchor =
        widget.anchor ?? const MyAnchorAuto(offset: Offset(0, 4));

    final effectiveMyows = widget.shadows;

    final effectiveFilter = widget.filter;

    final isMultiSelect = widget.selectedOptionsBuilder != null;

    // make effectiveText listen to controller changes
    final effectiveText = ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final Widget result;
        final TextStyle resultDefaultTextStyle;

        if (controller.value.isNotEmpty) {
          resultDefaultTextStyle = context.bodyMedium.copyWith(
            color: theme.colorScheme.foreground,
          );
          switch (isMultiSelect) {
            case true:
              result = widget.selectedOptionsBuilder!(
                context,
                controller.value.toList(),
              );
            case false:
              result = widget.selectedOptionBuilder!(
                context,
                controller.value.first,
              );
          }
        } else {
          assert(
            widget.placeholder != null,
            'placeholder must not be null when value is null',
          );
          resultDefaultTextStyle =
              widget.placeholderStyle ??
              context.bodyMedium.copyWith(color: theme.colorScheme.foreground);
          result = widget.placeholder!;
        }
        return DefaultTextStyle(style: resultDefaultTextStyle, child: result);
      },
    );

    final effectiveTrailing =
        widget.trailing ??
        Icon(
          LucideIcons.chevronDown,
          size: 16,
          color: theme.colorScheme.popoverForeground.withValues(alpha: .5),
        );

    final effectiveMinWidth = widget.minWidth ?? kDefaultSelectMinWidth;
    final effectiveMaxWidth = widget.maxWidth ?? double.infinity;
    final effectiveMaxHeight = widget.maxHeight ?? kDefaultSelectMaxHeight;
    final effectiveOptionsPadding =
        widget.optionsPadding ?? const EdgeInsets.all(4);

    final search = switch (widget.variant) {
      MySelectVariant.primary || MySelectVariant.multiple => null,
      MySelectVariant.search || MySelectVariant.multipleWithSearch => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.search ??
              MyInput(
                focusNode: searchFocusNode,
                leading: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    LucideIcons.search,
                    size: 16,
                    color: theme.colorScheme.popoverForeground,
                  ),
                ),
                // padding:
                //     widget.searchPadding ??
                //     const EdgeInsets.all(12),
                placeholder: widget.searchPlaceholder,
                decoration: MyDecoration.none,
                onChanged: widget.onSearchChanged,
                onSubmitted: widget.onSearchSubmitted,
              ),
          widget.searchDivider ?? const MyDivider(margin: EdgeInsets.zero),
        ],
      ),
    };

    return ListenableBuilder(
      listenable: searchFocusNode,
      builder: (context, child) {
        return CallbackShortcuts(
          bindings:
              searchFocusNode.hasFocus
                  ? const {}
                  : {
                    const SingleActivator(LogicalKeyboardKey.enter):
                        popoverController.toggle,
                    const SingleActivator(LogicalKeyboardKey.space):
                        popoverController.toggle,
                    const SingleActivator(LogicalKeyboardKey.escape):
                        popoverController.hide,
                  },
          child: child!,
        );
      },
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final calculatedMinWidth =
                max(effectiveMinWidth, constraints.minWidth) -
                decorationHorizontalPadding;

            final effectiveConstraints = BoxConstraints(
              minWidth: calculatedMinWidth,
              maxWidth: effectiveMaxWidth,
            );

            late final Widget effectiveChild;

            if (widget.options != null) {
              effectiveChild = SingleChildScrollView(
                padding: effectiveOptionsPadding,
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: widget.options!.toList(),
                ),
              );
            } else {
              effectiveChild = ListView.builder(
                padding: effectiveOptionsPadding,
                controller: scrollController,
                itemCount: widget.itemCount,
                shrinkWrap: widget.shrinkWrap ?? false,
                itemBuilder: (context, index) {
                  return widget.optionsBuilder?.call(context, index);
                },
              );
            }

            final Widget select = MyDisabled(
              disabled: !widget.enabled,
              child: MyFocusable(
                params: MyFocusableParams(
                  canRequestFocus: widget.enabled,
                  focusNode: focusNode,
                ),
                builder: (context, focused, child) {
                  return MyDecorator(
                    focused: focused,
                    decoration: effectiveDecoration,
                    child: child,
                  );
                },
                child: MyGestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    popoverController.toggle();
                  },
                  child: ConstrainedBox(
                    constraints: effectiveConstraints,
                    child: Padding(
                      padding: effectivePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: effectiveText),
                          effectiveTrailing,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );

            final scrollToTopChild =
                effectiveShowScrollToTopChevron
                    ? ValueListenableBuilder(
                      valueListenable: showScrollToTop,
                      builder: (context, show, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child:
                              show
                                  ? MouseRegion(
                                    onEnter: (_) {
                                      shouldAnimateToTop = true;
                                      unawaited(animateToTop());
                                    },
                                    onExit: (_) => shouldAnimateToTop = false,
                                    child: Container(
                                      width: calculatedMinWidth,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Icon(
                                        LucideIcons.chevronUp,
                                        size: 16,
                                        color:
                                            theme.colorScheme.popoverForeground,
                                      ),
                                    ),
                                  )
                                  : const SizedBox(),
                        );
                      },
                    )
                    : null;

            final scrollToBottomChild =
                effectiveShowScrollToBottomChevron
                    ? ValueListenableBuilder(
                      valueListenable: showScrollToBottom,
                      builder: (context, show, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child:
                              show
                                  ? MouseRegion(
                                    onEnter: (_) {
                                      shouldAnimateToBottom = true;
                                      unawaited(animateToBottom());
                                    },
                                    onExit:
                                        (_) => shouldAnimateToBottom = false,
                                    child: Container(
                                      width: calculatedMinWidth,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Icon(
                                        LucideIcons.chevronDown,
                                        size: 16,
                                        color:
                                            theme.colorScheme.popoverForeground,
                                      ),
                                    ),
                                  )
                                  : const SizedBox(),
                        );
                      },
                    )
                    : null;

            return MyProvider(
              data: this as MySelectState<dynamic>,
              notifyUpdate: (_) => true,
              child: MyPopover(
                groupId: widget.groupId,
                padding: EdgeInsets.zero,
                controller: popoverController,
                anchor: effectiveAnchor,
                closeOnTapOutside: widget.closeOnTapOutside,
                reverseDuration: effectivePopoverReverseDuration,
                shadows: effectiveMyows,
                filter: effectiveFilter,
                popover: (_) {
                  // set the initial value for showScrollToBottom and
                  // showScrollToTop, after the popover is rendered
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if (scrollController.hasClients) {
                      showScrollToBottom.value =
                          scrollController.offset <
                          scrollController.position.maxScrollExtent;
                      showScrollToTop.value = scrollController.offset > 0;
                    }
                  });

                  Widget effectiveColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (search != null)
                        Flexible(
                          child: ConstrainedBox(
                            constraints: effectiveConstraints,
                            child: search,
                          ),
                        ),
                      if (widget.header != null)
                        Flexible(
                          child: ConstrainedBox(
                            constraints: effectiveConstraints,
                            child: widget.header,
                          ),
                        ),
                      if (scrollToTopChild != null) scrollToTopChild,
                      Flexible(
                        child: ConstrainedBox(
                          constraints: effectiveConstraints,
                          child: effectiveChild,
                        ),
                      ),
                      if (scrollToBottomChild != null) scrollToBottomChild,
                      if (widget.footer != null)
                        Flexible(
                          child: ConstrainedBox(
                            constraints: effectiveConstraints,
                            child: widget.footer,
                          ),
                        ),
                    ],
                  );

                  if (widget.optionsBuilder == null) {
                    effectiveColumn = IntrinsicWidth(child: effectiveColumn);
                  }

                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: effectiveMaxHeight,
                      minWidth: calculatedMinWidth,
                      maxWidth: effectiveMaxWidth,
                    ),
                    child: effectiveColumn,
                  );
                },
                child: select,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyOption<T> extends StatefulWidget {
  const MyOption({
    required this.value,
    required this.child,
    super.key,
    this.hoveredBackgroundColor,
    this.padding,
    this.selectedIcon,
    this.radius,
    this.direction,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.textStyle,
    this.selectedTextStyle,
  });

  /// The value of the [MyOption], it must be unique above the options.
  final T value;

  /// The child widget.
  final Widget child;

  /// The background color of the [MyOption] when hovered, defaults to
  /// `MyThemeData.accent`.
  final Color? hoveredBackgroundColor;

  /// The padding of the [MyOption], defaults to
  /// `EdgeInsets.symmetric(horizontal: 8, vertical: 6)`
  final EdgeInsetsGeometry? padding;

  /// The icon of the [MyOption] when selected.
  final Widget? selectedIcon;

  /// The radius of the [MyOption], defaults to `MyThemeData.radius`.
  final BorderRadius? radius;

  /// The background color of the [MyOption], defaults to
  /// `MyThemeData.optionTheme.backgroundColor`.
  final Color? backgroundColor;

  /// The background color of the [MyOption] when selected, defaults to
  /// `MyThemeData.optionTheme.selectedBackgroundColor`.
  final Color? selectedBackgroundColor;

  /// The text style of the [MyOption], defaults to
  /// `MyThemeData.optionTheme.textStyle`.
  final TextStyle? textStyle;

  /// The text style of the [MyOption] when selected, defaults to
  /// `MyThemeData.optionTheme.selectedTextStyle`.
  final TextStyle? selectedTextStyle;

  /// {@template MyOption.direction}
  /// The direction of the ambient.
  /// {@endtemplate}
  final TextDirection? direction;

  @override
  State<MyOption<T>> createState() => _MyOptionState<T>();
}

class _MyOptionState<T> extends State<MyOption<T>> {
  final hovered = ValueNotifier(false);
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    final inherited =
        context.read<MySelectState<dynamic>>() as MySelectState<T>;
    final selected = inherited.controller.value.contains(widget.value);
    if (selected && inherited.ensureSelectedVisible) {
      focusNode.requestFocus();
      // scroll to the selected option
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(
          Scrollable.maybeOf(
            context,
          )?.position.ensureVisible(context.findRenderObject()!),
        );
      });
    }
  }

  @override
  void dispose() {
    focusNode
      ..removeListener(onFocusChange)
      ..dispose();
    hovered.dispose();
    super.dispose();
  }

  void onFocusChange() {
    hovered.value = focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final inheritedSelect =
        context.watch<MySelectState<dynamic>>() as MySelectState<T>;
    final selected = inheritedSelect.controller.value.contains(widget.value);

    final effectiveHoveredBackgroundColor = theme.colorScheme.accent;

    final effectivePadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 8, vertical: 6);

    final effectiveTextStyle =
        widget.textStyle ??
        context.bodyMedium.copyWith(color: theme.colorScheme.popoverForeground);

    final effectiveSelectedTextStyle =
        widget.selectedTextStyle ??
        context.bodyMedium.copyWith(color: theme.colorScheme.popoverForeground);

    final effectiveSelectedBackgroundColor = widget.selectedBackgroundColor;

    final effectiveBackgroundColor = widget.backgroundColor;

    final effectiveRadius = widget.radius ?? MyBorderRadius.small;

    final effectiveSelectedIcon = Visibility.maintain(
      visible: selected,
      child:
          widget.selectedIcon ??
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              LucideIcons.check,
              size: 16,
              color: theme.colorScheme.popoverForeground,
            ),
          ),
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () {
          inheritedSelect.select(widget.value);
        },
      },
      child: Focus(
        focusNode: focusNode,
        child: MyGestureDetector(
          behavior: HitTestBehavior.opaque,
          onHover: (value) {
            hovered.value = value;
          },
          onTap: () => inheritedSelect.select(widget.value),
          child: ValueListenableBuilder(
            valueListenable: hovered,
            builder: (context, hovered, child) {
              final resolvedBackgroundColor =
                  hovered
                      ? effectiveHoveredBackgroundColor
                      : selected
                      ? effectiveSelectedBackgroundColor
                      : effectiveBackgroundColor;

              return Container(
                padding: effectivePadding,
                decoration: BoxDecoration(
                  color: resolvedBackgroundColor,
                  borderRadius: effectiveRadius,
                ),
                child: child,
              );
            },
            child: Row(
              textDirection: widget.direction,
              children: [
                effectiveSelectedIcon,
                Expanded(
                  child: DefaultTextStyle(
                    style:
                        selected
                            ? effectiveSelectedTextStyle
                            : effectiveTextStyle,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
