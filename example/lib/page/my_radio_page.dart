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
            ExampleItem(desc: '纵向单选框', builder: _verticalRadios),
            ExampleItem(desc: '横向单选框', builder: _horizontalRadios),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [ExampleItem(desc: '单选框状态', builder: _radioStatus)],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: '勾选样式', builder: _checkStyle),
            ExampleItem(desc: '勾选显示位置', builder: _checkPosition),
            ExampleItem(desc: '非通栏单选样式', builder: _passThroughStyle),
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
        ExampleItem(desc: '横向单选框-显示下划线', builder: _showBottomLine),
        ExampleItem(desc: '横向单选框-自定义下划线', builder: _customBottomLine),
        ExampleItem(desc: '横向单选框-自定义颜色和字体尺寸', builder: _customColorAndFont),
        ExampleItem(
          desc: '横向单选框-自定义禁用字体颜色',
          builder: _customdisabledColorAndFont,
        ),
        ExampleItem(desc: '横向单选框-自定义选框左侧间距', builder: _customRadioLeftSpace),
      ],
    );
  }

  Widget _verticalRadios(BuildContext context) {
    return MyCell(
      title: '单选Title',
      hover: false,
      required: true,
      descriptionWidget: TDRadioGroup(
        selectId: '0',
        direction: Axis.horizontal,
        directionalTdRadios: const [
          MyRadio(id: '0', title: '单选Title0', showDivider: false),
          MyRadio(id: '1', title: '单选Title1', showDivider: false),
        ],
      ),
    );
  }

  Widget _horizontalRadios(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      directionalTdRadios: const [
        MyRadio(
          id: '0',
          title: '单选Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '1',
          title: '单选Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '2',
          title: '上限四字',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _radioStatus(BuildContext context) {
    return TDRadioGroup(
      contentDirection: MyContentDirection.right,
      selectId: '0',
      child: const Column(
        children: [
          MyRadio(
            id: '0',
            title: 'Options禁用-已选',
            radioStyle: MyRadioStyle.circle,
            enabled: false,
          ),
          MyRadio(
            id: '1',
            title: 'Options禁用-默认',
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
        TDRadioGroup(
          radioCheckStyle: MyRadioStyle.check,
          selectId: 'index:0',
          child: const MyRadio(id: 'index:0', title: '单选'),
        ),
        const SizedBox(height: 17),
        TDRadioGroup(
          radioCheckStyle: MyRadioStyle.hollowCircle,
          selectId: 'index:0',
          child: const MyRadio(id: 'index:0', title: '单选'),
        ),
      ],
    );
  }

  Widget _checkPosition(BuildContext context) {
    return Column(
      children: [
        TDRadioGroup(
          contentDirection: MyContentDirection.right,
          selectId: 'index:0',
          child: const MyRadio(id: 'index:0', title: '单选'),
        ),
        TDRadioGroup(
          contentDirection: MyContentDirection.left,
          selectId: 'index:0',
          child: const MyRadio(id: 'index:0', title: '单选', showDivider: false),
        ),
      ],
    );
  }

  Widget _passThroughStyle(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:0',
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '单选';
          return MyRadio(
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
    return TDRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.vertical,
      directionalTdRadios: const [
        MyRadio(
          id: 'index:0',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        MyRadio(
          id: 'index:1',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        MyRadio(
          id: 'index:2',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        MyRadio(
          id: 'index:3',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
      ],
    );
  }

  Widget _horizontalCardStyle(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.horizontal,
      rowCount: 2,
      directionalTdRadios: const [
        MyRadio(id: 'index:0', title: '单选', cardMode: true),
        MyRadio(id: 'index:1', title: '单选', cardMode: true),
        MyRadio(id: 'index:2', title: '单选', cardMode: true),
        MyRadio(id: 'index:3', title: '单选', cardMode: true),
      ],
    );
  }

  Widget _showBottomLine(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      showDivider: true,
      directionalTdRadios: const [
        MyRadio(
          id: '0',
          title: '单选Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '1',
          title: '单选Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '2',
          title: '上限四字',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _customBottomLine(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      showDivider: true,
      divider: const MyDivider(height: 20, color: Colors.red),
      directionalTdRadios: const [
        MyRadio(
          id: '0',
          title: '单选Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '1',
          title: '单选Title',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
        MyRadio(
          id: '2',
          title: '上限四字',
          radioStyle: MyRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _customColorAndFont(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      child: ListView(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          MyRadio(
            id: 'index:1',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            selectedColor: ThemeColors.error.shade200,
          ),
          MyRadio(
            id: 'index:2',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '单选Title多行单选Title多行单选Title多行单选Title多行单选Title多行单选Title多行',
            selectedColor: ThemeColors.error.shade200,
          ),
          MyRadio(
            id: 'index:3',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            selectedColor: ThemeColors.error.shade200,
          ),
          MyRadio(
            id: 'index:4',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '单选Title多行单选Title多行单选Title多行单选Title多行单选Title多行单选Title多行',
            selectedColor: ThemeColors.error.shade200,
            radioStyle: MyRadioStyle.hollowCircle,
          ),
          MyRadio(
            id: 'index:6',
            title: '绿色',
            titleColor: Colors.green,
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '我是蓝色并且有灰色背景',
            subTitleColor: Colors.blue,
            selectedColor: ThemeColors.error.shade200,
            backgroundColor: ThemeColors.neutral.shade100,
          ),
          MyRadio(
            id: 'index:5',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            selectedColor: ThemeColors.error.shade200,
            cardMode: true,
          ),
        ],
      ),
    );
  }

  Widget _customdisabledColorAndFont(BuildContext context) {
    return TDRadioGroup(
      contentDirection: MyContentDirection.right,
      selectId: '0',
      child: Column(
        children: [
          MyRadio(
            id: '0',
            title: 'Options禁用-已选',
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            radioStyle: MyRadioStyle.circle,
            enabled: false,
            // disabledColor: ThemeColors.error.shade50,
          ),
          MyRadio(
            id: '1',
            title: 'Options禁用-默认',
            radioStyle: MyRadioStyle.circle,
            enabled: false,
            // disabledColor: ThemeColors.error.shade50,
          ),
        ],
      ),
    );
  }

  Widget _customRadioLeftSpace(BuildContext context) {
    return MyRadio(
      id: '0',
      title: 'Options禁用-已选',
      subTitle: '描述信息',
      radioStyle: MyRadioStyle.circle,
      checkBoxLeftSpace: 0,
      // disabledColor: ThemeColors.error.shade50,
    );
  }
}
