import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class MySwitchPage extends StatefulWidget {
  const MySwitchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySwitchPageState();
  }
}

class MySwitchPageState extends State<MySwitchPage> {
  @override
  Widget build(BuildContext context) {
    var current = ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'switch',
      desc: 'Used to control the opening and closing of a certain function. ',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(builder: _buildSwitchWithBase),
            ExampleItem(builder: _buildSwitchWithIcon),
            ExampleItem(builder: _buildSwitchWithColor),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(builder: _buildSwitchWithLoadingOff),
            ExampleItem(builder: _buildSwitchWithLoadingOn),
            ExampleItem(builder: _buildSwitchWithDisableOff),
            ExampleItem(builder: _buildSwitchWithDisableOn),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(builder: _buildSwitchWithSizeLarge),
            ExampleItem(builder: _buildSwitchWithSizeMed),
            ExampleItem(builder: _buildSwitchWithSizeSmall),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc:
              'Custom switch text - usually only supports one character, any text exceeding this character cannot be displayed',
          builder: _customText,
        ),
        ExampleItem(builder: _customTextFont),
      ],
    );
    return current;
  }

  Widget demoRow(
    BuildContext context,
    String? title, {
    String? desc,
    bool on = true,
    bool enable = true,
    Color? trackOnColor,
    Color? trackOffColor,
    Color? thumbContentOnColor,
    Color? thumbContentOffColor,
    MySwitchSize? size,
    MySwitchType? type,
  }) {
    Widget current = Row(
      children: [
        Expanded(child: MyText(title, textColor: ThemeColors.neutral.shade900)),
        MyText(desc ?? '', textColor: ThemeColors.neutral.shade500),
        SizedBox(
          child: _buildSwitch(
            on: on,
            enable: enable,
            trackOnColor: trackOnColor,
            trackOffColor: trackOffColor,
            thumbContentOnColor: thumbContentOnColor,
            thumbContentOffColor: thumbContentOffColor,
            size: size,
            type: type,
          ),
        ),
      ],
    );
    current = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 56,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: current,
          ),
        ),
      ),
    );
    return current;
  }

  Widget _buildItem(
    BuildContext context,
    Widget switchItem, {
    String? title,
    String? desc,
  }) {
    Widget current = Row(
      children: [
        Expanded(child: MyText(title ?? '')),
        MyText(desc ?? ''),
        switchItem,
      ],
    );
    current = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 40,
        child: Container(
          color: context.colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: current,
          ),
        ),
      ),
    );
    return Column(mainAxisSize: MainAxisSize.min, children: [current]);
  }

  Widget _buildSwitchWithBase(BuildContext context) {
    return _buildItem(context, const MySwitch(), title: 'Basic Switch');
  }

  Widget _buildSwitchWithIcon(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(isOn: true, type: MySwitchType.icon),
      title: 'Switch with icon',
    );
  }

  Widget _buildSwitchWithColor(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(isOn: true, trackOnColor: Colors.green),
      title: 'Custom color switch',
    );
  }

  Widget _buildSwitchWithLoadingOff(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(isOn: false, type: MySwitchType.loading),
      title: 'Loading Status',
    );
  }

  Widget _buildSwitchWithLoadingOn(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(isOn: true, type: MySwitchType.loading),
      title: 'Loading Status',
    );
  }

  Widget _buildSwitchWithDisableOff(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(enable: false, isOn: false),
      title: 'Disabled State',
    );
  }

  Widget _buildSwitchWithDisableOn(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(enable: false, isOn: true),
      title: 'Disabled State',
    );
  }

  Widget _buildSwitchWithSizeLarge(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(isOn: true, size: MySwitchSize.large),
      title: 'Large size 32',
    );
  }

  Widget _buildSwitchWithSizeMed(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(isOn: true, size: MySwitchSize.medium),
      title: 'Medium size 28',
    );
  }

  Widget _buildSwitchWithSizeSmall(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(isOn: true, size: MySwitchSize.small),
      title: 'Small size 24',
    );
  }

  Widget _buildSwitch({
    bool on = true,
    bool enable = true,
    Color? trackOnColor,
    Color? trackOffColor,
    Color? thumbContentOnColor,
    Color? thumbContentOffColor,
    MySwitchSize? size,
    MySwitchType? type,
  }) {
    return MySwitch(
      isOn: on,
      trackOnColor: trackOnColor,
      trackOffColor: trackOffColor,
      thumbContentOnColor: thumbContentOnColor,
      thumbContentOffColor: thumbContentOffColor,
      enable: enable,
      size: size,
      type: type,
    );
  }

  Widget _customText(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(type: MySwitchType.text, openText: '1111', closeText: '—'),
      title: 'Basic Switch',
    );
  }

  Widget _customTextFont(BuildContext context) {
    return _buildItem(
      context,
      const MySwitch(
        type: MySwitchType.text,
        openText: 'Open',
        closeText: 'Close',
        thumbContentOffColor: Colors.red,
        thumbContentOnColor: Colors.green,
        thumbContentOnFont: TextStyle(fontSize: 18),
        thumbContentOffFont: TextStyle(fontSize: 12),
      ),
      title: 'Basic Switch',
    );
  }
}
