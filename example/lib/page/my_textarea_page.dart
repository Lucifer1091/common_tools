import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

class MyTextareaPage extends StatefulWidget {
  const MyTextareaPage({super.key});

  @override
  State<MyTextareaPage> createState() => _MyTextareaPageState();
}

class _MyTextareaPageState extends State<MyTextareaPage> {
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
      desc: 'Used for multi-line text input.',
      exampleCodeGroup: 'textarea',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Text Area Field', builder: _buildTextAreaField),
            ExampleItem(
              desc: 'Text Area Form Field',
              builder: _buildTextAreaFormField,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextAreaField(BuildContext context) {
    return MyTextarea(
      controller: controller[0],
      placeholder: 'Type your message here',
    ).padding(horizontal: 16);
  }

  Widget _buildTextAreaFormField(BuildContext context) {
    return MyForm(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          MyTextareaFormField(
            controller: controller[1],
            label: const Text('Bio'),
            placeholder: 'Tell us a little bit about yourself',
            description: const Text(
              'You can @mention other users and organizations.',
            ),
            validator: (v) {
              if (v.length < 10) {
                return 'Bio must be at least 10 characters.';
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
  }
}
