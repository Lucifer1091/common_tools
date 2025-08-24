/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * td_dialog_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDDialogPage extends StatefulWidget {
  const TDDialogPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDDialogPageState();
}

class _TDDialogPageState extends State<TDDialogPage> {
  final _dialogTitle = '对话框Title';
  final _commonContent = '告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。';
  final _longContent = '这里是辅助内容文案，这里是辅助内容文案，这里是辅助内容文案，这里是辅助内容文案。\n\n' * 4;
  final _inputHint = '请输入文字';

  final _demoImage = Image.asset('assets/img/image.png');

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于显示重要提示或请求用户进行重要操作，一种打断当前操作的模态视图。',
      exampleCodeGroup: 'dialog',
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: '反馈类对话框', builder: _buildFeedbackNormal),
            ExampleItem(builder: _buildFeedbackNoTitle),
            ExampleItem(builder: _buildFeedbackOnlyTitle),
            ExampleItem(builder: _buildFeedbackLongContent),
            ExampleItem(desc: '确认类对话框', builder: _buildConfirmNormal),
            ExampleItem(builder: _buildConfirmNoTitle),
            ExampleItem(builder: _buildConfirmOnlyTitle),
            ExampleItem(desc: '输入类对话框', builder: _buildInputNormal),
            ExampleItem(builder: _buildInputNoContent),
            ExampleItem(desc: '带图片的对话框', builder: _buildImageTop),
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
            ExampleItem(desc: '文字按钮', builder: _buildTextButtonSingle),
            ExampleItem(builder: _buildTextButtonDouble),
            ExampleItem(desc: '横向基础按钮', builder: _buildNormalButtonSingle),
            ExampleItem(builder: _buildNormalButtonDouble),
            ExampleItem(desc: '纵向基础按钮', builder: _buildVerticalButtonDouble),
            ExampleItem(builder: _buildVerticalButtonTriple),
            ExampleItem(
              desc: '带关闭按钮的对话框',
              builder: _buildDialogWithCloseButton,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: '自定义Title对齐和内容组件', builder: _customFeedbackNormal),
        ExampleItem(builder: _customConfirmNormal),
        ExampleItem(builder: _customConfirmVertical),
        ExampleItem(builder: _customImageTop),
        ExampleItem(desc: '自定义边距和按钮', builder: _customContentAndBtn),
      ],
    );
  }

  // 反馈类

  Widget _buildFeedbackNormal(BuildContext context) {
    return MyButton(
      text: '反馈类-带Title',
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
                return TDConfirmDialog(
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
      text: '反馈类-无Title',
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
                return TDConfirmDialog(content: _commonContent);
              },
        );
      },
    );
  }

  Widget _buildFeedbackOnlyTitle(BuildContext context) {
    return MyButton(
      text: '反馈类-纯Title',
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
                return TDConfirmDialog(title: _dialogTitle);
              },
        );
      },
    );
  }

  Widget _buildFeedbackLongContent(BuildContext context) {
    return MyButton(
      text: '反馈类-内容超长',
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
                return TDConfirmDialog(
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
      text: '确认类-带Title',
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
                return TDAlertDialog(
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
      text: '确认类-无Title',
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
                return TDAlertDialog(content: _commonContent);
              },
        );
      },
    );
  }

  Widget _buildConfirmOnlyTitle(BuildContext context) {
    return MyButton(
      text: '确认类-纯Title',
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
                return TDAlertDialog(title: _dialogTitle);
              },
        );
      },
    );
  }

  // 输入类

  Widget _buildInputNormal(BuildContext context) {
    return MyButton(
      text: '输入类-带描述',
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
                return TDInputDialog(
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
      text: '输入类-无描述',
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
                return TDInputDialog(
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
      text: '图片置顶-带Title描述',
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
                return TDImageDialog(
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
      text: '图片置顶-无Title',
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
                return TDImageDialog(
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
      text: '图片置顶-纯Title',
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
                return TDImageDialog(image: _demoImage, title: _dialogTitle);
              },
        );
      },
    );
  }

  Widget _buildImageMiddle(BuildContext context) {
    return MyButton(
      text: '图片居中-带Title描述',
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
                return TDImageDialog(
                  image: _demoImage,
                  title: _dialogTitle,
                  content: _commonContent,
                  imagePosition: TDDialogImagePosition.middle,
                );
              },
        );
      },
    );
  }

  Widget _buildImageMiddleOnlyTitle(BuildContext context) {
    return MyButton(
      text: '图片居中-纯Title',
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
                return TDImageDialog(
                  image: _demoImage,
                  title: _dialogTitle,
                  imagePosition: TDDialogImagePosition.middle,
                );
              },
        );
      },
    );
  }

  Widget _buildImageMiddleOnlyImage(BuildContext context) {
    return MyButton(
      text: '图片居中-纯图片',
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
                return TDImageDialog(
                  image: _demoImage,
                  imagePosition: TDDialogImagePosition.middle,
                );
              },
        );
      },
    );
  }

  // 文字按钮

  Widget _buildTextButtonSingle(BuildContext context) {
    return MyButton(
      text: '单个文字按钮',
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
                return TDConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttonStyle: TDDialogButtonStyle.text,
                );
              },
        );
      },
    );
  }

  Widget _buildTextButtonDouble(BuildContext context) {
    return MyButton(
      text: '左右文字按钮',
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
                return TDAlertDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttonStyle: TDDialogButtonStyle.text,
                );
              },
        );
      },
    );
  }

  // 横向基础按钮

  Widget _buildNormalButtonSingle(BuildContext context) {
    return MyButton(
      text: '单个横向基础按钮',
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
                return TDConfirmDialog(
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
      text: '左右横向基础按钮',
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
                return TDAlertDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                );
              },
        );
      },
    );
  }

  // 纵向基础按钮

  Widget _buildVerticalButtonDouble(BuildContext context) {
    return MyButton(
      text: '两个纵向基础按钮',
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
                return TDAlertDialog.vertical(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttons: [
                    TDDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                    ),
                    TDDialogButtonOptions(
                      title: '次要按钮',
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
      text: '三个纵向基础按钮',
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
                return TDAlertDialog.vertical(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttons: [
                    TDDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                    ),
                    TDDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: ThemeColors.blue.shade600,
                      action: () {
                        Navigator.pop(context);
                      },
                      type: MyButtonType.outline,
                    ),
                    TDDialogButtonOptions(
                      title: '次要按钮',
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
      text: '带关闭按钮的对话框',
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
                return TDConfirmDialog(
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
      text: '反馈类-Title偏左',
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
                return TDConfirmDialog(
                  title: _dialogTitle,
                  titleAlignment: Alignment.centerLeft,
                  contentWidget: MyText.rich(
                    MyTextSpan(
                      children: [
                        MyTextSpan(text: '红色文字', textColor: Colors.red),
                        MyTextSpan(text: '绿色文字', textColor: Colors.green),
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
                return TDAlertDialog(
                  title: _dialogTitle,
                  titleAlignment: Alignment.centerRight,
                  contentWidget: MyText.rich(
                    MyTextSpan(
                      children: [
                        MyTextSpan(text: '红色文字', textColor: Colors.red),
                        MyTextSpan(text: '绿色文字', textColor: Colors.green),
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
      text: '纵向按钮-自定义内容',
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
                return TDAlertDialog.vertical(
                  title: _dialogTitle,
                  contentWidget: MyText.rich(
                    MyTextSpan(
                      children: [
                        MyTextSpan(text: '红色文字', textColor: Colors.red),
                        MyTextSpan(text: '绿色文字', textColor: Colors.green),
                      ],
                    ),
                  ),
                  buttons: [
                    TDDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                    ),
                    TDDialogButtonOptions(
                      title: '次要按钮',
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
      text: '图片置顶-自定义列表内容',
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
                return TDImageDialog(
                  image: _demoImage,
                  title: _dialogTitle,
                  contentWidget: ListView(
                    shrinkWrap: true,
                    children: const [
                      MyText('红色文字', textColor: Colors.red),
                      MyText('绿色文字', textColor: Colors.green),
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
      text: '自定义边距和按钮',
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
                return TDConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  buttonWidget: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: MyButton(
                      text: '自定义按钮',

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
