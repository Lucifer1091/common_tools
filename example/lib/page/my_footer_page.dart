import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class MyFooterPage extends StatefulWidget {
  const MyFooterPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyFooterPageState();
}

class _MyFooterPageState extends State<MyFooterPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          "This is used to display the app's copyright notice, contact information, links to important pages, and other relevant content.",
      exampleCodeGroup: 'footer',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Basic footer', builder: _buildFooter),
            ExampleItem(
              desc: 'Basic footer with links',
              builder: _buildSingleLinkFooter,
            ),
            ExampleItem(desc: '', builder: _buildLinksFooter),
            ExampleItem(desc: 'Brand footer', builder: _buildBrandFooter),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return const MyFooter(
      MyFooterType.text,
      text: 'Copyright © 2024-2026 MyDesign.All Rights Reserved.',
    );
  }

  Widget _buildSingleLinkFooter(BuildContext context) {
    final singleLink = <MyLink>[
      MyLink(
        text: 'Bottom link',
        style: MyLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        onTap: (link) {
          print('Clicked link $link');
        },
      ),
    ];

    return MyFooter(
      MyFooterType.link,
      links: singleLink,
      text: 'Copyright © 2024-2026 MyDesign.All Rights Reserved.',
    );
  }

  Widget _buildLinksFooter(BuildContext context) {
    final links = <MyLink>[
      MyLink(
        text: 'Bottom link 1',
        style: MyLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        onTap: (link) {
          print('Clicked link 1 $link');
        },
      ),
      MyLink(
        text: 'Bottom link 2',
        style: MyLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        onTap: (link) {
          print('Clicked link 2 $link');
        },
      ),
    ];

    return Column(
      children: [
        const Gap(12),
        MyFooter(
          MyFooterType.link,
          links: links,
          text: 'Copyright © 2024-2026 MyDesign.All Rights Reserved.',
        ),
      ],
    );
  }

  Widget _buildBrandFooter(BuildContext context) {
    return MyFooter(
      MyFooterType.brand,
      logo: 'assets/img/google.svg',
      width: 204,
      height: 48,
    );
  }
}
