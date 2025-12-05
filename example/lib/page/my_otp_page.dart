import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyOtpPage extends StatefulWidget {
  const MyOtpPage({super.key});

  @override
  State<MyOtpPage> createState() => _MyOtpPageState();
}

class _MyOtpPageState extends State<MyOtpPage> {
  var controller = <TextEditingController>[];
  late final GlobalKey<MyFormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<MyFormState>();
    for (var i = 0; i < 2; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var element in controller) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          'Accessible one-time password component with copy paste functionality.',
      exampleCodeGroup: 'otp',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'OTP Field Basic', builder: _buildOtpFieldBasic),
            ExampleItem(
              desc: 'OTP Field Grouped',
              builder: _buildOtpFieldGroup,
            ),
            ExampleItem(desc: 'OTP Form Field', builder: _buildOtpFormField),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpFieldBasic(BuildContext context) {
    return MyOtp(
      maxLength: 4,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      children: const [
        MyOtpGroup(
          children: [MyOtpSlot(), MyOtpSlot(), MyOtpSlot(), MyOtpSlot()],
        ),
      ],
    );
  }

  Widget _buildOtpFieldGroup(BuildContext context) {
    return MyOtp(
      maxLength: 6,
      children: const [
        MyOtpGroup(children: [MyOtpSlot(), MyOtpSlot(), MyOtpSlot()]),
        Icon(size: 24, LucideIcons.dot),
        MyOtpGroup(children: [MyOtpSlot(), MyOtpSlot(), MyOtpSlot()]),
      ],
    );
  }

  Widget _buildOtpFormField(BuildContext context) {
    return MyForm(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          MyOtpFormField(
            maxLength: 6,
            label: const Text('OTP'),
            description: const Text('Enter your OTP.'),
            validator: (v) {
              if (v.contains(' ')) {
                return 'Fill the whole OTP code';
              }
              return null;
            },
            children: const [
              MyOtpGroup(children: [MyOtpSlot(), MyOtpSlot(), MyOtpSlot()]),
              Icon(size: 24, LucideIcons.dot),
              MyOtpGroup(children: [MyOtpSlot(), MyOtpSlot(), MyOtpSlot()]),
            ],
          ),
          MyButton(
            text: 'Submit',
            onTap: () {
              _formKey.currentState?.validate();
            },
          ),
        ],
      ).padding(horizontal: 16),
    );
  }
}
