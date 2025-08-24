import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

///
/// TDRadio演示
///
class TDRadioPage extends StatefulWidget {
  const TDRadioPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TDRadioPageState();
  }
}

class TDRadioPageState extends State<TDRadioPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
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
          builder: _customDisableColorAndFont,
        ),
        ExampleItem(desc: '横向单选框-自定义选框左侧间距', builder: _customRadioLeftSpace),
      ],
    );
  }

  Widget _verticalRadios(BuildContext context) {
    return MyCell(
      title: '单选标题',
      hover: false,
      required: true,
      descriptionWidget: TDRadioGroup(
        selectId: '0',
        direction: Axis.horizontal,
        directionalTdRadios: const [
          TDRadio(id: '0', title: '单选标题0', showDivider: false),
          TDRadio(id: '1', title: '单选标题1', showDivider: false),
        ],
      ),
    );
  }

  Widget _horizontalRadios(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      directionalTdRadios: const [
        TDRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _radioStatus(BuildContext context) {
    return TDRadioGroup(
      contentDirection: TDContentDirection.right,
      selectId: '0',
      child: const Column(
        children: [
          TDRadio(
            id: '0',
            title: '选项禁用-已选',
            radioStyle: TDRadioStyle.circle,
            enable: false,
          ),
          TDRadio(
            id: '1',
            title: '选项禁用-默认',
            radioStyle: TDRadioStyle.circle,
            enable: false,
          ),
        ],
      ),
    );
  }

  Widget _checkStyle(BuildContext context) {
    return Column(
      children: [
        TDRadioGroup(
          radioCheckStyle: TDRadioStyle.check,
          selectId: 'index:0',
          child: const TDRadio(id: 'index:0', title: '单选'),
        ),
        const SizedBox(height: 17),
        TDRadioGroup(
          radioCheckStyle: TDRadioStyle.hollowCircle,
          selectId: 'index:0',
          child: const TDRadio(id: 'index:0', title: '单选'),
        ),
      ],
    );
  }

  Widget _checkPosition(BuildContext context) {
    return Column(
      children: [
        TDRadioGroup(
          contentDirection: TDContentDirection.right,
          selectId: 'index:0',
          child: const TDRadio(id: 'index:0', title: '单选'),
        ),
        TDRadioGroup(
          contentDirection: TDContentDirection.left,
          selectId: 'index:0',
          child: const TDRadio(id: 'index:0', title: '单选', showDivider: false),
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
          return TDRadio(
            id: 'index:$index',
            title: title,
            size: TDCheckBoxSize.large,
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
        TDRadio(
          id: 'index:0',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:1',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:2',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
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
        TDRadio(id: 'index:0', title: '单选', cardMode: true),
        TDRadio(id: 'index:1', title: '单选', cardMode: true),
        TDRadio(id: 'index:2', title: '单选', cardMode: true),
        TDRadio(id: 'index:3', title: '单选', cardMode: true),
      ],
    );
  }

  Widget _showBottomLine(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      showDivider: true,
      directionalTdRadios: const [
        TDRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TDRadioStyle.circle,
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
        TDRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TDRadioStyle.circle,
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
          TDRadio(
            id: 'index:1',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            selectColor: ThemeColors.error.shade200,
          ),
          TDRadio(
            id: 'index:2',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行',
            selectColor: ThemeColors.error.shade200,
          ),
          TDRadio(
            id: 'index:3',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            selectColor: ThemeColors.error.shade200,
          ),
          TDRadio(
            id: 'index:4',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行',
            selectColor: ThemeColors.error.shade200,
            radioStyle: TDRadioStyle.hollowCircle,
          ),
          TDRadio(
            id: 'index:6',
            title: '绿色',
            titleColor: Colors.green,
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '我是蓝色并且有灰色背景',
            subTitleColor: Colors.blue,
            selectColor: ThemeColors.error.shade200,
            backgroundColor: ThemeColors.neutral.shade100,
          ),
          TDRadio(
            id: 'index:5',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            selectColor: ThemeColors.error.shade200,
            cardMode: true,
          ),
        ],
      ),
    );
  }

  Widget _customDisableColorAndFont(BuildContext context) {
    return TDRadioGroup(
      contentDirection: TDContentDirection.right,
      selectId: '0',
      child: Column(
        children: [
          TDRadio(
            id: '0',
            title: '选项禁用-已选',
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            radioStyle: TDRadioStyle.circle,
            enable: false,
            disableColor: ThemeColors.error.shade50,
          ),
          TDRadio(
            id: '1',
            title: '选项禁用-默认',
            radioStyle: TDRadioStyle.circle,
            enable: false,
            disableColor: ThemeColors.error.shade50,
          ),
        ],
      ),
    );
  }

  Widget _customRadioLeftSpace(BuildContext context) {
    return TDRadio(
      id: '0',
      title: '选项禁用-已选',
      subTitle: '描述信息',
      radioStyle: TDRadioStyle.circle,
      checkBoxLeftSpace: 0,
      disableColor: ThemeColors.error.shade50,
    );
  }
}
