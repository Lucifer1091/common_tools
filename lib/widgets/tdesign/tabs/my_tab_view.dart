import 'package:flutter/material.dart';

class MyTabView extends TabBarView {
  @override
  const MyTabView({
    required super.children,
    super.key,
    super.controller,
    this.enableSwipe = false,
  }) : super(
         physics:
             enableSwipe
                 ? const ScrollPhysics()
                 : const NeverScrollableScrollPhysics(),
       );

  final bool enableSwipe;

  Widget build(BuildContext context) {
    return TabBarView(controller: controller, children: children);
  }
}
