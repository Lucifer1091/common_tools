import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

const _list = [
  {
    'index': 'A',
    'children': [
      'Aba',
      'Alashan',
      'Nari',
      'Ankang',
      'Anqing',
      'Anshan',
      'Anshun',
      'Anyang',
      'Macao',
    ],
  },
  {
    'index': 'B',
    'children': [
      'Beijing',
      'Baiyin',
      'Baoding',
      'Baoji',
      'Baoshan',
      'Baotou',
      'Bazhong',
      'Beihai',
      'Bengbu',
      'Benxi',
      'Bijie',
      'Binzhou',
      'Baise',
      'Bozhou',
    ],
  },
  {
    'index': 'C',
    'children': [
      'Chongqing',
      'Chengdu',
      'Changsha',
      'Changchun',
      'Cangzhou',
      'Changde',
      'Chamdo',
      'Changzhi',
      'Changzhou',
      'Chaohu',
      'Chaozhou',
      'Chengde',
      'Chenzhou',
      'Chifeng',
      'Chizhou',
      'Chongzuo',
      'Chuxiong',
      'Chuzhou',
      'Chaoyang',
    ],
  },
  {
    'index': 'D',
    'children': [
      'Dalian',
      'Dongguan',
      'Dali',
      'Dandong',
      'Daqing',
      'Datong',
      "Daxing'anling",
      'Dehong',
      'Deyang',
      'Dezhou',
      'Dingxi',
      'Diqing',
      'Dongying',
    ],
  },
  {
    'index': 'E',
    'children': ['Ordos', 'Enshi', 'Ezhou'],
  },
  {
    'index': 'F',
    'children': [
      'Fuzhou',
      'Fangchenggang',
      'Foshan',
      'Fushun',
      'Fuzhou',
      'Fuxin',
      'Fuyang',
    ],
  },
  {
    'index': 'G',
    'children': [
      'Guangzhou',
      'Guilin',
      'Guiyang',
      'Gannan',
      'Ganzhou',
      'Ganzi',
      "Guang'an",
      'Guangyuan',
      'Guigang',
      'Guolok',
    ],
  },
  {
    'index': 'J',
    'children': [
      'Jieyang',
      'Jilin',
      'Jinjiang',
      "Ji'an",
      'Jiaozhou',
      'Jiaxing',
      'Jinan',
      'Jixi',
      'Jingzhou',
      'Jiangmen',
      'Keelung',
    ],
  },
  {
    'index': 'K',
    'children': ['Kunming', 'Kaifeng', 'Kangding', 'Kashgar'],
  },
];

class MyIndexesPage extends StatelessWidget {
  const MyIndexesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      desc:
          'Used for quick retrieval of information on a page, you can quickly find the required content based on the page number in the directory. ',
      exampleCodeGroup: 'indexes',
      navBarKey: navBarkey,
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              ignoreCode: true,
              desc: 'Basic index type',
              builder: (BuildContext context) {
                return _buildSimple(context);
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              ignoreCode: true,
              desc: 'Other index types',
              builder: (BuildContext context) {
                return _buildOther(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimple(BuildContext context) {
    final renderBox =
        navBarkey.currentContext?.findRenderObject() as RenderBox?;
    final indexList = _list.map((item) => item['index'] as String).toList();
    return MyButton(
      text: 'Basic usage',
      isExpanded: true,
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            slideTransitionFrom: MySlideFrom.right,
            modalTop: renderBox?.size.height,
            builder: (context) {
              return ExamplePage(
                title: 'Basic Index',
                exampleCodeGroup: '',
                showSingleChild: true,
                singleChild: (context) {
                  return Container(
                    color: context.colorScheme.background,
                    child: MyIndexes(
                      indexList: indexList,
                      builder: (context, index) {
                        final list =
                            _list.firstWhere(
                                  (element) => element['index'] == index,
                                )['children']
                                as List<String>;
                        return MyCellGroup(
                          cells: list.map((e) => MyCell(title: e)).toList(),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOther(BuildContext context) {
    final renderBox =
        navBarkey.currentContext?.findRenderObject() as RenderBox?;
    final indexList = _list.map((item) => item['index'] as String).toList();
    return MyButton(
      text: 'Capsule Index',
      isExpanded: true,
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      onTap: () {
        Navigator.of(context).push(
          MySlidePopupRoute(
            slideTransitionFrom: MySlideFrom.right,
            modalTop: renderBox?.size.height,
            builder: (context) {
              return ExamplePage(
                title: 'Capsule Index',
                exampleCodeGroup: '',
                showSingleChild: true,
                singleChild: (context) {
                  return Container(
                    color: context.colorScheme.background,
                    child: MyIndexes(
                      indexList: indexList,
                      capsuleTheme: true,
                      builder: (context, index) {
                        final list =
                            _list.firstWhere(
                                  (element) => element['index'] == index,
                                )['children']
                                as List<String>;
                        return MyCellGroup(
                          cells: list.map((e) => MyCell(title: e)).toList(),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
