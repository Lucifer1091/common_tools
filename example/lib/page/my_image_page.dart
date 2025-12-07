import 'package:flutter/material.dart';

import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

import 'dart:io';

class MyImagePage extends StatefulWidget {
  const MyImagePage({super.key});

  @override
  State<StatefulWidget> createState() => TDImageState();
}

class TDImageState extends State<MyImagePage>
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
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 8),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _imageClip(context),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _imageStretch(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 8),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _imageFitHeight(context),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _imageFitWidth(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 8),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _imageSquare(context),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _imageRoundedSquare(context),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _imageCircle(context),
                      ),
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
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 8),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _loadingDefault(context),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _loadingCustom(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            // ExampleItem(
            //   builder: (context) {
            //     return Container(
            //       alignment: Alignment.topLeft,
            //       padding: const EdgeInsets.only(left: 8),
            //       child: Wrap(
            //         children: [
            //           Container(
            //             margin: const EdgeInsets.all(8),
            //             child: _failDefault(context),
            //           ),
            //           Container(
            //             margin: const EdgeInsets.all(8),
            //             child: _failCustom(context),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ],
      // test: [
      //   ExampleItem(
      //     builder: (context) {
      //       return Container(
      //         alignment: Alignment.center,
      //         padding: const EdgeInsets.only(left: 8),
      //         child: Wrap(
      //           children: [
      //             Container(
      //               margin: const EdgeInsets.all(8),
      //               child: _imageFile(context),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      // ],
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

  Widget _imageRoundedSquare(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText('Rounded Square', style: context.textTheme.bodyMedium),
        ),
        const MyImage(
          image: 'assets/img/image.png',
          type: MyImageType.roundedSquare,
          width: 72,
          height: 72,
        ),
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
          child: MyText('Default Loading', style: context.textTheme.bodyMedium),
        ),
        const MyImage(
          // image:
          //     'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
          type: MyImageType.roundedSquare,
        ),
      ],
    );
  }

  Widget _loadingCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            'Load custom prompts',
            style: context.textTheme.bodyMedium,
          ),
        ),
        Container(
          height: 72,
          width: 72,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MyRadius.medium),
          ),
          child: Container(
            alignment: Alignment.center,
            color: ThemeColors.neutral.shade100,
            child: RotationTransition(
              turns: animation,
              alignment: Alignment.center,
              child: MyLoader(
                // color: context.colorScheme.primary,
                // size: 18,
                // lineWidth: 3,
              ),
            ),
          ),
        ),
        MyImage(
          image:
              'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
          loadingWidget: RotationTransition(
            turns: animation,
            alignment: Alignment.center,
            child: MyLoader(
              // color: context.colorScheme.primary,
              // size: 18,
              // lineWidth: 3,
            ),
          ),
          type: MyImageType.roundedSquare,
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
          child: MyText(
            'Default prompt for failure',
            style: context.textTheme.bodyMedium,
          ),
        ),
        const MyImage(image: 'error', type: MyImageType.roundedSquare),
      ],
    );
  }

  Widget _failCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            'Failure custom prompt',
            style: context.textTheme.bodyMedium,
          ),
        ),
        MyImage(
          image: 'error',
          errorWidget: MyText(
            'Loading failed',
            fontWeight: FontWeight.w500,
            textColor: ThemeColors.neutral.shade700,
          ),
          type: MyImageType.roundedSquare,
        ),
      ],
    );
  }

  Widget _imageFile(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: MyImage(
        image: File('/sdcard/td/test.jpg'),
        type: MyImageType.fitWidth,
      ),
    );
  }
}
