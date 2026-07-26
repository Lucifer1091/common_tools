import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

class MyToastPage extends StatelessWidget {
  const MyToastPage({super.key});

  static const msg = 'This is a regular notification message';
  static const longMsg =
      'This is a long toast message that wraps across multiple lines and is limited to three lines.';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'A non-modal, unobtrusive window element used to display brief, auto-expiring information to the user.',
      exampleCodeGroup: 'toast',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Default & Simple', builder: _simpleToast),
            ExampleItem(desc: 'Action Toast', builder: _actionToast),
            ExampleItem(desc: 'Different Positions', builder: _positionToast),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              padding: EdgeInsets.only(top: 16),
              builder: _stateToast,
            ),
          ],
        ),
        ExampleModule(
          title: 'Extras',
          children: [
            ExampleItem(
              desc: 'Expand Toast Stack on Hover',
              builder: _expandToastStack,
            ),
            ExampleItem(desc: 'Pause Toast ', builder: _pauseToast),
          ],
        ),
      ],
    );
  }

  Widget _simpleToast(BuildContext context) {
    return MyButton(
      onTap: () {
        MyToast.simple(context: context, title: msg, subtitle: longMsg);
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      text: 'Show Toast',
    );
  }

  Widget _actionToast(BuildContext context) {
    return MyButton(
      onTap: () {
        MyToast.simple(
          context: context,
          title: 'Event has been created',
          subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
          action: MyButton(text: 'Undo', size: MyButtonSize.small),
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      text: 'Show Action Toast',
    );
  }

  Widget _positionToast(BuildContext context) {
    final title = 'Event has been created';
    final subtitle = 'Sunday, July 07, 2024 at 12:00 PM';
    final button = MyButton(
      text: 'Undo',
      size: MyButtonSize.small,
      type: MyButtonType.primary,
      onTap: () {},
    );
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        MyButton(
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Bottom Left',
          onTap: () {
            MyToast.simple(
              context: context,
              title: title,
              subtitle: subtitle,
              action: button,
              toastAlignment: Alignment.bottomLeft,
            );
          },
        ),
        MyButton(
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Bottom Right',
          onTap: () {
            MyToast.simple(
              context: context,
              title: title,
              subtitle: subtitle,
              action: button,
              toastAlignment: Alignment.bottomRight,
            );
          },
        ),
        MyButton(
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Top Left',
          onTap: () {
            MyToast.simple(
              context: context,
              title: title,
              subtitle: subtitle,
              action: button,
              toastAlignment: Alignment.topLeft,
            );
          },
        ),
        MyButton(
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Top Right',
          onTap: () {
            MyToast.simple(
              context: context,
              title: title,
              subtitle: subtitle,
              action: button,
              toastAlignment: Alignment.topRight,
            );
          },
        ),
        MyButton(
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Bottom Center',
          onTap: () {
            MyToast.simple(
              context: context,
              title: title,
              subtitle: subtitle,
              action: button,
              toastAlignment: Alignment.bottomCenter,
            );
          },
        ),
        MyButton(
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Top Center',
          onTap: () {
            MyToast.simple(
              context: context,
              title: title,
              subtitle: subtitle,
              action: button,
              toastAlignment: Alignment.topCenter,
            );
          },
        ),
      ],
    );
  }

  Widget _stateToast(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        MyButton(
          onTap: () {
            MyToast.success(
              context: context,
              title: 'Event has been created',
              subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
            );
          },
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Success Toast',
        ),
        MyButton(
          onTap: () {
            MyToast.warning(
              context: context,
              title: 'Event has been created',
              subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
            );
          },
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Warning Toast',
        ),
        MyButton(
          onTap: () {
            MyToast.info(
              context: context,
              title: 'Event has been created',
              subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
            );
          },
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Info Toast',
        ),
        MyButton(
          onTap: () {
            MyToast.error(
              context: context,
              title: 'Event has been created',
              subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
            );
          },
          size: MyButtonSize.large,
          type: MyButtonType.outline,
          text: 'Error Toast',
        ),
      ],
    );
  }

  Widget _expandToastStack(BuildContext context) {
    return MyButton(
      onTap: () {
        MyToast.init(
          context: context,
          setting: SlidingToastSetting(
            expandOnHover: true,
            toastAlignment: Alignment.topCenter,
            toastStartPosition: ToastPosition.top,
          ),
        );
        MyToast.simple(
          context: context,
          title: 'Event has been created',
          subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      text: 'Show Toast',
    );
  }

  Widget _pauseToast(BuildContext context) {
    return MyButton(
      onTap: () {
        MyToast.init(
          context: context,
          setting: SlidingToastSetting(
            pauseOnHover: true,
            toastAlignment: Alignment.topCenter,
            toastStartPosition: ToastPosition.top,
          ),
        );

        MyToast.success(
          context: context,
          title: 'Event has been created',
          subtitle: 'Sunday, July 07, 2024 at 12:00 PM',
        );
      },
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      text: 'Show Toast',
    );
  }
}
