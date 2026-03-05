import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../index.dart';

export 'package:flutter_slidable/flutter_slidable.dart';

enum TDSwipeDirection { right, left }

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

  final SlidableController? controller;

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
  static void close(Object? tag, {SlidableController? current}) {
    if (tag == null || !_controllers.keys.contains(tag)) return;

    for (final element in _controllers[tag]!) {
      if (element != current) {
        unawaited(element.close());
      }
    }
  }

  /// Get the context's nearest [controller]
  static SlidableController? of(BuildContext context) {
    return Slidable.of(context);
  }

  @override
  _TDSwipeCellState createState() => _TDSwipeCellState();
}

class _TDSwipeCellState extends State<TDSwipeCell>
    with TickerProviderStateMixin {
  late final SlidableController controller;
  final confirmListenable = ValueNotifier<TDSwipeCellAction?>(null);
  TDSwipeDirection? openDirection;

  @override
  void initState() {
    super.initState();
    controller =
        (widget.controller ?? SlidableController(this))
          ..actionPaneType.addListener(_handleActionPanelTypeChanged)
          ..animation.addStatusListener((status) {
            confirmListenable.value = null;
          });
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
      controller =
          (widget.controller ?? SlidableController(this))
            ..actionPaneType.addListener(_handleActionPanelTypeChanged);
      TDSwipeCell._pushController(controller, widget.groupTag);
    }
  }

  @override
  void dispose() {
    controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);
    controller.dispose();
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
      startActionPane: widget.left?.build(context),
      endActionPane: widget.right?.build(context),
      dragStartBehavior: widget.dragStartBehavior ?? DragStartBehavior.start,
      direction: widget.direction ?? Axis.horizontal,
      child: widget.cell,
    );
    return TDSwipeCellInherited(
      duration: widget.getDuration,
      controller: controller,
      onTap: () {
        if (widget.closeWhenTapped.isTrue) {
          TDSwipeCell.close(widget.groupTag);
        }
      },
      onAction: (action) {
        final isLeft = openDirection == TDSwipeDirection.left;
        final panel = isLeft ? widget.left! : widget.right!;
        final index = panel.children.indexOf(action);
        final confirm = panel.confirms?.find(
          (element) => element.confirmIndex?.contains(index) ?? false,
        );
        confirmListenable.value = confirm;
        return confirm != null;
      },
      child:
          rightConfirmLength > 0 || leftConfirmLength > 0
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
        alignment:
            isHorizontal
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
          TDSwipeCell.close(widget.groupTag, current: controller);
        }
        openDirection = TDSwipeDirection.left;
        widget.onChange?.call(openDirection!, true);
      case ActionPaneType.end:
        if (widget.closeWhenOpened.isTrue) {
          TDSwipeCell.close(widget.groupTag, current: controller);
        }
        openDirection = TDSwipeDirection.right;
        widget.onChange?.call(openDirection!, true);
    }
  }
}
