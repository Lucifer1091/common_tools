import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that handles double press back navigation.
///
/// This widget allows users to navigate back by pressing the back button
/// twice within a 2-second window. It displays a customizable message
/// prompting the user for the second press.
class DoublePressBackWidget extends StatefulWidget {
  const DoublePressBackWidget({
    required this.child,
    super.key,
    this.message,
    this.onWillPop,
  });

  /// The child widget to display.
  final Widget child;

  /// The message to display when prompting the user to double press back.
  final String? message;

  /// Callback function that gets called on pop confirmation (double press).
  final VoidCallback? onWillPop;

  @override
  State<DoublePressBackWidget> createState() => _DoublePressBackWidgetState();
}

class _DoublePressBackWidgetState extends State<DoublePressBackWidget> {
  DateTime? _currentBackPressTime;
  Timer? _resetTimer;

  static const _timeout = Duration(seconds: 2);

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Allow pop only after 2 seconds since last press
      canPop: _currentBackPressTime != null,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) {
          widget.onWillPop?.call();
          return;
        }

        _currentBackPressTime = DateTime.now();
        setState(() {});

        ScaffoldMessenger.maybeOf(context)
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(widget.message ?? 'Press back again to exit'),
              duration: _timeout,
            ),
          );

        // Start a timer to reset state after 2 seconds
        _resetTimer?.cancel();
        _resetTimer = Timer(_timeout, () {
          if (!mounted) return;
          _currentBackPressTime = null;
          setState(() {});
        });
      },
      child: widget.child,
    );
  }
}
