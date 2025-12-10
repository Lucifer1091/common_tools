import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyImageViewer extends StatefulWidget {
  const MyImageViewer({
    required this.images,
    super.key,
    this.titleGallery,
    this.childAspectRatio = 1,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 5,
    this.crossAxisSpacing = 5,
    this.numOfShowImages = 3,
    this.colorOfNumberWidget,
    this.textStyleOfNumberWidget,
    this.padding = EdgeInsets.zero,
    this.loadingWidget,
    this.errorWidget,
    this.galleryBackgroundColor = Colors.black,
    this.minScale = .5,
    this.maxScale = 10,
    this.imageRadius = 8,
    this.reverse = false,
    this.showListInGalley = true,
    this.showAppBar = true,
    this.closeWhenSwipeUp = false,
    this.closeWhenSwipeDown = false,
  }) : assert(numOfShowImages <= images.length, '');

  final List<Object?> images;
  final String? titleGallery;
  final int numOfShowImages;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;
  final Color? colorOfNumberWidget;
  final Color galleryBackgroundColor;
  final TextStyle? textStyleOfNumberWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double minScale;
  final double maxScale;
  final double imageRadius;
  final bool reverse;
  final bool showListInGalley;
  final bool showAppBar;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;

  @override
  State<MyImageViewer> createState() => _MyImageViewerState();
}

class _MyImageViewerState extends State<MyImageViewer> {
  List<MyImageModel> galleryItems = <MyImageModel>[];

  @override
  void initState() {
    _buildItemsList(widget.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return galleryItems.isEmpty
        ? const NoWidget()
        : GridView.builder(
          primary: false,
          itemCount:
              galleryItems.length > 3
                  ? widget.numOfShowImages
                  : galleryItems.length,
          padding: widget.padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: widget.childAspectRatio,
            crossAxisCount: widget.crossAxisCount,
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
          ),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return _isLastItem(index)
                ? _buildImageNumbers(index)
                : MyGalleryThumbnail(
                  image: galleryItems[index],
                  onTap: () {
                    unawaited(_openImageFullScreen(index));
                  },
                  loadingWidget: widget.loadingWidget,
                  errorWidget: widget.errorWidget,
                  radius: widget.imageRadius,
                );
          },
        );
  }

  // build image with number for other images
  Widget _buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        unawaited(_openImageFullScreen(index));
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          MyGalleryThumbnail(
            image: galleryItems[index],
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            onTap: null,
            radius: widget.imageRadius,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.imageRadius)),
            child: ColoredBox(
              color:
                  widget.colorOfNumberWidget ??
                  Colors.black.withValues(alpha: .7),
              child: Center(
                child: Text(
                  '+${galleryItems.length - index}',
                  style:
                      widget.textStyleOfNumberWidget ??
                      const TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Check if item is last image in grid to view image or number
  bool _isLastItem(int index) {
    return index < galleryItems.length - 1 &&
        index == widget.numOfShowImages - 1;
  }

  // to open gallery image in full screen
  Future<void> _openImageFullScreen(int indexOfImage) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return GalleryImageViewWrapper(
            titleGallery: widget.titleGallery,
            galleryItems: galleryItems,
            backgroundColor: widget.galleryBackgroundColor,
            initialIndex: indexOfImage,
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            maxScale: widget.maxScale,
            minScale: widget.minScale,
            reverse: widget.reverse,
            showListInGalley: widget.showListInGalley,
            showAppBar: widget.showAppBar,
            closeWhenSwipeUp: widget.closeWhenSwipeUp,
            closeWhenSwipeDown: widget.closeWhenSwipeDown,
            radius: widget.imageRadius,
          );
        },
      ),
    );
  }

  // clear and build list
  void _buildItemsList(List<Object?> items) {
    galleryItems.clear();
    for (final item in items) {
      galleryItems.add(
        MyImageModel(
          id: item.toString(),
          source: item,
          index: items.indexOf(item),
        ),
      );
    }
  }
}
