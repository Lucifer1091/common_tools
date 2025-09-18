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

  bool value = false;

  @override
  void initState() {
    super.initState();
    controller = MyCheckboxGroupController();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc:
          'Used to perform multiple selections in a preset set of Options and present the selection results.',
      exampleCodeGroup: 'checkbox',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Default.',
              builder: (context) {
                return Checkbox(
                  value: value,
                  onChanged: (bool? value) {
                    setState(() {
                      this.value = value ?? false;
                    });
                  },
                );
              },
            ),
            ExampleItem(
              desc: 'The vertical multi-select box now selects the result.',
              builder: _verticalCheckbox,
            ),
            ExampleItem(
              desc: 'Horizontal multiple-select box',
              builder: _horizontalCheckbox,
            ),
            ExampleItem(
              desc: 'Multiple-choice box with select all',
              builder: _checkAllSelected,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: 'Checkbox status', builder: _checkboxStatus),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: 'Check style', builder: _checkStyle),
            ExampleItem(desc: 'Check Show Location', builder: _checkPosition),
            ExampleItem(
              desc: 'Non-full-width multiple-selection style',
              builder: _passThroughStyle,
            ),
          ],
        ),
        ExampleModule(
          title: 'Special style',
          children: [
            ExampleItem(
              desc: 'Vertical card radio button',
              builder: _verticalCardStyle,
            ),
            ExampleItem(
              desc: 'Horizontal card radio button',
              builder: _horizontalCardStyle,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: 'Custom Icon', builder: _customIconBuildStyle),
        ExampleItem(desc: 'Custom color', builder: _customColor),
        ExampleItem(desc: 'Custom font size', builder: _customFont),
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
          var title = 'Multiple Choice';
          var subTitle = '';
          if (index == 2) {
            title =
                'Multiple selections of Title, multiple lines, multiple selections of Title, multiple lines, multiple selections of Title, multiple lines, multiple selections of Title, multiple lines, multiple selections of Title, multiple lines, multiple selections of Title';
          }
          if (index == 3) {
            subTitle =
                'Description information description information description information description information description information description information description information description information';
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
          title: 'Multiple-select Title',
          style: MyCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        MyCheckbox(
          id: '1',
          title: 'Multiple-select Title',
          style: MyCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        MyCheckbox(
          id: '2',
          title: 'Upper limit of four characters',
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
          var title = 'Multiple-select ';
          if (index == 0) {
            title = 'Select all';
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
                    ? 'Description information description information description information description information description information description information description information description information'
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
            title: 'Options Disable-Selected',
            style: MyCheckboxStyle.circle,
            enable: false,
          ),
          MyCheckbox(
            id: '1',
            title: 'Options Disabled - Default',
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
          child: const MyCheckbox(id: 'index:0', title: 'Multiple-select '),
        ),
        const SizedBox(height: 17),
        MyCheckboxGroupContainer(
          style: MyCheckboxStyle.square,
          selectIds: const ['index:0'],
          child: const MyCheckbox(id: 'index:0', title: 'Multiple-select '),
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
          child: const MyCheckbox(id: 'index:0', title: 'Multiple-select '),
        ),
        MyCheckboxGroupContainer(
          contentDirection: MyContentDirection.left,
          selectIds: const ['index:0'],
          child: const MyCheckbox(id: 'index:0', title: 'Multiple-select '),
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
          var title = 'Multiple-select ';
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
          title: 'Multiple-select ',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
          cardMode: true,
        ),
        MyCheckbox(
          id: 'index:1',
          title: 'Multiple-select ',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
          cardMode: true,
        ),
        MyCheckbox(
          id: 'index:2',
          title: 'Multiple-select ',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
          cardMode: true,
        ),
        MyCheckbox(
          id: 'index:3',
          title: 'Multiple-select ',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
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
        MyCheckbox(id: 'index:0', title: 'Multiple-select ', cardMode: true),
        MyCheckbox(id: 'index:1', title: 'Multiple-select ', cardMode: true),
        MyCheckbox(id: 'index:2', title: 'Multiple-select ', cardMode: true),
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
          title: 'Multiple-select ',
          subTitle: 'Description information',
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
            title: 'Options Disable-Selected',
            style: MyCheckboxStyle.circle,
            enable: false,
          ),
          MyCheckbox(
            selectColor: ThemeColors.error.shade200,
            disableColor: ThemeColors.error.shade50,
            id: '1',
            title: 'Options Disabled - Default',
            style: MyCheckboxStyle.circle,
          ),

          MyCheckbox(
            selectColor: ThemeColors.error.shade200,
            disableColor: ThemeColors.error.shade50,
            id: 'index:0',
            title: 'Multiple-select ',
            subTitle: 'Description information',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
          ),

          MyCheckbox(
            selectColor: ThemeColors.error.shade200,
            id: 'index:1',
            title: 'Multiple-select ',
            titleColor: Colors.green,
            subTitle: 'Description information',
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
            title: 'Options Disable-Selected',
            subTitle: 'description text',
            style: MyCheckboxStyle.circle,
            enable: false,
          ),
          MyCheckbox(
            id: '1',
            title: 'Options Disabled - Default',
            subTitle: 'description text',
            style: MyCheckboxStyle.circle,
          ),

          MyCheckbox(
            id: 'index:0',
            title: 'Multiple-select ',
            subTitle: 'Description information',
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
