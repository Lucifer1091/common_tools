import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyInputViewPage extends StatefulWidget {
  const MyInputViewPage({super.key});

  @override
  State<MyInputViewPage> createState() => _MyInputViewPageState();
}

class _MyInputViewPageState extends State<MyInputViewPage> {
  var controller = [];

  @override
  void initState() {
    for (var i = 0; i < 28; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool enabled = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: '用于在预设的一组Options中执行单项选择，并呈现选择结果。',
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
                  placeholder: Text('abs@gmail.com'),
                  controller: TextEditController(),
                ).padding(all: 16);
              },
            ),
            ExampleItem(
              desc: 'Text Form Field',
              builder: (context) {
                return Column(
                  spacing: 8,
                  children: [
                    MySwitch(
                      // label: 'Enabled',
                      isOn: enabled,
                      onChanged: (value) {
                        setState(() => enabled = value);
                        return value;
                      },
                    ),
                    MySwitch(
                      // label: 'Obscure',
                      isOn: obscure,
                      onChanged: (value) {
                        setState(() => obscure = value);
                        return value;
                      },
                    ),
                    MyInput(
                      placeholder: const Text('Email'),
                      enabled: enabled,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Space.h8(),
                    MyInput(
                      enabled: enabled,
                      obscureText: obscure,
                      placeholder: const Text('Password'),
                      leading: Icon(
                        LucideIcons.lock,
                        color: context.colorScheme.mutedForeground,
                        size: 18,
                      ),
                      trailing: MyButton(
                        // height: 18,
                        // width: 18,
                        // padding: EdgeInsets.zero,
                        type: MyButtonType.ghost,
                        shape: MyButtonShape.square,
                        icon: obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                        onTap: () {
                          setState(() => obscure = !obscure);
                        },
                      ),
                    ),
                  ],
                ).padding(all: 16);
              },
            ),
          ],
        ),
      ],
    );
  }
}
