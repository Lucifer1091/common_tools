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
            ExampleItem(desc: 'Empty with Custom Icon', builder: _customIcon),
            ExampleItem(
              desc: 'Generic with Custom Image',
              builder: _customImage,
            ),
            ExampleItem(
              desc: 'Empty with Action Button',
              builder: _emptyWithButton,
            ),
            ExampleItem(
              desc: 'Generic with Custom Action Button',
              builder: _genericWithButton,
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
    return MyError.empty(
      icon: Icon(
        Icons.fmd_bad_rounded,
        size: 96,
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _customImage(BuildContext context) {
    return MyError.generic(
      icon: MyImage(
        height: 96,
        width: 96,
        source: 'https://demofree.sirv.com/nope-not-here.jpg',
      ),
    );
  }

  Widget _emptyWithButton(BuildContext context) {
    return MyError.empty(
      buttonText: 'Refresh',
      onAction: () {
        //
      },
    );
  }

  Widget _genericWithButton(BuildContext context) {
    return MyError.generic(
      action: MyButton(
        text: 'Try Again',
        type: MyButtonType.destructive,
        onTap: () {},
      ),
    );
  }
}
