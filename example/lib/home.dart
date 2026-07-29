import 'package:example/common_tools_catalog.dart';
import 'package:example/base/app_bar.dart';
import 'package:flutter/material.dart';

import 'base/example_route.dart';
import 'config.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditController controller = TextEditController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: MyAppBar(title: widget.title),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildChildren(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    var children = <Widget>[];

    // children.add(
    //   AnimSearchBar(
    //     width: 50,
    //     height: 30,
    //     isOpened: true,
    //     controller: controller,
    //     onSuffixTap: controller.clear,
    //   ),
    // );

    exampleMap.forEach((key, value) {
      var subList = <Widget>[];

      for (var model in value) {
        if (controller.isNotEmpty &&
            !model.text.toLowerCase().contains(controller.text.toLowerCase())) {
          continue;
        }

        subList.add(
          Padding(
            padding: const EdgeInsets.only(
              left: 40,
              right: 40,
              top: 8,
              bottom: 8,
            ),
            child: MyButton(
              type: MyButtonType.outline,
              shape: MyButtonShape.filled,
              size: MyButtonSize.large,
              onTap: () {
                Navigator.pushNamed(context, MyRoute.pagePath(model));
              },
              text: model.text,
              icon: Icons.arrow_right_alt_rounded,
              iconPosition: MyButtonIconPosition.right,
            ),
          ),
        );
      }

      children.add(
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(MyRadius.large),
            ),
          ),
          child: MyText(
            '$key(${subList.length})',
            textColor: context.colorScheme.primaryForeground,
          ),
        ),
      );
      children.addAll(subList);
    });

    return children;
  }
}
