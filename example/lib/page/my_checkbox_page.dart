import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyCheckboxPage extends StatefulWidget {
  const MyCheckboxPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyCheckboxPageState();
  }
}

class MyCheckboxPageState extends State<MyCheckboxPage> {
  List<String>? checkIds = ['index:1', 'index:2', 'index:3'];

  MyCheckboxGroupController? controller;

  @override
  void initState() {
    super.initState();
    controller = MyCheckboxGroupController();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于预设的一组Options中执行多项选择，并呈现选择结果。',
      exampleCodeGroup: 'checkbox',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: '纵向多选框', builder: _verticalCheckbox),
            ExampleItem(desc: '横向多选框', builder: _horizontalCheckbox),
            ExampleItem(desc: '带全选多选框', builder: _checkAllSelected),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [ExampleItem(desc: '多选框状态', builder: _checkboxStatus)],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: '勾选样式', builder: _checkStyle),
            ExampleItem(desc: '勾选显示位置', builder: _checkPosition),
            ExampleItem(desc: '非通栏多选样式', builder: _passThroughStyle),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [
            ExampleItem(desc: '纵向卡片单选框', builder: _verticalCardStyle),
            ExampleItem(desc: '横向卡片单选框', builder: _horizontalCardStyle),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: '自定义Icon', builder: _customIconBuildStyle),
        ExampleItem(desc: '自定义颜色', builder: _customColor),
        ExampleItem(desc: '自定义字体尺寸', builder: _customFont),
      ],
    );
  }

  Widget _verticalCheckbox(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['index:1'],
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var title = '多选';
          var subTitle = '';
          if (index == 2) {
            title = '多选Title多行多选Title多行多选Title多行多选Title多行多选Title多行多选Title多行';
          }
          if (index == 3) {
            subTitle = '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息';
          }
          return MyCheckbox(
            id: 'index:$index',
            title: title,
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: subTitle,
          );
        },
        itemCount: 4,
      ),
    );
  }

  Widget _horizontalCheckbox(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['1'],
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        MyCheckbox(
          id: '0',
          title: '多选Title',
          style: MyCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        MyCheckbox(
          id: '1',
          title: '多选Title',
          style: MyCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        MyCheckbox(
          id: '2',
          title: '上限四字',
          style: MyCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _checkAllSelected(BuildContext context) {
    const itemCount = 4;
    return MyCheckboxGroupContainer(
      selectIds: checkIds,
      passThrough: false,
      controller: controller,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '多选';
          if (index == 0) {
            title = '全选';
            return SizedBox(
              height: 56,
              child: MyCheckbox(
                id: 'index:$index',
                title: title,
                customIconBuilder: (context, checked) {
                  var length =
                      controller!.allChecked().length -
                      (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null && !allCheck && length > 0;
                  return getAllIcon(allCheck, halfSelected);
                },
                onCheckBoxChanged: (checked) {
                  if (checked) {
                    controller?.toggleAll(true);
                  } else {
                    controller?.toggleAll(false);
                  }
                },
              ),
            );
          } else {
            return SizedBox(
              height: index == itemCount - 1 ? null : 56,
              child: MyCheckbox(
                id: 'index:$index',
                title: title,
                subTitle: index == itemCount - 1
                    ? '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息'
                    : null,
                subTitleMaxLine: 2,
                onCheckBoxChanged: (checked) {
                  var length =
                      controller!.allChecked().length -
                      (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null && !allCheck && length > 0;
                  controller!.toggle('index:0', allCheck);
                  getAllIcon(allCheck, halfSelected);
                },
              ),
            );
          }
        },
        itemCount: itemCount,
      ),
    );
  }

  Widget _checkboxStatus(BuildContext context) {
    return MyCheckboxGroupContainer(
      contentDirection: MyContentDirection.right,
      selectIds: const ['0'],
      child: const Column(
        children: [
          MyCheckbox(
            id: '0',
            title: 'Options禁用-已选',
            style: MyCheckboxStyle.circle,
            enable: false,
          ),
          MyCheckbox(
            id: '1',
            title: 'Options禁用-默认',
            style: MyCheckboxStyle.circle,
            enable: false,
          ),
        ],
      ),
    );
  }

  Widget _checkStyle(BuildContext context) {
    return Column(
      children: [
        MyCheckboxGroupContainer(
          style: MyCheckboxStyle.check,
          selectIds: const ['index:0'],
          child: const MyCheckbox(id: 'index:0', title: '多选'),
        ),
        const SizedBox(height: 17),
        MyCheckboxGroupContainer(
          style: MyCheckboxStyle.square,
          selectIds: const ['index:0'],
          child: const MyCheckbox(id: 'index:0', title: '多选'),
        ),
      ],
    );
  }

  Widget _checkPosition(BuildContext context) {
    return Column(
      children: [
        MyCheckboxGroupContainer(
          contentDirection: MyContentDirection.right,
          selectIds: const ['index:0'],
          child: const MyCheckbox(id: 'index:0', title: '多选'),
        ),
        MyCheckboxGroupContainer(
          contentDirection: MyContentDirection.left,
          selectIds: const ['index:0'],
          child: const MyCheckbox(id: 'index:0', title: '多选'),
        ),
      ],
    );
  }

  Widget _passThroughStyle(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['index:0'],
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '多选';
          return MyCheckbox(
            id: 'index:$index',
            title: title,
            size: MyCheckboxSize.large,
          );
        },
        itemCount: 4,
      ),
    );
  }

  Widget _verticalCardStyle(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalTdCheckboxes: const [
        MyCheckbox(
          id: 'index:0',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        MyCheckbox(
          id: 'index:1',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        MyCheckbox(
          id: 'index:2',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        MyCheckbox(
          id: 'index:3',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
      ],
    );
  }

  Widget _horizontalCardStyle(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        MyCheckbox(id: 'index:0', title: '多选', cardMode: true),
        MyCheckbox(id: 'index:1', title: '多选', cardMode: true),
        MyCheckbox(id: 'index:2', title: '多选', cardMode: true),
      ],
    );
  }

  Widget _customIconBuildStyle(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalTdCheckboxes: [
        MyCheckbox(
          id: 'index:0',
          title: '多选',
          subTitle: '描述信息',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          cardMode: true,
          customIconBuilder: (context, checked) {
            return const Icon(Icons.dashboard_rounded, size: 12);
          },
        ),
      ],
    );
  }

  Widget _customColor(BuildContext context) {
    return MyCheckboxGroupContainer(
      contentDirection: MyContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children: [
          MyCheckbox(
            selectColor: ThemeColors.error.shade200,
            disableColor: ThemeColors.error.shade50,
            id: '0',
            title: 'Options禁用-已选',
            style: MyCheckboxStyle.circle,
            enable: false,
          ),
          MyCheckbox(
            selectColor: ThemeColors.error.shade200,
            disableColor: ThemeColors.error.shade50,
            id: '1',
            title: 'Options禁用-默认',
            style: MyCheckboxStyle.circle,
          ),

          MyCheckbox(
            selectColor: ThemeColors.error.shade200,
            disableColor: ThemeColors.error.shade50,
            id: 'index:0',
            title: '多选',
            subTitle: '描述信息',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
          ),

          MyCheckbox(
            selectColor: ThemeColors.error.shade200,
            id: 'index:1',
            title: '多选',
            titleColor: Colors.green,
            subTitle: '描述信息',
            subTitleColor: Colors.blue,
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
          ),
        ],
      ),
    );
  }

  Widget _customFont(BuildContext context) {
    return MyCheckboxGroupContainer(
      contentDirection: MyContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children: [
          MyCheckbox(
            id: '0',
            title: 'Options禁用-已选',
            subTitle: '描述文本',
            style: MyCheckboxStyle.circle,
            enable: false,
          ),
          MyCheckbox(
            id: '1',
            title: 'Options禁用-默认',
            subTitle: '描述文本',
            style: MyCheckboxStyle.circle,
          ),

          MyCheckbox(
            id: 'index:0',
            title: '多选',
            subTitle: '描述信息',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
          ),
        ],
      ),
    );
  }

  Widget getAllIcon(bool checked, bool halfSelected) {
    return Icon(
      checked
          ? Icons.check_circle_rounded
          : halfSelected
          ? Icons.remove_circle_rounded
          : Icons.circle,
      size: 24,
      color: (checked || halfSelected)
          ? context.colorScheme.primary
          : ThemeColors.neutral.shade300,
    );
  }
}
