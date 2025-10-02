import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

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

  late MyCheckboxGroupController controller;

  // bool? value;

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
            // ExampleItem(
            //   desc: 'Check',
            //   builder: (context) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         MyCheckbox(
            //           checked: value,
            //           size: MyCheckboxSize.large,
            //           shape: MyCheckboxShape.check,
            //           tristate: true,
            //           onChanged: (bool? value) {
            //             setState(() {
            //               this.value = value;
            //             });
            //           },
            //         ),
            //         MyCheckbox(
            //           checked: value,
            //           size: MyCheckboxSize.large,
            //           shape: MyCheckboxShape.circle,
            //           tristate: true,
            //           onChanged: (bool? value) {
            //             setState(() {
            //               this.value = value;
            //             });
            //           },
            //         ),
            //         MyCheckbox(
            //           checked: value,
            //           size: MyCheckboxSize.large,
            //           shape: MyCheckboxShape.square,
            //           tristate: true,
            //           onChanged: (bool? value) {
            //             setState(() {
            //               this.value = value;
            //             });
            //           },
            //         ),
            //       ],
            //     );
            //   },
            // ),
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
          title: 'Component shape',
          children: [
            ExampleItem(desc: 'Check shape', builder: _checkshape),
            ExampleItem(desc: 'Check Show Location', builder: _checkPosition),
            ExampleItem(
              desc: 'Non-full-width multiple-selection shape',
              builder: _passThroughshape,
            ),
          ],
        ),
        ExampleModule(
          title: 'Special shape',
          children: [
            ExampleItem(
              desc: 'Vertical card radio button',
              builder: _verticalCardshape,
            ),
            ExampleItem(
              desc: 'Horizontal card radio button',
              builder: _horizontalCardshape,
            ),
          ],
        ),
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
      directionalMyCheckboxes: const [
        MyCheckbox(
          id: '0',
          title: 'Multiple-select Title',
          shape: MyCheckboxShape.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        MyCheckbox(
          id: '1',
          title: 'Multiple-select Title',
          shape: MyCheckboxShape.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        MyCheckbox(
          id: '2',
          title: 'Upper limit of four characters',
          shape: MyCheckboxShape.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _checkAllSelected(BuildContext context) {
    const itemCount = 4;

    bool? state(int total) {
      final list = controller.allChecked();

      final length = list.length - (controller.checked('index:0') ? 1 : 0);
      final allCheck = total - 1 == length;

      if (list.isEmpty) return false;

      if (allCheck) return true;

      return null;
    }

    return MyCheckboxGroupContainer(
      selectIds: checkIds,
      passThrough: false,
      controller: controller,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = 'Multiple-select';
          if (index == 0) {
            title = 'Select all';
            return MyCheckbox(
              id: 'index:$index',
              title: title,
              tristate: true,
              checked: state(itemCount),
              onChanged: (checked) {
                if (checked ?? false) {
                  controller.toggleAll(true);
                } else {
                  controller.toggleAll(false);
                }
              },
            );
          } else {
            return MyCheckbox(
              id: 'index:$index',
              title: title,
              subTitle: index == itemCount - 1
                  ? 'Description information description information description information description information description information description information description information description information'
                  : null,
              subTitleMaxLine: 2,
              onChanged: (checked) {
                controller.toggle('index:0', state(itemCount));
              },
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
            shape: MyCheckboxShape.circle,
            enabled: false,
          ),
          MyCheckbox(
            id: '1',
            title: 'Options Disabled - Default',
            shape: MyCheckboxShape.circle,
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _checkshape(BuildContext context) {
    return Column(
      children: [
        MyCheckboxGroupContainer(
          shape: MyCheckboxShape.check,
          selectIds: const ['index:0'],
          child: const MyCheckbox(id: 'index:0', title: 'Multiple-select '),
        ),
        const Gap(17),
        MyCheckboxGroupContainer(
          shape: MyCheckboxShape.square,
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

  Widget _passThroughshape(BuildContext context) {
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
            backgroundColor: context.colorScheme.secondary.withValues(
              alpha: 0.5,
            ),
          );
        },
        itemCount: 4,
      ),
    );
  }

  Widget _verticalCardshape(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalMyCheckboxes: const [
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

  Widget _horizontalCardshape(BuildContext context) {
    return MyCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.horizontal,
      directionalMyCheckboxes: const [
        MyCheckbox(id: 'index:0', title: 'Multiple-select ', cardMode: true),
        MyCheckbox(id: 'index:1', title: 'Multiple-select ', cardMode: true),
        MyCheckbox(id: 'index:2', title: 'Multiple-select ', cardMode: true),
      ],
    );
  }
}
