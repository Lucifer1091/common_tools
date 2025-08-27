import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyStepsPage extends StatefulWidget {
  const MyStepsPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyStepsPageState();
}

class _MyStepsPageState extends State<MyStepsPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.primaryForeground,
      title: tdTitle(),
      exampleCodeGroup: 'steps',
      desc: 'Steps Bar',
      children: [
        ExampleModule(
          title: 'Horizontal Bars',
          children: [
            ExampleItem(desc: 'Default Bar', builder: _buildBasicHSteps3),
            ExampleItem(desc: 'Icon Bar', builder: _buildHIconSteps3),
            ExampleItem(desc: 'Simple Bar', builder: _buildSimpleHSteps3),
          ],
        ),
        ExampleModule(
          title: 'Horizontal Error Bars',
          children: [
            ExampleItem(desc: 'Error Bar', builder: _buildHErrorSteps1),
            ExampleItem(desc: 'Error Icon Bar', builder: _buildHErrorSteps2),
            ExampleItem(desc: 'Error Simple Bar', builder: _buildHErrorSteps3),
          ],
        ),
        ExampleModule(
          title: 'Vertical Bar',
          children: [
            ExampleItem(
              desc: 'Vertical Default Bar',
              builder: _buildVBasicSteps,
            ),
            ExampleItem(desc: 'Vertical Icon Bar', builder: _buildVIconSteps),
            ExampleItem(
              desc: 'Vertical Simple Bar',
              builder: _buildVSimpleSteps,
            ),
            ExampleItem(
              desc: 'Vertical Error Bar',
              builder: _buildVErrorBasicSteps,
            ),
            ExampleItem(
              desc: 'Vertical error status icons Bar',
              builder: _buildVErrorIconSteps,
            ),
            ExampleItem(
              desc: 'Vertical error status simple Bar',
              builder: _buildVErrorSimpleSteps,
            ),
            ExampleItem(
              desc: 'Vertical custom title base Bar',
              builder: _buildVCustomTitleBaseSteps,
            ),
            ExampleItem(
              desc: 'Vertical custom content base Bar',
              builder: _buildVCustomContentBaseSteps,
            ),
          ],
        ),
        ExampleModule(
          title: 'Extension Bar',
          children: [
            ExampleItem(
              desc: 'Read-only Steps Pure display level Bar',
              builder: _buildHReadOnlySteps,
            ),
            ExampleItem(
              desc: 'Read-only Steps Pure display vertical Bar',
              builder: _buildVReadOnlySteps,
            ),
            ExampleItem(
              desc: 'Vertical Customize Steps Vertical customization Bar',
              builder: _buildVCustomizeSteps,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicHSteps3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: [
                MyStepItem(title: 'Steps1', content: 'Content1'),
                MyStepItem(title: 'Steps2', content: 'Content2'),
                MyStepItem(title: 'Steps3', content: 'Content3'),
                MyStepItem(title: 'Steps4', content: 'Content4'),
              ],
              direction: MyStepsDirection.horizontal,
              activeIndex: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHIconSteps3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: [
                MyStepItem(
                  title: 'Steps1',
                  content: 'Content1',
                  successIcon: LucideIcons.phone,
                ),
                MyStepItem(
                  title: 'Steps2',
                  content: 'Content2',
                  successIcon: LucideIcons.phone,
                ),
                MyStepItem(
                  title: 'Steps3',
                  content: 'Content3',
                  successIcon: LucideIcons.phone,
                ),
                MyStepItem(
                  title: 'Steps4',
                  content: 'Content4',
                  successIcon: LucideIcons.phone,
                ),
              ],
              direction: MyStepsDirection.horizontal,
              activeIndex: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleHSteps3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: [
                MyStepItem(title: 'Steps1', content: 'Content1'),
                MyStepItem(title: 'Steps2', content: 'Content2'),
                MyStepItem(title: 'Steps3', content: 'Content3'),
                MyStepItem(title: 'Steps4', content: 'Content4'),
              ],
              direction: MyStepsDirection.horizontal,
              activeIndex: 1,
              simple: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHErrorSteps1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: [
                MyStepItem(title: 'Steps1', content: 'Content1'),
                MyStepItem(title: 'Error', content: 'Content2'),
                MyStepItem(title: 'Steps3', content: 'Content3'),
                MyStepItem(title: 'Steps4', content: 'Content4'),
              ],
              direction: MyStepsDirection.horizontal,
              activeIndex: 1,
              status: MyStepState.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHErrorSteps2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: [
                MyStepItem(
                  title: 'Steps1',
                  content: 'Content1',
                  successIcon: LucideIcons.phone,
                ),
                MyStepItem(
                  title: 'Error',
                  content: 'Content2',
                  successIcon: LucideIcons.phone,
                  errorIcon: LucideIcons.circleX,
                ),
                MyStepItem(
                  title: 'Steps3',
                  content: 'Content3',
                  successIcon: LucideIcons.phone,
                ),
                MyStepItem(
                  title: 'Steps4',
                  content: 'Content4',
                  successIcon: LucideIcons.phone,
                ),
              ],
              direction: MyStepsDirection.horizontal,
              activeIndex: 1,
              status: MyStepState.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHErrorSteps3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: [
                MyStepItem(
                  title: 'Steps1',
                  content: 'Content1',
                  successIcon: LucideIcons.phone,
                ),
                MyStepItem(
                  title: 'Error',
                  content: 'Content2',
                  successIcon: LucideIcons.phone,
                  errorIcon: LucideIcons.circleX,
                ),
                MyStepItem(
                  title: 'Steps3',
                  content: 'Content3',
                  successIcon: LucideIcons.phone,
                ),
                MyStepItem(
                  title: 'Steps4',
                  content: 'Content4',
                  successIcon: LucideIcons.phone,
                ),
              ],
              direction: MyStepsDirection.horizontal,
              activeIndex: 1,
              status: MyStepState.error,
              simple: true,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vBasicStepsListData = [
    MyStepItem(title: 'Filish', content: 'Customize content'),
    MyStepItem(title: 'Process', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
  ];

  Widget _buildVBasicSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vBasicStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vIconStepsListData = [
    MyStepItem(
      title: 'Filish',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Process',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
  ];

  Widget _buildVIconSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vIconStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vSimpleStepsListData = [
    MyStepItem(
      title: 'Filish',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Process',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
  ];

  Widget _buildVSimpleSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vSimpleStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
              simple: true,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vErrorBasicStepsListData = [
    MyStepItem(title: 'Filish', content: 'Customize content'),
    MyStepItem(title: 'Process', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
  ];

  Widget _buildVErrorBasicSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vErrorBasicStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
              status: MyStepState.error,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vErrorIconStepsListData = [
    MyStepItem(
      title: 'Filish',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Process',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
      errorIcon: LucideIcons.circleX,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
  ];

  Widget _buildVErrorIconSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vErrorIconStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
              status: MyStepState.error,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vErrorSimpleStepsListData = [
    MyStepItem(
      title: 'Filish',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Process',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
    MyStepItem(
      title: 'Default',
      content: 'Customize content',
      successIcon: LucideIcons.shoppingCart,
    ),
  ];

  Widget _buildVErrorSimpleSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vErrorSimpleStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
              simple: true,
              status: MyStepState.error,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vCustomTitleBasicStepsListData = [
    MyStepItem(title: 'Filish', content: 'Customize content'),
    MyStepItem(
      title: 'Process',
      content: 'Customize content',
      customTitle: Container(
        margin: const EdgeInsets.only(bottom: 16, top: 4),
        child: const Text(
          'This is a very long custom title, which can automatically wrap the title content',
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.visible,
        ),
      ),
    ),
    MyStepItem(title: 'Default', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
  ];

  List<MyStepItem> vCustomContentBasicStepsListData = [
    MyStepItem(title: 'Filish', content: 'Customize content'),
    MyStepItem(
      title:
          'This is a very long, very long text, it is used to show the title of this step',
      content: 'Customize content',
      customContent: Container(
        margin: const EdgeInsets.only(bottom: 16, top: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: const TDImage(
            assetUrl: 'assets/img/image.png',
            type: TDImageType.square,
          ),
        ),
      ),
    ),
    MyStepItem(title: 'Default', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
  ];

  Widget _buildVCustomTitleBaseSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vCustomTitleBasicStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVCustomContentBaseSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vCustomContentBasicStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 1,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> hReadOnlyStepsListData = [
    MyStepItem(title: 'Filish', content: 'content'),
    MyStepItem(title: 'Process', content: 'content'),
    MyStepItem(title: 'Default', content: 'content'),
    MyStepItem(title: 'Default', content: 'content'),
  ];

  Widget _buildHReadOnlySteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(steps: hReadOnlyStepsListData, readOnly: true),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vReadOnlyStepsListData = [
    MyStepItem(title: 'Filish', content: 'Customize content'),
    MyStepItem(title: 'Process', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
    MyStepItem(title: 'Default', content: 'Customize content'),
  ];

  Widget _buildVReadOnlySteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vReadOnlyStepsListData,
              direction: MyStepsDirection.vertical,
              activeIndex: 0,
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  List<MyStepItem> vCustomizeStepsListData = [
    MyStepItem(title: 'Selected', content: ''),
    MyStepItem(title: 'Selected', content: ''),
    MyStepItem(title: 'Selected', content: ''),
    MyStepItem(title: 'Please Selected', content: ''),
  ];

  Widget _buildVCustomizeSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MySteps(
              steps: vCustomizeStepsListData,
              direction: MyStepsDirection.vertical,
              simple: true,
              activeIndex: 3,
              verticalSelect: true,
            ),
          ),
        ],
      ),
    );
  }
}
