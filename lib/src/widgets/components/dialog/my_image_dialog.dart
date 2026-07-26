import 'package:flutter/material.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../packages/gap/src/widgets/gap.dart';
import '../button/my_button.dart';
import './my_dialog_config.dart';
import './my_dialog_widget.dart';

enum MyDialogImagePosition { top, middle }

class MyImageDialog extends StatelessWidget {
  const MyImageDialog({
    required this.image,
    super.key,
    this.height,
    this.width,
    this.imagePosition = MyDialogImagePosition.top,
    this.backgroundColor,
    this.radius,
    this.title,
    this.titleColor,
    this.titleAlignment,
    this.contentAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
    this.leftBtnAction,
    this.rightBtnAction,
    this.showCloseButton,
    this.padding,
    this.margin,
    this.buttonWidget,
  });

  final double? height, width;
  final Color? backgroundColor;
  final BorderRadius? radius;
  final String? title;
  final Color? titleColor;
  final AlignmentGeometry? titleAlignment, contentAlignment;
  final Widget? contentWidget;
  final String? content;
  final Color? contentColor;
  final MyDialogButtonOptions? leftBtn;
  final MyDialogButtonOptions? rightBtn;
  final Image image;
  final MyDialogImagePosition? imagePosition;
  final bool? showCloseButton;
  final EdgeInsets? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? buttonWidget;
  final VoidCallback? leftBtnAction;
  final VoidCallback? rightBtnAction;

  Widget _buildImage(BuildContext context) {
    return SizedBox(
      width: width ?? 320,
      height: 160,
      child: FittedBox(fit: BoxFit.cover, child: image),
    );
  }

  Widget _buildTopImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius:
              radius ??
              BorderRadius.only(
                topLeft: Radius.circular(MyRadius.large),
                topRight: Radius.circular(MyRadius.large),
              ),
          child: _buildImage(context),
        ),
        MyDialogInfoWidget(
          title: title,
          padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
          titleColor: titleColor,
          titleAlignment: titleAlignment,
          contentAlignment: contentAlignment,
          contentWidget: contentWidget,
          content: content,
          contentColor: contentColor,
        ),
        const Gap(24),
        _horizontalButtons(context),
      ],
    );
  }

  Widget _buildMiddleImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyDialogInfoWidget(
          padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
          title: title,
          titleColor: titleColor,
          titleAlignment: titleAlignment,
          contentWidget: contentWidget,
          content: content,
          contentColor: contentColor,
        ),
        Container(
          padding: const EdgeInsets.only(top: 24),
          child: ClipRRect(child: _buildImage(context)),
        ),
        const Gap(24),
        _horizontalButtons(context),
      ],
    );
  }

  Widget _buildOnlyImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius:
              radius ??
              BorderRadius.only(
                topLeft: Radius.circular(MyRadius.large),
                topRight: Radius.circular(MyRadius.large),
              ),
          child: _buildImage(context),
        ),
        const Gap(24),
        _horizontalButtons(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (title == null && content == null) {
      return _buildOnlyImage(context);
    } else if (imagePosition == MyDialogImagePosition.middle) {
      return _buildMiddleImage(context);
    } else {
      return _buildTopImage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDialogScaffold(
      height: height,
      width: width,
      margin: margin,
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      radius: radius,
      body: _buildBody(context),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    if (buttonWidget != null) return buttonWidget!;

    final left =
        leftBtn ??
        MyDialogButtonOptions(
          title: 'Cancel',
          type: MyButtonType.outline,
          action: leftBtnAction,
        );

    final right =
        rightBtn ??
        MyDialogButtonOptions(
          title: 'Confirm',
          titleColor: context.colorScheme.primaryForeground,
          action: rightBtnAction,
        );

    return MyDialogExpandedButtons(leftBtn: left, rightBtn: right);
  }
}
