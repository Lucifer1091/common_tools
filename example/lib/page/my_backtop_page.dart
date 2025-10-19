import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class MyBackTopPage extends StatefulWidget {
  const MyBackTopPage({super.key});

  @override
  State<MyBackTopPage> createState() => _MyBackTopPageState();
}

class _MyBackTopPageState extends State<MyBackTopPage> {
  ScrollController controller = ScrollController();
  bool showBackTop = false;
  bool showText = false;
  MyBackTopStyle style = MyBackTopStyle.circle;

  @override
  void initState() {
    super.initState();
    controller.addListener(listenCallback);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(listenCallback);
  }

  void listenCallback() {}

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      scrollController: controller,
      title: myTitle(),
      desc:
          'Used to help users quickly return to the top of the page when the page is too long and slides down.',
      exampleCodeGroup: 'backtop',
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          Visibility(
            visible: showBackTop,
            child: style == MyBackTopStyle.halfCircle
                ? Positioned(
                    right: -16,
                    bottom: 10,
                    child: MyBackTop(
                      controller: controller,
                      showText: showText,
                      style: style,
                    ),
                  )
                : MyBackTop(
                    controller: controller,
                    showText: showText,
                    style: style,
                  ),
          ),
        ],
      ),
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Toggle Button Text',
              builder: (context) {
                return MySwitch(
                  isOn: showText,
                  onChanged: (value) {
                    setState(() {
                      showText = value;
                    });

                    return value;
                  },
                );
              },
            ),
            ExampleItem(
              desc: 'Circle Return to Top',
              builder: _buildCircleBackTop,
            ),
            ExampleItem(
              desc: 'Semi Circle Return to Top',
              builder: _buildHalfCircleBackTop,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleBackTop(BuildContext context) {
    return getCustomButton(context, 'Show Circle Button', () {
      setState(() {
        showBackTop = true;
        if (controller.hasClients) {
          controller.animateTo(
            controller.position.maxScrollExtent,
            duration: kDefaultDuration,
            curve: Curves.easeInOut,
          );
        }
        style = MyBackTopStyle.circle;
      });
    });
  }

  Widget _buildHalfCircleBackTop(BuildContext context) {
    return Column(
      children: [
        getCustomButton(context, 'Show Semi Circle Button', () {
          setState(() {
            showBackTop = true;
            if (controller.hasClients) {
              controller.animateTo(
                controller.position.maxScrollExtent,
                duration: kDefaultDuration,
                curve: Curves.easeInOut,
              );
            }
            style = MyBackTopStyle.halfCircle;
          });
        }),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
              getDemoBox(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget getCustomButton(
    BuildContext context,
    String text,
    void Function() onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MyButton(
        text: text,
        size: MyButtonSize.large,
        type: MyButtonType.outline,
        shape: MyButtonShape.rectangle,
        isExpanded: true,
        onTap: onTap,
      ),
    );
  }

  Widget getDemoBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 163,
          height: 163,
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 163,
          height: 16,
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 16,
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
