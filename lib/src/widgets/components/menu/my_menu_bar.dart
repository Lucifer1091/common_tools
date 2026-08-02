import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../common/my_border.dart';
import '../../common/my_decoration.dart';
import '../../common/my_decorator.dart';
import '../../common/portal.dart';
import '../popover/popover.dart';
import '../text/my_text.dart';
import 'my_menu.dart';

/// A desktop-style horizontal menu bar.
class MyMenuBar extends StatefulWidget {
  const MyMenuBar({
    required this.items,
    super.key,
    this.border = true,
    this.padding,
    this.decoration,
    this.shadows,
    this.constraints = const BoxConstraints(minWidth: 192, maxWidth: 320),
    this.popoverOffset,
    this.closeOnSelect = true,
    this.closeOnTapOutside = true,
    this.requestFocusOnOpen = true,
    this.onOpenChanged,
  });

  final List<MyMenuBarItem> items;
  final bool border;
  final EdgeInsetsGeometry? padding;
  final MyDecoration? decoration;
  final List<BoxShadow>? shadows;
  final BoxConstraints constraints;
  final Offset? popoverOffset;
  final bool closeOnSelect;
  final bool closeOnTapOutside;
  final bool requestFocusOnOpen;
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  final Object _groupId = Object();
  final Map<Object, _MyMenuBarEntry> _entries = <Object, _MyMenuBarEntry>{};
  Object? _activeKey;
  var _notifyingOpen = false;

  Object _entryKey(MyMenuBarItem item, int index) => item.key ?? index;

  bool get _isAnyOpen =>
      _entries.values.any((entry) => entry.controller.isOpen);

  @override
  void initState() {
    super.initState();
    _reconcileEntries();
  }

  @override
  void didUpdateWidget(covariant MyMenuBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.items, widget.items)) {
      _reconcileEntries();
    }
  }

  @override
  void dispose() {
    for (final entry in _entries.values) {
      entry.dispose();
    }
    super.dispose();
  }

  void _reconcileEntries() {
    final previous = Map<Object, _MyMenuBarEntry>.of(_entries);
    _entries.clear();
    for (var index = 0; index < widget.items.length; index++) {
      final item = widget.items[index];
      final key = _entryKey(item, index);
      final existing = previous.remove(key);
      if (existing != null && existing.matches(item)) {
        existing.updateListener(() => _handleControllerChanged(key, item));
        _entries[key] = existing;
      } else {
        existing?.dispose();
        _entries[key] = _MyMenuBarEntry(
          item: item,
          listener: () => _handleControllerChanged(key, item),
        );
      }
    }
    for (final entry in previous.values) {
      entry.dispose();
    }
  }

  void _handleControllerChanged(Object key, MyMenuBarItem item) {
    final entry = _entries[key];
    if (entry == null) return;
    if (entry.controller.isOpen) {
      _closeOtherMenus(key);
      _activeKey = key;
    } else {
      _hideSuppliedSubmenus(item.items);
      if (_activeKey == key) _activeKey = null;
    }
    _notifyOpenChanged();
    if (mounted) setState(() {});
  }

  void _notifyOpenChanged() {
    if (_notifyingOpen) return;
    _notifyingOpen = true;
    widget.onOpenChanged?.call(_isAnyOpen);
    _notifyingOpen = false;
  }

  void _closeOtherMenus(Object key) {
    for (final entry in _entries.entries) {
      if (entry.key != key) entry.value.controller.hide();
    }
  }

  void _hideSuppliedSubmenus(List<MyMenuItem> items) {
    for (final item in items) {
      item.submenuController?.hide();
      if (item is MyMenuButton && item.subMenu != null) {
        _hideSuppliedSubmenus(item.subMenu!);
      }
    }
  }

  void _closeAll({FocusNode? restoreFocus}) {
    for (var index = 0; index < widget.items.length; index++) {
      final item = widget.items[index];
      _hideSuppliedSubmenus(item.items);
    }
    for (final entry in _entries.values) {
      entry.controller.hide();
    }
    _activeKey = null;
    restoreFocus?.requestFocus();
    _notifyOpenChanged();
    if (mounted) setState(() {});
  }

  void _openItem(int index, {bool autofocus = false}) {
    final item = widget.items[index];
    if (!item.enabled || item.items.isEmpty) return;
    final key = _entryKey(item, index);
    final entry = _entries[key]!;
    entry.autofocusOnOpen = autofocus;
    _closeOtherMenus(key);
    _activeKey = key;
    entry.controller.show();
    if (mounted) setState(() {});
  }

  void _activateItem(int index) {
    final item = widget.items[index];
    if (!item.enabled) return;
    item.onPressed?.call();
    if (item.items.isNotEmpty) {
      _openItem(index, autofocus: true);
    } else {
      _closeAll();
    }
  }

  void _focusSibling(int index, {required bool forward}) {
    if (widget.items.isEmpty) return;
    for (var step = 1; step <= widget.items.length; step++) {
      final target = forward
          ? (index + step) % widget.items.length
          : (index - step) % widget.items.length;
      final item = widget.items[target];
      if (!item.enabled) continue;
      final key = _entryKey(item, target);
      final entry = _entries[key]!;
      entry.focusNode.requestFocus();
      if (_isAnyOpen && item.items.isNotEmpty) {
        _openItem(target);
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = MyDecoration(
      color: context.colorScheme.background,
      border: widget.border
          ? MyBorder.all(
              color: context.colorScheme.border,
              width: 1,
              radius: MyBorderRadius.medium,
            )
          : MyBorder.none,
    ).merge(widget.decoration);

    final content = Padding(
      padding: widget.padding ?? const EdgeInsets.all(4),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var index = 0; index < widget.items.length; index++)
              FocusTraversalOrder(
                order: NumericFocusOrder(index.toDouble()),
                child: _MyMenuBarTrigger(
                  key: widget.items[index].key ?? ValueKey<int>(index),
                  item: widget.items[index],
                  entry: _entries[_entryKey(widget.items[index], index)]!,
                  index: index,
                  groupId: _groupId,
                  constraints: widget.constraints,
                  popoverOffset: widget.popoverOffset,
                  closeOnSelect: widget.closeOnSelect,
                  closeOnTapOutside: widget.closeOnTapOutside,
                  requestFocusOnOpen: widget.requestFocusOnOpen,
                  shadows: widget.shadows,
                  anyOpen: _isAnyOpen,
                  active: _activeKey == _entryKey(widget.items[index], index),
                  onHoverOpen: () => _openItem(index),
                  onActivate: () => _activateItem(index),
                  onDismissed: () => _closeAll(
                    restoreFocus:
                        _entries[_entryKey(widget.items[index], index)]!
                            .focusNode,
                  ),
                  onFocusSibling: (forward) =>
                      _focusSibling(index, forward: forward),
                ),
              ),
          ],
        ),
      ),
    );

    return MyDecorator(decoration: effectiveDecoration, child: content);
  }
}

@immutable
class MyMenuBarItem {
  const MyMenuBarItem({
    this.key,
    this.child,
    this.text,
    this.items = const [],
    this.enabled = true,
    this.leading,
    this.trailing,
    this.controller,
    this.focusNode,
    this.onPressed,
  }) : assert(
         (child != null) ^ (text != null),
         'Provide either child or text, but not both.',
       );

  final Key? key;
  final Widget? child;
  final String? text;
  final List<MyMenuItem> items;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
  final MyPopoverController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onPressed;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyMenuBarItem &&
        other.key == key &&
        other.child == child &&
        other.text == text &&
        listEquals(other.items, items) &&
        other.enabled == enabled &&
        other.leading == leading &&
        other.trailing == trailing &&
        other.controller == controller &&
        other.focusNode == focusNode &&
        other.onPressed == onPressed;
  }

  @override
  int get hashCode => Object.hash(
    key,
    child,
    text,
    Object.hashAll(items),
    enabled,
    leading,
    trailing,
    controller,
    focusNode,
    onPressed,
  );
}

class _MyMenuBarTrigger extends StatefulWidget {
  const _MyMenuBarTrigger({
    required super.key,
    required this.item,
    required this.entry,
    required this.index,
    required this.groupId,
    required this.constraints,
    required this.closeOnSelect,
    required this.closeOnTapOutside,
    required this.requestFocusOnOpen,
    required this.anyOpen,
    required this.active,
    required this.onHoverOpen,
    required this.onActivate,
    required this.onDismissed,
    required this.onFocusSibling,
    this.popoverOffset,
    this.shadows,
  });

  final MyMenuBarItem item;
  final _MyMenuBarEntry entry;
  final int index;
  final Object groupId;
  final BoxConstraints constraints;
  final bool closeOnSelect;
  final bool closeOnTapOutside;
  final bool requestFocusOnOpen;
  final bool anyOpen;
  final bool active;
  final VoidCallback onHoverOpen;
  final VoidCallback onActivate;
  final VoidCallback onDismissed;
  final ValueChanged<bool> onFocusSibling;
  final Offset? popoverOffset;
  final List<BoxShadow>? shadows;

  @override
  State<_MyMenuBarTrigger> createState() => _MyMenuBarTriggerState();
}

class _MyMenuBarTriggerState extends State<_MyMenuBarTrigger> {
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _hasMenu => widget.item.items.isNotEmpty;

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !widget.item.enabled) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final direction = Directionality.of(context);
    final forwardKey = direction == TextDirection.ltr
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowLeft;
    final backwardKey = direction == TextDirection.ltr
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowRight;
    if (key == forwardKey) {
      widget.onFocusSibling(true);
      return KeyEventResult.handled;
    }
    if (key == backwardKey) {
      widget.onFocusSibling(false);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      widget.onHoverOpen();
      widget.entry.autofocusOnOpen = true;
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      widget.onActivate();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      widget.onDismissed();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ltr = Directionality.of(context) == TextDirection.ltr;
    final active =
        widget.item.enabled &&
        (_hovered || _focused || _pressed || widget.active);
    final foreground = !widget.item.enabled
        ? context.colorScheme.mutedForeground
        : active
        ? context.colorScheme.accentForeground
        : context.colorScheme.foreground;
    final secondaryForeground = foreground.withValues(alpha: 0.7);
    final offset = widget.popoverOffset ?? const Offset(0, 4);

    final trigger = Semantics(
      button: true,
      enabled: widget.item.enabled,
      child: MouseRegion(
        cursor: widget.item.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: (_) {
          if (!_hovered) setState(() => _hovered = true);
          if (widget.item.enabled && widget.anyOpen && _hasMenu) {
            widget.entry.focusNode.requestFocus();
            widget.onHoverOpen();
          }
        },
        onExit: (_) {
          if (_hovered) setState(() => _hovered = false);
        },
        child: Focus(
          focusNode: widget.entry.focusNode,
          canRequestFocus: widget.item.enabled,
          onFocusChange: (value) {
            if (_focused != value) setState(() => _focused = value);
          },
          onKeyEvent: _handleKeyEvent,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.item.enabled
                ? () {
                    widget.entry.focusNode.requestFocus();
                    widget.onActivate();
                  }
                : null,
            onTapDown: widget.item.enabled
                ? (_) => setState(() => _pressed = true)
                : null,
            onTapUp: widget.item.enabled
                ? (_) => setState(() => _pressed = false)
                : null,
            onTapCancel: widget.item.enabled
                ? () => setState(() => _pressed = false)
                : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: active ? context.colorScheme.accent : Colors.transparent,
                borderRadius: MyBorderRadius.small,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: IconTheme.merge(
                  data: IconThemeData(color: foreground, size: 16),
                  child: DefaultTextStyle.merge(
                    style: context.bodyMedium.copyWith(color: foreground),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.item.leading != null) ...[
                          widget.item.leading!,
                          const SizedBox(width: 6),
                        ],
                        widget.item.child ?? MyText(widget.item.text!),
                        if (widget.item.trailing != null) ...[
                          const SizedBox(width: 8),
                          IconTheme.merge(
                            data: IconThemeData(color: secondaryForeground),
                            child: DefaultTextStyle.merge(
                              style: context.bodySmall.copyWith(
                                color: secondaryForeground,
                              ),
                              child: widget.item.trailing!,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!_hasMenu) return trigger;

    return MyPopover(
      controller: widget.entry.controller,
      anchor: MyAnchorAuto(
        offset: Offset(ltr ? offset.dx : -offset.dx, offset.dy),
        targetAnchor: ltr ? Alignment.bottomLeft : Alignment.bottomRight,
        followerAnchor: ltr ? Alignment.topLeft : Alignment.topRight,
      ),
      closeOnTapOutside: widget.closeOnTapOutside,
      padding: const EdgeInsets.all(4),
      shadows: widget.shadows,
      groupId: widget.groupId,
      areaGroupId: widget.groupId,
      requestFocusOnOpen: widget.requestFocusOnOpen,
      popover: (context) {
        return MyMenuGroup(
          key: ValueKey<bool>(widget.entry.controller.isOpen),
          constraints: widget.constraints,
          groupId: widget.groupId,
          allowAutoClose: widget.closeOnSelect,
          onDismissed: widget.onDismissed,
          autofocus: widget.entry.autofocusOnOpen,
          children: widget.item.items,
        );
      },
      child: trigger,
    );
  }
}

class _MyMenuBarEntry {
  _MyMenuBarEntry({required MyMenuBarItem item, required this._listener})
    : controller = item.controller ?? MyPopoverController(),
      focusNode = item.focusNode ?? FocusNode(),
      ownsController = item.controller == null,
      ownsFocusNode = item.focusNode == null {
    controller.addListener(_listener);
  }

  final MyPopoverController controller;
  final FocusNode focusNode;
  final bool ownsController;
  final bool ownsFocusNode;
  VoidCallback _listener;
  var autofocusOnOpen = false;

  bool matches(MyMenuBarItem item) {
    return (item.controller == null
            ? ownsController
            : controller == item.controller) &&
        (item.focusNode == null ? ownsFocusNode : focusNode == item.focusNode);
  }

  void updateListener(VoidCallback listener) {
    controller.removeListener(_listener);
    _listener = listener;
    controller.addListener(_listener);
  }

  void dispose() {
    controller.removeListener(_listener);
    if (ownsController) controller.dispose();
    if (ownsFocusNode) focusNode.dispose();
  }
}
