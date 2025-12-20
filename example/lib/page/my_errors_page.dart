import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class MyErrorsPage extends StatefulWidget {
  const MyErrorsPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyErrorsPageState();
}

class _MyErrorsPageState extends State<MyErrorsPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'errors',
      desc:
          'Placeholder widgets used when there are some kind of errors like no '
          'records, no internet, restricted access etc.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Generic', builder: _generic),
            ExampleItem(desc: 'Empty', builder: _empty),
            ExampleItem(desc: 'No Internet', builder: _noInternet),
            ExampleItem(desc: 'Restricted Access', builder: _restricted),
            ExampleItem(desc: 'Page Not Found', builder: _pageNotFound),
            ExampleItem(desc: 'Empty Custom Icon', builder: _customIcon),
            ExampleItem(
              desc: 'Empty Image with Operation',
              builder: _operationEmpty,
            ),
            ExampleItem(
              desc: 'Empty Image with Operation',
              builder: _operationCustomEmpty,
            ),
          ],
        ),
      ],
    );
  }

  Widget _generic(BuildContext context) {
    return const MyError.generic();
  }

  Widget _empty(BuildContext context) {
    return const MyError.empty();
  }

  Widget _noInternet(BuildContext context) {
    return const MyError.noInternet();
  }

  Widget _restricted(BuildContext context) {
    return const MyError.restricted();
  }

  Widget _pageNotFound(BuildContext context) {
    return const MyError.pageNotFound();
  }

  Widget _customIcon(BuildContext context) {
    return MyError(
      type: MyErrorType.empty,
      icon: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MyRadius.medium),
          image: const DecorationImage(
            image: AssetImage('assets/img/empty.png'),
          ),
        ),
      ),
    );
  }

  Widget _operationEmpty(BuildContext context) {
    return const MyError(
      type: MyErrorType.generic,
      buttonText: 'Action button',
      title: 'Description text',
    );
  }

  Widget _operationCustomEmpty(BuildContext context) {
    return MyError(
      type: MyErrorType.generic,
      title: 'Description text',
      action: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: MyButton(
          text: 'Custom action',
          size: MyButtonSize.medium,
          type: MyButtonType.destructive,
          width: 160,
          onTap: () {},
        ),
      ),
    );
  }
}
