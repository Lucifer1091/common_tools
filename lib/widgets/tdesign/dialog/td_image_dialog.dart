import 'package:flutter/material.dart';

import '../button/td_button.dart';
import '../divider/td_divider.dart';
import 'td_dialog.dart';
import 'td_dialog_widget.dart';

enum TDDialogImagePosition { top, middle }

class TDImageDialog extends StatelessWidget {
  const TDImageDialog({
    required this.image,
    super.key,
    this.imagePosition = TDDialogImagePosition.top,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
    this.title,
    this.titleColor = const Color(0xE6000000),
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.leftBtn,
    this.rightBtn,
    this.showCloseButton,
    this.padding,
    this.buttonWidget,
  });

  final Color backgroundColor;

  final double radius;

  final String? title;

  final Color titleColor;

  final AlignmentGeometry? titleAlignment;

  final Widget? contentWidget;

  final String? content;

  final Color? contentColor;

  final TDDialogButtonOptions? leftBtn;

  final TDDialogButtonOptions? rightBtn;

  final Image image;

  final TDDialogImagePosition? imagePosition;

  final bool? showCloseButton;

  final EdgeInsets? padding;

  final Widget? buttonWidget;

  Widget _buildImage(BuildContext context) {
    return SizedBox(
      width: 311,
      height: 160,
      child: FittedBox(fit: BoxFit.cover, child: image),
    );
  }

  Widget _buildTopImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
          child: _buildImage(context),
        ),
        TDDialogInfoWidget(
          title: title,
          padding: padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
          titleColor: titleColor,
          titleAlignment: titleAlignment,
          contentWidget: contentWidget,
          content: content,
          contentColor: contentColor,
        ),
        const TDDivider(height: 24, color: Colors.transparent),
        _horizontalButtons(context),
      ],
    );
  }

  Widget _buildMiddleImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TDDialogInfoWidget(
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
        const TDDivider(height: 24, color: Colors.transparent),
        _horizontalButtons(context),
      ],
    );
  }

  Widget _buildOnlyImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
          child: _buildImage(context),
        ),
        const TDDivider(height: 24, color: Colors.transparent),
        _horizontalButtons(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (title == null && content == null) {
      return _buildOnlyImage(context);
    } else if (imagePosition == TDDialogImagePosition.middle) {
      return _buildMiddleImage(context);
    } else {
      return _buildTopImage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TDDialogScaffold(
      showCloseButton: showCloseButton,
      backgroundColor: backgroundColor,
      radius: radius,
      body: _buildBody(context),
    );
  }

  Widget _horizontalButtons(BuildContext context) {
    if (buttonWidget != null) {
      return buttonWidget!;
    }
    final left =
        leftBtn ??
        TDDialogButtonOptions(
          title: 'Cancel',
          type: MyButtonType.outline,
          action: null,
        );
    final right =
        rightBtn ??
        TDDialogButtonOptions(
          title: 'Confirm',
          action: null,
        );
    return HorizontalNormalButtons(leftBtn: left, rightBtn: right);
  }
}
