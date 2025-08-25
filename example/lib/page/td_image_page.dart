import 'package:flutter/material.dart';

import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

import 'dart:io';

class TDImagePage extends StatefulWidget {
  const TDImagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TDImageState();
}

class TDImageState extends State<TDImagePage>
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
      title: tdTitle(),
      exampleCodeGroup: 'image',
      desc: '用于展示效果，主要为上下左右居中裁切、拉伸、平铺等方式。',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              ignoreCode: true,
              desc: '',
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
              ignoreCode: true,
              desc: '',
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
                        margin: const EdgeInsets.all(8), // 适应宽
                        child: _imageFitWidth(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '',
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
              ignoreCode: true,
              desc: '',
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
            ExampleItem(
              ignoreCode: true,
              desc: '',
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 8),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _failDefault(context),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: _failCustom(context),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          ignoreCode: true,
          desc: '',
          builder: (context) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 8),
              child: Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: _imageFile(context),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /* 图片裁剪 */

  Widget _imageClip(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '裁剪',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        const TDImage(assetUrl: 'assets/img/image.png', type: TDImageType.clip),
      ],
    );
  }

  /* 图片拉伸 */

  Widget _imageStretch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '拉伸',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        Container(
          color: Colors.black,
          width: 121,
          height: 72,
          child: const Stack(
            alignment: Alignment.center,
            children: [
              TDImage(
                assetUrl: 'assets/img/image.png',
                width: 121,
                height: 50,
                type: TDImageType.stretch,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /* 图片适应高 */

  Widget _imageFitHeight(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '适应高',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        Container(
          width: 89,
          height: 72,
          color: Colors.black,
          child: const TDImage(
            assetUrl: 'assets/img/image.png',
            type: TDImageType.fitHeight,
          ),
        ),
      ],
    );
  }

  /* 图片适应宽 */

  Widget _imageFitWidth(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '适应宽',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        Container(
          width: 72,
          height: 89,
          color: Colors.black,
          child: const TDImage(
            assetUrl: 'assets/img/image.png',
            type: TDImageType.fitWidth,
          ),
        ),
      ],
    );
  }

  /* 方形 */

  Widget _imageSquare(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '方形',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        const TDImage(
          assetUrl: 'assets/img/image.png',
          type: TDImageType.square,
        ),
      ],
    );
  }

  /* 圆角方形 */

  Widget _imageRoundedSquare(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '圆角方形',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        const TDImage(
          assetUrl: 'assets/img/image.png',
          type: TDImageType.roundedSquare,
          width: 72,
          height: 72,
        ),
      ],
    );
  }

  /* 圆形 */

  Widget _imageCircle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '圆形',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        const TDImage(
          assetUrl: 'assets/img/image.png',
          width: 72,
          height: 72,
          type: TDImageType.circle,
        ),
      ],
    );
  }

  /* 加载默认提示 */

  Widget _loadingDefault(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '加载默认提示',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
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
            child: Icon(
              Icons.more_horiz_rounded,
              size: 22,
              color: ThemeColors.neutral.shade700,
            ),
          ),
        ),
        // 实际组件写法如下：上面仅为加载展示
        // const TDImage(
        //   imgUrl:
        //       'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        //   type: TDImageType.roundedSquare,
        // ),
      ],
    );
  }

  /* 加载自定义提示 */

  Widget _loadingCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '加载自定义提示',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
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
              child: MyCircleIndicator(
                color: context.colorScheme.primary,
                size: 18,
                lineWidth: 3,
              ),
            ),
          ),
        ),
        // 实际组件写法如下：上面仅为加载展示
        // TDImage(
        //   imgUrl:
        //       'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        //   loadingWidget: RotationTransition(
        //       turns: animation,
        //       alignment: Alignment.center,
        //       child: TDCircleIndicator(
        //         color: context.colorScheme.primary,
        //         size: 18,
        //         lineWidth: 3,
        //       )),
        //   type: TDImageType.roundedSquare,
        // ),
      ],
    );
  }

  /* 失败默认提示 */

  Widget _failDefault(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '失败默认提示',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        const TDImage(imgUrl: 'error', type: TDImageType.roundedSquare),
      ],
    );
  }

  /* 失败自定义提示 */

  Widget _failCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyText(
            '失败自定义提示',
            fontSize: context.textTheme.bodyMedium.fontSize,
            textColor: ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
        ),
        TDImage(
          imgUrl: 'error',
          errorWidget: MyText(
            '加载失败',
            fontWeight: FontWeight.w500,
            textColor: ThemeColors.neutral.shade700,
          ),
          type: TDImageType.roundedSquare,
        ),
      ],
    );
  }

  Widget _imageFile(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      child: TDImage(
        imageFile: File('/sdcard/td/test.jpg'),
        type: TDImageType.fitWidth,
      ),
    );
  }
}
