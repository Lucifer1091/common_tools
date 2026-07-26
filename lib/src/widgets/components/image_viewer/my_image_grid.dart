import 'package:flutter/material.dart';

import '../../../constants/my_radius.dart';
import '../../common/my_gesture_detector.dart';
import '../image/my_image.dart';
import '../text/my_text.dart';

class MyImageGrid extends StatelessWidget {
  const MyImageGrid({
    required this.images,
    this.gridDelegate,
    super.key,
    this.numOfShowImages = 3,
    this.colorOfNumberWidget,
    this.textStyleOfNumberWidget,
    this.padding = EdgeInsets.zero,
    this.loader,
    this.error,
    this.radius,
    this.reverse = false,
    this.onTap,
  });

  final List<Object?> images;
  final int numOfShowImages;
  final SliverGridDelegate? gridDelegate;
  final EdgeInsetsGeometry padding;
  final Color? colorOfNumberWidget;
  final TextStyle? textStyleOfNumberWidget;
  final Widget? loader;
  final Widget? error;
  final BorderRadius? radius;
  final bool reverse;
  final void Function(List<Object?> images, int index)? onTap;

  int get count {
    if (numOfShowImages > images.length || images.length <= 3) {
      return images.length;
    }

    return numOfShowImages;
  }

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? const SizedBox.shrink()
        : GridView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: count,
            padding: padding,
            gridDelegate:
                gridDelegate ??
                SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 72,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
            itemBuilder: (BuildContext context, int index) {
              return _isLastItem(index)
                  ? _buildImageNumbers(index)
                  : _MyGalleryThumbnail(
                      image: images[index],
                      loader: loader,
                      error: error,
                      radius: radius,
                      onTap: () => onTap?.call(images, index),
                    );
            },
          );
  }

  // build last image with number for other images
  Widget _buildImageNumbers(int index) {
    return MyGestureDetector(
      onTap: () => onTap?.call(images, index),
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          _MyGalleryThumbnail(
            image: images[index],
            loader: loader,
            error: error,
            radius: radius,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius ?? MyBorderRadius.medium,
              color: colorOfNumberWidget ?? Colors.black.withValues(alpha: .6),
            ),
            child: Center(
              child: MyText(
                '+${images.length - index}',
                style:
                    textStyleOfNumberWidget ??
                    const TextStyle(color: Colors.white, fontSize: 36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Check if item is last image in grid to view image or number
  bool _isLastItem(int index) {
    return index < images.length - 1 && index == numOfShowImages - 1;
  }
}

class _MyGalleryThumbnail extends StatelessWidget {
  const _MyGalleryThumbnail({
    required this.image,
    this.radius,
    this.loader,
    this.error,
    this.onTap,
  });

  final Object? image;
  final VoidCallback? onTap;
  final Widget? loader;
  final Widget? error;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return MyGestureDetector(
      onTap: onTap,
      child: MyImage(
        source: image,
        fit: BoxFit.cover,
        loader: loader,
        error: error,
        borderRadius: radius,
      ),
    );
  }
}
