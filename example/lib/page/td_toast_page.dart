import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDToastPage extends StatefulWidget {
  const TDToastPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDToastPageState();
}

class _TDToastPageState extends State<TDToastPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: '用于轻量级反馈或提示，不会打断用户操作。',
      exampleCodeGroup: 'toast',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: '纯文字', builder: _textToast),
            ExampleItem(desc: '多行文字', builder: _multipleToast),
            ExampleItem(desc: '带横向图标', builder: _horizontalIconToast),
            ExampleItem(desc: '带竖向图标', builder: _verticalIconToast),
            ExampleItem(desc: '加载状态', builder: _loadingToast),
            ExampleItem(desc: '加载状态自定义', builder: _loadingCustomToast),
            ExampleItem(desc: '加载状态(无文字)', builder: _loadingWithoutTextToast),
            ExampleItem(desc: '停止加载', builder: _dismissLoadingToast),
            ExampleItem(desc: '自定义纯文字', builder: _textCustomToast),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: '成功提示', builder: _successToast),
            ExampleItem(desc: '成功提示(竖向)', builder: _successVerticalToast),
            ExampleItem(desc: '警告提示', builder: _warningToast),
            ExampleItem(desc: '警告提示(竖向)', builder: _warningVerticalToast),
            ExampleItem(desc: '失败提示', builder: _failToast),
            ExampleItem(desc: '失败提示(竖向)', builder: _failVerticalToast),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: '禁止滚动+点击', builder: _preventTapToast),
        ExampleItem(desc: '自定义宽度+行数', builder: _customMultipleToast),
      ],
    );
  }

  Widget _textToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showText('轻提示文字内容', context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '纯文字',
    );
  }

  Widget _textCustomToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showText(
          '自定义纯文字',
          context: context,
          customWidget: Container(
            width: 50,
            height: 20,
            color: ThemeColors.blue.shade700,
            child: const MyText('自定义纯文字'),
          ),
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '纯文字',
    );
  }

  Widget _multipleToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showText('最多一行展示十个汉字宽度限制最多不超过三行文字', context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '多行文字',
    );
  }

  Widget _horizontalIconToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showIconText(
          '带横向图标',
          icon: Icons.check_circle,
          context: context,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '带横向图标',
    );
  }

  Widget _verticalIconToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showIconText(
          '带竖向图标',
          icon: Icons.check_circle,
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '带竖向图标',
    );
  }

  Widget _loadingToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showLoading(context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '加载状态',
    );
  }

  Widget _loadingCustomToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showLoading(
          context: context,
          customWidget: Container(
            width: 50,
            height: 20,
            color: ThemeColors.blue.shade50,
            child: const MyText('自定义加载'),
          ),
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '加载状态',
    );
  }

  Widget _loadingWithoutTextToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showLoadingWithoutText(context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '加载状态（无文案）',
    );
  }

  Widget _dismissLoadingToast(BuildContext context) {
    return const MyButton(
      onTap: TDToast.dismissLoading,
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '停止加载',
    );
  }

  Widget _successToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showSuccess('成功文案', context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '成功提示',
    );
  }

  Widget _successVerticalToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showSuccess(
          '成功文案',
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '成功提示(竖向)',
    );
  }

  Widget _warningToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showWarning(
          '警告文案',
          direction: IconTextDirection.horizontal,
          context: context,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '警告提示',
    );
  }

  Widget _warningVerticalToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showWarning(
          '警告文案',
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '警告提示(竖向)',
    );
  }

  Widget _failToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showFail(
          '失败文案',
          direction: IconTextDirection.horizontal,
          context: context,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: '失败提示',
    );
  }

  Widget _failVerticalToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showFail(
          '失败文案',
          direction: IconTextDirection.vertical,
          context: context,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      isExpanded: true,

      text: '失败提示(竖向)',
    );
  }

  Widget _preventTapToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showText(
          '轻提示文字内容',
          context: context,
          preventTap: true,
          backgroundColor: Colors.black.withValues(alpha: 0.7),
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      isExpanded: true,

      text: '禁止滚动+点击',
    );
  }

  Widget _customMultipleToast(BuildContext context) {
    return MyButton(
      onTap: () {
        TDToast.showText(
          '最多一行展示十个汉字宽度限制最多不超过三行文字最多一行展示十个汉字宽度限制最多不超过三行文字最多一行展示十个汉字宽度限制最多不超过三行文字最多一行展示十个汉字宽度限制最多不超过三行文字最多一行展示十个汉字宽度限制最多不超过三行文字最多一行展示十个汉字宽度限制最多不超过三行文字',
          context: context,
          constraints: BoxConstraints(maxWidth: 350),
          maxLines: 5,
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      isExpanded: true,

      text: '多行文字',
    );
  }
}
