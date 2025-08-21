import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDTextPage extends StatelessWidget {
  const TDTextPage({Key? key}) : super(key: key);

  final exampleTxt = '文本Text';

  @override
  Widget build(BuildContext context) {
    // debugPaintBaselinesEnabled = true;
    return ExamplePage(
      padding: const EdgeInsets.all(8),
      title: tdTitle(context),
      exampleCodeGroup: 'text',
      children: [
        ExampleModule(
          title: '使用示例',
          children: [
            ExampleItem(desc: '系统Text:', builder: _buildSystemText),
            ExampleItem(desc: '普通TDText:', builder: _buildNormalTDText),
            ExampleItem(desc: '指定常用属性:', builder: _buildGeneralProp),
            ExampleItem(
              desc: 'style覆盖textColor,不覆盖font:',
              builder: _buildStyleCoverColor,
            ),
            ExampleItem(
              desc: 'style覆盖textColor和font:',
              builder: _buildStyleCoverColorAndFont,
            ),
            ExampleItem(desc: 'TDText.rich测试:', builder: _buildRichText),
            ExampleItem(desc: '获取系统Text:', builder: _getSystemText),
            ExampleItem(
              desc: '中文居中:（带有英文可能不居中）',
              builder: _buildVerticalCenterText,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: '中文居中-系统字体',
          builder: (context) {
            return Container(
              color: ThemeColors.blue.shade100,
              child: Text(exampleTxt),
            );
          },
        ),
        ExampleItem(
          desc: '中文居中-TD字体',
          builder: (context) {
            return Container(
              color: ThemeColors.blue.shade100,
              child: MyText(exampleTxt),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNormalTDText(BuildContext context) {
    return MyText(exampleTxt);
  }

  Widget _buildSystemText(BuildContext context) {
    return Text(exampleTxt);
  }

  Widget _buildGeneralProp(BuildContext context) {
    return MyText(
      exampleTxt,
      fontSize: context.headlineLarge.fontSize,
      textColor: context.colorScheme.primary,
      backgroundColor: ThemeColors.blue.shade100,
    );
  }

  Widget _buildStyleCoverColor(BuildContext context) {
    return MyText(
      exampleTxt,
      fontSize: context.bodyLarge.fontSize,
      textColor: context.colorScheme.primary,
      style: TextStyle(color: ThemeColors.error.shade500),
    );
  }

  Widget _buildStyleCoverColorAndFont(BuildContext context) {
    return MyText(
      exampleTxt,
      fontSize: context.bodyLarge.fontSize,
      textColor: context.colorScheme.primary,
    );
  }

  Widget _buildRichText(BuildContext context) {
    return MyText.rich(
      TDTextSpan(
        children: [
          TDTextSpan(
            text: 'TDTextSpan1',
            textColor: ThemeColors.warning,
            isTextThrough: true,
            lineThroughColor: context.colorScheme.primary,
            style: TextStyle(color: ThemeColors.error.shade500),
          ),
          TextSpan(
            text: 'TextSpan2',
            style: TextStyle(fontSize: 14, color: context.colorScheme.primary),
          ),
          const WidgetSpan(child: Icon(Icons.settings, size: 24)),
        ],
      ),
      fontSize: context.bodyLarge.fontSize,
      textColor: context.colorScheme.primary,
      style: TextStyle(color: ThemeColors.error.shade500, fontSize: 32),
    );
  }

  Widget _getSystemText(BuildContext context) {
    return MyText(exampleTxt, backgroundColor: ThemeColors.blue.shade100);
  }

  Widget _buildVerticalCenterText(BuildContext context) {
    return MyText(
      '中华人民共和国腾讯科技',
      // font: Font(size: 100, lineHeight: 100),
      backgroundColor: ThemeColors.blue.shade100,
    );
  }
}

/// 自定义控件，内部的context可拿到外部TDTextConfiguration的配置信息
class CustomPaddingText extends StatelessWidget {
  const CustomPaddingText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyText('中华人民共和国腾讯科技fgjpqy', backgroundColor: ThemeColors.blue.shade100),
        MyText(
          'English',
          fontSize: context.headlineLarge.fontSize,
          backgroundColor: ThemeColors.blue.shade100,
        ),
      ],
    );
  }
}
