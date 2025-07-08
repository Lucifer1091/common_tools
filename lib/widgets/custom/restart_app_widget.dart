import 'package:flutter/material.dart';

/// RestartAppWidget helps you to restart your Flutter app
class RestartAppWidget extends StatefulWidget {
  const RestartAppWidget({required this.child, super.key});

  final Widget child;

  @override
  _RestartAppWidgetState createState() => _RestartAppWidgetState();

  static void init(BuildContext context) =>
      context.findAncestorStateOfType<_RestartAppWidgetState>()?.restartApp();
}

class _RestartAppWidgetState extends State<RestartAppWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    _key = UniqueKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}
