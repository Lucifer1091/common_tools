import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../common/my_decoration.dart';
import '../../common/my_gesture_detector.dart';
import '../../common/portal.dart';
import '../popover/popover.dart';
import 'my_input.dart';

typedef MyAutoCompleteCompleter = String Function(String suggestion);
typedef MyAutoCompleteFilter = bool Function(String option, String query);
typedef MyAutoCompleteItemBuilder =
    Widget Function(BuildContext context, String suggestion, bool highlighted);

String _identityCompleter(String suggestion) => suggestion;

bool _containsFilter(String option, String query) {
  return option.toLowerCase().contains(query.toLowerCase());
}

bool _isWhitespace(String value) => RegExp(r'\s').hasMatch(value);

/// Returns the active selection or the whitespace-delimited word at the caret.
TextRange? currentWordRange(TextEditingValue value) {
  final selection = value.selection;
  if (!selection.isValid) return null;
  if (!selection.isCollapsed) {
    return TextRange(start: selection.start, end: selection.end);
  }

  final text = value.text;
  final caret = selection.extentOffset;
  if (caret < 0 || caret > text.length) return null;

  var start = caret;
  while (start > 0 && !_isWhitespace(text.substring(start - 1, start))) {
    start--;
  }

  var end = caret;
  while (end < text.length && !_isWhitespace(text.substring(end, end + 1))) {
    end++;
  }

  return TextRange(start: start, end: end);
}

extension MyAutoCompleteTextEditingController on TextEditingController {
  /// The selected text or whitespace-delimited word around the caret.
  String? get currentWord {
    final range = currentWordRange(value);
    if (range == null || range.isCollapsed) return null;
    return text.substring(range.start, range.end);
  }
}

enum MyAutoCompleteMode { append, replaceWord, replaceAll }

class MyAutoCompleteIntent extends Intent {
  const MyAutoCompleteIntent(this.suggestion, this.mode);

  final String suggestion;
  final MyAutoCompleteMode mode;
}

/// Adds autocomplete suggestions to a compatible text input child.
///
/// [MyInput] handles [MyAutoCompleteIntent] automatically. When [controller]
/// is supplied, it must be the same controller used by the child.
class MyAutoComplete extends StatefulWidget {
  const MyAutoComplete({
    required this.suggestions,
    required this.child,
    super.key,
    this.controller,
    this.mode = MyAutoCompleteMode.replaceWord,
    this.completer = _identityCompleter,
    this.onSelected,
    this.popoverConstraints = const BoxConstraints(maxHeight: 300),
    this.matchInputWidth = true,
    this.anchor = const MyAnchorAuto(offset: Offset(0, 4)),
    this.popoverPadding = const EdgeInsets.all(4),
    this.popoverDecoration,
    this.shadows,
    this.filter,
    this.reverseDuration,
    this.itemBuilder,
    this.optionPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.highlightedBackgroundColor,
    this.closeOnTapOutside = true,
    this.scrollController,
  }) : options = const [],
       _usesInternalFiltering = false,
       suggestionFilter = null;

  MyAutoComplete.filtered({
    required this.options,
    required this.controller,
    required this.child,
    super.key,
    this.suggestionFilter,
    this.mode = MyAutoCompleteMode.replaceWord,
    this.completer = _identityCompleter,
    this.onSelected,
    this.popoverConstraints = const BoxConstraints(maxHeight: 300),
    this.matchInputWidth = true,
    this.anchor = const MyAnchorAuto(offset: Offset(0, 4)),
    this.popoverPadding = const EdgeInsets.all(4),
    this.popoverDecoration,
    this.shadows,
    this.filter,
    this.reverseDuration,
    this.itemBuilder,
    this.optionPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.highlightedBackgroundColor,
    this.closeOnTapOutside = true,
    this.scrollController,
  }) : assert(controller != null),
       assert(
         child is! MyInput || child.controller == controller,
         'MyAutoComplete.filtered and its MyInput child must use the same '
         'TextEditingController.',
       ),
       suggestions = const [],
       _usesInternalFiltering = true;

  /// Externally filtered suggestions displayed by the default constructor.
  final List<String> suggestions;

  /// Complete local option list used by [MyAutoComplete.filtered].
  final List<String> options;

  /// Controller observed for edits and built-in filtering.
  final TextEditingController? controller;

  final Widget child;
  final MyAutoCompleteFilter? suggestionFilter;
  final MyAutoCompleteMode mode;
  final MyAutoCompleteCompleter completer;
  final ValueChanged<String>? onSelected;
  final BoxConstraints popoverConstraints;
  final bool matchInputWidth;
  final MyAnchorBase anchor;
  final EdgeInsetsGeometry popoverPadding;
  final MyDecoration? popoverDecoration;
  final List<BoxShadow>? shadows;
  final ImageFilter? filter;
  final Duration? reverseDuration;
  final MyAutoCompleteItemBuilder? itemBuilder;
  final EdgeInsetsGeometry optionPadding;
  final Color? highlightedBackgroundColor;
  final bool closeOnTapOutside;
  final ScrollController? scrollController;
  final bool _usesInternalFiltering;

  @override
  State<MyAutoComplete> createState() => _MyAutoCompleteState();
}

class _MyAutoCompleteState extends State<MyAutoComplete> {
  final MyPopoverController _popoverController = MyPopoverController();
  final Map<(int, String), GlobalKey> _itemKeys = {};
  ScrollController? _scrollController;
  late List<String> _visibleSuggestions;
  var _highlightedIndex = -1;
  var _hasFocus = false;
  var _suppressControllerReopen = false;
  var _suppressSuggestionReopen = false;

  ScrollController get _effectiveScrollController =>
      widget.scrollController ?? (_scrollController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _visibleSuggestions = _resolveSuggestions();
    widget.controller?.addListener(_handleControllerChanged);
    _popoverController.addListener(_handlePopoverChanged);
    FocusManager.instance.addListener(_handlePrimaryFocusChanged);
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _handlePrimaryFocusChanged();
    });
  }

  @override
  void didUpdateWidget(covariant MyAutoComplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
    }
    if (oldWidget.scrollController != widget.scrollController) {
      _scrollController?.dispose();
      _scrollController = null;
    }

    final allowOpen = !_suppressSuggestionReopen;
    _suppressSuggestionReopen = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _refreshSuggestions(allowOpen: allowOpen);
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    FocusManager.instance.removeListener(_handlePrimaryFocusChanged);
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _popoverController
      ..removeListener(_handlePopoverChanged)
      ..dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  List<String> _resolveSuggestions() {
    if (!widget._usesInternalFiltering) {
      return List<String>.of(widget.suggestions);
    }

    final query = widget.controller?.currentWord;
    if (query == null || query.isEmpty) return const [];
    final suggestionFilter = widget.suggestionFilter ?? _containsFilter;
    return widget.options
        .where((option) => suggestionFilter(option, query))
        .toList(growable: false);
  }

  void _handleControllerChanged() {
    final allowOpen = !_suppressControllerReopen;
    _suppressControllerReopen = false;
    _refreshSuggestions(allowOpen: allowOpen);
  }

  void _handlePopoverChanged() {
    if (mounted) setState(() {});
  }

  void _refreshSuggestions({required bool allowOpen}) {
    final next = _resolveSuggestions();
    if (!listEquals(next, _visibleSuggestions)) {
      setState(() {
        _visibleSuggestions = next;
        _highlightedIndex = -1;
        _itemKeys.clear();
      });
    }
    _syncPopover(allowOpen: allowOpen);
  }

  void _syncPopover({required bool allowOpen}) {
    final shouldOpen = _hasFocus && _visibleSuggestions.isNotEmpty;
    if (!shouldOpen) {
      _popoverController.hide();
    } else if (allowOpen) {
      _popoverController.show();
    }
  }

  void _handlePrimaryFocusChanged() {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    var focused = focusedContext == context;
    focusedContext?.visitAncestorElements((ancestor) {
      focused = ancestor == context;
      return !focused;
    });

    if (_hasFocus == focused) return;
    setState(() => _hasFocus = focused);
    if (focused) {
      _refreshSuggestions(allowOpen: true);
    } else {
      _popoverController.hide();
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent || !_hasFocus || !_popoverController.isOpen) {
      return false;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _navigate(1);
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _navigate(-1);
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _popoverController.hide();
      return true;
    }
    if (_highlightedIndex != -1 &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.tab)) {
      _select(_highlightedIndex);
      return true;
    }
    return false;
  }

  void _navigate(int direction) {
    if (_visibleSuggestions.isEmpty) return;
    if (!_popoverController.isOpen) {
      _popoverController.show();
    }
    setState(() {
      if (_highlightedIndex == -1) {
        _highlightedIndex = direction > 0 ? 0 : _visibleSuggestions.length - 1;
      } else {
        _highlightedIndex =
            (_highlightedIndex + direction) % _visibleSuggestions.length;
      }
    });
    _scrollToHighlightedItem();
  }

  void _scrollToHighlightedItem() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _highlightedIndex < 0) return;
      final controller = _effectiveScrollController;
      if (!controller.hasClients) return;

      final itemContext =
          _itemKeys[(_highlightedIndex, _visibleSuggestions[_highlightedIndex])]
              ?.currentContext;
      if (itemContext != null) {
        unawaited(
          Scrollable.ensureVisible(
            itemContext,
            duration: const Duration(milliseconds: 80),
          ),
        );
        return;
      }

      final maxScrollExtent = controller.position.maxScrollExtent;
      final fraction = _visibleSuggestions.length == 1
          ? 0.0
          : _highlightedIndex / (_visibleSuggestions.length - 1);
      controller.jumpTo(maxScrollExtent * fraction);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final builtContext =
            _itemKeys[(
                  _highlightedIndex,
                  _visibleSuggestions[_highlightedIndex],
                )]
                ?.currentContext;
        if (builtContext != null) {
          unawaited(
            Scrollable.ensureVisible(
              builtContext,
              duration: const Duration(milliseconds: 80),
            ),
          );
        }
      });
    });
  }

  void _select(int index) {
    if (index < 0 || index >= _visibleSuggestions.length) return;
    final suggestion = _visibleSuggestions[index];
    final completedSuggestion = widget.completer(suggestion);
    _suppressControllerReopen = true;
    _suppressSuggestionReopen = true;
    _popoverController.hide();

    final focusedContext = FocusManager.instance.primaryFocus?.context;
    if (focusedContext != null) {
      Actions.maybeInvoke(
        focusedContext,
        MyAutoCompleteIntent(completedSuggestion, widget.mode),
      );
    }
    widget.onSelected?.call(suggestion);
  }

  BoxConstraints _resolvedPopoverConstraints(BoxConstraints fieldConstraints) {
    if (!widget.matchInputWidth || !fieldConstraints.hasBoundedWidth) {
      return widget.popoverConstraints;
    }
    final width = widget.popoverConstraints.constrainWidth(
      fieldConstraints.maxWidth,
    );
    return widget.popoverConstraints.copyWith(minWidth: width, maxWidth: width);
  }

  Widget _buildDefaultItem(
    BuildContext context,
    String suggestion,
    bool highlighted,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: widget.optionPadding,
      decoration: BoxDecoration(
        color: highlighted
            ? widget.highlightedBackgroundColor ?? context.colorScheme.accent
            : null,
        borderRadius: MyBorderRadius.small,
      ),
      child: Text(
        suggestion,
        textAlign: .start,
        style: context.bodyMedium.copyWith(
          color: context.colorScheme.popoverForeground,
        ),
      ),
    );
  }

  Widget _buildPopover(BuildContext context, BoxConstraints constraints) {
    return TextFieldTapRegion(
      key: const ValueKey<String>('my_auto_complete.popover'),
      child: ConstrainedBox(
        constraints: _resolvedPopoverConstraints(constraints),
        child: Padding(
          padding: widget.popoverPadding,
          child: ListView.builder(
            controller: _effectiveScrollController,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _visibleSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _visibleSuggestions[index];
              final highlighted = index == _highlightedIndex;
              return _MyAutoCompleteItem(
                key: _itemKeys.putIfAbsent(
                  (index, suggestion),
                  () => GlobalKey(
                    debugLabel: 'my_auto_complete.$index.$suggestion',
                  ),
                ),
                highlighted: highlighted,
                onHover: () {
                  if (_highlightedIndex != index) {
                    setState(() => _highlightedIndex = index);
                  }
                },
                onSelected: () => _select(index),
                child:
                    widget.itemBuilder?.call(
                      context,
                      suggestion,
                      highlighted,
                    ) ??
                    _buildDefaultItem(context, suggestion, highlighted),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MyPopover(
          controller: _popoverController,
          requestFocusOnOpen: false,
          closeOnTapOutside: widget.closeOnTapOutside,
          anchor: widget.anchor,
          padding: EdgeInsets.zero,
          decoration: widget.popoverDecoration,
          shadows: widget.shadows,
          filter: widget.filter,
          reverseDuration: widget.reverseDuration,
          popover: (context) => _buildPopover(context, constraints),
          child: widget.child,
        );
      },
    );
  }
}

class _MyAutoCompleteItem extends StatefulWidget {
  const _MyAutoCompleteItem({
    required this.highlighted,
    required this.onHover,
    required this.onSelected,
    required this.child,
    super.key,
  });

  final bool highlighted;
  final VoidCallback onHover;
  final VoidCallback onSelected;
  final Widget child;

  @override
  State<_MyAutoCompleteItem> createState() => _MyAutoCompleteItemState();
}

class _MyAutoCompleteItemState extends State<_MyAutoCompleteItem> {
  @override
  void didUpdateWidget(covariant _MyAutoCompleteItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.highlighted && widget.highlighted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(Scrollable.ensureVisible(context));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: widget.highlighted,
      onTap: widget.onSelected,
      child: MyGestureDetector(
        behavior: HitTestBehavior.opaque,
        onHover: (hovered) {
          if (hovered) widget.onHover();
        },
        onTap: widget.onSelected,
        child: widget.child,
      ),
    );
  }
}
