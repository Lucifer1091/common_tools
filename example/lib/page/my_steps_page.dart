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
  MyStepController controller = MyStepController(current: 1);
  MyStepController errorCtrl = MyStepController(
    current: 1,
    states: {1: MyStepState.error},
  );

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.primaryForeground,
      title: tdTitle(),
      exampleCodeGroup: 'steps',
      desc: 'Steps Bar',
      children: [
        ExampleModule(
          title: 'Controls',
          children: [
            ExampleItem(
              desc: 'Stepper Controller',
              builder: (context) {
                return Row(
                  children: [
                    Gap(16),
                    MyButton(
                      text: 'Previous',
                      type: MyButtonType.outline,
                      onTap: controller.previous,
                    ),
                    Gap(16),
                    MyButton(text: 'Next', onTap: controller.next),
                    Gap(16),
                  ],
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Horizontal Bars',
          children: [
            ExampleItem(desc: 'Default Bar', builder: _buildBasicHSteps3),
            ExampleItem(desc: 'Icon Bar', builder: _buildHIconSteps3),
            ExampleItem(desc: 'Simple Bar', builder: _buildSimpleHSteps3),
            ExampleItem(desc: 'Line Bar', builder: _buildSimpleHSteps3),
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
              controller: controller,
              steps: [
                MyStepItem(title: 'Steps1', content: 'Content1'),
                MyStepItem(title: 'Steps2', content: 'Content2'),
                MyStepItem(title: 'Steps3', content: 'Content3'),
                MyStepItem(title: 'Steps4', content: 'Content4'),
              ],
              direction: MyStepsDirection.horizontal,
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
              controller: controller,
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
              controller: controller,
              steps: [
                MyStepItem(title: 'Steps1', content: 'Content1'),
                MyStepItem(title: 'Steps2', content: 'Content2'),
                MyStepItem(title: 'Steps3', content: 'Content3'),
                MyStepItem(title: 'Steps4', content: 'Content4'),
              ],
              direction: MyStepsDirection.horizontal,

              type: MyStepType.simple,
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
              controller: errorCtrl,
              steps: [
                MyStepItem(title: 'Steps1', content: 'Content1'),
                MyStepItem(title: 'Error', content: 'Content2'),
                MyStepItem(title: 'Steps3', content: 'Content3'),
                MyStepItem(title: 'Steps4', content: 'Content4'),
              ],
              direction: MyStepsDirection.horizontal,
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
              controller: errorCtrl,
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
              controller: errorCtrl,
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
              type: MyStepType.simple,
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
              controller: controller,
              steps: vBasicStepsListData,
              direction: MyStepsDirection.vertical,
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
              controller: controller,
              steps: vIconStepsListData,
              direction: MyStepsDirection.vertical,
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
              controller: controller,
              steps: vSimpleStepsListData,
              direction: MyStepsDirection.vertical,

              type: MyStepType.simple,
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
              controller: controller,
              steps: vErrorBasicStepsListData,
              direction: MyStepsDirection.vertical,
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
              controller: controller,
              steps: vErrorIconStepsListData,
              direction: MyStepsDirection.vertical,
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
              controller: controller,
              steps: vErrorSimpleStepsListData,
              direction: MyStepsDirection.vertical,
              type: MyStepType.simple,
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
              controller: controller,
              steps: vCustomTitleBasicStepsListData,
              direction: MyStepsDirection.vertical,
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
              controller: controller,
              steps: vCustomContentBasicStepsListData,
              direction: MyStepsDirection.vertical,
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
            child: MySteps(
              controller: controller,
              steps: hReadOnlyStepsListData,
              readOnly: true,
            ),
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
              controller: controller,
              steps: vReadOnlyStepsListData,
              direction: MyStepsDirection.vertical,
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
              controller: controller,
              steps: vCustomizeStepsListData,
              direction: MyStepsDirection.vertical,
              type: MyStepType.simple,
              verticalSelect: true,
            ),
          ),
        ],
      ),
    );
  }
}
