import 'package:flutter/material.dart';

import '../../../index.dart';

// to show image in Row
class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail({
    required this.galleryItem,
    required this.onTap,
    required this.radius,
    required this.loadingWidget,
    required this.errorWidget,
    super.key,
  });

  final GalleryItemModel galleryItem;
  final GestureTapCallback? onTap;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: galleryItem.id,
        child: MyImage(
          image: galleryItem.imageUrl,
          fit: BoxFit.cover,
          loader: loadingWidget,
          error: errorWidget,
        ),
      ),
    );
  }
}
