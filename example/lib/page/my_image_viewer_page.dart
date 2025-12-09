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
      backgroundColor: const Color(0xFFF0F2F5),
      title: myTitle(),
      desc: '用于图片内容的缩略展示与查看。',
      exampleCodeGroup: 'image_viewer',
      children: [
        // ExampleModule(
        //   title: 'Component Types',
        //   children: [
        //     ExampleItem(desc: '基础图片预览', builder: _basicImageViewer),
        //     ExampleItem(desc: '带操作图片预览', builder: _actionImageViewer),
        //   ],
        // ),
      ],
      test: [
        // ExampleItem(desc: '长按图片', builder: _longPressImageViewer),
        // ExampleItem(desc: '图片超宽情况', builder: _ultraWidthImageViewer),
        // ExampleItem(desc: '图片超高情况', builder: _ultraHeightImageViewer),
        // ExampleItem(desc: '带图片Title', builder: _descImageViewer),
      ],
    );
  }

  // var images = [
  //   'https://tdesign.gtimg.com/mobile/demos/swiper1.png',
  //   'https://tdesign.gtimg.com/mobile/demos/swiper2.png',
  // ];

  // Widget _basicImageViewer(BuildContext context) {
  //   return TDButton(
  //     type: TDButtonType.ghost,
  //     theme: TDButtonTheme.primary,
  //     isBlock: true,
  //     size: TDButtonSize.large,
  //     text: '基础图片预览',
  //     onTap: () {
  //       TDImageViewer.showImageViewer(context: context, images: images);
  //     },
  //   );
  // }

  // Widget _actionImageViewer(BuildContext context) {
  //   var delImages = [
  //     'https://tdesign.gtimg.com/mobile/demos/swiper1.png',
  //     'https://tdesign.gtimg.com/mobile/demos/swiper2.png',
  //   ];
  //   return TDButton(
  //     type: TDButtonType.ghost,
  //     theme: TDButtonTheme.primary,
  //     isBlock: true,
  //     size: TDButtonSize.large,
  //     text: '带操作图片预览',
  //     onTap: () {
  //       TDImageViewer.showImageViewer(
  //         context: context,
  //         images: delImages,
  //         showIndex: true,
  //         deleteBtn: true,
  //       );
  //     },
  //   );
  // }

  // Widget _longPressImageViewer(BuildContext context) {
  //   return TDButton(
  //     type: TDButtonType.ghost,
  //     theme: TDButtonTheme.primary,
  //     isBlock: true,
  //     size: TDButtonSize.large,
  //     text: '长按图片',
  //     onTap: () {
  //       TDImageViewer.showImageViewer(
  //         context: context,
  //         images: images,
  //         deleteBtn: true,
  //         showIndex: true,
  //         onLongPress: (index) {
  //           Navigator.of(context).push(
  //             TDSlidePopupRoute(
  //               slideTransitionFrom: SlideTransitionFrom.bottom,
  //               builder: _getSheetItem,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _ultraWidthImageViewer(BuildContext context) {
  //   return TDButton(
  //     type: TDButtonType.ghost,
  //     theme: TDButtonTheme.primary,
  //     isBlock: true,
  //     size: TDButtonSize.large,
  //     text: '图片超宽情况',
  //     onTap: () {
  //       TDImageViewer.showImageViewer(
  //         context: context,
  //         images: images,
  //         showIndex: true,
  //         height: 140,
  //         onLongPress: (index) {
  //           Navigator.of(context).push(
  //             TDSlidePopupRoute(
  //               slideTransitionFrom: SlideTransitionFrom.bottom,
  //               builder: _getSheetItem,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _ultraHeightImageViewer(BuildContext context) {
  //   return TDButton(
  //     type: TDButtonType.ghost,
  //     theme: TDButtonTheme.primary,
  //     isBlock: true,
  //     size: TDButtonSize.large,
  //     text: '图片超高情况',
  //     onTap: () {
  //       TDImageViewer.showImageViewer(
  //         context: context,
  //         images: images,
  //         showIndex: true,
  //         width: 180,
  //         onLongPress: (index) {
  //           Navigator.of(context).push(
  //             TDSlidePopupRoute(
  //               slideTransitionFrom: SlideTransitionFrom.bottom,
  //               builder: _getSheetItem,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _descImageViewer(BuildContext context) {
  //   var delImages = [
  //     'https://tdesign.gtimg.com/mobile/demos/swiper1.png',
  //     'https://tdesign.gtimg.com/mobile/demos/swiper2.png',
  //   ];
  //   var labels = ['图片Title1', '图片Title2'];
  //   return TDButton(
  //     type: TDButtonType.ghost,
  //     theme: TDButtonTheme.primary,
  //     isBlock: true,
  //     size: TDButtonSize.large,
  //     text: '带图片Title',
  //     onTap: () {
  //       TDImageViewer.showImageViewer(
  //         context: context,
  //         images: delImages,
  //         labels: labels,
  //       );
  //     },
  //   );
  // }

  // Widget _getSheetItem(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     height: 120,
  //     color: Colors.white,
  //     child: Column(
  //       children: [
  //         const SizedBox(height: 16),
  //         Text(
  //           '保存图片',
  //           style: TextStyle(
  //             color: ThemeColors.neutral.shade900,
  //             decoration: TextDecoration.none,
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //         const TDDivider(margin: EdgeInsets.symmetric(vertical: 10)),
  //         Text(
  //           '删除图片',
  //           style: TextStyle(
  //             color: ThemeColors.neutral.shade900,
  //             decoration: TextDecoration.none,
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
