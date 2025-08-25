import 'dart:async';

import 'package:flutter/material.dart';

import '../badge/my_badge.dart';
import '../loading/my_loader.dart';
import 'my_sidebar_controller.dart';
import 'my_sidebar_item.dart';
import 'my_wrap_sidebar_item.dart';

enum MySideBarStyle { normal, outline }

class MySideItemProps {
  MySideItemProps({
    required this.value,
    required this.index,
    this.enabled = true,
    this.icon,
    this.label,
    this.badge,
    this.textStyle,
  });

  int index;
  int value;
  bool enabled;
  IconData? icon;
  String? label;
  MyBadge? badge;
  TextStyle? textStyle;
}

class MySideBar extends StatefulWidget {
  const MySideBar({
    super.key,
    this.value,
    this.defaultValue,
    this.selectedColor,
    this.children = const [],
    this.onChanged,
    this.onSelected,
    this.height,
    this.controller,
    this.contentPadding,
    this.selectedTextStyle,
    this.style = MySideBarStyle.normal,
    this.loading,
    this.loadingWidget,
    this.selectedBgColor,
    this.unSelectedBgColor,
  });

  final int? value;

  final int? defaultValue;

  final List<MySideBarItem> children;

  final ValueChanged<int>? onChanged;

  final ValueChanged<int>? onSelected;

  final Color? selectedColor;

  final TextStyle? selectedTextStyle;

  final MySideBarStyle style;

  final double? height;

  final EdgeInsetsGeometry? contentPadding;

  final MySideBarController? controller;

  final bool? loading;

  final Widget? loadingWidget;

  final Color? selectedBgColor;

  final Color? unSelectedBgColor;

  @override
  State<MySideBar> createState() => _MySideBarState();
}

class _MySideBarState extends State<MySideBar> {
  late List<MySideItemProps> displayChildren;
  late int? currentValue;
  late int? currentIndex;
  final _scrollerController = ScrollController();
  final GlobalKey globalKey = GlobalKey();
  final double itemHeight = 56;
  bool _loading = false;

  MySideItemProps findSideItem(int value) {
    return displayChildren.where((element) => element.value == value).first;
  }

  void selectValue(int value, {bool needScroll = false}) {
    MySideItemProps? item;
    for (final element in displayChildren) {
      if (element.value == value) {
        item = element;
      }
    }

    if (needScroll && item != null) {
      try {
        final height = globalKey.currentContext!.size!.height;
        final offset = _scrollerController.offset;
        final distance = item.index * itemHeight - offset;
        if (distance + itemHeight > height) {
          unawaited(
            _scrollerController.animateTo(
              offset + itemHeight,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
            ),
          );
        } else if (distance < 0) {
          unawaited(
            _scrollerController.animateTo(
              offset - itemHeight,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
            ),
          );
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    if (item != null) {
      onSelect(item, isController: true);
    }
  }

  @override
  void initState() {
    super.initState();

    _loading = widget.loading ?? widget.controller?.loading ?? false;

    if (widget.controller != null) {
      widget.controller!.addListener(() {
        selectValue(widget.controller!.currentValue, needScroll: true);
        _loading = widget.controller!.loading;
        getDisplayChildren();
        setState(() {});
      });
    }

    displayChildren =
        widget.children
            .asMap()
            .entries
            .map(
              (entry) => MySideItemProps(
                index: entry.key,
                enabled: entry.value.enabled,
                value: entry.value.value,
                icon: entry.value.icon,
                label: entry.value.label,
                textStyle: entry.value.textStyle,
                badge: entry.value.badge,
              ),
            )
            .toList();

    currentValue =
        widget.value ??
        widget.defaultValue ??
        (displayChildren.isNotEmpty ? displayChildren[0].value : null);

    if (currentValue != null) {
      try {
        final item = findSideItem(currentValue!);
        currentIndex = item.index;
      } catch (e) {
        currentIndex = null;
        currentValue = null;
      }
    } else {
      currentIndex = null;
    }
  }

  void getDisplayChildren() {
    if (widget.controller != null && widget.controller!.children.isNotEmpty) {
      displayChildren =
          widget.controller!.children
              .asMap()
              .entries
              .map(
                (entry) => MySideItemProps(
                  index: entry.key,
                  enabled: entry.value.enabled,
                  value: entry.value.value,
                  icon: entry.value.icon,
                  label: entry.value.label,
                  textStyle: entry.value.textStyle,
                  badge: entry.value.badge,
                ),
              )
              .toList();
    } else if (widget.children.isNotEmpty) {
      displayChildren =
          widget.children
              .asMap()
              .entries
              .map(
                (entry) => MySideItemProps(
                  index: entry.key,
                  enabled: entry.value.enabled,
                  value: entry.value.value,
                  icon: entry.value.icon,
                  label: entry.value.label,
                  textStyle: entry.value.textStyle,
                  badge: entry.value.badge,
                ),
              )
              .toList();
    } else {
      displayChildren = [];
    }
  }

  void onSelect(MySideItemProps item, {bool isController = false}) {
    if (currentIndex != item.index) {
      if (isController) {
        widget.onChanged?.call(item.value);
      } else {
        widget.onSelected?.call(item.value);
      }

      setState(() {
        currentIndex = item.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      widget.controller?.loading = true;

      return widget.loadingWidget ??
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Align(child: MyLoader(size: MyLoaderSize.large)),
          );
    }

    return ConstrainedBox(
      key: globalKey,
      constraints: BoxConstraints(
        minWidth: 106,
        maxHeight:
            MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
      ),

      child: SizedBox(
        height: widget.height ?? MediaQuery.of(context).size.height,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: displayChildren.length,
            controller: _scrollerController,
            itemBuilder: (BuildContext context, int index) {
              final ele = displayChildren[index];

              return MyWrapSideBarItem(
                style: widget.style,
                value: ele.value,
                icon: ele.icon,
                enabled: ele.enabled,
                label: ele.label ?? '',
                badge: ele.badge,
                textStyle: ele.textStyle,
                selected: currentIndex == ele.index,
                selectedColor: widget.selectedColor,
                selectedTextStyle: widget.selectedTextStyle,
                contentPadding: widget.contentPadding,
                topAdjacent:
                    currentIndex != null && currentIndex! + 1 == ele.index,
                bottomAdjacent:
                    currentIndex != null && currentIndex! - 1 == ele.index,
                selectedBgColor: widget.selectedBgColor,
                unSelectedBgColor: widget.unSelectedBgColor,
                onTap: () {
                  if (ele.enabled) onSelect(ele);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
