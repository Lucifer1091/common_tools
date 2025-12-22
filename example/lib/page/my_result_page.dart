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
            ExampleItem(desc: 'Custom Result', builder: _buildCustomResult),
            ExampleItem(desc: 'Dialog Example', builder: _buildDialogExample),
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
      subtitle:
          'There was a problem with your network connection.\nPlease check your connection and try again.',
    );
  }

  MyResult _buildDefaultResult(BuildContext context) {
    return const MyResult(
      title: 'Info',
      theme: MyResultTheme.primary,
      subtitle:
          'Please read the comment carefully and search again.\n You can watch the tutorials for futher guidance.',
    );
  }

  MyResult _buildCustomResult(BuildContext context) {
    return MyResult(
      title: 'Error',
      icon: Image.asset('assets/img/illustration.png'),
      subtitle: 'No network found.\nPlese check your connection and try again.',
    );
  }

  Widget _buildDialogExample(BuildContext context) {
    return MyButton(
      text: 'Open Dialog',
      size: MyButtonSize.large,
      onTap: () {
        MyDialog.show(
          context: context,
          builder: (context) {
            return MyInfoDialog(
              contentWidget: const MyResult(
                title: 'Success',
                theme: MyResultTheme.success,
                subtitle:
                    'Your booking has been confirmed.\nPlease check your email for details.',
              ),
            );
          },
        );
      },
    );
  }
}
