import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../text/my_text.dart';

class MyIndexesList extends StatefulWidget {
  const MyIndexesList({
    required this.indexList,
    required this.activeIndex,
    required this.onSelect,
    super.key,
    this.indexListMaxHeight = 0.8,
    this.indexBuilder,
  });

  /// Index character list. If not passed, the default is A-Z
  final List<String> indexList;

  /// Maximum height of the index list (percentage of parent container height, default 0.8)
  final double indexListMaxHeight;

  final ValueNotifier<String> activeIndex;

  final void Function(String newIndex, String oldIndex) onSelect;

  final Widget Function(BuildContext context, String index, bool isActive)?
  indexBuilder;

  @override
  State<MyIndexesList> createState() => _MyIndexesListState();
}

class _MyIndexesListState extends State<MyIndexesList> {
  late Map<String, GlobalKey> _containerKeys;
  final _indexSize = 20.0;
  Timer? _hideTipTimer;
  var _showTip = false;

  @override
  void initState() {
    super.initState();
    _containerKeys = widget.indexList.asMap().map(
      (index, e) => MapEntry(e, GlobalKey()),
    );
  }

  @override
  void didUpdateWidget(MyIndexesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indexList != oldWidget.indexList) {
      _containerKeys = widget.indexList.asMap().map(
        (index, e) => MapEntry(e, GlobalKey()),
      );
    }
  }

  @override
  void dispose() {
    _hideTipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      top: 0,
      bottom: 0,
      child: Align(
        child: FractionallySizedBox(
          heightFactor: widget.indexListMaxHeight,
          child: Align(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) {
                _changeSelect(details.globalPosition);
              },
              onTapUp: (details) {
                _changeSelect(details.globalPosition);
                _hideTip();
              },
              onVerticalDragEnd: (details) {
                _hideTip();
              },
              child: ValueListenableBuilder(
                valueListenable: widget.activeIndex,
                builder: (context, value, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.indexList.map((e) {
                      final isActive = value == e;
                      if (widget.indexBuilder != null) {
                        return Container(
                          key: _containerKeys[e],
                          child: widget.indexBuilder!(context, e, isActive),
                        );
                      }
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (_showTip && value == e)
                            Positioned(
                              top: -48 / 2 + _indexSize / 2,
                              left: -48,
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  borderRadius: MyBorderRadius.round,
                                  color: context.colorScheme.secondary,
                                ),
                                child: Center(
                                  child: MyText(
                                    e,
                                    style: context.displaySmall,
                                    textColor:
                                        context.colorScheme.secondaryForeground,
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            key: _containerKeys[e],
                            padding: EdgeInsets.only(left: 8),
                            color: Colors.transparent,
                            child: Container(
                              width: _indexSize,
                              height: _indexSize,
                              decoration: isActive
                                  ? BoxDecoration(
                                      borderRadius: MyBorderRadius.round,
                                      color: context.colorScheme.primary,
                                    )
                                  : null,
                              child: Center(
                                child: MyText(
                                  e,
                                  style: isActive
                                      ? context.bodySmall
                                      : context.labelSmall,
                                  textColor: isActive
                                      ? context.colorScheme.primaryForeground
                                      : context.colorScheme.foreground,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changeSelect(Offset globalPosition) {
    final newIndex = _fingerInsideContainer(globalPosition);
    if (newIndex != null && newIndex != widget.activeIndex.value) {
      final oldIndex = widget.activeIndex.value;
      widget.activeIndex.value = newIndex;
      _showTip = true;
      widget.onSelect.call(newIndex, oldIndex);
    }
  }

  String? _fingerInsideContainer(Offset globalPosition) {
    for (final entry in _containerKeys.entries) {
      final renderBox =
          entry.value.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final localPosition = renderBox.globalToLocal(globalPosition);
        final isIn = renderBox.hitTest(
          BoxHitTestResult(),
          position: localPosition,
        );

        if (isIn) return entry.key;
      }
    }
    return null;
  }

  void _hideTip() {
    _hideTipTimer?.cancel();
    _hideTipTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        _showTip = false;
      });
    });
  }
}
