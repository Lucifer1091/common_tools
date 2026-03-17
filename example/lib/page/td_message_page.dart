import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class TDMessagePage extends StatefulWidget {
  const TDMessagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDMessagePageState();
}

class _TDMessagePageState extends State<TDMessagePage> {
  final _commonContent = 'This is a regular notification message';
  final longContent =
      'This is a regular notification message. This is a regular notification message. This is a regular notification message.';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      backgroundColor: Colors.white,
      desc:
          'Used for lightweight feedback or prompts without interrupting the user.',
      exampleCodeGroup: 'message',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Plain text notification',
              builder: _buildPlainTextMessage,
            ),
            ExampleItem(
              desc: 'Notification with icon',
              builder: _buildIconTextMessage,
            ),
            ExampleItem(
              desc: 'Notification with close button',
              builder: _buildMessageWithCloseButton,
            ),
            ExampleItem(
              desc: 'Scrollable notification',
              builder: _buildRollingMessage,
            ),
            ExampleItem(
              desc: 'Notification with button',
              builder: _buildLinkMessage,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              desc: 'Default notification',
              builder: _buildInfoMessage,
            ),
            ExampleItem(
              desc: 'Success notification',
              builder: _buildSuccessMessage,
            ),
            ExampleItem(
              desc: 'Warning notification',
              builder: _buildWarningMessage,
            ),
            ExampleItem(
              desc: 'Error notification',
              builder: _buildErrorMessage,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlainTextMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,
      text: 'Plain Text Notification',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,
      onTap: () {
        

        // TDMessage.showMessage(
        //   context: context,
        //   content: _commonContent,
        //   visible: true,
        //   icon: false,
        //   theme: MessageTheme.info,
        //   duration: 3000,
        //   onDurationEnd: () {
        //     print('message end');
        //   },
        // );
      },
    );
  }

  Widget _buildIconTextMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,
      text: 'Notification with Icon',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,
      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   content: _commonContent,
        //   visible: true,
        //   icon: true,
        //   theme: MessageTheme.info,
        //   duration: 3000,
        // );
      },
    );
  }

  Widget _buildMessageWithCloseButton(BuildContext context) {
    return MyButton(
      isExpanded: true,

      text: 'Notification with Close Button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,

      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   visible: true,
        //   icon: true,
        //   content: _commonContent,
        //   theme: MessageTheme.info,
        //   duration: 300000,
        //   closeBtn: true,
        //   link: MessageLink(name: 'Button', uri: Uri.parse('www.example.com')),
        //   onCloseBtnClick: () {
        //     print('Close button clicked!');
        //   },
        // );
      },
    );
  }

  Widget _buildRollingMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,

      text: 'Scrollable Notification',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,

      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   visible: true,
        //   icon: false,
        //   marquee: MessageMarquee(speed: 5000, loop: 1, delay: 300),
        //   content: longContent,
        //   theme: MessageTheme.info,
        //   duration: 8000,
        //   onCloseBtnClick: () {
        //     print('Close button clicked!');
        //   },
        // );
      },
    );
  }

  Widget _buildLinkMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,

      text: 'Notification with Button',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,

      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   visible: true,
        //   icon: true,
        //   content: _commonContent,
        //   theme: MessageTheme.info,
        //   duration: 3000,
        //   link: MessageLink(
        //     name: 'Button',
        //     uri: Uri.parse('https://tdesign.tencent.com/'),
        //   ),
        //   // link: 'Button',
        //   onLinkClick: () {
        //     print('link clicked!');
        //   },
        // );
      },
    );
  }

  Widget _buildInfoMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,

      text: 'Default Notification',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,

      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   visible: true,
        //   icon: true,
        //   content: _commonContent,
        //   theme: MessageTheme.info,
        //   duration: 3000,
        // );
      },
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,

      text: 'Success Notification',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,

      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   visible: true,
        //   icon: true,
        //   content: _commonContent,
        //   theme: MessageTheme.success,
        //   duration: 3000,
        // );
      },
    );
  }

  Widget _buildWarningMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,

      text: 'Warning Notification',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,

      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   visible: true,
        //   icon: true,
        //   content: _commonContent,
        //   theme: MessageTheme.warning,
        //   duration: 3000,
        // );
      },
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return MyButton(
      isExpanded: true,

      text: 'Error Notification',
      size: MyButtonSize.large,
      type: MyButtonType.outline,
      width: 450,

      onTap: () {
        // TDMessage.showMessage(
        //   context: context,
        //   visible: true,
        //   icon: true,
        //   content: _commonContent,
        //   theme: MessageTheme.error,
        //   duration: 3000,
        // );
      },
    );
  }
}
