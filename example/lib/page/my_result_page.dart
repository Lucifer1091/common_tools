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
            ExampleItem(desc: 'Dafault Results', builder: _buildDefaultResults),
            ExampleItem(desc: 'Custom results', builder: _buildCustomResult),
            ExampleItem(desc: 'Page example', builder: _buildPageExample),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultResults(BuildContext context) {
    return Column(
      spacing: 48,
      children: [
        _buildSuccessResult(context),
        _buildErrorResult(context),
        _buildWarningResult(context),
        _buildDefaultResult(context),
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
                    title: 'Success',
                    theme: MyResultTheme.success,
                    subtitle:
                        'Your booking has been confirmed.\nPlease check your email for details.',
                  ),
                  const SizedBox(height: 48),
                  MyButton(
                    text: 'Return',
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

  MyResult _buildSuccessResult(BuildContext context) {
    return const MyResult(
      title: 'Success',
      theme: MyResultTheme.success,
      subtitle:
          'Your booking has been confirmed.\nPlease check your email for details.',
    );
  }

  MyResult _buildErrorResult(BuildContext context) {
    return const MyResult(
      title: 'Error',
      theme: MyResultTheme.error,
      subtitle: 'Your transcation has failed.\n Please go back and try again.',
    );
  }

  MyResult _buildWarningResult(BuildContext context) {
    return const MyResult(
      title: 'Warning',
      theme: MyResultTheme.warning,
      subtitle: 'There was a problem with your network connection.',
    );
  }

  MyResult _buildDefaultResult(BuildContext context) {
    return const MyResult(
      title: 'Info',
      theme: MyResultTheme.primary,
      subtitle: 'Please read the comment carefully and search again.',
    );
  }

  MyResult _buildCustomResultContent(BuildContext context) {
    return MyResult(
      title: 'Error',
      icon: Image.asset('assets/img/illustration.png'),
      subtitle: 'No network found.\nPlese check your connection and try again.',
    );
  }
}
