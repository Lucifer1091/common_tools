import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class TDSwipeCellPage extends StatelessWidget {
  const TDSwipeCellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      exampleCodeGroup: 'swipecell',
      desc: '用于承载列表中的更多操作，通过左右滑动来展示，按钮的宽度固定高度根据列表高度而变化。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '左滑单操作', builder: _buildSwiperCell),
            ExampleItem(desc: '左滑双操作', builder: _buildSwiperMuliCell),
            ExampleItem(desc: '左滑三操作', builder: _buildSwiper3Cell),
            ExampleItem(desc: '右滑单操作', builder: _buildSwiperRightCell),
            ExampleItem(desc: '左右滑操作', builder: _buildSwiperRightLeftCell),
            ExampleItem(desc: '带图标的滑动操作', builder: _buildSwiperIconCell),
            ExampleItem(desc: '带二次确认的操作', builder: _buildSwiperConfirmCell),
          ],
        ),
      ],
      test: const [],
    );
  }

  Widget _buildSwiperCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    var list = [
      {'id': '1', 'title': '左滑操作', 'note': '辅助信息', 'description': ''},
      {
        'id': '2',
        'title': '左滑操作',
        'note': '辅助信息',
        'description': '一段很长很长的内容文字',
      },
    ];
    final cellLength = ValueNotifier<int>(list.length);
    return ValueListenableBuilder(
      valueListenable: cellLength,
      builder: (BuildContext context, value, Widget? child) {
        return TDCellGroup(
          cells: list
              .map(
                (e) => TDCell(
                  title: e['title'],
                  note: e['note'],
                  description: e['description'],
                ),
              )
              .toList(),
          builder: (context, cell, index) {
            return TDSwipeCell(
              slidableKey: ValueKey(list[index]['id']),
              groupTag: 'test',
              onChange: (direction, open) {
                print('打开方向：$direction');
                print('打开转态$open');
              },
              right: TDSwipeCellPanel(
                extentRatio: 60 / screenWidth,
                // dragDismissible: true,
                onDismissed: (context) {
                  list.removeAt(index);
                  cellLength.value = list.length;
                },
                children: [
                  TDSwipeCellAction(
                    backgroundColor: ThemeColors.error.shade500,
                    label: '删除',
                    onPressed: (context) {
                      print('点击action');
                      print(TDSwipeCell.of(context));
                      print(TDSwipeCellInherited.of(context)?.controller);
                      list.removeAt(index);
                      cellLength.value = list.length;
                    },
                  ),
                ],
              ),
              cell: cell,
            );
          },
        );
      },
    );
  }

  Widget _buildSwiperMuliCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      right: TDSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.warning.shade300,
            label: '编辑',
          ),
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.error.shade500,
            label: '删除',
          ),
        ],
      ),
      cell: const TDCell(title: '左滑操作', note: '辅助信息'),
    );
  }

  Widget _buildSwiper3Cell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      right: TDSwipeCellPanel(
        extentRatio: 180 / screenWidth,
        children: [
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.blue.shade600,
            label: '保存',
          ),
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.warning.shade300,
            label: '编辑',
          ),
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.error.shade500,
            label: '删除',
          ),
        ],
      ),
      cell: const TDCell(title: '左滑操作', note: '辅助信息'),
    );
  }

  Widget _buildSwiperRightCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      left: TDSwipeCellPanel(
        extentRatio: 60 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: ThemeColors.blue.shade600,
            label: '选择',
          ),
        ],
      ),
      cell: const TDCell(title: '右滑操作', note: '辅助信息'),
    );
  }

  Widget _buildSwiperRightLeftCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      left: TDSwipeCellPanel(
        extentRatio: 60 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: ThemeColors.blue.shade600,
            label: '选择',
          ),
        ],
      ),
      right: TDSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.warning.shade300,
            label: '编辑',
          ),
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.error.shade500,
            label: '删除',
          ),
        ],
      ),
      cell: const TDCell(title: '左右滑操作', note: '辅助信息'),
    );
  }

  Widget _buildSwiperIconCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return TDSwipeCell(
            groupTag: 'test',
            right: TDSwipeCellPanel(
              extentRatio: (80 + 80) / screenWidth,
              children: [
                TDSwipeCellAction(
                  flex: 80,
                  backgroundColor: ThemeColors.warning.shade300,
                  icon: Icons.edit,
                  label: '编辑',
                ),
                TDSwipeCellAction(
                  flex: 80,
                  backgroundColor: ThemeColors.error.shade500,
                  icon: Icons.delete,
                  label: '删除',
                ),
              ],
            ),
            cell: const TDCell(title: '左滑操作', note: '辅助信息'),
          );
        } else if (index == 1) {
          return TDSwipeCell(
            groupTag: 'test',
            right: TDSwipeCellPanel(
              extentRatio: 120 / screenWidth,
              children: [
                TDSwipeCellAction(
                  flex: 60,
                  backgroundColor: ThemeColors.warning.shade300,
                  icon: Icons.edit,
                ),
                TDSwipeCellAction(
                  flex: 60,
                  backgroundColor: ThemeColors.error.shade500,
                  icon: Icons.delete,
                ),
              ],
            ),
            cell: const TDCell(title: '左滑操作', note: '辅助信息'),
          );
        } else {
          return TDSwipeCell(
            groupTag: 'test',
            right: TDSwipeCellPanel(
              extentRatio: 120 / screenWidth,
              children: [
                TDSwipeCellAction(
                  flex: 60,
                  backgroundColor: ThemeColors.warning.shade300,
                  direction: Axis.vertical,
                  icon: Icons.edit,
                  label: '编辑',
                ),
                TDSwipeCellAction(
                  flex: 60,
                  backgroundColor: ThemeColors.error.shade500,
                  direction: Axis.vertical,
                  icon: Icons.delete,
                  label: '删除',
                ),
              ],
            ),
            cell: const TDCell(
              title: '左滑操作',
              note: '辅助信息',
              description: '一段很长很长的内容文字',
            ),
          );
        }
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 24);
      },
    );
  }

  Widget _buildSwiperConfirmCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      right: TDSwipeCellPanel(
        extentRatio: (60 + 60) / screenWidth,
        children: [
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.warning.shade300,
            label: '编辑',
          ),
          TDSwipeCellAction(
            flex: 60,
            backgroundColor: ThemeColors.error.shade500,
            label: '删除',
          ),
        ],
        confirms: [
          TDSwipeCellAction(
            backgroundColor: ThemeColors.error.shade500,
            label: '确认删除',
            confirmIndex: const [1],
          ),
        ],
      ),
      cell: const TDCell(title: '左滑操作', note: '辅助信息'),
    );
  }
}
