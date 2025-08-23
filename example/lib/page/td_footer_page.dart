import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDFooterPage extends StatefulWidget {
  const TDFooterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDFooterPageState();
}

class _TDFooterPageState extends State<TDFooterPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      backgroundColor: context.colorScheme.primaryForeground,
      desc: '用于展示App的版权声明、联系信息、重要页面链接和其他相关内容等信息。',
      exampleCodeGroup: 'footer',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: '基础页脚', builder: _buildFooter),
            ExampleItem(desc: '基础加链接页脚', builder: _buildSingleLinkFooter),
            ExampleItem(desc: '', builder: _buildLinksFooter),
            ExampleItem(desc: '品牌页脚', builder: _buildBrandFooter),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return const TDFooter(
      TDFooterType.text,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  Widget _buildSingleLinkFooter(BuildContext context) {
    // 示例链接列表
    final singleLink = <MyLink>[
      MyLink(
        text: '底部链接',
        style: MyLinkStyle.primary,
        // type: MyLinkType.withSuffixIcon,
        uri: Uri.parse('https://example.com'),
        onTap: (link) {
          print('点击了链接 $link');
        },
      ),
    ];

    return TDFooter(
      TDFooterType.link,
      links: singleLink,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  Widget _buildLinksFooter(BuildContext context) {
    final links = <MyLink>[
      MyLink(
        text: '底部链接1',
        style: MyLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        onTap: (link) {
          print('点击了链接1 $link');
        },
      ),
      MyLink(
        text: '底部链接2',
        style: MyLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        onTap: (link) {
          print('点击了链接2 $link');
        },
      ),
    ];
    return Column(
      children: [
        const SizedBox(height: 12),
        TDFooter(
          TDFooterType.link,
          links: links,
          text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
        ),
      ],
    );
  }

  Widget _buildBrandFooter(BuildContext context) {
    return TDFooter(
      TDFooterType.brand,
      logo: 'assets/img/td_brand.png',
      width: 204,
      height: 48,
    );
  }
}
