import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';
import '../../base/example_widget.dart';

class MyCellPage extends StatelessWidget {
  const MyCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'A vertical arrangement of a row of content/functions. The left side of a row of items is the main content display area, and more operational content can be added on the right side.',
      exampleCodeGroup: 'cell',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              ignoreCode: true,
              desc: 'Single Row of Cells',
              center: false,
              builder: (BuildContext context) {
                return _buildSimple(context);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: 'Multiple rows of cells',
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
            ExampleItem(desc: 'Card Cell', builder: _buildCard),
            ExampleItem(
              desc: 'Disabled State',
              builder: (BuildContext context) {
                return MyCell(
                  enabled: false,
                  arrow: true,
                  title: 'Single Row Title',
                );
              },
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          ignoreCode: true,
          desc: 'Custom Padding',
          center: false,
          builder: (BuildContext context) {
            return _buildPadding(context);
          },
        ),
      ],
    );
  }
}

Widget _buildSimple(BuildContext context) {
  var style = MyCellStyle(context: context);
  return MyCellGroup(
    style: style,
    cells: [
      MyCell(
        arrow: true,
        title: 'Single Row Title',
        style: MyCellStyle.style(context),
      ),
      MyCell(
        arrow: true,
        hover: false,
        title: 'Single Row Title',
        required: true,
        onTap: (cell) {
          debugPrint('Single Row Title');
        },
      ),
      const MyCell(
        arrow: true,
        title: 'Single Row Title',
        noteWidget: MyBadge(MyBadgeType.message, count: 8),
      ),
      const MyCell(
        arrow: false,
        title: 'Single Row Title',
        rightIconWidget: MySwitch(isOn: true),
      ),
      const MyCell(
        arrow: true,
        title: 'Single Row Title',
        note: 'Auxiliary Information',
      ),
      const MyCell(
        arrow: true,
        title: 'Single Row Title',
        leftIcon: Icons.lock_open,
      ),
      const MyCell(arrow: false, title: 'Single Row Title'),
    ],
  );
}

Widget _buildDesSimple(BuildContext context) {
  return const MyCellGroup(
    cells: [
      MyCell(
        arrow: true,
        title: 'Single Row Title',
        description: 'A long piece of content text',
      ),
      MyCell(
        arrow: true,
        title: 'Single Row Title',
        description: 'A long piece of content text',
        required: true,
      ),
      MyCell(
        arrow: true,
        title: 'Single Row Title',
        description: 'A long piece of content text',
        noteWidget: MyBadge(MyBadgeType.message, count: 8),
      ),
      MyCell(
        arrow: false,
        title: 'Single Row Title',
        description: 'A long piece of content text',
        rightIconWidget: MySwitch(isOn: true),
      ),
      MyCell(
        arrow: true,
        title: 'Single Row Title',
        description: 'A long piece of content text',
        note: 'Auxiliary Information',
      ),
      MyCell(
        arrow: true,
        title: 'Single Row Title',
        description: 'A long piece of content text',
        leftIcon: Icons.lock_open,
      ),
      MyCell(
        arrow: false,
        title: 'Single Row Title',
        description: 'A long piece of content text',
      ),
      MyCell(
        arrow: false,
        title:
            'Multi-line height is uncertain, long text automatically wraps, the description of this option is a long piece of content',
        description: 'A long piece of content text',
      ),
      MyCell(
        arrow: true,
        title: 'Multi-line with Avatar',
        description: 'A long piece of content text',
        image: AssetImage('assets/img/td_avatar_1.png'),
      ),
      // NetworkImage('https://tdesign.gtimg.com/mobile/demos/avatar1.png')),
      MyCell(
        arrow: true,
        title: 'Multi-line with Avatar',
        description: 'A long piece of content text',
        image: AssetImage('assets/img/td_avatar_1.png'),
      ),
      // NetworkImage('https://tdesign.gtimg.com/mobile/demos/avatar1.png')),
      MyCell(
        arrow: true,
        title: 'Multi-line with Image',
        description: 'A long piece of content text',
        image: AssetImage('assets/img/image.png'),
        imageRadius: 8,
      ),
    ],
  );
}

Widget _buildCard(BuildContext context) {
  return MyCellGroup(
    theme: MyCellGroupTheme.card,
    style: MyCellStyle.style(
      context,
    ).copyWith(backgroundColor: context.colorScheme.secondary),
    cells: [
      MyCell(arrow: true, title: 'Single Row Title'),
      MyCell(arrow: true, title: 'Single Row Title', required: true),
      MyCell(arrow: true, title: 'Single Row Title'),
    ],
  );
}

Widget _buildPadding(BuildContext context) {
  var style = MyCellStyle.style(context).copyWith(
    backgroundColor: context.colorScheme.secondary,
    padding: const EdgeInsets.all(30),
  );
  return MyCellGroup(
    theme: MyCellGroupTheme.card,
    style: style,
    cells: [
      MyCell(
        arrow: true,
        title: 'padding-all-30',
        onTap: (cell) {
          debugPrint('padding-all-30');
        },
      ),
    ],
  );
}
