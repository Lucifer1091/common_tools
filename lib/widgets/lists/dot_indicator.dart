import 'dart:async';

import 'package:flutter/material.dart';

import '../../common_tools.dart';

// Use with PageView Widget
class DotIndicator<T> extends StatefulWidget {
  const DotIndicator({
    required this.pageController,
    required this.pages,
    this.indicatorColor,
    this.unselectedIndicatorColor,
    this.onDotTap,
    this.onPageChanged,
    this.selectedSize,
    this.selectedWidth,
    this.size,
    this.selectedBoxShape,
    this.boxShape,
    this.borderRadius,
    this.currentBorderRadius,
    super.key,
  });

  final List<T> pages;
  final Color? indicatorColor;
  final Color? unselectedIndicatorColor;
  final IntCallback? onDotTap;
  final IntCallback? onPageChanged;
  final double? size;
  final double? selectedSize;
  final double? selectedWidth;
  final BoxShape? boxShape;
  final BoxShape? selectedBoxShape;

  final PageController pageController;

  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? currentBorderRadius;

  @override
  DotIndicatorState<T> createState() => DotIndicatorState();
}

class DotIndicatorState<T> extends State<DotIndicator<T>> {
  int selectedIndex = 0;

  @override
  void setState(VoidCallback callback) {
    if (mounted) super.setState(callback);
  }

  @override
  void initState() {
    super.initState();

    widget.pageController.addListener(() {
      selectedIndex = widget.pageController.page!.round();
      widget.onPageChanged?.call(selectedIndex);

      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    // widget.pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            widget.pages.asMap().entries.map((entry) {
              final idx = entry.key;

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  selectedIndex = idx;
                  unawaited(
                    widget.pageController.animateToPage(
                      idx,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                    ),
                  );

                  setState(() {});

                  widget.onDotTap?.call(idx);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height:
                      selectedIndex == idx
                          ? (widget.selectedWidth ?? widget.selectedSize ?? 14)
                          : widget.size ?? 8,
                  width:
                      selectedIndex == idx
                          ? widget.selectedSize ?? 14
                          : widget.size ?? 8,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape:
                        selectedIndex == idx
                            ? widget.selectedBoxShape ?? BoxShape.circle
                            : widget.boxShape ?? BoxShape.circle,
                    color:
                        selectedIndex == idx
                            ? widget.indicatorColor ?? Colors.white
                            : widget.unselectedIndicatorColor ?? Colors.black26,
                    borderRadius:
                        selectedIndex == idx
                            ? widget.currentBorderRadius
                            : widget.borderRadius,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
