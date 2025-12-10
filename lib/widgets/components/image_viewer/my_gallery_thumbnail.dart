import 'package:flutter/material.dart';

import '../../../index.dart';

// to show image in Row
class MyGalleryThumbnail extends StatelessWidget {
  const MyGalleryThumbnail({
    required this.image,
    required this.onTap,
    required this.radius,
    required this.loadingWidget,
    required this.errorWidget,
    super.key,
  });

  final MyImageModel image;
  final GestureTapCallback? onTap;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return MyGestureDetector(
      onTap: onTap,
      child: Hero(
        tag: image.id,
        child: MyImage(
          source: image.source,
          fit: BoxFit.cover,
          loader: loadingWidget,
          error: errorWidget,
        ),
      ),
    );
  }
}
