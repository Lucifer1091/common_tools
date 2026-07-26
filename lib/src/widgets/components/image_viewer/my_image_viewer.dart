import 'dart:async';

import 'package:flutter/material.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../themes/my_scroll_wrapper.dart';
import '../../common/my_gesture_detector.dart';
import '../image/my_image.dart';

enum MyThumbnailAlignment { left, right, bottom }

enum MyThumbnailShape { circle, custom }

enum MyThumbnailStyle { overSlider, nextToSlider }

class MyImageViewer extends StatefulWidget {
  const MyImageViewer({
    required this.images,
    super.key,
    this.initialIndex = 0,
    this.aspectRatio = 16 / 9,
    this.fit,
    this.borderRadius,
    this.thumbnailFit,
    this.thumbnailWidth = 55,
    this.thumbnailHeight = 55,
    this.thumbnailAlignment = MyThumbnailAlignment.bottom,
    this.thumbnailBorderRadius,
    this.thumbnailBorderWidth = 2,
    this.thumbnailBorderColor,
    this.style = MyThumbnailStyle.nextToSlider,
    this.minZoom = .5,
    this.maxZoom = 10,
    this.reverse = false,
    this.showThumbnails = true,
    this.builder,
  });

  final int initialIndex;
  final List<Object?> images;
  final double aspectRatio;
  final BoxFit? fit, thumbnailFit;
  final double thumbnailWidth;
  final double thumbnailHeight;
  final MyThumbnailAlignment thumbnailAlignment;
  final Color? thumbnailBorderColor;
  final double thumbnailBorderWidth;
  final BorderRadius? borderRadius, thumbnailBorderRadius;
  final MyThumbnailStyle style;
  final double minZoom;
  final double maxZoom;
  final bool reverse;
  final bool showThumbnails;
  final Widget Function(BuildContext context, Widget viewer, Widget thumbnails)?
  builder;

  @override
  State<MyImageViewer> createState() => _MyImageViewerState();
}

class _MyImageViewerState extends State<MyImageViewer> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;
  late final ScrollController _thumbnailScrollController;
  static const double _paddingOfBorder = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentPageNotifier = ValueNotifier(widget.initialIndex);
    _thumbnailScrollController = ScrollController();
    _currentPageNotifier.addListener(_scrollThumbnailToSelected);
  }

  @override
  void didUpdateWidget(covariant MyImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentPageNotifier.value = widget.initialIndex;
      _pageController.jumpToPage(widget.initialIndex);
      _scrollThumbnailToSelected();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier
      ..removeListener(_scrollThumbnailToSelected)
      ..dispose();
    _thumbnailScrollController.dispose();
    super.dispose();
  }

  void _scrollThumbnailToSelected() {
    if (!_thumbnailScrollController.hasClients) return;

    final selectedIndex = _currentPageNotifier.value;
    final itemExtent = widget.thumbnailWidth;
    final targetOffset = selectedIndex * itemExtent;

    unawaited(
      _thumbnailScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      final bool isVertical = switch (widget.thumbnailAlignment) {
        MyThumbnailAlignment.bottom => false,
        MyThumbnailAlignment.left => true,
        MyThumbnailAlignment.right => true,
      };

      return widget.builder!.call(
        context,
        _buildImageSlider(),
        _buildThumbnail(isVertical: isVertical),
      );
    }

    return switch (widget.style) {
      MyThumbnailStyle.overSlider => _buildTheme1(),
      MyThumbnailStyle.nextToSlider => _buildTheme2(),
    };
  }

  Widget _buildTheme1() {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        children: [
          Positioned.fill(child: _buildImageSlider()),
          if (widget.showThumbnails) _buildThumbnailPosition(),
        ],
      ),
    );
  }

  Widget _buildThumbnailPosition() {
    return switch (widget.thumbnailAlignment) {
      MyThumbnailAlignment.bottom => Positioned(
        left: 0,
        bottom: 5,
        right: 0,
        child: _buildThumbnail(isVertical: false),
      ),
      MyThumbnailAlignment.left => Positioned(
        top: 5,
        left: 10,
        bottom: 5,
        child: _buildThumbnail(isVertical: true),
      ),
      MyThumbnailAlignment.right => Positioned(
        top: 5,
        right: 10,
        bottom: 5,
        child: _buildThumbnail(isVertical: true),
      ),
    };
  }

  Widget _buildTheme2() {
    return widget.thumbnailAlignment == MyThumbnailAlignment.bottom
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: _buildImageSlider(),
              ),
              if (widget.showThumbnails)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: _buildThumbnail(isVertical: false),
                ),
            ],
          )
        : AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Row(
              children: [
                if (widget.showThumbnails &&
                    widget.thumbnailAlignment == MyThumbnailAlignment.left)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildThumbnail(isVertical: true),
                  ),
                Expanded(child: _buildImageSlider()),
                if (widget.showThumbnails &&
                    widget.thumbnailAlignment == MyThumbnailAlignment.right)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildThumbnail(isVertical: true),
                  ),
              ],
            ),
          );
  }

  Widget _buildImageSlider() {
    return PageView.builder(
      reverse: widget.reverse,
      controller: _pageController,
      onPageChanged: (int currentPage) {
        _currentPageNotifier.value = currentPage;
      },
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return MyImage(
          fit: widget.fit,
          width: double.maxFinite,
          height: double.maxFinite,
          source: widget.images[index],
          type: MyImageType.stretch,
          enableZoom: true,
          minZoom: widget.minZoom,
          maxZoom: widget.maxZoom,
        );
      },
    );
  }

  Widget _buildThumbnail({required bool isVertical}) {
    return SizedBox(
      width: isVertical
          ? widget.thumbnailWidth + _paddingOfBorder
          : double.infinity,
      height: isVertical
          ? double.infinity
          : widget.thumbnailHeight + _paddingOfBorder,
      child: ValueListenableBuilder<int>(
        valueListenable: _currentPageNotifier,
        builder: (context, currentIndex, _) {
          return DisableScrollbar(
            child: ListView.builder(
              reverse: widget.reverse,
              controller: _thumbnailScrollController,
              scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
              itemCount: widget.images.length,
              physics: const ClampingScrollPhysics(),
              padding: isVertical ? null : EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                final isSelected = currentIndex == index;
                return _ThumbnailItem(
                  isSelected: isSelected,
                  imageUrl: widget.images[index],
                  onTap: () => _onThumbnailTap(index),
                  width: widget.thumbnailWidth,
                  height: widget.thumbnailHeight,
                  borderRadius: widget.borderRadius ?? MyBorderRadius.small,
                  thumbnailBorderRadius:
                      widget.thumbnailBorderRadius ?? MyBorderRadius.medium,
                  borderColor:
                      widget.thumbnailBorderColor ?? context.colorScheme.ring,
                  borderWidth: widget.thumbnailBorderWidth,
                  paddingOfBorder: _paddingOfBorder,
                  boxFit: widget.thumbnailFit ?? BoxFit.cover,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _onThumbnailTap(int index) async {
    _currentPageNotifier.value = index;
    _pageController.jumpToPage(index);
  }
}

class _ThumbnailItem extends StatelessWidget {
  const _ThumbnailItem({
    required this.isSelected,
    required this.imageUrl,
    required this.onTap,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.thumbnailBorderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.paddingOfBorder,
    this.boxFit,
  });

  final bool isSelected;
  final Object? imageUrl;
  final VoidCallback onTap;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final BorderRadius thumbnailBorderRadius;
  final Color borderColor;
  final double borderWidth;
  final double paddingOfBorder;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return MyGestureDetector(
      onTap: onTap,
      child: Container(
        height: height + paddingOfBorder,
        width: width + paddingOfBorder,
        decoration: BoxDecoration(
          borderRadius: thumbnailBorderRadius,
          border: Border.all(
            width: borderWidth,
            color: isSelected ? borderColor : Colors.transparent,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: MyImage(
            source: imageUrl,
            fit: boxFit,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
