import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class MyDialogPage extends StatefulWidget {
  const MyDialogPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyDialogPageState();
}

class _MyDialogPageState extends State<MyDialogPage> {
  final _dialogTitle = 'Dialog Title';

  final _commonContent =
      'Inform the current status, information, and solution. Keep the description '
      'to three lines if possible.';

  final _longContent =
      'Here is the auxiliary content, here is the auxiliary content, here is the '
          'auxiliary content, here is the auxiliary content.\n\n' *
      4;

  final _inputHint = 'Please enter text';

  final _demoImage = Image.asset('assets/img/image.png');

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc:
          'Used to display important prompts or request users to perform important'
          'operations, a modal view that interrupts the current operation. ',
      exampleCodeGroup: 'dialog',
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              padding: EdgeInsets.only(top: 16),
              builder: _buildInfoNormal,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Horizontal Buttons',
              builder: _buildNormalButtonSingle,
            ),
            ExampleItem(builder: _buildNormalButtonDouble),
            ExampleItem(
              desc: 'Vertical Buttons',
              builder: _buildVerticalButtonDouble,
            ),
            ExampleItem(
              desc: 'Dialog with a Close Button',
              builder: _buildDialogWithCloseButton,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoNormal(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          MyButton(
            text: 'Info Dialog - short',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                builder: (context) {
                  return MyInfoDialog(
                    title: _dialogTitle,
                    content: _commonContent,
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Info Dialog - long',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                builder: (context) {
                  return MyInfoDialog(
                    title: _dialogTitle,
                    content: _longContent,
                    contentMaxHeight: 300,
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Info Dialog - Web',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                builder: (context) {
                  return MyInfoDialog(
                    width: 500,
                    title: 'You have been kicked out of session.',
                    titleAlignment: Alignment.centerLeft,
                    contentAlignment: Alignment.centerLeft,
                    content: Faker.generateLoremIpsumWords(15),
                    buttonWidget: MyDialogShrinkButtons(
                      rightBtn: MyDialogButtonOptions(
                        title: 'OK',
                        titleColor: context.colorScheme.primaryForeground,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Alert Dialog',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                builder: (context) {
                  return MyAlertDialog(
                    title: _dialogTitle,
                    content: _commonContent,
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Alert Dialog - Web',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                builder: (context) {
                  return MyAlertDialog(
                    width: 500,
                    title: 'Are you absolutely sure ?',
                    titleAlignment: Alignment.centerLeft,
                    contentAlignment: Alignment.centerLeft,
                    content: Faker.generateLoremIpsumWords(15),
                    buttonWidget: MyDialogShrinkButtons(
                      leftBtn: MyDialogButtonOptions(
                        title: 'Cancel',
                        type: MyButtonType.outline,
                      ),
                      rightBtn: MyDialogButtonOptions(
                        title: 'Confirm',
                        titleColor: context.colorScheme.primaryForeground,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Input Dialog',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                builder: (context) {
                  return MyInputDialog(
                    textEditingController: TextEditingController(),
                    title: _dialogTitle,
                    content: _commonContent,
                    hintText: _inputHint,
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Image Dialog',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                builder: (context) {
                  return MyImageDialog(
                    image: _demoImage,
                    title: _dialogTitle,
                    content: _commonContent,
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Draggable Dialog',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                draggable: true,
                builder: (context) {
                  return MyInputDialog(
                    textEditingController: TextEditingController(),
                    title: _dialogTitle,
                    content: _commonContent,
                    hintText: _inputHint,
                  );
                },
              );
            },
          ),
          MyButton(
            text: 'Fullscreen Dialog',
            size: MyButtonSize.large,
            type: MyButtonType.outline,
            onTap: () {
              MyDialog.show(
                context,
                fullscreen: true,
                builder: (context) {
                  return FancyDateRangePickerDialog(
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNormalButtonSingle(BuildContext context) {
    return MyButton(
      text: 'Single Horizontal Button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      onTap: () {
        MyDialog.show(
          context,
          builder: (context) {
            return MyInfoDialog(title: _dialogTitle, content: _commonContent);
          },
        );
      },
    );
  }

  Widget _buildNormalButtonDouble(BuildContext context) {
    return MyButton(
      text: 'Left and Right Horizontal Buttons',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      onTap: () {
        MyDialog.show(
          context,
          builder: (context) {
            return MyAlertDialog(title: _dialogTitle, content: _commonContent);
          },
        );
      },
    );
  }

  Widget _buildVerticalButtonDouble(BuildContext context) {
    return MyButton(
      text: 'Two Vertical Buttons',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      onTap: () {
        MyDialog.show(
          context,
          builder: (context) {
            return MyAlertDialog.vertical(
              title: _dialogTitle,
              content: _commonContent,
              buttons: [
                MyDialogButtonOptions(
                  title: 'Primary Button',
                  titleColor: context.colorScheme.primaryForeground,
                  action: () {
                    Navigator.pop(context);
                  },
                ),
                MyDialogButtonOptions(
                  title: 'Secondary Button',
                  action: () {
                    Navigator.pop(context);
                  },
                  type: MyButtonType.outline,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogWithCloseButton(BuildContext context) {
    return MyButton(
      text: 'Dialog box with a close button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      onTap: () {
        MyDialog.show(
          context,
          builder: (context) {
            return MyInfoDialog(
              title: _dialogTitle,
              content: _commonContent,
              showCloseButton: true,
            );
          },
        );
      },
    );
  }
}
