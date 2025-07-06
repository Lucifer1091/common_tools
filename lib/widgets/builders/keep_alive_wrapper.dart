import 'package:flutter/material.dart';

/// Wrapper for widgets to keep them alive and not destroy them.
class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
