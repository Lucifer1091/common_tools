import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

void main() async {
  runApp(TagTestApp());
}

class TagTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDTag 宽度测试',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyText('TDTag 宽度测试')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(context),
            _buildFixedWidthSection(context),
            _buildEdgeCaseSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          '不带宽度测试',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            MyTag('1', theme: MyTagTheme.primary, size: MyTagSize.medium),
            MyTag('1000', theme: MyTagTheme.warning),
            MyTag('文本', theme: MyTagTheme.success),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFixedWidthSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          '基础固定宽度测试',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            MyTag(
              '1',
              fixedWidth: 80,
              theme: MyTagTheme.primary,
              size: MyTagSize.medium,
            ),
            MyTag('1000', fixedWidth: 80, theme: MyTagTheme.warning),
            MyTag('文本', fixedWidth: 80, theme: MyTagTheme.success),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEdgeCaseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          '边界情况测试',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const MyTag(
          '超长文本测试超长文本测试超长文本测试超长文本测试',
          fixedWidth: 100,
          theme: MyTagTheme.warning,
        ),
        const SizedBox(height: 12),
        const MyTag(
          '带关闭按钮',
          fixedWidth: 150,
          needCloseIcon: true,
          theme: MyTagTheme.danger,
        ),
        const SizedBox(height: 12),
        MyTag(
          '动态宽度',
          fixedWidth: MediaQuery.of(context).size.width * 0.5,
          theme: MyTagTheme.success,
        ),
        const SizedBox(height: 12),
        const MyTag('极小宽度', fixedWidth: 50, theme: MyTagTheme.primary),
      ],
    );
  }
}
