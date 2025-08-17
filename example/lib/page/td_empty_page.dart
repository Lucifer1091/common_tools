import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class TDEmptyPage extends StatefulWidget {
  const TDEmptyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDEmptyPageState();
}

class _TDEmptyPageState extends State<TDEmptyPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'empty',
      desc: '用于空状态时的占位提示。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '图标空状态', builder: _iconEmpty),
            ExampleItem(desc: '自定义图片空状态', builder: _imageEmpty),
            ExampleItem(desc: '带操作空状态', builder: _operationEmpty),
            ExampleItem(desc: '自定义带操作空状态', builder: _operationCustomEmpty),
          ],
        ),
      ],
    );
  }

  Widget _iconEmpty(BuildContext context) {
    return const TDEmpty(type: TDEmptyType.plain, emptyText: '描述文字');
  }

  Widget _imageEmpty(BuildContext context) {
    return TDEmpty(
      type: TDEmptyType.plain,
      emptyText: '描述文字',
      image: Container(
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
    return const TDEmpty(
      type: TDEmptyType.operation,
      operationText: '操作按钮',
      emptyText: '描述文字',
    );
  }

  Widget _operationCustomEmpty(BuildContext context) {
    return TDEmpty(
      type: TDEmptyType.operation,
      emptyText: '描述文字',
      customOperationWidget: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: MyButton(
          text: '自定义操作按钮',
          size: MyButtonSize.medium,
          theme: MyButtonTheme.danger,
          width: 160,
          onTap: () {},
        ),
      ),
    );
  }
}
