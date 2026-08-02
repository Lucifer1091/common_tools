import 'package:flutter/material.dart';

import '../../common/my_decoration.dart';
import '../../common/portal.dart';
import '../menu/my_menu.dart';
import '../popover/popover.dart';

typedef MyDropDownMenuTriggerBuilder =
    Widget Function(
      BuildContext context,
      MyPopoverController controller,
      bool open,
    );

/// A menu overlay anchored to a caller-built trigger.
class MyDropDownMenu extends StatefulWidget {
  const MyDropDownMenu({
    required this.triggerBuilder,
    required this.children,
    super.key,
    this.controller,
    this.anchor,
    this.padding,
    this.decoration,
    this.shadows,
    this.constraints = const BoxConstraints(minWidth: 192, maxWidth: 320),
    this.closeOnSelect = true,
    this.closeOnTapOutside = true,
    this.requestFocusOnOpen = true,
    this.onOpenChanged,
  });

  final MyDropDownMenuTriggerBuilder triggerBuilder;
  final List<MyMenuItem> children;
  final MyPopoverController? controller;
  final MyAnchorBase? anchor;
  final EdgeInsetsGeometry? padding;
  final MyDecoration? decoration;
  final List<BoxShadow>? shadows;
  final BoxConstraints constraints;
  final bool closeOnSelect;
  final bool closeOnTapOutside;
  final bool requestFocusOnOpen;
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<MyDropDownMenu> createState() => _MyDropDownMenuState();
}

class _MyDropDownMenuState extends State<MyDropDownMenu> {
  final Object _groupId = Object();
  MyPopoverController? _controller;

  MyPopoverController get _effectiveController =>
      widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _controller = MyPopoverController();
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MyDropDownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    final oldController = oldWidget.controller ?? _controller;
    oldController?.removeListener(_handleControllerChanged);
    if (widget.controller == null) {
      _controller = MyPopoverController(isOpen: oldController?.isOpen ?? false);
    } else {
      _controller?.dispose();
      _controller = null;
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!_effectiveController.isOpen) {
      _hideSuppliedSubmenus(widget.children);
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

  @override
  Widget build(BuildContext context) {
    final controller = _effectiveController;
    final ltr = Directionality.of(context) == TextDirection.ltr;
    final effectiveAnchor =
        widget.anchor ??
        MyAnchorAuto(
          offset: const Offset(0, 4),
          targetAnchor: ltr ? Alignment.bottomLeft : Alignment.bottomRight,
          followerAnchor: ltr ? Alignment.topLeft : Alignment.topRight,
        );

    return MyPopover(
      controller: controller,
      anchor: effectiveAnchor,
      closeOnTapOutside: widget.closeOnTapOutside,
      padding: widget.padding ?? const EdgeInsets.all(4),
      decoration: widget.decoration,
      shadows: widget.shadows,
      groupId: _groupId,
      areaGroupId: _groupId,
      requestFocusOnOpen: widget.requestFocusOnOpen,
      popover: (context) {
        return MyMenuGroup(
          key: ValueKey<bool>(controller.isOpen),
          constraints: widget.constraints,
          groupId: _groupId,
          allowAutoClose: widget.closeOnSelect,
          onDismissed: controller.hide,
          children: widget.children,
        );
      },
      child: widget.triggerBuilder(context, controller, controller.isOpen),
    );
  }
}
