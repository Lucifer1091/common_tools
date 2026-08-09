import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyColorPickerPage extends StatefulWidget {
  const MyColorPickerPage({super.key});

  @override
  State<MyColorPickerPage> createState() => _MyColorPickerPageState();
}

class _MyColorPickerPageState extends State<MyColorPickerPage> {
  static const _referenceColor = Color(0xFFE41E78);

  Color _compactColor = _referenceColor;
  Color _dialogColor = _referenceColor;

  @override
  Widget build(BuildContext context) {
    return MyRecentColorsScope(
      initialColors: const [
        _referenceColor,
        Color(0xFFDDB0C6),
        Color(0xFF3B82F6),
      ],
      child: MyEyeDropperLayer(
        child: ExamplePage(
          title: myTitle(),
          desc: 'Pick a color from inputs, popovers, dialogs, or the screen.',
          exampleCodeGroup: 'color_picker',
          children: [
            ExampleModule(
              title: 'Component Types',
              children: [
                ExampleItem(
                  desc: 'Compact popover input',
                  builder: _buildCompactPopover,
                ),
                ExampleItem(
                  desc: 'Dialog input with label',
                  builder: _buildDialogInput,
                ),
              ],
            ),
            ExampleModule(
              title: 'Picker Tools',
              children: [
                ExampleItem(
                  desc: 'Screen color picker',
                  builder: _buildScreenPicker,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactPopover(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: MyColorPicker(
        value: _compactColor,
        presentation: MyColorPickerPresentation.popover,
        showAlpha: true,
        onChanged: (value) => setState(() => _compactColor = value),
      ),
    );
  }

  Widget _buildDialogInput(BuildContext context) {
    return MyColorPicker(
      value: _dialogColor,
      presentation: MyColorPickerPresentation.dialog,
      dialogTitle: const Text('Select Color'),
      showLabel: true,
      showAlpha: true,
      onChanged: (value) => setState(() => _dialogColor = value),
    );
  }

  Widget _buildScreenPicker(BuildContext context) {
    return MyButton(
      text: 'Pick Color',
      onTap: () async {
        final result = await MyColorPicker.pickColorFromScreen(context);
        if (result == null || !context.mounted) return;
        MyToast.show(
          context: context,
          title: Text('Color: ${_hexWithoutAlpha(result)}'),
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: result,
              borderRadius: MyBorderRadius.small,
              border: Border.all(color: context.colorScheme.border),
            ),
          ),
        );
      },
    );
  }

  String _hexWithoutAlpha(Color color) {
    String channel(double value) =>
        (value * 255).round().toRadixString(16).padLeft(2, '0');
    return '#${channel(color.r)}${channel(color.g)}${channel(color.b)}'
        .toUpperCase();
  }
}
