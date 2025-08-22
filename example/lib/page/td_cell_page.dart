import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDCellPage extends StatelessWidget {
  const TDCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.neutral.shade100,
      child: ExamplePage(
        title: tdTitle(context),
        desc: '一行内容/功能的垂直排列方式。一行项目左侧为主要内容展示区域，右侧可增加更多操作内容。',
        exampleCodeGroup: 'cell',
        children: [
          ExampleModule(
            title: 'Component Types',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '单行单元格',
                center: false,
                builder: (BuildContext context) {
                  return _buildSimple(context);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '多行单元格',
                center: false,
                builder: (BuildContext context) {
                  return _buildDesSimple(context);
                },
              ),
            ],
          ),
          ExampleModule(
            title: 'Component Style',
            children: [
              ExampleItem(
                ignoreCode: true,
                desc: '卡片单元格',
                center: false,
                builder: (BuildContext context) {
                  return _buildCard(context);
                },
              ),
            ],
          ),
        ],
        test: [
          ExampleItem(
            ignoreCode: true,
            desc: '自定义内边距-padding',
            center: false,
            builder: (BuildContext context) {
              return _buildPadding(context);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildSimple(BuildContext context) {
  // 可统一修改样式
  var style = TDCellStyle(context: context);
  return TDCellGroup(
    style: style,
    cells: [
      // 可单独修改样式
      TDCell(arrow: true, title: '单行标题', style: TDCellStyle.cellStyle(context)),
      TDCell(
        arrow: true,
        title: '单行标题',
        required: true,
        onClick: (cell) {
          print('单行标题');
        },
      ),
      const TDCell(
        arrow: true,
        title: '单行标题',
        noteWidget: TDBadge(TDBadgeType.message, count: 8),
      ),
      const TDCell(
        arrow: false,
        title: '单行标题',
        rightIconWidget: TDSwitch(isOn: true),
      ),
      const TDCell(arrow: true, title: '单行标题', note: '辅助信息'),
      const TDCell(arrow: true, title: '单行标题', leftIcon: Icons.lock_open),
      const TDCell(arrow: false, title: '单行标题'),
    ],
  );
}

Widget _buildDesSimple(BuildContext context) {
  return const TDCellGroup(
    cells: [
      TDCell(arrow: true, title: '单行标题', description: '一段很长很长的内容文字'),
      TDCell(
        arrow: true,
        title: '单行标题',
        description: '一段很长很长的内容文字',
        required: true,
      ),
      TDCell(
        arrow: true,
        title: '单行标题',
        description: '一段很长很长的内容文字',
        noteWidget: TDBadge(TDBadgeType.message, count: 8),
      ),
      TDCell(
        arrow: false,
        title: '单行标题',
        description: '一段很长很长的内容文字',
        rightIconWidget: TDSwitch(isOn: true),
      ),
      TDCell(
        arrow: true,
        title: '单行标题',
        description: '一段很长很长的内容文字',
        note: '辅助信息',
      ),
      TDCell(
        arrow: true,
        title: '单行标题',
        description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内',
        leftIcon: Icons.lock_open,
      ),
      TDCell(
        arrow: false,
        title: '单行标题',
        description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内',
      ),
      TDCell(
        arrow: false,
        title: '多行高度不定，长文本自动换行，该选项的描述是一段很长的内容',
        description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内',
      ),
      TDCell(
        arrow: true,
        title: '多行带头像',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/td_avatar_1.png'),
      ),
      // NetworkImage('https://tdesign.gtimg.com/mobile/demos/avatar1.png')),
      TDCell(
        arrow: true,
        title: '多行带图片',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/image.png'),
        imageCircle: 8,
      ),
    ],
  );
}

Widget _buildCard(BuildContext context) {
  return const TDCellGroup(
    theme: TDCellGroupTheme.cardTheme,
    cells: [
      TDCell(arrow: true, title: '单行标题'),
      TDCell(arrow: true, title: '单行标题', required: true),
      TDCell(arrow: true, title: '单行标题'),
    ],
  );
}

Widget _buildPadding(BuildContext context) {
  var style = TDCellStyle(context: context);
  style.padding = const EdgeInsets.all(30);
  return TDCellGroup(
    theme: TDCellGroupTheme.cardTheme,
    cells: [
      TDCell(
        arrow: true,
        title: 'padding-all-30',
        style: style,
        onClick: (cell) {
          print('padding-all-30');
        },
      ),
    ],
  );
}

// 
// Widget _buildBorder(BuildContext context) {
//   return const TDCellGroup(
//     theme: TDCellGroupTheme.cardTheme,
//     bordered: true,
//     cells: [
//       TDCell(arrow: true, title: '单行标题'),
//       TDCell(arrow: true, title: '单行标题', required: true),
//       TDCell(arrow: true, title: '单行标题'),
//     ],
//   );
// }

// 
// Widget _buildTitle(BuildContext context) {
//   var style = TDCellStyle.cellStyle(context);
//   style.leftIconColor = ThemeColors.neutral.shade900;
//   return TDCellGroup(
//     title: '标题',
//     style: style,
//     cells: const [
//       TDCell(title: 'item', leftIcon: Icons.dashboard_rounded),
//       TDCell(title: 'item', leftIcon: Icons.dashboard_rounded),
//       TDCell(title: 'item', leftIcon: Icons.dashboard_rounded),
//     ],
//   );
// }
