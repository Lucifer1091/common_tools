import 'package:common_tools/widgets/components/toast/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

class TDToastPage extends StatelessWidget {
  const TDToastPage({super.key});

  static const msg = 'This is a regular notification message';
  static const longMsg =
      'This is a long toast message that wraps across multiple lines and is limited to three lines.';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'Used for lightweight feedback or prompts without interrupting the user.',
      exampleCodeGroup: 'toast',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Plain Text', builder: _textToast),
            ExampleItem(desc: 'Multi-line Text', builder: _multipleToast),
            ExampleItem(
              desc: 'With Horizontal Icon',
              builder: _horizontalIconToast,
            ),
            ExampleItem(
              desc: 'With Vertical Icon',
              builder: _verticalIconToast,
            ),
            ExampleItem(desc: 'Loading State', builder: _loadingToast),
            ExampleItem(
              desc: 'Custom Loading State',
              builder: _loadingCustomToast,
            ),
            ExampleItem(
              desc: 'Loading State (No Text)',
              builder: _loadingWithoutTextToast,
            ),
            ExampleItem(desc: 'Stop Loading', builder: _dismissLoadingToast),
            ExampleItem(desc: 'Custom Plain Text', builder: _textCustomToast),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: 'Default notification', builder: _successToast),
            ExampleItem(
              desc: 'Success notification',
              builder: _successVerticalToast,
            ),
            ExampleItem(desc: 'Warning notification', builder: _warningToast),
            ExampleItem(
              desc: 'Error notification',
              builder: _failVerticalToast,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(desc: 'Success Toast', builder: _successToast),
            ExampleItem(
              desc: 'Success Toast (Vertical)',
              builder: _successVerticalToast,
            ),
            ExampleItem(desc: 'Warning Toast', builder: _warningToast),
            ExampleItem(
              desc: 'Warning Toast (Vertical)',
              builder: _warningVerticalToast,
            ),
            ExampleItem(desc: 'Failure Toast', builder: _failToast),
            ExampleItem(
              desc: 'Failure Toast (Vertical)',
              builder: _failVerticalToast,
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: 'Prevent Scroll + Tap', builder: _preventTapToast),
        ExampleItem(
          desc: 'Custom Width + Line Count',
          builder: _customMultipleToast,
        ),
      ],
    );
  }

  Widget _textToast(BuildContext context) {
    return Wrap(
      children: [
        MyButton(
          onTap: () {
            MyToast.error(
              context: context,
              title: 'Event has been created',
              subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
              action: MyButton(
                text: 'Undo',
                size: MyButtonSize.small,
                type: MyButtonType.destructive,
                onTap: () {},
              ),
            );
          },
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Default',
        ),
      ],
    );
  }

  Widget _textCustomToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showText(
        //   'Custom plain text',
        //   context: context,
        //   customWidget: Container(
        //     width: 50,
        //     height: 20,
        //     color: ThemeColors.blue.shade700,
        //     child: const MyText('Custom plain text'),
        //   ),
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Plain Text',
    );
  }

  Widget _multipleToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showText(
        //   'This is a long toast message that wraps across multiple lines and is limited to three lines.',
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Multi-line Text',
    );
  }

  Widget _horizontalIconToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showIconText(
        //   'With horizontal icon',
        //   icon: Icons.check_circle,
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'With Horizontal Icon',
    );
  }

  Widget _verticalIconToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showIconText(
        //   'With vertical icon',
        //   icon: Icons.check_circle,
        //   direction: IconTextDirection.vertical,
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'With Vertical Icon',
    );
  }

  Widget _loadingToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showLoading(context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Loading State',
    );
  }

  Widget _loadingCustomToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showLoading(
        //   context: context,
        //   customWidget: Container(
        //     width: 50,
        //     height: 20,
        //     color: ThemeColors.blue.shade50,
        //     child: const MyText('Custom loading'),
        //   ),
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Custom Loading State',
    );
  }

  Widget _loadingWithoutTextToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showLoadingWithoutText(context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Loading State (No Text)',
    );
  }

  Widget _dismissLoadingToast(BuildContext context) {
    return const MyButton(
      // onTap: TDToast.dismissLoading,
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Stop Loading',
    );
  }

  Widget _successToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showSuccess('Success message', context: context);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Success Toast',
    );
  }

  Widget _successVerticalToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showSuccess(
        //   'Success message',
        //   direction: IconTextDirection.vertical,
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Success Toast (Vertical)',
    );
  }

  Widget _warningToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showWarning(
        //   'Warning message',
        //   direction: IconTextDirection.horizontal,
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Warning Toast',
    );
  }

  Widget _warningVerticalToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showWarning(
        //   'Warning message',
        //   direction: IconTextDirection.vertical,
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Warning Toast (Vertical)',
    );
  }

  Widget _failToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showFail(
        //   'Failure message',
        //   direction: IconTextDirection.horizontal,
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      isExpanded: true,

      text: 'Failure Toast',
    );
  }

  Widget _failVerticalToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showFail(
        //   'Failure message',
        //   direction: IconTextDirection.vertical,
        //   context: context,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      isExpanded: true,

      text: 'Failure Toast (Vertical)',
    );
  }

  Widget _preventTapToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showText(
        //   'Toast message',
        //   context: context,
        //   preventTap: true,
        //   backgroundColor: Colors.black.withValues(alpha: 0.7),
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      isExpanded: true,

      text: 'Prevent Scroll + Tap',
    );
  }

  Widget _customMultipleToast(BuildContext context) {
    return MyButton(
      onTap: () {
        // TDToast.showText(
        //   'This is a longer toast message used to demonstrate a custom width and line count. '
        //   'This is a longer toast message used to demonstrate a custom width and line count. '
        //   'This is a longer toast message used to demonstrate a custom width and line count. '
        //   'This is a longer toast message used to demonstrate a custom width and line count.',
        //   context: context,
        //   constraints: BoxConstraints(maxWidth: 350),
        //   maxLines: 5,
        // );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,

      isExpanded: true,

      text: 'Multi-line Text',
    );
  }
}
