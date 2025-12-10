import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyImageGalleryPage extends StatefulWidget {
  const MyImageGalleryPage({super.key});

  @override
  State<MyImageGalleryPage> createState() => _MyImageGalleryPageState();
}

class _MyImageGalleryPageState extends State<MyImageGalleryPage> {
  static const images = [
    'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://fastly.picsum.photos/id/15/2500/1667.jpg?hmac=Lv03D1Y3AsZ9L2tMMC1KQZekBVaQSDc1waqJ54IHvo4',
    'https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68',
    'https://fastly.picsum.photos/id/12/2500/1667.jpg?hmac=Pe3284luVre9ZqNzv1jMFpLihFI6lwq7TPgMSsNXw2w',
    'https://fastly.picsum.photos/id/17/2500/1667.jpg?hmac=HD-JrnNUZjFiP2UZQvWcKrgLoC_pc_ouUSWv8kHsJJY',
    'https://fastly.picsum.photos/id/16/2500/1667.jpg?hmac=uAkZwYc5phCRNFTrV_prJ_0rP0EdwJaZ4ctje2bY7aE',
    'https://fastly.picsum.photos/id/16/2500/1667.jpg?hmac=uAkZwYc5phCRNFTrV_prJ_0rP0EdwJaZ4ctje2bY7aE',
    'https://fastly.picsum.photos/id/16/2500/1667.jpg?hmac=uAkZwYc5phCRNFTrV_prJ_0rP0EdwJaZ4ctje2bY7aE',
    "https://wallpapers.com/images/featured/2ygv7ssy2k0lxlzu.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Used for displaying and viewing thumbnails of image content.',
      exampleCodeGroup: 'image_viewer',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Show Partial Gallery',
              builder: _actionImageViewer,
            ),
            ExampleItem(desc: 'Open Galley on Tap', builder: _basicImageViewer),
          ],
        ),
      ],
    );
  }

  Widget _actionImageViewer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MyImageGallery(numOfShowImages: 6, images: images),
    );
  }

  Widget _basicImageViewer(BuildContext context) {
    return MyButton(
      text: 'Open Galley',
      onTap: () {
        // TDImageViewer.showImageViewer(context: context, images: images);
      },
    );
  }
}
