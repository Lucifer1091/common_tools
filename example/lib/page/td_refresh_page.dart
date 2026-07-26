/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

class TdPullDownRefreshPage extends StatefulWidget {
  const TdPullDownRefreshPage({super.key});

  @override
  State<StatefulWidget> createState() => _TdPullDownRefreshPageState();
}

class _TdPullDownRefreshPageState extends State<TdPullDownRefreshPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'refresh',
      desc: '用于快速刷新页面信息，刷新可以是整页刷新也可以是页面的局部刷新。',
      showSingleChild: true,
      singleChild: _buildRefresh,
    );
  }

  Widget _buildRefresh(BuildContext context) {
    return EasyRefresh(
      // 下拉样式
      header: TDRefreshHeader(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 171,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ThemeColors.neutral.shade50,
                borderRadius: MyBorderRadius.large,
              ),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: MyText(
                MyPlatform.isWeb ? 'Web暂不支持下拉，请下载安装apk体验' : '拖拽该区域演示 顶部下拉刷新',
                textColor: ThemeColors.neutral.shade600,
              ),
            ),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ThemeColors.neutral.shade50,
                borderRadius: MyBorderRadius.large,
              ),
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: MyText(
                '下拉刷新次数：$count',
                textColor: ThemeColors.neutral.shade600,
              ),
            ),
            const SizedBox(height: 500),
          ],
        ),
      ),
      // 下拉刷新回调
      onRefresh: () {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              count++;
            });
          }
        });
      },
    );
  }
}
