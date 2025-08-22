import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDResultPage extends StatefulWidget {
  const TDResultPage({Key? key}) : super(key: key);

  @override
  State<TDResultPage> createState() => _TDResultPageState();
}

class _TDResultPageState extends State<TDResultPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Result 结果',
      desc: '反馈结果状态。',
      exampleCodeGroup: 'result',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: '基础结果',
              ignoreCode: true,
              builder: _buildBasicResult,
            ),
            ExampleItem(
              desc: '带描述的结果',
              ignoreCode: true,
              builder: _buildResultWithDescription,
            ),
            ExampleItem(
              desc: '自定义结果',
              ignoreCode: true,
              builder: _buildCustomResult,
            ),
            ExampleItem(
              desc: '页面示例',
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
      text: '页面示例',

      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Result 结果')),
              body: Column(
                children: [
                  const SizedBox(height: 48),
                  const TDResult(
                    title: '成功状态',
                    theme: TDResultTheme.success,
                    description: '描述文字',
                  ),
                  const SizedBox(height: 48),
                  MyButton(
                    text: '返回',

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

  TDResult _buildBasicResultSuccess(BuildContext context) {
    return const TDResult(title: '成功状态', theme: TDResultTheme.success);
  }

  TDResult _buildBasicResultError(BuildContext context) {
    return const TDResult(title: '失败状态', theme: TDResultTheme.error);
  }

  TDResult _buildBasicResultWarning(BuildContext context) {
    return const TDResult(title: '警示状态', theme: TDResultTheme.warning);
  }

  TDResult _buildBasicResultDefault(BuildContext context) {
    return const TDResult(title: '默认状态', theme: TDResultTheme.defaultTheme);
  }

  TDResult _buildResultWithDescriptionSuccess(BuildContext context) {
    return const TDResult(
      title: '成功状态',
      theme: TDResultTheme.success,
      description: '描述文字',
    );
  }

  TDResult _buildResultWithDescriptionError(BuildContext context) {
    return const TDResult(
      title: '失败状态',
      theme: TDResultTheme.error,
      description: '描述文字',
    );
  }

  TDResult _buildResultWithDescriptionWarning(BuildContext context) {
    return const TDResult(
      title: '警示状态',
      theme: TDResultTheme.warning,
      description: '描述文字',
    );
  }

  TDResult _buildResultWithDescriptionDefault(BuildContext context) {
    return const TDResult(
      title: '默认状态',
      theme: TDResultTheme.defaultTheme,
      description: '描述文字',
    );
  }

  TDResult _buildCustomResultContent(BuildContext context) {
    return TDResult(
      title: '自定义结果',
      icon: Image.asset('assets/img/illustration.png'),
      description: '描述文字',
    );
  }
}
