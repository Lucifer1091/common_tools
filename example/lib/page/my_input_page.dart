import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyInputViewPage extends StatefulWidget {
  const MyInputViewPage({super.key});

  @override
  State<MyInputViewPage> createState() => _MyInputViewPageState();
}

class _MyInputViewPageState extends State<MyInputViewPage> {
  var controller = <TextEditingController>[];
  late final GlobalKey<MyFormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<MyFormState>();

    for (var i = 0; i < 28; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var e in controller) {
      e.dispose();
    }
    super.dispose();
  }

  bool enabled = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          'Displays a form input field or a component that looks like an input field.',
      exampleCodeGroup: 'input',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Text Field',
              builder: (context) {
                return MyInputFormField(
                  label: Text('Email'),
                  placeholder: 'abs@gmail.com',
                  controller: TextEditController(),
                ).padding(horizontal: 16);
              },
            ),
            ExampleItem(
              desc: 'With leading and trailing',
              builder: (context) {
                return Column(
                  spacing: 16,
                  children: [
                    Row(
                      children: [
                        MyCell(
                          title: 'Enabled',
                          hover: false,
                          rightIconWidget: MySwitch(
                            isOn: enabled,
                            onChanged: (value) {
                              setState(() => enabled = value);
                              return value;
                            },
                          ),
                        ).expanded(),
                        Gap(16),
                        MyCell(
                          title: 'Obscure',
                          hover: false,
                          rightIconWidget: MySwitch(
                            isOn: obscure,
                            onChanged: (value) {
                              setState(() => obscure = value);
                              return value;
                            },
                          ),
                        ).expanded(),
                      ],
                    ),
                    MyInput(
                      enabled: enabled,
                      leading: Icon(
                        LucideIcons.mail,
                        color: context.colorScheme.mutedForeground,
                        size: 18,
                      ),
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    MyInput(
                      enabled: enabled,
                      obscureText: obscure,
                      placeholder: 'Password',
                      leading: Icon(
                        LucideIcons.lock,
                        color: context.colorScheme.mutedForeground,
                        size: 18,
                      ),
                      trailing: MyButton(
                        enabled: enabled,
                        height: 20,
                        width: 20,
                        padding: EdgeInsets.zero,
                        focus: MyFocusableParams(canRequestFocus: false),
                        type: MyButtonType.text,
                        shape: MyButtonShape.square,
                        icon: obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                        onTap: () {
                          setState(() => obscure = !obscure);
                        },
                      ),
                    ),
                  ],
                ).padding(horizontal: 16);
              },
            ),
            ExampleItem(
              desc: 'Text Form Field',
              builder: (context) {
                return MyForm(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      MyInputFormField(
                        id: 'username',
                        label: const Text('Username'),
                        placeholder: 'Enter your username',
                        description: const Text(
                          'This is your public display name.',
                        ),
                        validator: (v) {
                          if (v.length < 2) {
                            return 'Username must be at least 2 characters.';
                          }
                          return null;
                        },
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
              },
            ),
          ],
        ),
      ],
    );
  }
}
