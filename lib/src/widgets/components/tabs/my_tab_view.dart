import 'package:flutter/material.dart';

class MyTabView extends TabBarView {
  const MyTabView({
    required super.children,
    super.key,
    super.controller,
    this.enableSwipe = false,
    ScrollPhysics? physics,
  }) : super(
         physics: enableSwipe
             ? physics ?? const ScrollPhysics()
             : const NeverScrollableScrollPhysics(),
       );

  final bool enableSwipe;
}
