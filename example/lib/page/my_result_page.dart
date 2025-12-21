import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class MyResultPage extends StatefulWidget {
  const MyResultPage({super.key});

  @override
  State<MyResultPage> createState() => _MyResultPageState();
}

class _MyResultPageState extends State<MyResultPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Result',
      desc: 'Used to display feedback result status. ',
      exampleCodeGroup: 'result',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Basic results',
              ignoreCode: true,
              builder: _buildBasicResult,
            ),
            ExampleItem(
              desc: 'Results with description',
              ignoreCode: true,
              builder: _buildResultWithDescription,
            ),
            ExampleItem(
              desc: 'Custom results',
              ignoreCode: true,
              builder: _buildCustomResult,
            ),
            ExampleItem(
              desc: 'Page example',
              ignoreCode: true,
              builder: _buildPageExample,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicResult(BuildContext context) {
    return Column(
      children: [
        _buildBasicResultSuccess(context),
        const SizedBox(height: 48),
        _buildBasicResultError(context),
        const SizedBox(height: 48),
        _buildBasicResultWarning(context),
        const SizedBox(height: 48),
        _buildBasicResultDefault(context),
      ],
    );
  }

  Widget _buildResultWithDescription(BuildContext context) {
    return Column(
      children: [
        _buildResultWithDescriptionSuccess(context),
        const SizedBox(height: 48),
        _buildResultWithDescriptionError(context),
        const SizedBox(height: 48),
        _buildResultWithDescriptionWarning(context),
        const SizedBox(height: 48),
        _buildResultWithDescriptionDefault(context),
      ],
    );
  }

  Widget _buildCustomResult(BuildContext context) {
    return _buildCustomResultContent(context);
  }

  Widget _buildPageExample(BuildContext context) {
    return MyButton(
      text: 'Page example',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Result')),
              body: Column(
                children: [
                  const SizedBox(height: 48),
                  const MyResult(
                    title: 'success status',
                    theme: MyResultTheme.success,
                    description: 'Description text',
                  ),
                  const SizedBox(height: 48),
                  MyButton(
                    text: 'return',
                    size: MyButtonSize.large,
                    type: MyButtonType.outline,
                    isExpanded: true,

                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  MyResult _buildBasicResultSuccess(BuildContext context) {
    return const MyResult(
      title: 'success status',
      theme: MyResultTheme.success,
    );
  }

  MyResult _buildBasicResultError(BuildContext context) {
    return const MyResult(title: 'failure status', theme: MyResultTheme.error);
  }

  MyResult _buildBasicResultWarning(BuildContext context) {
    return const MyResult(title: 'alert status', theme: MyResultTheme.warning);
  }

  MyResult _buildBasicResultDefault(BuildContext context) {
    return const MyResult(
      title: 'Default state',
      theme: MyResultTheme.defaultTheme,
    );
  }

  MyResult _buildResultWithDescriptionSuccess(BuildContext context) {
    return const MyResult(
      title: 'success status',
      theme: MyResultTheme.success,
      description: 'Description text',
    );
  }

  MyResult _buildResultWithDescriptionError(BuildContext context) {
    return const MyResult(
      title: 'failure status',
      theme: MyResultTheme.error,
      description: 'Description text',
    );
  }

  MyResult _buildResultWithDescriptionWarning(BuildContext context) {
    return const MyResult(
      title: 'alert status',
      theme: MyResultTheme.warning,
      description: 'Description text',
    );
  }

  MyResult _buildResultWithDescriptionDefault(BuildContext context) {
    return const MyResult(
      title: 'Default state',
      theme: MyResultTheme.defaultTheme,
      description: 'Description text',
    );
  }

  MyResult _buildCustomResultContent(BuildContext context) {
    return MyResult(
      title: 'Custom results',
      icon: Image.asset('assets/img/illustration.png'),
      description: 'Description text',
    );
  }
}
