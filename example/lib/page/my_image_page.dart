import 'package:flutter/material.dart';

import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

import 'dart:io';

class MyImagePage extends StatefulWidget {
  const MyImagePage({super.key});

  @override
  State<StatefulWidget> createState() => MyImageState();
}

class MyImageState extends State<MyImagePage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    animation = Tween(begin: 0.0, end: 4.0).animate(animationController);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  static const images = [
    'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://fastly.picsum.photos/id/15/2500/1667.jpg?hmac=Lv03D1Y3AsZ9L2tMMC1KQZekBVaQSDc1waqJ54IHvo4',
    'https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68',
    'https://fastly.picsum.photos/id/12/2500/1667.jpg?hmac=Pe3284luVre9ZqNzv1jMFpLihFI6lwq7TPgMSsNXw2w',
    'https://fastly.picsum.photos/id/17/2500/1667.jpg?hmac=HD-JrnNUZjFiP2UZQvWcKrgLoC_pc_ouUSWv8kHsJJY',
    'https://fastly.picsum.photos/id/16/2500/1667.jpg?hmac=uAkZwYc5phCRNFTrV_prJ_0rP0EdwJaZ4ctje2bY7aE',
    'https://fastly.picsum.photos/id/16/2500/1667.jpg?hmac=uAkZwYc5phCRNFTrV_prJ_0rP0EdwJaZ4ctje2bY7aE',
    'https://fastly.picsum.photos/id/16/2500/1667.jpg?hmac=uAkZwYc5phCRNFTrV_prJ_0rP0EdwJaZ4ctje2bY7aE',
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'image',
      desc:
          'Used for displaying images, it mainly involves centering, stretching, and tiling in various ways.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              builder: (context) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 24,
                    children: [_imageClip(context), _imageStretch(context)],
                  ),
                );
              },
            ),
            ExampleItem(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              builder: (context) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 24,
                    children: [
                      _imageFitHeight(context),
                      _imageFitWidth(context),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              builder: (context) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 24,
                    children: [
                      _imageSquare(context),
                      _imageSquircle(context),
                      _imageCircle(context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              builder: (context) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 24,
                    children: [
                      _loadingDefault(context),
                      _loadingCustom(context),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              builder: (context) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 24,
                    children: [
                      _failDefault(context),
                      _failCustom(context),
                      _imageFile(context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Styles',
          children: [
            ExampleItem(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              builder: (context) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 24,
                    children: [
                      _enableZoom(context),
                      _enableScaleAnimation(context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _imageClip(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Clip', style: context.textTheme.bodyMedium),
        ),
        const MyImage(image: 'assets/img/image.png', type: MyImageType.clip),
      ],
    );
  }

  Widget _imageStretch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Stretch', style: context.textTheme.bodyMedium),
        ),
        Container(
          color: Colors.black,
          width: 121,
          height: 72,
          child: const Stack(
            alignment: Alignment.center,
            children: [
              MyImage(
                image: 'assets/img/image.png',
                width: 121,
                height: 50,
                type: MyImageType.stretch,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageFitHeight(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Fit Height', style: context.textTheme.bodyMedium),
        ),
        Container(
          width: 89,
          height: 72,
          color: Colors.black,
          child: const MyImage(
            image: 'assets/img/image.png',
            type: MyImageType.fitHeight,
          ),
        ),
      ],
    );
  }

  Widget _imageFitWidth(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Fit Width', style: context.textTheme.bodyMedium),
        ),
        Container(
          width: 72,
          height: 89,
          color: Colors.black,
          child: const MyImage(
            image: 'assets/img/image.png',
            type: MyImageType.fitWidth,
          ),
        ),
      ],
    );
  }

  Widget _imageSquare(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Square', style: context.textTheme.bodyMedium),
        ),
        const MyImage(image: 'assets/img/image.png', type: MyImageType.square),
      ],
    );
  }

  Widget _imageSquircle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Squircle', style: context.textTheme.bodyMedium),
        ),
        const MyImage(image: 'assets/img/image.png', width: 72, height: 72),
      ],
    );
  }

  Widget _imageCircle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Circle', style: context.textTheme.bodyMedium),
        ),
        const MyImage(
          image: 'assets/img/image.png',
          width: 72,
          height: 72,
          type: MyImageType.circle,
        ),
      ],
    );
  }

  Widget _loadingDefault(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Default Loader', style: context.textTheme.bodyMedium),
        ),
        MyImage(image: images.random()),
      ],
    );
  }

  Widget _loadingCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Custom Loader', style: context.textTheme.bodyMedium),
        ),
        MyImage(
          image: images.random(),
          loader: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
              borderRadius: MyBorderRadius.medium,
            ),
            child: Center(
              child: MyLoader(
                size: MyLoaderSize.small,
                icon: MyLoaderIcon.spin,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _failDefault(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Default Error', style: context.textTheme.bodyMedium),
        ),
        const MyImage(image: 'error'),
      ],
    );
  }

  Widget _failCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Custom Error', style: context.textTheme.bodyMedium),
        ),
        MyImage(
          image: 'error',
          error: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
              borderRadius: MyBorderRadius.medium,
            ),
            child: Center(
              child: Icon(
                LucideIcons.fileWarning,
                color: context.colorScheme.mutedForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageFile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Asset Error', style: context.textTheme.bodyMedium),
        ),
        MyImage(image: File('/sdcard/td/test.jpg'), type: MyImageType.square),
      ],
    );
  }

  Widget _enableZoom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Pinch to Zoom', style: context.textTheme.bodyMedium),
        ),
        MyImage(
          height: 400,
          width: 200,
          image: images.random(),
          enableZoom: true,
        ),
      ],
    );
  }

  Widget _enableScaleAnimation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Scale on Hover', style: context.textTheme.bodyMedium),
        ),
        MyImage(
          height: 400,
          width: 200,
          image: images.random(),
          enableScaleAnimation: true,
        ),
      ],
    );
  }
}
