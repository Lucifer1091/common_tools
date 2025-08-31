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
  MyStepController controller = MyStepController(total: 4, current: 1);
  MyStepController errorCtrl = MyStepController(
    total: 4,
    current: 1,
    states: {1: MyStepState.error},
  );

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: context.colorScheme.primaryForeground,
      title: tdTitle(),
      exampleCodeGroup: 'steps',
      desc:
          'A stepper is a fundamental part of material design guidelines. Steps convey progress through numbered steps.',
      children: [
        //  ExampleModule(
        //   title: 'Controls',
        //   children: [
        //     ExampleItem(
        //       desc: 'Stepper Controller',
        //       builder: (context) {
        //         return Row(
        //           children: [
        //             Gap(16),
        //             MyButton(
        //               text: 'Previous',
        //               type: MyButtonType.outline,
        //               onTap: controller.previous,
        //             ),
        //             Gap(16),
        //             MyButton(text: 'Next', onTap: controller.next),
        //             Gap(16),
        //           ],
        //         );
        //       },
        //     ),
        //   ],
        // ),
        ExampleModule(
          title: 'Horizontal Bars',
          children: [
            ExampleItem(desc: 'Default Bar', builder: _buildBasicHSteps),
            ExampleItem(desc: 'Icon Bar', builder: _buildHIconSteps),
            ExampleItem(desc: 'Simple Bar', builder: _buildSimpleHSteps),
            ExampleItem(desc: 'Line Bar', builder: _buildLineHSteps),
          ],
        ),
        ExampleModule(
          title: 'Horizontal Error Bars',
          children: [
            ExampleItem(desc: 'Error Bar', builder: _buildHErrorSteps),
            ExampleItem(desc: 'Error Icon Bar', builder: _buildIconHErrorSteps),
            ExampleItem(
              desc: 'Error Simple Bar',
              builder: _buildSimpleHErrorSteps,
            ),
            ExampleItem(desc: 'Error Line Bar', builder: _buildLineHErrorSteps),
          ],
        ),

        ExampleModule(
          title: 'Vertical Bars',
          children: [
            ExampleItem(desc: 'Default Bar', builder: _buildVBasicSteps),
            ExampleItem(desc: 'Icon Bar', builder: _buildVIconSteps),
            ExampleItem(desc: 'Simple Bar', builder: _buildVSimpleSteps),
            ExampleItem(desc: 'Line Bar', builder: _buildVLineSteps),
            ExampleItem(desc: 'Error Bar', builder: _buildVErrorBasicSteps),
            ExampleItem(
              desc: 'Error Icons Bar',
              builder: _buildVErrorIconSteps,
            ),
            ExampleItem(
              desc: 'Error Simple Bar',
              builder: _buildVErrorSimpleSteps,
            ),
            ExampleItem(desc: 'Error Line Bar', builder: _buildLineSimpleSteps),
            ExampleItem(
              desc: 'Custom Title Bar',
              builder: _buildVCustomTitleBaseSteps,
            ),
            ExampleItem(
              desc: 'Custom Content Bar',
              builder: _buildVCustomContentBaseSteps,
            ),
          ],
        ),
        ExampleModule(
          title: 'Read-only Bars',
          children: [
            ExampleItem(
              desc: 'Read-only Steps Bar',
              builder: _buildHReadOnlySteps,
            ),
            ExampleItem(
              desc: 'Read-only Steps Vertical Bar',
              builder: _buildVReadOnlySteps,
            ),
          ],
        ),
        ExampleModule(
          title: 'Fixed Steps',
          children: [
            ExampleItem(
              desc: 'A series of steps for progress.',
              builder: _buildVFixSteps,
            ),
          ],
        ),
        ExampleModule(
          title: 'Timeline',
          children: [
            ExampleItem(
              desc:
                  'A timeline is a way of displaying a list of events in chronological order, sometimes described as a project artifact.',
              builder: _buildVTimelineSteps,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicHSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Steps 1', content: 'Content 1'),
          MyStepItem(title: 'Steps 2', content: 'Content 2'),
          MyStepItem(title: 'Steps 3', content: 'Content 3'),
          MyStepItem(title: 'Steps 4', content: 'Content 4'),
        ],
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildHIconSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        type: MyStepType.icon,
        steps: [
          MyStepItem(
            title: 'Steps 1',
            content: 'Content 1',
            successIcon: LucideIcons.phone,
          ),
          MyStepItem(
            title: 'Steps 2',
            content: 'Content 2',
            successIcon: LucideIcons.phone,
          ),
          MyStepItem(
            title: 'Steps 3',
            content: 'Content 3',
            successIcon: LucideIcons.phone,
          ),
          MyStepItem(
            title: 'Steps 4',
            content: 'Content 4',
            successIcon: LucideIcons.phone,
          ),
        ],
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildSimpleHSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Steps 1', content: 'Content 1'),
          MyStepItem(title: 'Steps 2', content: 'Content 2'),
          MyStepItem(title: 'Steps 3', content: 'Content 3'),
          MyStepItem(title: 'Steps 4', content: 'Content 4'),
        ],
        direction: Axis.horizontal,
        type: MyStepType.simple,
      ),
    );
  }

  Widget _buildLineHSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Steps 1', content: 'Content 1'),
          MyStepItem(title: 'Steps 2', content: 'Content 2'),
          MyStepItem(title: 'Steps 3', content: 'Content 3'),
          MyStepItem(title: 'Steps 4', content: 'Content 4'),
        ],
        direction: Axis.horizontal,
        type: MyStepType.line,
      ),
    );
  }

  Widget _buildHErrorSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        steps: [
          MyStepItem(title: 'Steps 1', content: 'Content 1'),
          MyStepItem(title: 'Error', content: 'Content 2'),
          MyStepItem(title: 'Steps 3', content: 'Content 3'),
          MyStepItem(title: 'Steps 4', content: 'Content 4'),
        ],
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildIconHErrorSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        steps: [
          MyStepItem(
            title: 'Steps 1',
            content: 'Content 1',
            successIcon: LucideIcons.phone,
          ),
          MyStepItem(
            title: 'Error',
            content: 'Content 2',
            successIcon: LucideIcons.phone,
            errorIcon: LucideIcons.circleX,
          ),
          MyStepItem(
            title: 'Steps 3',
            content: 'Content 3',
            successIcon: LucideIcons.phone,
          ),
          MyStepItem(
            title: 'Steps 4',
            content: 'Content 4',
            successIcon: LucideIcons.phone,
          ),
        ],
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _buildSimpleHErrorSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        steps: [
          MyStepItem(
            title: 'Steps 1',
            content: 'Content 1',
            successIcon: LucideIcons.phone,
          ),
          MyStepItem(
            title: 'Error',
            content: 'Content 2',
            successIcon: LucideIcons.phone,
            errorIcon: LucideIcons.circleX,
          ),
          MyStepItem(
            title: 'Steps 3',
            content: 'Content 3',
            successIcon: LucideIcons.phone,
          ),
          MyStepItem(
            title: 'Steps 4',
            content: 'Content 4',
            successIcon: LucideIcons.phone,
          ),
        ],
        direction: Axis.horizontal,
        type: MyStepType.simple,
      ),
    );
  }

  Widget _buildLineHErrorSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        steps: [
          MyStepItem(title: 'Steps 1', content: 'Content 1'),
          MyStepItem(title: 'Error', content: 'Content 2'),
          MyStepItem(title: 'Steps 3', content: 'Content 3'),
          MyStepItem(title: 'Steps 4', content: 'Content 4'),
        ],
        direction: Axis.horizontal,
        type: MyStepType.line,
      ),
    );
  }

  Widget _buildVBasicSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(title: 'Step 2', content: 'Customize content'),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
      ),
    );
  }

  Widget _buildVIconSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        type: MyStepType.icon,
        steps: [
          MyStepItem(
            title: 'Step 1',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
          ),
          MyStepItem(
            title: 'Step 2',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
          ),
          MyStepItem(
            title: 'Step 3',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
          ),
          MyStepItem(
            title: 'Step 4',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
          ),
        ],
        direction: Axis.vertical,
      ),
    );
  }

  Widget _buildVSimpleSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(title: 'Step 2', content: 'Customize content'),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,

        type: MyStepType.simple,
      ),
    );
  }

  Widget _buildVLineSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(title: 'Step 2', content: 'Customize content'),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
        type: MyStepType.line,
      ),
    );
  }

  Widget _buildVErrorBasicSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(title: 'Step 2', content: 'Customize content'),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
      ),
    );
  }

  Widget _buildVErrorIconSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        type: MyStepType.icon,
        steps: [
          MyStepItem(
            title: 'Step 1',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
          ),
          MyStepItem(
            title: 'Step 2',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
            errorIcon: LucideIcons.circleX,
          ),
          MyStepItem(
            title: 'Step 3',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
          ),
          MyStepItem(
            title: 'Step 4',
            content: 'Customize content',
            successIcon: LucideIcons.shoppingCart,
          ),
        ],
        direction: Axis.vertical,
      ),
    );
  }

  Widget _buildVErrorSimpleSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(title: 'Step 2', content: 'Customize content'),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
        type: MyStepType.simple,
      ),
    );
  }

  Widget _buildLineSimpleSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: errorCtrl,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(title: 'Step 2', content: 'Customize content'),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
        type: MyStepType.line,
      ),
    );
  }

  Widget _buildVCustomTitleBaseSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(
            title: 'Step 2',
            content: 'Customize content',
            customTitle: Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: MyText(
                'This is a very long custom title, which can automatically wrap the title content',
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: context.bodyMedium,
              ),
            ),
          ),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
      ),
    );
  }

  Widget _buildVCustomContentBaseSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(
            title:
                'This is a very long, very long text, it is used to show the title of this step',
            content: 'Customize content',
            customContent: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const TDImage(
                  assetUrl: 'assets/img/image.png',
                  type: TDImageType.square,
                ),
              ),
            ),
          ),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
      ),
    );
  }

  Widget _buildHReadOnlySteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        readOnly: true,
        controller: controller,
        steps: [
          MyStepItem(title: 'Step 1', content: 'content'),
          MyStepItem(title: 'Step 2', content: 'content'),
          MyStepItem(title: 'Step 3', content: 'content'),
          MyStepItem(title: 'Step 4', content: 'content'),
        ],
      ),
    );
  }

  Widget _buildVReadOnlySteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        steps: [
          MyStepItem(title: 'Step 1', content: 'Customize content'),
          MyStepItem(title: 'Step 2', content: 'Customize content'),
          MyStepItem(title: 'Step 3', content: 'Customize content'),
          MyStepItem(title: 'Step 4', content: 'Customize content'),
        ],
        direction: Axis.vertical,
        readOnly: true,
      ),
    );
  }

  Widget _buildVFixSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        type: MyStepType.steps,
        size: MyStepSize.medium,
        steps: [
          MyStepItem(
            customTitle: MyText(
              'Create a project',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            customContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText('Create a new project in the project manager.'),
                MyText('Add the required files to the project.'),
              ],
            ),
          ),
          MyStepItem(
            customTitle: MyText(
              'Add dependencies',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            customContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText('Add the required dependencies to the project.'),
              ],
            ),
          ),
          MyStepItem(
            customTitle: MyText(
              'Run the project',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            customContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [MyText('Run the project in the project manager.')],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVTimelineSteps(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: MySteps(
        controller: controller,
        type: MyStepType.timeline,
        steps: [
          MyStepItem(
            time: '2022-01-01',
            title: 'First event',
            content:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Odio euismod lacinia at quis risus sed vulputate odio ut. Quam viverra orci sagittis eu volutpat odio facilisis mauris.',
          ),
          MyStepItem(
            time: '2022-01-02',
            title: 'Second event',
            content:
                'Aut eius excepturi ex recusandae eius est minima molestiae. Nam dolores iusto ad fugit reprehenderit hic dolorem quisquam et quia omnis non suscipit nihil sit libero distinctio. Ad dolorem tempora sit nostrum voluptatem qui tempora unde? Sit rerum magnam nam ipsam nesciunt aut rerum necessitatibus est quia esse non magni quae.',
          ),
          MyStepItem(
            time: '2022-01-03',
            title: 'Third event',
            content:
                'Sit culpa quas ex nulla animi qui deleniti minus rem placeat mollitia. Et enim doloremque et quia sequi ea dolores voluptatem ea rerum vitae. Aut itaque incidunt est aperiam vero sit explicabo fuga id optio quis et molestiae nulla ex quae quam. Ab eius dolores ab tempora dolorum eos beatae soluta At ullam placeat est incidunt cumque.',
          ),
        ],
      ),
    );
  }
}
