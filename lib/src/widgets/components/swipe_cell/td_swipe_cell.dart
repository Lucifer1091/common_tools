import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../extensions/iterable/sanitizers.dart';
import '../../../extensions/misc/bool.dart';
import '../cell/my_cell.dart';
import './td_swipe_cell_action.dart';
import './td_swipe_cell_inherited.dart';
import './td_swipe_cell_panel.dart';

enum TDSwipeDirection { right, left }

/// Package-owned controller for a swipe cell.
class MySwipeCellController {
  SlidableController? _delegate;

  bool get isAttached => _delegate != null;

  Future<void> close({Duration duration = const Duration(milliseconds: 200)}) {
    return _delegate?.close(duration: duration) ?? Future<void>.value();
  }

  Future<void> openStart({
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return _delegate?.openStartActionPane(duration: duration) ??
        Future<void>.value();
  }

  Future<void> openEnd({
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return _delegate?.openEndActionPane(duration: duration) ??
        Future<void>.value();
  }
}

class TDSwipeCell extends StatefulWidget {
  const TDSwipeCell({
    required this.cell,
    super.key,
    this.slidableKey,
    this.disabled = false,
    this.opened = const [false, false],
    this.right,
    this.left,
    this.onChange,
    this.controller,
    this.groupTag,
    this.closeWhenOpened = true,
    this.closeWhenTapped = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.direction = Axis.horizontal,
    this.duration = const Duration(milliseconds: 200),
  });

  final Key? slidableKey;

  /// Cell [MyCell]
  final Widget cell;

  final bool? disabled;

  /// Open by default, [left, right]
  final List<bool>? opened;

  final TDSwipeCellPanel? right;

  final TDSwipeCellPanel? left;

  final void Function(TDSwipeDirection direction, bool open)? onChange;

  final MySwipeCellController? controller;

  /// After configuration, [closeWhenOpened] and [closeWhenTapped] will take effect.
  final Object? groupTag;

  /// When a [TDSwipeCell] in the same group ([groupTag]) is opened, should all
  /// other [TDSwipeCell] in the group be closed?
  final bool? closeWhenOpened;

  /// When a [TDSwipeCell] in the same group ([groupTag]) is clicked, should all
  /// [TDSwipeCell] in the group be closed?
  ///
  /// When the [cell] component is clicked, the click event must be passed and
  /// `TDSwipeCellInherited.of(context)?.cellClick()` must be executed
  final bool? closeWhenTapped;

  /// How to handle drag start behavior [GestureDetector.dragStartBehavior]
  final DragStartBehavior? dragStartBehavior;

  final Axis? direction;

  final Duration? duration;

  Duration get getDuration => duration ?? const Duration(milliseconds: 200);

  static final Map<Object, List<SlidableController>> _controllers = {};

  static void _pushController(
    SlidableController controller,
    Object? tag, {
    bool del = false,
  }) {
    if (tag == null) return;

    if (del) {
      if (_controllers.keys.contains(tag)) {
        _controllers[tag]!.remove(controller);
      }
    } else {
      if (_controllers.keys.contains(tag)) {
        if (!_controllers[tag]!.contains(controller)) {
          _controllers[tag]!.add(controller);
        }
      } else {
        _controllers[tag] = [controller];
      }
    }
  }

  /// Close [TDSwipeCell] according to [groupTag]
  ///
  /// current: keep the current state
  static void close(Object? tag, {MySwipeCellController? current}) {
    if (tag == null || !_controllers.keys.contains(tag)) return;

    for (final element in _controllers[tag]!) {
      if (element != current?._delegate) {
        unawaited(element.close());
      }
    }
  }

  /// Get the context's nearest [controller]
  static MySwipeCellController? of(BuildContext context) {
    return TDSwipeCellInherited.of(context)?.controller;
  }

  @override
  State<TDSwipeCell> createState() => _TDSwipeCellState();
}

class _TDSwipeCellState extends State<TDSwipeCell>
    with TickerProviderStateMixin {
  late SlidableController controller;
  late MySwipeCellController exposedController;
  final confirmListenable = ValueNotifier<TDSwipeCellAction?>(null);
  TDSwipeDirection? openDirection;

  @override
  void initState() {
    super.initState();
    exposedController = widget.controller ?? MySwipeCellController();
    controller = SlidableController(this)
      ..actionPaneType.addListener(_handleActionPanelTypeChanged)
      ..animation.addStatusListener((status) {
        confirmListenable.value = null;
      });
    exposedController._delegate = controller;
    TDSwipeCell._pushController(controller, widget.groupTag);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((widget.opened?.length ?? 0) > 0 && widget.opened![0]) {
        unawaited(controller.openStartActionPane(duration: widget.getDuration));
      }
      if ((widget.opened?.length ?? 0) > 1 && widget.opened![1]) {
        unawaited(controller.openEndActionPane(duration: widget.getDuration));
      }
    });
  }

  @override
  void didUpdateWidget(covariant TDSwipeCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);
      TDSwipeCell._pushController(controller, widget.groupTag, del: true);
      controller.dispose();
      exposedController._delegate = null;
      exposedController = widget.controller ?? MySwipeCellController();
      controller = SlidableController(this)
        ..actionPaneType.addListener(_handleActionPanelTypeChanged);
      exposedController._delegate = controller;
      TDSwipeCell._pushController(controller, widget.groupTag);
    }
  }

  @override
  void dispose() {
    controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);
    controller.dispose();
    exposedController._delegate = null;
    TDSwipeCell._pushController(controller, widget.groupTag, del: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rightConfirmLength = widget.right?.confirms?.length ?? 0;
    final leftConfirmLength = widget.left?.confirms?.length ?? 0;

    final slidable = Slidable(
      key: widget.slidableKey ?? UniqueKey(),
      closeOnScroll: false,
      controller: controller,
      enabled: !(widget.disabled ?? false),
      groupTag: widget.groupTag,
      startActionPane: widget.left?.build(context) as ActionPane?,
      endActionPane: widget.right?.build(context) as ActionPane?,
      dragStartBehavior: widget.dragStartBehavior ?? DragStartBehavior.start,
      direction: widget.direction ?? Axis.horizontal,
      child: widget.cell,
    );
    return TDSwipeCellInherited(
      duration: widget.getDuration,
      controller: exposedController,
      onTap: () {
        if (widget.closeWhenTapped.isTrue) {
          TDSwipeCell.close(widget.groupTag);
        }
      },
      onAction: (TDSwipeCellAction action) {
        final isLeft = openDirection == TDSwipeDirection.left;
        final panel = isLeft ? widget.left! : widget.right!;
        final index = panel.children.indexOf(action);
        final confirm = panel.confirms?.find(
          (element) => element.confirmIndex?.contains(index) ?? false,
        );
        confirmListenable.value = confirm;
        return confirm != null;
      },
      child: rightConfirmLength > 0 || leftConfirmLength > 0
          ? ValueListenableBuilder(
              valueListenable: confirmListenable,
              builder: (BuildContext context, value, Widget? child) {
                return Stack(children: [slidable, _confirmWidget()]);
              },
            )
          : slidable,
    );
  }

  Widget _confirmWidget() {
    final isHorizontal = widget.direction == Axis.horizontal;
    final isLeft = openDirection == TDSwipeDirection.left;
    final pane = isLeft ? widget.left : widget.right;
    final extentRatio = pane?.extentRatio ?? 0.3;
    return Positioned.fill(
      child: FractionallySizedBox(
        alignment: isHorizontal
            ? (isLeft ? Alignment.centerLeft : Alignment.centerRight)
            : (isLeft ? Alignment.topCenter : Alignment.bottomCenter),
        widthFactor: isHorizontal ? extentRatio : null,
        heightFactor: isHorizontal ? null : extentRatio,
        child: AnimatedSwitcher(
          duration: widget.getDuration,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: isLeft ? const Offset(-1, 0) : const Offset(1, 0),
                end: isLeft ? Offset.zero : Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: confirmListenable.value ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _handleActionPanelTypeChanged() {
    switch (controller.actionPaneType.value) {
      case ActionPaneType.none:
        widget.onChange?.call(openDirection!, false);
        openDirection = null;
      case ActionPaneType.start:
        if (widget.closeWhenOpened.isTrue) {
          TDSwipeCell.close(widget.groupTag, current: exposedController);
        }
        openDirection = TDSwipeDirection.left;
        widget.onChange?.call(openDirection!, true);
      case ActionPaneType.end:
        if (widget.closeWhenOpened.isTrue) {
          TDSwipeCell.close(widget.groupTag, current: exposedController);
        }
        openDirection = TDSwipeDirection.right;
        widget.onChange?.call(openDirection!, true);
    }
  }
}
