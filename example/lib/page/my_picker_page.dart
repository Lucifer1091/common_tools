import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyPickerPage extends StatefulWidget {
  const MyPickerPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPickerPageState();
}

class _MyPickerPageState extends State<MyPickerPage> {
  String selected_1 = '';
  List<String> data_1 = [
    'Guangzhou',
    'Shaoguan',
    'Shenzhen',
    'Zhuhai',
    'Shantou',
  ];
  String selected_2 = '';
  String selected_3 = '';
  List<List<String>> data_2 = [];
  String selected_4 = '';
  Map data_3 = {
    'Guangdong Province': {
      'Shenzhen City': [
        'Nanshan District',
        "Bao'an District",
        'Luohu District',
        'Futian District',
      ],
      'Foshan City': [''],
      'Guangzhou City': ['Huadu District'],
    },
    'Chongqing': {
      'Chongqing': ['Jiulongpo District', 'Jiangbei District'],
    },
    'Zhejiang Province': {
      'Hangzhou': ['Xihu District', 'Yuhang District', 'Xiaoshan District'],
      'Ningbo': ['Jiangdong District', 'Beilun District', 'Fenghua City'],
    },
    'Hong Kong': {
      'Hong Kong': [
        'Kowloon City District',
        'Wong Tai Sin District',
        'Islands District',
        'Wan Chai District',
      ],
    },
  };

  String selected_5 = '';

  @override
  void initState() {
    var list = <String>[];
    for (var i = 2022; i >= 2000; i--) {
      list.add('Year $i');
    }
    data_2.add(list);
    data_2.add(['Spring', 'Summer', 'Autumn', 'Winter']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'For selection from a set of preset data.',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Basic Picker - Region', builder: _buildArea),
            ExampleItem(desc: 'Basic Picker - Time', builder: _buildTime),
            ExampleItem(
              desc: 'Basic Picker - Region - Linkage',
              builder: _buildMultiArea,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: 'With Title Picker', builder: _buildAreaWithTitle),
            ExampleItem(
              desc: 'Without Title Picker',
              builder: _buildAreaWithoutTitle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArea(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyPicker.showMultiPicker(
          context,
          title: 'Select Region',
          onConfirm: (selected) {
            setState(() {
              selected_1 = data_1[selected[0]];
            });
            Navigator.of(context).pop();
          },
          data: [data_1],
        );
      },
      child: _buildPickerRow(context, selected_1, 'Select Region'),
    );
  }

  Widget _buildTime(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyPicker.showMultiPicker(
          context,
          title: 'Select time',
          onConfirm: (selected) {
            setState(() {
              selected_2 =
                  '${data_2[0][selected[0]]} ${data_2[1][selected[1]]}';
            });
            Navigator.of(context).pop();
          },
          data: data_2,
        );
      },
      child: _buildPickerRow(context, selected_2, 'Select time'),
    );
  }

  Widget _buildMultiArea(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyPicker.showMultiLinkedPicker(
          context,
          title: 'Select Region',
          onConfirm: (selected) {
            setState(() {
              selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
            });
            Navigator.of(context).pop();
          },
          data: data_3,
          columnNum: 3,
          initialData: [
            'Zhejiang Province',
            'Hangzhou City',
            'West Lake District',
          ],
        );
      },
      child: _buildPickerRow(context, selected_3, 'Select Region'),
    );
  }

  Widget _buildAreaWithTitle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyPicker.showMultiPicker(
          context,
          title: 'Select Region',
          onConfirm: (selected) {
            setState(() {
              selected_4 = data_1[selected[0]];
            });
            Navigator.of(context).pop();
          },
          data: [data_1],
        );
      },
      child: _buildPickerRow(context, selected_4, 'With Title'),
    );
  }

  Widget _buildAreaWithoutTitle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyPicker.showMultiPicker(
          context,
          title: '',
          onConfirm: (selected) {
            setState(() {
              selected_5 = data_1[selected[0]];
            });
            Navigator.of(context).pop();
          },
          data: [data_1],
        );
      },
      child: _buildPickerRow(context, selected_5, 'Without Title'),
    );
  }

  Widget _buildPickerRow(BuildContext context, String output, String title) {
    return Container(
      height: 56,
      color: context.colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: MyText(title),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Row(
                children: [
                  Expanded(
                    child: MyText(
                      output,
                      textColor: context.colorScheme.foreground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: context.colorScheme.secondaryForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
