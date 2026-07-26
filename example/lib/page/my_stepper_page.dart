import 'package:flutter/material.dart';

import 'package:example/common_tools_catalog.dart';

import '../base/example_widget.dart';

class MyStepperPage extends StatefulWidget {
  const MyStepperPage({super.key});

  @override
  State<MyStepperPage> createState() => _MyStepperPageState();
}

class _MyStepperPageState extends State<MyStepperPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: ExamplePage(
        title: myTitle(),
        desc: 'Used for increasing or decreasing quantity.',
        exampleCodeGroup: 'stepper',
        children: [
          ExampleModule(
            title: 'Component Types',
            children: [
              ExampleItem(desc: 'Base Stepper', builder: _buildStepperWithBase),
            ],
          ),
          ExampleModule(
            title: 'Component State',
            children: [
              ExampleItem(
                desc: 'Maximum and Minimum Status',
                builder: _buildStepperWithMaxMinStatus,
              ),
              ExampleItem(
                desc: 'Disabled Status',
                builder: _buildStepperWithDisableStatus,
              ),
            ],
          ),
          ExampleModule(
            title: 'Component Style',
            children: [
              ExampleItem(
                desc: 'Stepper Style',
                builder: _buildStepperWithTheme,
              ),
              ExampleItem(desc: 'Stepper Size', builder: _buildStepperWithSize),
            ],
          ),
        ],
        test: [
          ExampleItem(desc: 'Custom stepValue', builder: _customStepperValue),
        ],
      ),
    );
  }

  Widget _buildStepperWithBase(BuildContext context) {
    return _buildRow(context, [const MyStepper(theme: MyStepperTheme.filled)]);
  }

  Widget _buildStepperWithMaxMinStatus(BuildContext context) {
    return _buildRow(context, [
      const MyStepper(theme: MyStepperTheme.filled, value: 0, min: 0),
      const MyStepper(theme: MyStepperTheme.filled, value: 999, max: 999),
    ]);
  }

  Widget _buildStepperWithDisableStatus(BuildContext context) {
    return _buildRow(context, [
      const MyStepper(theme: MyStepperTheme.filled, disabled: true),
    ]);
  }

  Widget _buildStepperWithTheme(BuildContext context) {
    return _buildRow(context, [
      const MyStepper(theme: MyStepperTheme.filled, value: 3),
      const MyStepper(theme: MyStepperTheme.outline, value: 3),
      const MyStepper(theme: MyStepperTheme.normal, value: 3),
    ]);
  }

  Widget _buildStepperWithSize(BuildContext context) {
    return _buildRow(context, [
      const MyStepper(
        size: MyStepperSize.large,
        theme: MyStepperTheme.filled,
        value: 3,
      ),
      const MyStepper(
        size: MyStepperSize.medium,
        theme: MyStepperTheme.filled,
        value: 3,
      ),
      const MyStepper(
        size: MyStepperSize.small,
        theme: MyStepperTheme.filled,
        value: 3,
      ),
    ]);
  }

  Widget _buildRow(BuildContext context, List<Widget> stepperItems) {
    return Container(
      decoration: BoxDecoration(color: context.colorScheme.background),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: stepperItems
              .map(
                (item) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 32) / 3,
                  child: item,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  var controller = MyStepperController()..value = 1;

  Widget _customStepperValue(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MyStepper(theme: MyStepperTheme.filled, controller: controller),
        MyButton(
          text: 'value * 2',
          onTap: () {
            controller.value *= 2;
          },
        ),
      ],
    );
  }
}
