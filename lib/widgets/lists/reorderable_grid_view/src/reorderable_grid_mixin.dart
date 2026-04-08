import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../reorderable_grid_view.dart';
import 'drag_info.dart';
import 'reorderable_item.dart';
import 'util.dart';

abstract class ReorderableChildPosDelegate {
  const ReorderableChildPosDelegate();

  Offset getPos(
    int index,
    Map<int, ReorderableItemViewState> items,
    BuildContext context,
  );
}

mixin ReorderableGridWidgetMixin on StatefulWidget {
  DragEnableConfig? get dragEnableConfig;
  ReorderCallback get onReorder;
  DragWidgetBuilder? get dragWidgetBuilder;
  ScrollSpeedController? get scrollSpeedController;
  PlaceholderBuilder? get placeholderBuilder;
  OnDragStart? get onDragStart;
  OnDragUpdate? get onDragUpdate;

  Widget get child;
  Duration? get dragStartDelay;
  bool? get dragEnabled;

  bool? get isSliver;

  bool? get restrictDragScope;

  // every time an animation occurs begin
  OnDropIndexChange? get onDropIndexChange;
}

// What I want is I can call setState and get those properties.
// So I want my widget to on The ReorderableGridWidgetMixin
mixin ReorderableGridStateMixin<T extends ReorderableGridWidgetMixin>
    on State<T>, TickerProviderStateMixin<T> {
  DragEnableConfig get dragEnableConfig =>
      widget.dragEnableConfig ?? (index) => true;
  MultiDragGestureRecognizer? _recognizer;
  GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();
  // late Overlay overlay = Overlay(key: overlayKey);

  Duration get dragStartDelay => widget.dragStartDelay ?? kLongPressTimeout;
  bool get dragEnabled => widget.dragEnabled ?? true;
  // it's not as drag start?
  void startDragRecognizer(
    int index,
    PointerDownEvent event,
    MultiDragGestureRecognizer recognizer,
  ) {
    // how to fix enter this twice?
    if (_dragIndex != null) {
      _dragReset();
    }

    _dragIndex = index;
    _recognizer =
        recognizer
          ..onStart = _onDragStart
          ..addPointer(event);
  }

  int? _dragIndex;

  int? _dropIndex;

  int get dropIndex => _dropIndex ?? -1;

  PlaceholderBuilder? get placeholderBuilder => widget.placeholderBuilder;

  OverlayState? getOverlay() {
    return overlayKey.currentState;
  }

  bool containsByIndex(int index) {
    return __items.containsKey(index);
  }

  Offset getPosByOffset(int index, int dIndex) {
    // how to do to this?
    final keys = __items.keys.toList();
    var keyIndex = keys.indexOf(index);
    keyIndex = keyIndex + dIndex;
    if (keyIndex < 0) {
      keyIndex = 0;
    }
    if (keyIndex > keys.length - 1) {
      keyIndex = keys.length - 1;
    }

    return getPosByIndex(keys[keyIndex]);
  }

  // The pos is relate to the container's 0, 0
  Offset getPosByIndex(int index, {bool safe = true}) {
    if (safe) {
      if (index < 0) {
        index = 0;
      }
    }

    if (index < 0) {
      return Offset.zero;
    }

    final child = __items[index];

    if (child == null) {
      debugPrint('why child is null for index: $index, and __item: $__items');
    }

    // how to do?
    final thisRenderObject = context.findRenderObject();
    // RenderSliverGrid

    if (thisRenderObject is RenderSliverGrid) {
      final renderObject = thisRenderObject;

      final SliverConstraints constraints = renderObject.constraints;
      final SliverGridLayout layout = renderObject.gridDelegate.getLayout(
        constraints,
      );

      // SliverGridGeometry(scrollOffset: 0.0, crossAxisOffset: 0.0, mainAxisExtent: 217.46031746031747, crossAxisExtent: 130.47619047619048), index: 0
      // SliverGridGeometry(scrollOffset: 0.0, crossAxisOffset: 140.47619047619048, mainAxisExtent: 217.46031746031747, crossAxisExtent: 130.47619047619048), index: 1
      // SliverGridGeometry(scrollOffset: 227.46031746031747, crossAxisOffset: 0.0, mainAxisExtent: 217.46031746031747, crossAxisExtent: 130.47619047619048), index: 3
      // index is not the right index!!!
      final fixedIndex = child!.indexInAll ?? child.index;
      final SliverGridGeometry gridGeometry = layout.getGeometryForChildIndex(
        fixedIndex,
      );
      final rst = Offset(
        gridGeometry.crossAxisOffset,
        gridGeometry.scrollOffset,
      );
      return rst;
    }

    final renderObject = child?.context.findRenderObject();
    if (renderObject == null) {
      return Offset.zero;
    }
    final RenderBox box = renderObject as RenderBox;

    final parentRenderObject = context.findRenderObject() as RenderBox;
    final pos = parentRenderObject.globalToLocal(
      box.localToGlobal(Offset.zero),
    );
    return pos;
  }

  // Ok, let's no calc the dropIndex
  // Check the dragInfo before you call this function.
  int _calcDropIndex(int defaultIndex) {
    if (_dragInfo == null) {
      // _debug("_dragInfo is null, so return: $defaultIndex");
      return defaultIndex;
    }

    for (final item in __items.values) {
      final RenderBox box = item.context.findRenderObject() as RenderBox;
      final Offset pos = box.globalToLocal(_dragInfo!.getCenterInGlobal());
      if (pos.dx > 0 &&
          pos.dy > 0 &&
          pos.dx < box.size.width &&
          pos.dy < box.size.height) {
        if (dragEnableConfig(item.index)) {
          return item.index;
        }
      }
    }
    return defaultIndex;
  }

  Offset getOffsetInDrag(int index) {
    if (_dragInfo == null || _dropIndex == null || _dragIndex == _dropIndex) {
      return Offset.zero;
    }

    // ok now we check.
    bool inDragRange = false;
    final bool isMoveLeft = _dropIndex! > _dragIndex!;

    final int minPos = min(_dragIndex!, _dropIndex!);
    final int maxPos = max(_dragIndex!, _dropIndex!);

    if (index >= minPos && index <= maxPos) {
      inDragRange = true;
    }

    if (!inDragRange) {
      return Offset.zero;
    } else {
      final preIndex = _findPreviousCanDrag(index);
      final nextIndex = _findNextCanDrag(index);
      if (isMoveLeft) {
        if (!containsByIndex(preIndex) || !containsByIndex(index)) {
          return Offset.zero;
        }
        return getPosByIndex(preIndex) - getPosByIndex(index);
      } else {
        if (!containsByIndex(nextIndex) || !containsByIndex(index)) {
          return Offset.zero;
        }
        return getPosByIndex(nextIndex) - getPosByIndex(index);
      }
    }
  }

  int _findPreviousCanDrag(int start) {
    for (var i = start - 1; i >= 0; i--) {
      if (dragEnableConfig(i)) {
        return i;
      }
    }
    return -1;
  }

  int _findNextCanDrag(int start) {
    final max = __items.keys.reduce((a, b) => a > b ? a : b);
    for (var i = start + 1; i <= max; i++) {
      if (dragEnableConfig(i)) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSliver ?? false || !(widget.restrictDragScope ?? false)) {
      return widget.child;
    }
    return Stack(children: [widget.child, Overlay(key: overlayKey)]);
  }

  // position is the global position
  Drag _onDragStart(Offset position) {
    // how can I delay for take snapshot?
    debugPrint('_onDragStart: $position, __dragIndex: $_dragIndex');
    assert(_dragInfo == null);
    widget.onDragStart?.call(_dragIndex!);

    final ReorderableItemViewState item = __items[_dragIndex!]!;

    _dropIndex = _dragIndex;

    if (_dropIndex != null) {
      widget.onDropIndexChange?.call(_dropIndex!, null);
    }

    _dragInfo = DragInfo(
      item: item,
      tickerProvider: this,
      overlay: getOverlay(),
      context: context,
      dragWidgetBuilder: widget.dragWidgetBuilder,
      scrollSpeedController: widget.scrollSpeedController,
      onStart: _onDragStart,
      dragPosition: position,
      onUpdate: _onDragUpdate,
      onCancel: _onDragCancel,
      onEnd: _onDragEnd,
      readyCallback: () {
        item
          ..dragging = true
          ..rebuild();
        unawaited(updateDragTarget());
      },
    );

    // ok, how about at here, do a capture?
    // _dragInfo!.startDrag();
    unawaited(_startDrag(item));

    return _dragInfo!;
  }

  Future<void> _startDrag(ReorderableItemViewState item) async {
    if (_dragInfo == null) return;

    if (widget.dragWidgetBuilder?.takeScreenshot ?? false) {
      final ui.Image? screenshot = await takeScreenShot(item);

      final ByteData? byteData = await screenshot?.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        _dragInfo?.startDrag(MemoryImage(byteData.buffer.asUint8List()));
        return;
      }
    }

    _dragInfo?.startDrag(null);
  }

  void _onDragUpdate(DragInfo item, Offset position, Offset delta) {
    widget.onDragUpdate?.call(_dragIndex!, position, delta);
    unawaited(updateDragTarget());
  }

  void _onDragCancel(DragInfo item) {
    _dragReset();
    setState(() {});
  }

  void _onDragEnd(DragInfo item) {
    widget.onReorder(_dragIndex!, _dropIndex!);
    _dragReset();
  }

  // ok, drag is end.
  void _dragReset() {
    if (_dragIndex != null) {
      if (__items.containsKey(_dragIndex!)) {
        final ReorderableItemViewState _ =
            __items[_dragIndex!]!
              ..dragging = false
              ..rebuild();
      }

      _dragIndex = null;
      _dropIndex = null;

      for (final item in __items.values) {
        item.resetGap();
      }
    }

    _recognizer?.dispose();
    _recognizer = null;

    _dragInfo?.dispose();
    _dragInfo = null;
  }

  // stock at here.
  static ReorderableGridStateMixin of(BuildContext context) {
    return context.findAncestorStateOfType<ReorderableGridStateMixin>()!;
  }

  // Places the value from startIndex one space before the element at endIndex.
  void reorder(int startIndex, int endIndex) {
    // what to do??
    setState(() {
      if (startIndex != endIndex) widget.onReorder(startIndex, endIndex);
      // Animates leftover space in the drop area closed.
    });
  }

  final Map<int, ReorderableItemViewState> __items =
      <int, ReorderableItemViewState>{};

  DragInfo? _dragInfo;

  void registerItem(ReorderableItemViewState item) {
    __items[item.index] = item;
    if (item.index == _dragInfo?.index) {
      item
        ..dragging = true
        ..rebuild();
    }
  }

  void unRegisterItem(int index, ReorderableItemViewState item) {
    // why you check the item?
    final current = __items[index];
    if (current == item) {
      __items.remove(index);
    }
  }

  Future<void> updateDragTarget() async {
    final int newTargetIndex = _calcDropIndex(_dropIndex!);
    if (newTargetIndex != _dropIndex) {
      widget.onDropIndexChange?.call(newTargetIndex, _dropIndex);
      _dropIndex = newTargetIndex;
      for (final item in __items.values) {
        item.updateForGap(_dropIndex!);
      }
    }
  }
}
