import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

class MySideBarPage extends StatefulWidget {
  const MySideBarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySideBarPageState();
  }
}

class MySideBarPageState extends State<MySideBarPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'sideBar',
      desc: 'Used for display switching after content classification.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Side Navigation Usage',
              ignoreCode: true,
              builder: _buildNavigatorSideBar,
            ),
            ExampleItem(
              desc: 'Icon Side Navigation',
              builder: _buildIconSideBar,
              methodName: '_buildIconSideBar',
            ),
            ExampleItem(
              desc: 'Lazy Loading',
              ignoreCode: true,
              builder: _loadingSideBar,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              desc: 'Side Navigation Style',
              ignoreCode: true,
              builder: _buildStyleSideBar,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigatorSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          getCustomButton(context, 'SideBar Anchor', 'SideBarAnchor'),
          const Gap(16),
          getCustomButton(context, 'SideBar Pagination', 'SideBarPagination'),
        ],
      ),
    );
  }

  Widget _buildIconSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          getCustomButton(context, 'Side Navigation with Icons', 'SideBarIcon'),
        ],
      ),
    );
  }

  Widget _buildStyleSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          getCustomButton(
            context,
            'Non-full-width option styles',
            'SideBarOutline',
          ),

          const SizedBox(height: 16),
          getCustomButton(context, 'Custom Styles', 'SideBarCustom'),
        ],
      ),
    );
  }

  Widget _loadingSideBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [getCustomButton(context, 'Lazy Loading', 'SideBarLoading')],
      ),
    );
  }

  MyButton getCustomButton(
    BuildContext context,
    String text,
    String routeName,
  ) {
    return MyButton(
      text: text,
      width: MediaQuery.of(context).size.width - 16 * 2,
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
