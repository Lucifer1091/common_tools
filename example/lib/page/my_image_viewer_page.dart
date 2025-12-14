import 'package:common_tools/index.dart';
import 'package:example/base/app_bar.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyImageViewerPage extends StatefulWidget {
  const MyImageViewerPage({super.key});

  @override
  State<MyImageViewerPage> createState() => _MyImageViewerPageState();
}

class _MyImageViewerPageState extends State<MyImageViewerPage> {
  static const images = [
    'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68',
    'https://fastly.picsum.photos/id/11/2500/1667.jpg?hmac=xxjFJtAPgshYkysU_aqx2sZir-kIOjNR9vx0te7GycQ',
    'https://fastly.picsum.photos/id/12/2500/1667.jpg?hmac=Pe3284luVre9ZqNzv1jMFpLihFI6lwq7TPgMSsNXw2w',
    'https://fastly.picsum.photos/id/13/2500/1667.jpg?hmac=SoX9UoHhN8HyklRA4A3vcCWJMVtiBXUg0W4ljWTor7s',
    'https://fastly.picsum.photos/id/14/2500/1667.jpg?hmac=ssQyTcZRRumHXVbQAVlXTx-MGBxm6NHWD3SryQ48G-o',
    'https://fastly.picsum.photos/id/15/2500/1667.jpg?hmac=Lv03D1Y3AsZ9L2tMMC1KQZekBVaQSDc1waqJ54IHvo4',
    'https://fastly.picsum.photos/id/16/2500/1667.jpg?hmac=uAkZwYc5phCRNFTrV_prJ_0rP0EdwJaZ4ctje2bY7aE',
    'https://fastly.picsum.photos/id/17/2500/1667.jpg?hmac=HD-JrnNUZjFiP2UZQvWcKrgLoC_pc_ouUSWv8kHsJJY',
    'https://fastly.picsum.photos/id/866/2500/1667.jpg?hmac=GMpuR2w6Wuw6O0JTbndbEDLddIld1Vbrlc5XsxBdM1k',
    'https://fastly.picsum.photos/id/29/4000/2670.jpg?hmac=rCbRAl24FzrSzwlR5tL-Aqzyu5tX_PA95VJtnUXegGU',
    'https://fastly.picsum.photos/id/28/4928/3264.jpg?hmac=GnYF-RnBUg44PFfU5pcw_Qs0ReOyStdnZ8MtQWJqTfA',
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
            ExampleItem(desc: 'Image Grid', builder: _imageGrid),
            ExampleItem(desc: 'Image Viewer', builder: _imageViewer),
            ExampleItem(desc: 'Open Image Viewer', builder: _imageViewerDialog),
          ],
        ),
        ExampleModule(
          title: 'Component Styles',
          children: [
            ExampleItem(
              desc: 'Image Viewer Thumbnails on Left',
              builder: (context) {
                return _imageViewer(
                  context,
                  alignment: MyThumbnailAlignment.left,
                );
              },
            ),
            ExampleItem(
              desc: 'Image Viewer Thumbnails on Right',
              builder: (context) {
                return _imageViewer(
                  context,
                  alignment: MyThumbnailAlignment.right,
                );
              },
            ),
            ExampleItem(
              desc: 'Image Viewer Over Slider',
              builder: (context) {
                return _imageViewer(
                  context,
                  style: MyThumbnailStyle.overSlider,
                  alignment: MyThumbnailAlignment.left,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _imageGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MyImageGrid(
        images: images,
        numOfShowImages: 6,
        onTap: (items, index) {
          _openImageViewer(index);
        },
      ),
    );
  }

  Widget _imageViewer(
    BuildContext context, {
    MyThumbnailStyle style = MyThumbnailStyle.nextToSlider,
    MyThumbnailAlignment alignment = MyThumbnailAlignment.bottom,
  }) {
    return MyImageViewer(
      images: images,
      style: style,
      thumbnailAlignment: alignment,
    );
  }

  Widget _imageViewerDialog(BuildContext context) {
    return MyButton(
      text: 'Open Gallery',
      onTap: () {
        _openImageViewer();
      },
    );
  }

  Future<void> _openImageViewer([int indexOfImage = 0]) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return FullScreenImageViewer(
            images: images,
            initialIndex: indexOfImage,
          );
        },
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<Object?> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: MyAppBar(title: 'Image Viewer'),
      body: MyImageViewer(
        images: images,
        initialIndex: initialIndex,
        fit: BoxFit.fitWidth,
        builder: (context, viewer, thumbnails) {
          return Column(
            children: [
              Expanded(child: viewer),
              const Gap(8),
              thumbnails,
              const Gap(16),
            ],
          );
        },
      ),
    );
  }
}
