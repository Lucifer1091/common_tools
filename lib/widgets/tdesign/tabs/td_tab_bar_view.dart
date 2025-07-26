import 'package:flutter/material.dart';

class TDTabBarView extends TabBarView {
  @override
  const TDTabBarView({
    required super.children,
    super.key,
    super.controller,
    this.isSlideSwitch = false,
  }) : super(
         physics:
             isSlideSwitch
                 ? const ScrollPhysics()
                 : const NeverScrollableScrollPhysics(),
       );

  final bool isSlideSwitch;

  Widget build(BuildContext context) {
    return TabBarView(controller: controller, children: children);
  }
}
