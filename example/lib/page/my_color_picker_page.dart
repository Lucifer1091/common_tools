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
  Color _panelColor = _referenceColor.withValues(alpha: 0.82);
  final MyPopoverController _explicitPopoverController = MyPopoverController();
  final Object _explicitPopoverGroupId = Object();

  @override
  void dispose() {
    _explicitPopoverController.dispose();
    super.dispose();
  }

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
                ExampleItem(
                  desc: 'Explicit picker in popover and dialog',
                  builder: _buildExplicitPicker,
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
    return SizedBox(
      width: 220,
      child: MyColorPicker(
        value: _dialogColor,
        presentation: MyColorPickerPresentation.dialog,
        dialogTitle: const Text('Select Color'),
        showLabel: true,
        showAlpha: true,
        onChanged: (value) => setState(() => _dialogColor = value),
      ),
    );
  }

  Widget _buildScreenPicker(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: MyButton(
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
        ),
      ),
    );
  }

  Widget _buildExplicitPicker(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        MyPopover(
          controller: _explicitPopoverController,
          groupId: _explicitPopoverGroupId,
          padding: const EdgeInsets.all(12),
          popover: (context) {
            return SizedBox(
              width: 320,
              child: MyColorPicker(
                value: _panelColor,
                presentation: MyColorPickerPresentation.inline,
                showAlpha: true,
                popoverGroupId: _explicitPopoverGroupId,
                onChanged: (value) => setState(() => _panelColor = value),
              ),
            );
          },
          child: MyButton(
            text: 'Open Color Picker Popover',
            type: MyButtonType.outline,
            onTap: _explicitPopoverController.toggle,
          ),
        ),
        MyButton(
          text: 'Open Color Picker Dialog',
          type: MyButtonType.outline,
          onTap: () {
            final themeData = context.theme;
            MyDialog.show<void>(
              context: context,
              builder: (context) {
                return MyTheme(
                  data: themeData,
                  child: Center(
                    child: Material(
                      color: context.colorScheme.popover,
                      borderRadius: MyBorderRadius.large,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 340,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Select Color',
                                  style: context.titleMedium,
                                ),
                                const Gap(16),
                                MyColorPicker(
                                  value: _panelColor,
                                  presentation:
                                      MyColorPickerPresentation.inline,
                                  showAlpha: true,
                                  onChanged: (value) {
                                    setState(() => _panelColor = value);
                                  },
                                ),
                                const Gap(16),
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: MyButton(
                                    text: 'Close',
                                    onTap: () =>
                                        Navigator.of(context).maybePop(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  String _hexWithoutAlpha(Color color) {
    String channel(double value) =>
        (value * 255).round().toRadixString(16).padLeft(2, '0');
    return '#${channel(color.r)}${channel(color.g)}${channel(color.b)}'
        .toUpperCase();
  }
}
