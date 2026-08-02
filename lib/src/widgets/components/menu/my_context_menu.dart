import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/my_decoration.dart';
import '../../common/my_gesture_detector.dart';
import '../../common/portal.dart';
import '../popover/popover.dart';
import 'my_menu.dart';

/// Opens a reusable [MyMenuGroup] at the pointer location.
class MyContextMenu extends StatefulWidget {
  const MyContextMenu({
    required this.child,
    required this.items,
    super.key,
    this.controller,
    this.enabled = true,
    this.closeOnSelect = true,
    this.closeOnTapOutside = true,
    this.requestFocusOnOpen = true,
    this.padding,
    this.decoration,
    this.shadows,
    this.constraints = const BoxConstraints(minWidth: 192, maxWidth: 320),
    this.behavior,
    this.longPressDuration,
    this.suppressBrowserContextMenu = true,
    this.onOpenChanged,
  });

  final Widget child;
  final List<MyMenuItem> items;
  final MyPopoverController? controller;
  final bool enabled;
  final bool closeOnSelect;
  final bool closeOnTapOutside;
  final bool requestFocusOnOpen;
  final EdgeInsetsGeometry? padding;
  final MyDecoration? decoration;
  final List<BoxShadow>? shadows;
  final BoxConstraints constraints;
  final HitTestBehavior? behavior;
  final Duration? longPressDuration;
  final bool suppressBrowserContextMenu;
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<MyContextMenu> createState() => _MyContextMenuState();
}

class _MyContextMenuState extends State<MyContextMenu> {
  final Object _groupId = Object();
  MyPopoverController? _controller;
  Offset _position = Offset.zero;

  MyPopoverController get _effectiveController =>
      widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _controller = MyPopoverController();
    _effectiveController.addListener(_handleControllerChanged);
    if (widget.suppressBrowserContextMenu) {
      _MyBrowserContextMenuSuppressor.acquire();
    }
  }

  @override
  void didUpdateWidget(covariant MyContextMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final oldController = oldWidget.controller ?? _controller;
      oldController?.removeListener(_handleControllerChanged);
      if (widget.controller == null) {
        _controller = MyPopoverController(
          isOpen: oldController?.isOpen ?? false,
        );
      } else {
        _controller?.dispose();
        _controller = null;
      }
      _effectiveController.addListener(_handleControllerChanged);
    }
    if (oldWidget.suppressBrowserContextMenu !=
        widget.suppressBrowserContextMenu) {
      if (widget.suppressBrowserContextMenu) {
        _MyBrowserContextMenuSuppressor.acquire();
      } else {
        _MyBrowserContextMenuSuppressor.release();
      }
    }
    if (!widget.enabled && _effectiveController.isOpen) {
      _effectiveController.hide();
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    if (widget.suppressBrowserContextMenu) {
      _MyBrowserContextMenuSuppressor.release();
    }
    _controller?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!_effectiveController.isOpen) {
      _hideSuppliedSubmenus(widget.items);
    }
    widget.onOpenChanged?.call(_effectiveController.isOpen);
    if (mounted) setState(() {});
  }

  void _hideSuppliedSubmenus(List<MyMenuItem> items) {
    for (final item in items) {
      item.submenuController?.hide();
      if (item is MyMenuButton && item.subMenu != null) {
        _hideSuppliedSubmenus(item.subMenu!);
      }
    }
  }

  void _openAt(Offset position) {
    if (!widget.enabled) return;
    setState(() => _position = position);
    _effectiveController.show();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _effectiveController;
    return MyPopover(
      controller: controller,
      anchor: MyGlobalAnchor(_position),
      closeOnTapOutside: widget.closeOnTapOutside,
      padding: widget.padding ?? const EdgeInsets.all(4),
      decoration: widget.decoration,
      shadows: widget.shadows,
      groupId: _groupId,
      areaGroupId: _groupId,
      requestFocusOnOpen: widget.requestFocusOnOpen,
      useSameGroupIdForChild: false,
      popover: (context) {
        return MyMenuGroup(
          key: ValueKey<bool>(controller.isOpen),
          constraints: widget.constraints,
          groupId: _groupId,
          allowAutoClose: widget.closeOnSelect,
          onDismissed: controller.hide,
          children: widget.items,
        );
      },
      child: MyGestureDetector(
        cursor: MouseCursor.defer,
        behavior: widget.behavior,
        longPressDuration: widget.longPressDuration,
        onSecondaryTapDown: (details) => _openAt(details.globalPosition),
        onLongPressStart: (details) => _openAt(details.globalPosition),
        child: widget.child,
      ),
    );
  }
}

class _MyBrowserContextMenuSuppressor {
  _MyBrowserContextMenuSuppressor._();

  static var _activeCount = 0;
  static var _disabledByUs = false;
  static Future<void> _operation = Future<void>.value();

  static void acquire() {
    if (!kIsWeb) return;
    _activeCount++;
    if (_activeCount != 1 || !BrowserContextMenu.enabled || _disabledByUs) {
      return;
    }
    _disabledByUs = true;
    _queue(() async {
      if (_activeCount > 0 && _disabledByUs) {
        await BrowserContextMenu.disableContextMenu();
      }
    });
  }

  static void release() {
    if (!kIsWeb || _activeCount == 0) return;
    _activeCount--;
    if (_activeCount != 0 || !_disabledByUs) return;
    _queue(() async {
      if (_activeCount == 0 && _disabledByUs) {
        _disabledByUs = false;
        await BrowserContextMenu.enableContextMenu();
      }
    });
  }

  static void _queue(Future<void> Function() action) {
    _operation = _operation.then((_) => action()).catchError((Object _) {});
    unawaited(_operation);
  }
}
