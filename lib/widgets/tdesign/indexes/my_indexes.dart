import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../extensions/iterable/index.dart';
import 'my_indexes_anchor.dart';
import 'my_indexes_list.dart';
import 'sticky_header/sticky_header_widget.dart';

export 'my_indexes_anchor.dart';
export 'my_indexes_list.dart';
export 'sticky_header/sticky_header_widget.dart';

class MyIndexes extends StatefulWidget {
  const MyIndexes({
    required this.builder,
    super.key,
    this.indexList,
    this.indexListMaxHeight = 0.8,
    this.sticky = true,
    this.stickyOffset = 0,
    this.capsuleTheme = false,
    this.reverse = false,
    this.scrollController,
    this.onChange,
    this.onSelect,
    this.anchorBuilder,
    this.indexBuilder,
  });

  /// Index character list. If not passed, the default is A-Z
  final List<String>? indexList;

  /// Maximum height of the index list (percentage of parent container height, default 0.8)
  final double? indexListMaxHeight;

  final bool? sticky;

  final double? stickyOffset;

  final bool? capsuleTheme;

  final bool? reverse;

  final ScrollController? scrollController;

  final void Function(String index)? onChange;

  final void Function(String index)? onSelect;

  final Widget? Function(BuildContext context, String index) builder;

  final Widget? Function(
    BuildContext context,
    String index,
    bool isPinnedToTop,
  )?
  anchorBuilder;

  final Widget Function(BuildContext context, String index, bool isActive)?
  indexBuilder;

  @override
  _MyIndexesState createState() => _MyIndexesState();
}

class _MyIndexesState extends State<MyIndexes> {
  late List<String> _indexList;
  late ValueNotifier<String> _activeIndex;
  late ScrollController _scrollController;
  final _anchorKeys = <String, BuildContext>{};
  final _contentKeys = <String, BuildContext>{};
  var _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _indexList = widget.indexList ?? _azList();
    _activeIndex = ValueNotifier(_indexList.getOrNull(0) ?? '');
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void didUpdateWidget(MyIndexes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indexList != oldWidget.indexList) {
      _indexList = widget.indexList ?? _azList();
      _activeIndex = ValueNotifier(_indexList.getOrNull(0) ?? '');
    }
    if (widget.scrollController != oldWidget.scrollController) {
      _scrollController.dispose();
      _scrollController = widget.scrollController ?? ScrollController();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          reverse: widget.reverse ?? false,
          slivers: _slivers(),
        ),
        MyIndexesList(
          indexList: _indexList,
          activeIndex: _activeIndex,
          onSelect: (newIndex, oldIndex) {
            widget.onSelect?.call(newIndex);
            widget.onChange?.call(newIndex);
            _scrollToTarget(newIndex, oldIndex);
          },
          indexListMaxHeight: widget.indexListMaxHeight ?? 0.8,
          indexBuilder: widget.indexBuilder,
        ),
      ],
    );
  }

  List<Widget> _slivers() {
    final capsuleTheme = widget.capsuleTheme ?? false;
    final stickyOffset = widget.stickyOffset ?? 0;
    _anchorKeys.clear();
    _contentKeys.clear();
    return _indexList.map((index) {
      final isPinnedOffset = capsuleTheme && _activeIndex.value == index;

      return SliverStickyHeader.builder(
        sticky: widget.sticky ?? true,
        pinnedOffset: isPinnedOffset ? 8 + stickyOffset : stickyOffset,
        builder: (context, state) {
          _anchorKeys[index] = context;

          if (state.isPinned && _activeIndex.value != index && !_isAnimating) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _activeIndex.value = index;
              widget.onChange?.call(index);
            });
          }

          return MyIndexesAnchor(
            text: index,
            capsuleTheme: capsuleTheme,
            activeIndex: _activeIndex,
            anchorBuilder: widget.anchorBuilder,
            sticky: widget.sticky ?? true,
          );
        },
        sliver: SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              _contentKeys[index] = context;
              return Padding(
                padding:
                    isPinnedOffset ? EdgeInsets.only(top: 8) : EdgeInsets.zero,
                child: widget.builder(context, index),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  List<String> _azList() {
    final azList = <String>[];
    for (var i = 65; i <= 90; i++) {
      azList.add(String.fromCharCode(i));
    }
    return azList;
  }

  void _scrollToTarget(String newIndex, String oldIndex) {
    _isAnimating = true;

    /// isUp: Whether (finger) slides up
    final isUp = _indexList.indexOf(newIndex) > _indexList.indexOf(oldIndex);
    if (isUp) {
      var index = oldIndex;
      final contentRenderBox =
          _contentKeys[index]?.findRenderObject() as RenderBox?;
      if (contentRenderBox != null) {
        final contentHeight = contentRenderBox.size.height;
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final targetOffset = contentRenderBox.localToGlobal(
          Offset(0, contentHeight),
          ancestor: context.findRenderObject(),
        );
        final scrollOffset = targetOffset.dy + _scrollController.offset;
        _scrollController.jumpTo(min(maxScrollExtent, scrollOffset));
      }
      index = _indexList[_indexList.indexOf(index) + 1];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (index != newIndex) {
          _scrollToTarget(newIndex, index);
        } else {
          _isAnimating = false;
        }
      });
    } else {
      final anchorContext = _anchorKeys[newIndex];
      if (anchorContext != null) {
        unawaited(
          Scrollable.ensureVisible(anchorContext).then((value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _isAnimating = false;
            });
          }),
        );
      }
    }
  }
}
