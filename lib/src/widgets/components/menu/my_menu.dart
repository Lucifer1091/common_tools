import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../common/portal.dart';
import '../divider/my_divider.dart';
import '../popover/popover.dart';
import '../text/my_text.dart';

typedef MyMenuGroupBuilder =
    Widget Function(BuildContext context, List<Widget> children);

/// Base type for widgets that participate in a [MyMenuGroup].
abstract class MyMenuItem extends Widget {
  const MyMenuItem({super.key});

  bool get hasLeading;

  MyPopoverController? get submenuController;
}

/// Coordinates layout, focus, submenus, and dismissal for menu items.
class MyMenuGroup extends StatefulWidget {
  const MyMenuGroup({
    required this.children,
    super.key,
    this.builder,
    this.direction = Axis.vertical,
    this.itemPadding = EdgeInsets.zero,
    this.subMenuOffset = const Offset(4, -2),
    this.autofocus = true,
    this.focusNode,
    this.groupId,
    this.onDismissed,
    this.allowAutoClose = true,
    this.constraints = const BoxConstraints(minWidth: 192, maxWidth: 320),
  });

  final List<MyMenuItem> children;
  final MyMenuGroupBuilder? builder;
  final Axis direction;
  final EdgeInsetsGeometry itemPadding;
  final Offset subMenuOffset;
  final bool autofocus;
  final FocusNode? focusNode;
  final Object? groupId;
  final VoidCallback? onDismissed;
  final bool allowAutoClose;
  final BoxConstraints constraints;

  @override
  State<MyMenuGroup> createState() => _MyMenuGroupState();
}

class _MyMenuGroupState extends State<MyMenuGroup> {
  final Map<Object, _MyMenuEntry> _entries = <Object, _MyMenuEntry>{};
  final Object _fallbackGroupId = Object();
  var _didAutofocus = false;

  Object _entryKey(MyMenuItem child, int index) => child.key ?? index;

  @override
  void initState() {
    super.initState();
    _reconcileEntries();
  }

  @override
  void didUpdateWidget(covariant MyMenuGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.children, widget.children)) {
      _reconcileEntries();
    }
  }

  void _reconcileEntries() {
    final previous = Map<Object, _MyMenuEntry>.of(_entries);
    _entries.clear();
    for (var index = 0; index < widget.children.length; index++) {
      final child = widget.children[index];
      final key = _entryKey(child, index);
      final supplied = child.submenuController;
      final existing = previous.remove(key);
      if (existing != null && existing.matches(supplied)) {
        _entries[key] = existing;
      } else {
        existing?.dispose();
        _entries[key] = _MyMenuEntry(supplied);
      }
    }
    for (final entry in previous.values) {
      entry.dispose();
    }
  }

  @override
  void dispose() {
    for (final entry in _entries.values) {
      entry.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parent = _MyMenuGroupScope.maybeOf(context);
    final owner = _MyMenuOwnerScope.maybeOf(context);
    final firstFocusable = widget.children.indexWhere(
      (item) => item is! MyMenuDivider && item is! MyMenuLabel,
    );
    late final _MyMenuGroupData data;
    data = _MyMenuGroupData(
      parent: parent,
      entries: _entries.values.toList(growable: false),
      hasLeading: widget.children.any((item) => item.hasLeading),
      direction: widget.direction,
      itemPadding: widget.itemPadding,
      subMenuOffset: widget.subMenuOffset,
      groupId: widget.groupId ?? parent?.groupId ?? _fallbackGroupId,
      allowAutoClose: widget.allowAutoClose && (parent?.allowAutoClose ?? true),
      onDismissed: widget.onDismissed ?? parent?.onDismissed,
      ownerController: owner?.controller,
      ownerFocusNode: owner?.focusNode,
    );

    final rendered = <Widget>[];
    for (var index = 0; index < widget.children.length; index++) {
      final child = widget.children[index];
      final entry = _entries[_entryKey(child, index)]!;
      rendered.add(
        FocusTraversalOrder(
          order: NumericFocusOrder(index.toDouble()),
          child: _MyMenuEntryScope(
            data: _MyMenuEntryData(
              entry: entry,
              autofocus:
                  widget.autofocus && !_didAutofocus && index == firstFocusable,
            ),
            child: child,
          ),
        ),
      );
    }
    _didAutofocus = true;

    final content =
        widget.builder?.call(context, rendered) ??
        MyMenuPanel(
          direction: widget.direction,
          constraints: widget.constraints,
          children: rendered,
        );
    return _MyMenuGroupScope(
      data: data,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Focus(focusNode: widget.focusNode, child: content),
      ),
    );
  }
}

/// Constrains and lays out a rendered menu group.
class MyMenuPanel extends StatelessWidget {
  const MyMenuPanel({
    required this.children,
    super.key,
    this.direction = Axis.vertical,
    this.constraints = const BoxConstraints(minWidth: 192, maxWidth: 320),
  });

  final List<Widget> children;
  final Axis direction;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final availableWidth = math.max(0.0, MediaQuery.sizeOf(context).width - 16);
    final maxWidth = math.min(constraints.maxWidth, availableWidth).toDouble();
    final effective = constraints.copyWith(
      minWidth: math.min(constraints.minWidth, maxWidth),
      maxWidth: maxWidth,
    );
    final flex = Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
    return ConstrainedBox(
      constraints: effective,
      child: direction == Axis.vertical
          ? IntrinsicWidth(child: flex)
          : IntrinsicHeight(child: flex),
    );
  }
}

/// Clickable menu row with optional leading, trailing, and submenu content.
class MyMenuButton extends StatefulWidget implements MyMenuItem {
  const MyMenuButton({
    super.key,
    this.child,
    this.text,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.onPressed,
    this.autoClose = true,
    this.focusNode,
    this.subMenu,
    this.submenuController,
    this.padding,
    this.textStyle,
  }) : assert(
         (child != null) ^ (text != null),
         'Provide either child or text, but not both.',
       );

  final Widget? child;
  final String? text;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onPressed;
  final bool autoClose;
  final FocusNode? focusNode;
  final List<MyMenuItem>? subMenu;
  @override
  final MyPopoverController? submenuController;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  bool get hasLeading => leading != null;

  @override
  State<MyMenuButton> createState() => _MyMenuButtonState();
}

class _MyMenuButtonState extends State<MyMenuButton> {
  FocusNode? _internalFocusNode;
  MyPopoverController? _listenedController;
  Timer? _hideTimer;
  var _hideRevision = 0;
  var _triggerHovered = false;
  var _contentHovered = false;
  var _hovered = false;
  var _focused = false;
  var _pressed = false;
  var _subMenuAutofocus = false;

  bool get _hasSubMenu => widget.subMenu?.isNotEmpty ?? false;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _internalFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = _MyMenuEntryScope.of(context).entry.controller;
    if (controller == _listenedController) return;
    _listenedController?.removeListener(_handleControllerChanged);
    _listenedController = controller..addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MyMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) return;
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    } else {
      _internalFocusNode?.dispose();
      _internalFocusNode = null;
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _listenedController?.removeListener(_handleControllerChanged);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (_listenedController?.isOpen ?? false) {
      _MyMenuGroupScope.maybeOf(context)?.closeOthers(_listenedController!);
    }
    if (mounted) setState(() {});
  }

  void _openSubMenu(_MyMenuGroupData group, {bool autofocus = false}) {
    if (!widget.enabled || !_hasSubMenu) return;
    _hideTimer?.cancel();
    _hideRevision++;
    _subMenuAutofocus = autofocus;
    group.openSubMenu(_MyMenuEntryScope.of(context).entry.controller);
  }

  void _scheduleSubMenuHide() {
    _hideTimer?.cancel();
    final revision = ++_hideRevision;
    _hideTimer = Timer(const Duration(milliseconds: 150), () {
      if (!mounted ||
          revision != _hideRevision ||
          _triggerHovered ||
          _contentHovered) {
        return;
      }
      _listenedController?.hide();
    });
  }

  void _activate(_MyMenuGroupData group) {
    if (!widget.enabled) return;
    widget.onPressed?.call();
    if (_hasSubMenu) {
      _openSubMenu(group);
    } else if (widget.autoClose && group.allowAutoClose) {
      group.closeAll();
    }
  }

  KeyEventResult _handleKeyEvent(
    FocusNode node,
    KeyEvent event,
    _MyMenuGroupData group,
  ) {
    if (event is! KeyDownEvent || !widget.enabled) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final direction = Directionality.of(context);
    final openKey = direction == TextDirection.ltr
        ? LogicalKeyboardKey.arrowRight
        : LogicalKeyboardKey.arrowLeft;
    final closeKey = direction == TextDirection.ltr
        ? LogicalKeyboardKey.arrowLeft
        : LogicalKeyboardKey.arrowRight;
    if (key == LogicalKeyboardKey.arrowDown ||
        (key == LogicalKeyboardKey.tab &&
            !HardwareKeyboard.instance.isShiftPressed)) {
      FocusScope.of(context).nextFocus();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp ||
        (key == LogicalKeyboardKey.tab &&
            HardwareKeyboard.instance.isShiftPressed)) {
      FocusScope.of(context).previousFocus();
      return KeyEventResult.handled;
    }
    if (key == openKey && _hasSubMenu) {
      _openSubMenu(group, autofocus: true);
      return KeyEventResult.handled;
    }
    if (key == closeKey && group.parent != null) {
      group.closeCurrent();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      _activate(group);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      group.closeAll();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final group = _MyMenuGroupScope.of(context);
    final itemData = _MyMenuEntryScope.of(context);
    final autofocus = itemData.takeAutofocus();
    if (autofocus && !_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.enabled) _focusNode.requestFocus();
      });
    }
    final controller = itemData.entry.controller;
    final active =
        widget.enabled &&
        (_hovered || _focused || _pressed || controller.isOpen);
    final foreground = !widget.enabled
        ? context.colorScheme.mutedForeground
        : active
        ? context.colorScheme.accentForeground
        : context.colorScheme.popoverForeground;
    final secondaryForeground = foreground.withValues(alpha: 0.7);

    final row = Semantics(
      button: true,
      enabled: widget.enabled,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: (PointerEnterEvent event) {
          _triggerHovered = true;
          if (widget.enabled) {
            if (!_focusNode.hasFocus) {
              _focusNode.requestFocus();
            }
            if (_hasSubMenu) {
              _openSubMenu(group);
            } else {
              group.closeOthers();
            }
          }
          if (!_hovered) setState(() => _hovered = true);
        },
        onExit: (PointerExitEvent event) {
          _triggerHovered = false;
          if (_hovered) setState(() => _hovered = false);
          if (_hasSubMenu) _scheduleSubMenuHide();
        },
        child: Focus(
          focusNode: _focusNode,
          autofocus: autofocus,
          canRequestFocus: widget.enabled,
          onFocusChange: (value) {
            if (_focused != value) setState(() => _focused = value);
          },
          onKeyEvent: (node, event) => _handleKeyEvent(node, event, group),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled ? () => _activate(group) : null,
            onTapDown: widget.enabled
                ? (_) => setState(() => _pressed = true)
                : null,
            onTapUp: widget.enabled
                ? (_) => setState(() => _pressed = false)
                : null,
            onTapCancel: widget.enabled
                ? () => setState(() => _pressed = false)
                : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: active ? context.colorScheme.accent : Colors.transparent,
                borderRadius: MyBorderRadius.small,
              ),
              child: Padding(
                padding:
                    (widget.padding ??
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ))
                        .add(group.itemPadding),
                child: IconTheme.merge(
                  data: IconThemeData(color: foreground, size: 16),
                  child: DefaultTextStyle.merge(
                    style: (widget.textStyle ?? context.bodyMedium).copyWith(
                      color: foreground,
                    ),
                    child: Row(
                      mainAxisSize: .max,
                      children: [
                        if (group.hasLeading) ...[
                          SizedBox.square(
                            dimension: 16,
                            child: widget.leading == null
                                ? null
                                : Center(child: widget.leading),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child:
                              widget.child ??
                              MyText(widget.text!, textAlign: .left),
                        ),
                        if (widget.trailing != null) ...[
                          const SizedBox(width: 16),
                          IconTheme.merge(
                            data: IconThemeData(color: secondaryForeground),
                            child: DefaultTextStyle.merge(
                              style: context.bodyMedium.copyWith(
                                color: secondaryForeground,
                              ),
                              child: widget.trailing!,
                            ),
                          ),
                        ],
                        if (_hasSubMenu) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Directionality.of(context) == TextDirection.ltr
                                ? LucideIcons.chevronRight
                                : LucideIcons.chevronLeft,
                            size: 16,
                            color: secondaryForeground,
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
    if (!_hasSubMenu) return row;

    final ltr = Directionality.of(context) == TextDirection.ltr;
    return MyPopover(
      controller: controller,
      anchor: MyAnchorAuto(
        offset: Offset(
          ltr ? group.subMenuOffset.dx : -group.subMenuOffset.dx,
          group.subMenuOffset.dy,
        ),
        targetAnchor: ltr ? Alignment.topRight : Alignment.topLeft,
        followerAnchor: ltr ? Alignment.topLeft : Alignment.topRight,
      ),
      closeOnTapOutside: true,
      padding: const EdgeInsets.all(4),
      groupId: group.groupId,
      areaGroupId: group.groupId,
      requestFocusOnOpen: false,
      popover: (context) {
        return MouseRegion(
          onEnter: (_) {
            _contentHovered = true;
            _hideTimer?.cancel();
            _hideRevision++;
          },
          onExit: (_) {
            _contentHovered = false;
            _scheduleSubMenuHide();
          },
          child: _MyMenuOwnerScope(
            controller: controller,
            focusNode: _focusNode,
            child: MyMenuGroup(
              key: ValueKey<bool>(controller.isOpen),
              direction: group.direction,
              itemPadding: group.itemPadding,
              subMenuOffset: group.subMenuOffset,
              autofocus: _subMenuAutofocus,
              groupId: group.groupId,
              allowAutoClose: group.allowAutoClose,
              children: widget.subMenu!,
            ),
          ),
        );
      },
      child: row,
    );
  }
}

/// Non-interactive menu heading or informational row.
class MyMenuLabel extends StatelessWidget implements MyMenuItem {
  const MyMenuLabel({
    super.key,
    this.child,
    this.text,
    this.leading,
    this.trailing,
    this.padding,
    this.textStyle,
  }) : assert(
         (child != null) ^ (text != null),
         'Provide either child or text, but not both.',
       );

  final Widget? child;
  final String? text;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  bool get hasLeading => leading != null;

  @override
  MyPopoverController? get submenuController => null;

  @override
  Widget build(BuildContext context) {
    final group = _MyMenuGroupScope.of(context);
    return Padding(
      padding:
          (padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6))
              .add(group.itemPadding),
      child: DefaultTextStyle.merge(
        style: (textStyle ?? context.bodyMedium).copyWith(
          color: context.colorScheme.mutedForeground,
          fontWeight: FontWeight.w600,
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            if (group.hasLeading) ...[
              SizedBox.square(
                dimension: 16,
                child: leading == null ? null : Center(child: leading),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(child: child ?? MyText(text!, textAlign: .start)),
            if (trailing != null) ...[const SizedBox(width: 16), trailing!],
          ],
        ),
      ),
    );
  }
}

/// Divider that follows the containing menu's direction.
class MyMenuDivider extends StatelessWidget implements MyMenuItem {
  const MyMenuDivider({super.key, this.margin, this.color});

  final EdgeInsetsGeometry? margin;
  final Color? color;

  @override
  bool get hasLeading => false;

  @override
  MyPopoverController? get submenuController => null;

  @override
  Widget build(BuildContext context) {
    final direction =
        _MyMenuGroupScope.maybeOf(context)?.direction ?? Axis.vertical;
    return MyDivider(
      direction: direction == Axis.vertical ? Axis.horizontal : Axis.vertical,
      color: color ?? context.colorScheme.border,
      margin:
          margin ??
          (direction == Axis.vertical
              ? const EdgeInsets.symmetric(vertical: 4)
              : const EdgeInsets.symmetric(horizontal: 4)),
    );
  }
}

/// Boolean menu action with a stable checkmark leading slot.
class MyMenuCheckbox extends StatelessWidget implements MyMenuItem {
  const MyMenuCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.child,
    this.text,
    this.trailing,
    this.enabled = true,
    this.autoClose = true,
    this.focusNode,
  }) : assert(
         (child != null) ^ (text != null),
         'Provide either child or text, but not both.',
       );

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? child;
  final String? text;
  final Widget? trailing;
  final bool enabled;
  final bool autoClose;
  final FocusNode? focusNode;

  @override
  bool get hasLeading => true;

  @override
  MyPopoverController? get submenuController => null;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      child: MyMenuButton(
        leading: value
            ? const Icon(LucideIcons.check, size: 16)
            : const SizedBox.shrink(),
        trailing: trailing,
        enabled: enabled,
        autoClose: autoClose,
        focusNode: focusNode,
        onPressed: onChanged == null ? null : () => onChanged!(!value),
        child: child ?? MyText(text!, textAlign: .left),
      ),
    );
  }
}

/// Provides the selected value for descendant [MyMenuRadio] widgets.
class MyMenuRadioGroup<T> extends StatelessWidget implements MyMenuItem {
  const MyMenuRadioGroup({
    required this.value,
    required this.onChanged,
    required this.children,
    super.key,
  });

  final T? value;
  final ValueChanged<T>? onChanged;
  final List<MyMenuRadio<T>> children;

  @override
  bool get hasLeading => children.isNotEmpty;

  @override
  MyPopoverController? get submenuController => null;

  @override
  Widget build(BuildContext context) {
    return _MyMenuRadioScope<T>(
      value: value,
      onChanged: onChanged,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// A selectable item within a [MyMenuRadioGroup].
class MyMenuRadio<T> extends StatelessWidget {
  const MyMenuRadio({
    required this.value,
    super.key,
    this.child,
    this.text,
    this.trailing,
    this.enabled = true,
    this.autoClose = true,
    this.focusNode,
  }) : assert(
         (child != null) ^ (text != null),
         'Provide either child or text, but not both.',
       );

  final T value;
  final Widget? child;
  final String? text;
  final Widget? trailing;
  final bool enabled;
  final bool autoClose;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final group = _MyMenuRadioScope.of<T>(context);
    final selected = group.value == value;
    return Semantics(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      child: MyMenuButton(
        leading: selected
            ? Icon(Icons.circle_rounded, size: 10)
            : const SizedBox.shrink(),
        trailing: trailing,
        enabled: enabled,
        autoClose: autoClose,
        focusNode: focusNode,
        onPressed: group.onChanged == null
            ? null
            : () => group.onChanged!(value),
        child: child ?? MyText(text!, textAlign: .left),
      ),
    );
  }
}

/// Displays a keyboard shortcut at the trailing edge of a menu item.
class MyMenuShortcut extends StatelessWidget {
  const MyMenuShortcut({
    required this.activator,
    super.key,
    this.combiner = ' + ',
    this.style,
  });

  final ShortcutActivator activator;
  final String combiner;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return MyText(
      _labels().join(combiner),
      style: (style ?? context.bodySmall).copyWith(
        color:
            DefaultTextStyle.of(context).style.color ??
            context.colorScheme.mutedForeground,
      ),
    );
  }

  List<String> _labels() {
    if (activator case final SingleActivator value) {
      return <String>[
        if (value.control) 'Ctrl',
        if (value.alt) 'Alt',
        if (value.shift) 'Shift',
        if (value.meta) 'Meta',
        value.trigger.keyLabel.isEmpty
            ? value.trigger.debugName ?? value.trigger.toString()
            : value.trigger.keyLabel.toUpperCase(),
      ];
    }
    return <String>[activator.toString()];
  }
}

class _MyMenuEntry {
  _MyMenuEntry(MyPopoverController? supplied)
    : controller = supplied ?? MyPopoverController(),
      ownsController = supplied == null;

  final MyPopoverController controller;
  final bool ownsController;

  bool matches(MyPopoverController? supplied) {
    return supplied == null ? ownsController : controller == supplied;
  }

  void dispose() {
    if (ownsController) controller.dispose();
  }
}

class _MyMenuEntryData {
  _MyMenuEntryData({required this.entry, required this.autofocus});

  final _MyMenuEntry entry;
  final bool autofocus;
  var _autofocusClaimed = false;

  bool takeAutofocus() {
    if (!autofocus || _autofocusClaimed) return false;
    _autofocusClaimed = true;
    return true;
  }
}

class _MyMenuEntryScope extends InheritedWidget {
  const _MyMenuEntryScope({required this.data, required super.child});

  final _MyMenuEntryData data;

  static _MyMenuEntryData of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_MyMenuEntryScope>();
    assert(scope != null, 'MyMenuItem must be used inside MyMenuGroup.');
    return scope!.data;
  }

  @override
  bool updateShouldNotify(_MyMenuEntryScope oldWidget) =>
      data != oldWidget.data;
}

class _MyMenuGroupData {
  const _MyMenuGroupData({
    required this.parent,
    required this.entries,
    required this.hasLeading,
    required this.direction,
    required this.itemPadding,
    required this.subMenuOffset,
    required this.groupId,
    required this.allowAutoClose,
    required this.onDismissed,
    required this.ownerController,
    required this.ownerFocusNode,
  });

  final _MyMenuGroupData? parent;
  final List<_MyMenuEntry> entries;
  final bool hasLeading;
  final Axis direction;
  final EdgeInsetsGeometry itemPadding;
  final Offset subMenuOffset;
  final Object groupId;
  final bool allowAutoClose;
  final VoidCallback? onDismissed;
  final MyPopoverController? ownerController;
  final FocusNode? ownerFocusNode;

  void openSubMenu(MyPopoverController controller) {
    closeOthers(controller);
    controller.show();
  }

  void closeOthers([MyPopoverController? except]) {
    for (final entry in entries) {
      if (entry.controller != except) entry.controller.hide();
    }
  }

  void closeAll() {
    closeOthers();
    if (parent != null) {
      parent!.closeAll();
    } else {
      onDismissed?.call();
    }
  }

  void closeCurrent() {
    ownerController?.hide();
    ownerFocusNode?.requestFocus();
  }
}

class _MyMenuGroupScope extends InheritedWidget {
  const _MyMenuGroupScope({required this.data, required super.child});

  final _MyMenuGroupData data;

  static _MyMenuGroupData of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'MyMenuItem must be used inside MyMenuGroup.');
    return scope!;
  }

  static _MyMenuGroupData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_MyMenuGroupScope>()
        ?.data;
  }

  @override
  bool updateShouldNotify(_MyMenuGroupScope oldWidget) =>
      data != oldWidget.data;
}

class _MyMenuOwnerScope extends InheritedWidget {
  const _MyMenuOwnerScope({
    required this.controller,
    required this.focusNode,
    required super.child,
  });

  final MyPopoverController controller;
  final FocusNode focusNode;

  static _MyMenuOwnerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MyMenuOwnerScope>();
  }

  @override
  bool updateShouldNotify(_MyMenuOwnerScope oldWidget) {
    return controller != oldWidget.controller ||
        focusNode != oldWidget.focusNode;
  }
}

class _MyMenuRadioScope<T> extends InheritedWidget {
  const _MyMenuRadioScope({
    required this.value,
    required this.onChanged,
    required super.child,
  });

  final T? value;
  final ValueChanged<T>? onChanged;

  static _MyMenuRadioScope<T> of<T>(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_MyMenuRadioScope<T>>();
    assert(scope != null, 'MyMenuRadio must be used in MyMenuRadioGroup<$T>.');
    return scope!;
  }

  @override
  bool updateShouldNotify(_MyMenuRadioScope<T> oldWidget) {
    return value != oldWidget.value || onChanged != oldWidget.onChanged;
  }
}
