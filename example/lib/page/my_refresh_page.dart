import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

class MyPullDownRefreshPage extends StatefulWidget {
  const MyPullDownRefreshPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPullDownRefreshPageState();
}

class _MyPullDownRefreshPageState extends State<MyPullDownRefreshPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'refresh',
      desc:
          'Used to quickly refresh page information; the refresh can be either a full-page refresh or a partial page refresh.',
      showSingleChild: true,
      singleChild: _buildRefresh,
    );
  }

  Widget _buildRefresh(BuildContext context) {
    return MyRefreshTrigger(
      minExtent: 50,
      maxExtent: 100,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              count++;
            });
          }
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(16),
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                borderRadius: MyBorderRadius.large,
              ),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: MyText(
                'Pull down this area to demonstrate the refresh feature.',
              ),
            ),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                borderRadius: MyBorderRadius.large,
              ),
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: MyText('Pull-to-refresh count: $count'),
            ),
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }
}
