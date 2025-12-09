import 'package:flutter/material.dart';

import '../../../index.dart';

// to view image in full screen
class GalleryImageViewWrapper extends StatefulWidget {
  const GalleryImageViewWrapper({
    required this.galleryItems,
    required this.minScale,
    required this.maxScale,
    required this.radius,
    required this.reverse,
    required this.showListInGalley,
    required this.showAppBar,
    required this.closeWhenSwipeUp,
    required this.closeWhenSwipeDown,
    this.titleGallery,
    this.backgroundColor,
    this.initialIndex,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  final Color? backgroundColor;
  final int? initialIndex;
  final List<GalleryItemModel> galleryItems;
  final String? titleGallery;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double minScale;
  final double maxScale;
  final double radius;
  final bool reverse;
  final bool showListInGalley;
  final bool showAppBar;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;

  @override
  State<StatefulWidget> createState() {
    return _GalleryImageViewWrapperState();
  }
}

class _GalleryImageViewWrapperState extends State<GalleryImageViewWrapper> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex ?? 0,
  );
  int _currentPage = 0;

  @override
  void initState() {
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.toInt() ?? 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.showAppBar
              ? AppBar(title: Text(widget.titleGallery ?? 'Gallery'))
              : null,
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (widget.closeWhenSwipeUp &&
                        details.primaryVelocity! < 0) {
                      //'up'
                      Navigator.of(context).pop();
                    }
                    if (widget.closeWhenSwipeDown &&
                        details.primaryVelocity! > 0) {
                      // 'down'
                      Navigator.of(context).pop();
                    }
                  },
                  child: PageView.builder(
                    reverse: widget.reverse,
                    controller: _controller,
                    itemCount: widget.galleryItems.length,
                    itemBuilder:
                        (context, index) =>
                            _buildImage(widget.galleryItems[index]),
                  ),
                ),
              ),
              if (widget.showListInGalley)
                SizedBox(
                  height: 80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          widget.galleryItems.map(_buildLitImage).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // build image with zooming
  Widget _buildImage(GalleryItemModel item) {
    return Hero(
      tag: item.id,
      child: InteractiveViewer(
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: Center(
          child: MyImage(
            image: item.imageUrl,
            loader: widget.loadingWidget,
            error: widget.errorWidget,
            // radius: widget.radius,
          ),
        ),
      ),
    );
  }

  // build image with zooming
  Widget _buildLitImage(GalleryItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.jumpToPage(item.index);
          });
        },
        child: MyImage(
          image: item.imageUrl,
          height: _currentPage == item.index ? 70 : 60,
          width: _currentPage == item.index ? 70 : 60,
          fit: BoxFit.cover,
          error: widget.errorWidget,
          loader: widget.loadingWidget,
        ),
      ),
    );
  }
}
