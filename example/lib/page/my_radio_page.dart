import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyRadioPage extends StatefulWidget {
  const MyRadioPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyRadioPageState();
  }
}

class MyRadioPageState extends State<MyRadioPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'radio',
      backgroundColor: const Color(0xfff6f6f6),
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Vertical Radio Button',
              builder: _verticalRadios,
            ),
            ExampleItem(
              desc: 'Horizontal Radio Button',
              builder: _horizontalRadios,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: 'Radio Button State', builder: _radioStatus),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: 'Check style', builder: _checkStyle),
            ExampleItem(desc: 'Check Show Location', builder: _checkPosition),
            ExampleItem(
              desc: 'Non-full-width radio button style',
              builder: _passThroughStyle,
            ),
          ],
        ),
        ExampleModule(
          title: 'Special Style',
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
    );
  }

  Widget _verticalRadios(BuildContext context) {
    return MyCell(
      title: 'Single-choice Title',
      hover: false,
      required: true,
      descriptionWidget: MyRadioGroup(
        selectId: '0',
        direction: Axis.horizontal,
        directionalTdRadios: const [
          MyRadio(id: '0', title: 'Single choice Title0', showDivider: false),
          MyRadio(id: '1', title: 'Single choice Title1', showDivider: false),
        ],
      ),
    );
  }

  Widget _horizontalRadios(BuildContext context) {
    return MyRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      directionalTdRadios: const [
        MyRadio(
          id: '0',
          title: 'Single-choice Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '1',
          title: 'Single-choice Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '2',
          title: 'Upper limit of four characters',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _radioStatus(BuildContext context) {
    return MyRadioGroup(
      contentDirection: MyContentDirection.right,
      selectId: '0',
      child: const Column(
        children: [
          MyRadio(
            id: '0',
            title: 'Options Disabled - Selected',
            radioStyle: MyRadioStyle.circle,
            enabled: false,
          ),
          MyRadio(
            id: '1',
            title: 'Options Disabled - Default',
            radioStyle: MyRadioStyle.circle,
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _checkStyle(BuildContext context) {
    return Column(
      children: [
        MyRadioGroup(
          radioCheckStyle: MyRadioStyle.circle,
          selectId: 'index:0',
          child: const MyRadio(id: 'index:0', title: 'Single choice'),
        ),
        const SizedBox(height: 17),
        MyRadioGroup(
          radioCheckStyle: MyRadioStyle.square,
          selectId: 'index:0',
          child: const MyRadio(id: 'index:0', title: 'Single choice'),
        ),
      ],
    );
  }

  Widget _checkPosition(BuildContext context) {
    return Column(
      children: [
        MyRadioGroup(
          contentDirection: MyContentDirection.right,
          selectId: 'index:0',
          child: const MyRadio(id: 'index:0', title: 'Single choice'),
        ),
        MyRadioGroup(
          contentDirection: MyContentDirection.left,
          selectId: 'index:0',
          child: const MyRadio(
            id: 'index:0',
            title: 'Single choice',
            showDivider: false,
          ),
        ),
      ],
    );
  }

  Widget _passThroughStyle(BuildContext context) {
    return MyRadioGroup(
      selectId: 'index:0',
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = 'Single choice';
          return MyRadio(
            id: 'index:$index',
            title: title,
            backgroundColor: context.colorScheme.secondary.withValues(
              alpha: 0.5,
            ),
            size: MyCheckboxSize.large,
            showDivider: index != 3,
          );
        },
        itemCount: 4,
      ),
    );
  }

  Widget _verticalCardStyle(BuildContext context) {
    return MyRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.vertical,
      directionalTdRadios: [
        MyRadio(
          id: 'index:0',
          title: 'Single choice',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
        MyRadio(
          id: 'index:1',
          title: 'Single choice',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
        MyRadio(
          id: 'index:2',
          title: 'Single choice',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
        MyRadio(
          id: 'index:3',
          title: 'Single choice',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: 'Description information',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _horizontalCardStyle(BuildContext context) {
    return MyRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.horizontal,
      rowCount: 2,
      directionalTdRadios: [
        MyRadio(
          id: 'index:0',
          title: 'Single choice',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
        MyRadio(
          id: 'index:1',
          title: 'Single choice',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
        MyRadio(
          id: 'index:2',
          title: 'Single choice',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
        MyRadio(
          id: 'index:3',
          title: 'Single choice',
          cardMode: true,
          backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
