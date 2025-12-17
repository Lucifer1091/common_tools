import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

/// 圆角示例页面
class TDShadowsPage extends StatelessWidget {
  const TDShadowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.primaryForeground,
      title: myTitle(context),
      exampleCodeGroup: 'shadows',
      children: [
        ExampleModule(
          title: '投影',
          children: [
            ExampleItem(desc: '基础投影', builder: _buildShadowsBase),
            ExampleItem(desc: '中层投影', builder: _buildShadowsMiddle),
            ExampleItem(desc: '上层投影', builder: _buildShadowsTop),
            ExampleItem(
              desc: 'Diagonal Decoration',
              builder: _buildDiagonalDecoration,
            ),
            ExampleItem(
              desc: 'Matrix Decoration',
              builder: _buildMatrixDecoration,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShadowsBase(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryForeground,
        boxShadow: MyBoxShadows.base,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
    );
  }

  Widget _buildShadowsMiddle(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryForeground,
        boxShadow: MyBoxShadows.middle,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
    );
  }

  Widget _buildShadowsTop(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryForeground,
        boxShadow: MyBoxShadows.top,
        borderRadius: BorderRadius.circular(MyRadius.medium),
      ),
    );
  }

  Widget _buildDiagonalDecoration(BuildContext context) {
    Widget tile(String title, String subtitle, IconData icon) {
      return Row(
        children: [
          Icon(icon),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(title),
              const SizedBox(height: 5),
              MyText(
                subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36),
      padding: const EdgeInsets.all(25),
      decoration: DiagonalDecoration(
        backgroundColor: context.colorScheme.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            'Main features',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          tile('Multi-currency account', '29 currencies', Icons.wallet),
          const SizedBox(height: 20),
          tile('Free cards', '1 virtual + 1 physical', Icons.currency_exchange),
        ],
      ),
    );
  }

  Widget _buildMatrixDecoration(BuildContext context) {
    return Container(
      width: 300,
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: MatrixDecoration(
        backgroundColor: context.colorScheme.secondary,
        lineColor: context.colorScheme.mutedForeground,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MyText(
            'Temperature',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          MyText('in Ukraine 🇺🇦', style: TextStyle(fontSize: 15)),
          SizedBox(height: 10),
          MyText(
            '32°C',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
