import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyTextPage extends StatefulWidget {
  const MyTextPage({super.key});

  @override
  State<MyTextPage> createState() => _MyTextPageState();
}

class _MyTextPageState extends State<MyTextPage> {
  final exampleTxt = 'Example Text';

  int _number = 0;
  final NumEditController _controller = NumEditController();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'text',
      desc: 'Use to display text with various styles using exposed properties.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'System Text', builder: _buildSystemText),
            ExampleItem(desc: 'Normal MyText', builder: _buildNormalMyText),
            ExampleItem(desc: 'General Properties', builder: _buildGeneralProp),
            ExampleItem(desc: 'MyText.rich', builder: _buildRichText),
            ExampleItem(desc: 'Number Ticker', builder: _buildNumberTicker),
            ExampleItem(desc: 'Circular Text', builder: _buildCircularText),
            ExampleItem(desc: 'Drop Cap Text', builder: _buildDropCapText),
          ],
        ),
      ],
    );
  }

  Widget _buildNormalMyText(BuildContext context) {
    return MyText(exampleTxt);
  }

  Widget _buildSystemText(BuildContext context) {
    return Text(
      exampleTxt,
      style: TextStyle(color: context.colorScheme.foreground),
    );
  }

  Widget _buildGeneralProp(BuildContext context) {
    return MyText(
      exampleTxt,
      fontSize: context.headlineLarge.fontSize,
      textColor: context.colorScheme.primary,
      backgroundColor: context.colorScheme.secondary,
    );
  }

  Widget _buildRichText(BuildContext context) {
    return MyText.rich(
      MyTextSpan(
        children: [
          MyTextSpan(
            text: 'MyTextSpan1',
            textColor: MyColors.warning,
            isTextThrough: true,
            fontSize: 20,
            lineThroughColor: context.colorScheme.primary,
            style: TextStyle(color: context.colorScheme.destructive),
          ),
          TextSpan(
            text: 'TextSpan2',
            style: TextStyle(fontSize: 14, color: context.colorScheme.primary),
          ),
          const WidgetSpan(child: Icon(LucideIcons.settings, size: 24)),
        ],
      ),
      fontSize: context.bodyLarge.fontSize,
      textColor: context.colorScheme.primary,
      style: TextStyle(color: context.colorScheme.destructive, fontSize: 32),
    );
  }

  Widget _buildNumberTicker(BuildContext context) {
    return Column(
      children: [
        MyNumberTicker(
          // Starting point for the first animation frame.
          initialNumber: 0,
          // The live value to animate toward. When this changes, the ticker
          // interpolates between the previous and the new value.
          number: _number,
          style: const TextStyle(fontSize: 32),
          formatter: (number) {
            // Optional display formatter: 1200 -> 1.2K, etc.
            return number.compact;
          },
        ),
        const Gap(24),
        MyInput(
          controller: _controller,
          placeholder: 'Enter a number here',
          onEditingComplete: () {
            // Commit input on edit complete and update the ticker target.
            int? number = int.tryParse(_controller.text);
            if (number != null) {
              setState(() {
                _number = number;
              });
            }
          },
        ).padding(horizontal: 16),
      ],
    );
  }

  Widget _buildCircularText(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colorScheme.secondary,
      ),
      child: MyCircularText(
        children: [
          MyCircularTextItem(
            text: MyText(
              "Chuck Norris".toUpperCase(),
              style: TextStyle(
                fontSize: 28,
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            space: 12,
            startAngle: -90,
            startAngleAlignment: MyStartAngleAlignment.center,
            direction: MyCircularTextDirection.clockwise,
          ),
          MyCircularTextItem(
            text: MyText(
              "top 100 Facts".toUpperCase(),
              style: TextStyle(
                color: context.colorScheme.secondaryForeground,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            space: 10,
            startAngle: 90,
            startAngleAlignment: MyStartAngleAlignment.center,
            direction: MyCircularTextDirection.anticlockwise,
          ),
          MyCircularTextItem(
            text: MyText(
              "༒",
              style: TextStyle(
                color: context.colorScheme.secondaryForeground,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            space: 10,
            startAngle: 180,
            startAngleAlignment: MyStartAngleAlignment.center,
            direction: MyCircularTextDirection.clockwise,
          ),
          MyCircularTextItem(
            text: MyText(
              "༒",
              style: TextStyle(
                color: context.colorScheme.secondaryForeground,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            space: 10,
            startAngle: 0,
            startAngleAlignment: MyStartAngleAlignment.center,
            direction: MyCircularTextDirection.clockwise,
          ),
        ],
        radius: 135,
        position: MyCircularTextPosition.inside,
      ),
    );
  }

  Widget _buildDropCapText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MyDropCapText(
        MyFaker.generateLoremIpsumWords(200),
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}
