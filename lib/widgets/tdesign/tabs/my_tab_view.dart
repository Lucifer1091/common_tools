import 'package:flutter/material.dart';

class MyTabView extends TabBarView {
  @override
  const MyTabView({
    required super.children,
    super.key,
    super.controller,
    this.enableSwipe = false,
    ScrollPhysics? physics,
  }) : super(
         physics:
             enableSwipe
                 ? physics ?? const ScrollPhysics()
                 : const NeverScrollableScrollPhysics(),
       );

  final bool enableSwipe;

  Widget build(BuildContext context) {
    return TabBarView(controller: controller, children: children);
  }
}
