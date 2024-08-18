import 'package:flutter/material.dart';

// Adds jump effect on click
class TranslateOnClick extends StatefulWidget {
  const TranslateOnClick({required this.child, super.key});
  final Widget child;

  @override
  _TranslateOnClickState createState() => _TranslateOnClickState();
}

class _TranslateOnClickState extends State<TranslateOnClick> {
  final nonClickTransform = Matrix4.identity();
  final clickTransform = Matrix4.identity()..translate(0, -10);

  bool _clicking = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (d) => _userClick(true),
        onTapUp: (d) => _userClick(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _clicking ? clickTransform : nonClickTransform,
          child: widget.child,
        ),
      );

  void _userClick(bool click) {
    setState(() {
      _clicking = click;
    });
  }
}
