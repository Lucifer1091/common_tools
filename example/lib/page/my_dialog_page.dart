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
      'Inform the current status, information, and solution. Keep the description to three lines if possible.';

  final _longContent =
      'Here is the auxiliary content, here is the auxiliary content, here is the auxiliary content, here is the auxiliary content.\n\n' *
      4;

  final _inputHint = 'Please enter text';

  final _demoImage = Image.asset('assets/img/image.png');

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc:
          'Used to display important prompts or request users to perform important operations, a modal view that interrupts the current operation. ',
      exampleCodeGroup: 'dialog',
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              builder: (context) {
                return Column(
                  spacing: 16,
                  children: [
                    MyButton(
                      text: 'ACCEPT',
                      onTap: () {
                        MyDialog.show(
                          context,
                          builder: (BuildContext context) {
                            return MyAlertDialog();
                          },
                        );
                      },
                    ),
                    MyButton(
                      text: 'DELETE',
                      onTap: () {
                        MyDialog.show(
                          context,
                          builder: (BuildContext context) {
                            return MyAlertDialog();
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            ExampleItem(
              desc: 'Feedback Dialog Box',
              builder: _buildFeedbackNormal,
            ),
            ExampleItem(builder: _buildFeedbackNoTitle),
            ExampleItem(builder: _buildFeedbackOnlyTitle),
            ExampleItem(builder: _buildFeedbackLongContent),
            ExampleItem(
              desc: 'Confirm Dialog Box',
              builder: _buildConfirmNormal,
            ),
            ExampleItem(builder: _buildConfirmNoTitle),
            ExampleItem(builder: _buildConfirmOnlyTitle),
            ExampleItem(desc: 'Input Dialog Box', builder: _buildInputNormal),
            ExampleItem(builder: _buildInputNoContent),
            ExampleItem(desc: 'Image Dialog Box', builder: _buildImageTop),
            ExampleItem(builder: _buildImageTopNoTitle),
            ExampleItem(builder: _buildImageTopOnlyTitle),
            ExampleItem(builder: _buildImageMiddle),
            ExampleItem(builder: _buildImageMiddleOnlyTitle),
            ExampleItem(builder: _buildImageMiddleOnlyImage),
          ],
        ),
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Text Button', builder: _buildTextButtonSingle),
            ExampleItem(builder: _buildTextButtonDouble),
            ExampleItem(
              desc: 'Horizontal Basic Button',
              builder: _buildNormalButtonSingle,
            ),
            ExampleItem(builder: _buildNormalButtonDouble),
            ExampleItem(
              desc: 'Vertical Buttons',
              builder: _buildVerticalButtonDouble,
            ),
            ExampleItem(builder: _buildVerticalButtonTriple),
            ExampleItem(
              desc: 'Dialog box with a close button',
              builder: _buildDialogWithCloseButton,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: 'Customize Title alignment and content components',
          builder: _customFeedbackNormal,
        ),
        ExampleItem(builder: _customConfirmNormal),
        ExampleItem(builder: _customConfirmVertical),
        ExampleItem(builder: _customImageTop),
        ExampleItem(
          desc: 'Customize margins and buttons',
          builder: _customContentAndBtn,
        ),
      ],
    );
  }

  // 反馈类

  Widget _buildFeedbackNormal(BuildContext context) {
    return MyButton(
      text: 'Feedback Category-with Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                );
              },
        );
      },
    );
  }

  Widget _buildFeedbackNoTitle(BuildContext context) {
    return MyButton(
      text: 'Feedback-No Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(content: _commonContent);
              },
        );
      },
    );
  }

  Widget _buildFeedbackOnlyTitle(BuildContext context) {
    return MyButton(
      text: 'Feedback-Pure Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(title: _dialogTitle);
              },
        );
      },
    );
  }

  Widget _buildFeedbackLongContent(BuildContext context) {
    return MyButton(
      text: 'Feedback - Content is too long',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(
                  title: _dialogTitle,
                  content: _longContent,
                  contentMaxHeight: 300,
                );
              },
        );
      },
    );
  }

  // 确认类

  Widget _buildConfirmNormal(BuildContext context) {
    return MyButton(
      text: 'Confirmation Class-with Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                );
              },
        );
      },
    );
  }

  Widget _buildConfirmNoTitle(BuildContext context) {
    return MyButton(
      text: 'Confirmation Class-No Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog(content: _commonContent);
              },
        );
      },
    );
  }

  Widget _buildConfirmOnlyTitle(BuildContext context) {
    return MyButton(
      text: 'Confirmation Class - Pure Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog(title: _dialogTitle);
              },
        );
      },
    );
  }

  // 输入类

  Widget _buildInputNormal(BuildContext context) {
    return MyButton(
      text: 'Input class with description',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyInputDialog(
                  textEditingController: TextEditingController(),
                  title: _dialogTitle,
                  content: _commonContent,
                  hintText: _inputHint,
                );
              },
        );
      },
    );
  }

  Widget _buildInputNoContent(BuildContext context) {
    return MyButton(
      text: 'Input Class - No Description',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyInputDialog(
                  textEditingController: TextEditingController(),
                  title: _dialogTitle,
                  hintText: _inputHint,
                );
              },
        );
      },
    );
  }

  // 图片类型

  Widget _buildImageTop(BuildContext context) {
    return MyButton(
      text: 'Picture sticky with title description',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyImageDialog(
                  image: _demoImage,
                  title: _dialogTitle,
                  content: _commonContent,
                );
              },
        );
      },
    );
  }

  Widget _buildImageTopNoTitle(BuildContext context) {
    return MyButton(
      text: 'Picture sticky-no title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyImageDialog(
                  image: _demoImage,
                  content: _commonContent,
                );
              },
        );
      },
    );
  }

  Widget _buildImageTopOnlyTitle(BuildContext context) {
    return MyButton(
      text: 'Picture Pinned - Pure Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyImageDialog(image: _demoImage, title: _dialogTitle);
              },
        );
      },
    );
  }

  Widget _buildImageMiddle(BuildContext context) {
    return MyButton(
      text: 'Picture centered - with Title description',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyImageDialog(
                  image: _demoImage,
                  title: _dialogTitle,
                  content: _commonContent,
                  imagePosition: MyDialogImagePosition.middle,
                );
              },
        );
      },
    );
  }

  Widget _buildImageMiddleOnlyTitle(BuildContext context) {
    return MyButton(
      text: 'Image Centered - Pure Title',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyImageDialog(
                  image: _demoImage,
                  title: _dialogTitle,
                  imagePosition: MyDialogImagePosition.middle,
                );
              },
        );
      },
    );
  }

  Widget _buildImageMiddleOnlyImage(BuildContext context) {
    return MyButton(
      text: 'Image Center - Pure Image',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyImageDialog(
                  image: _demoImage,
                  imagePosition: MyDialogImagePosition.middle,
                );
              },
        );
      },
    );
  }

  // Text Button

  Widget _buildTextButtonSingle(BuildContext context) {
    return MyButton(
      text: 'Single Text Button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttonStyle: MyDialogButtonStyle.text,
                );
              },
        );
      },
    );
  }

  Widget _buildTextButtonDouble(BuildContext context) {
    return MyButton(
      text: 'Left and right Text Button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttonStyle: MyDialogButtonStyle.text,
                );
              },
        );
      },
    );
  }

  // Horizontal Basic Button

  Widget _buildNormalButtonSingle(BuildContext context) {
    return MyButton(
      text: 'Single Horizontal Basic Button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                );
              },
        );
      },
    );
  }

  Widget _buildNormalButtonDouble(BuildContext context) {
    return MyButton(
      text: 'Left and right Horizontal Basic Button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                );
              },
        );
      },
    );
  }

  // Vertical Buttons

  Widget _buildVerticalButtonDouble(BuildContext context) {
    return MyButton(
      text: 'Two Vertical Buttons',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog.vertical(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttons: [
                    MyDialogButtonOptions(
                      title: 'Main Button',
                      action: () {
                        Navigator.pop(context);
                      },
                    ),
                    MyDialogButtonOptions(
                      title: 'Secondary Button',
                      titleColor: ThemeColors.blue.shade600,
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

  Widget _buildVerticalButtonTriple(BuildContext context) {
    return MyButton(
      text: '三个Vertical Buttons',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog.vertical(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttons: [
                    MyDialogButtonOptions(
                      title: 'Main Button',
                      action: () {
                        Navigator.pop(context);
                      },
                    ),
                    MyDialogButtonOptions(
                      title: 'Secondary Button',
                      titleColor: ThemeColors.blue.shade600,
                      action: () {
                        Navigator.pop(context);
                      },
                      type: MyButtonType.outline,
                    ),
                    MyDialogButtonOptions(
                      title: 'Secondary Button',
                      titleColor: ThemeColors.blue.shade600,
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
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  showCloseButton: true,
                );
              },
        );
      },
    );
  }

  // 反馈类

  Widget _customFeedbackNormal(BuildContext context) {
    return MyButton(
      text: 'Feedback Category - Title Left-leaning',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(
                  title: _dialogTitle,
                  titleAlignment: Alignment.centerLeft,
                  contentWidget: MyText.rich(
                    MyTextSpan(
                      children: [
                        MyTextSpan(text: 'Red text', textColor: Colors.red),
                        MyTextSpan(text: 'green text', textColor: Colors.green),
                      ],
                    ),
                  ),
                );
              },
        );
      },
    );
  }

  Widget _customConfirmNormal(BuildContext context) {
    return MyButton(
      text: '确认类-Title偏右',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog(
                  title: _dialogTitle,
                  titleAlignment: Alignment.centerRight,
                  contentWidget: MyText.rich(
                    MyTextSpan(
                      children: [
                        MyTextSpan(text: 'Red text', textColor: Colors.red),
                        MyTextSpan(text: 'green text', textColor: Colors.green),
                      ],
                    ),
                  ),
                );
              },
        );
      },
    );
  }

  Widget _customConfirmVertical(BuildContext context) {
    return MyButton(
      text: 'Vertical button-custom content',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyAlertDialog.vertical(
                  title: _dialogTitle,
                  contentWidget: MyText.rich(
                    MyTextSpan(
                      children: [
                        MyTextSpan(text: 'Red text', textColor: Colors.red),
                        MyTextSpan(text: 'green text', textColor: Colors.green),
                      ],
                    ),
                  ),
                  buttons: [
                    MyDialogButtonOptions(
                      title: 'Main Button',
                      action: () {
                        Navigator.pop(context);
                      },
                    ),
                    MyDialogButtonOptions(
                      title: 'Secondary Button',
                      titleColor: ThemeColors.blue.shade600,
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

  Widget _customImageTop(BuildContext context) {
    return MyButton(
      text: 'Picture top-custom list content',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyImageDialog(
                  image: _demoImage,
                  title: _dialogTitle,
                  contentWidget: ListView(
                    shrinkWrap: true,
                    children: const [
                      MyText('Red text', textColor: Colors.red),
                      MyText('green text', textColor: Colors.green),
                    ],
                  ),
                );
              },
        );
      },
    );
  }

  Widget _customContentAndBtn(BuildContext context) {
    return MyButton(
      text: 'Customize margins and buttons',
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder:
              (
                BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return MyConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  buttonWidget: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: MyButton(
                      text: 'Custom button',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
        );
      },
    );
  }
}
