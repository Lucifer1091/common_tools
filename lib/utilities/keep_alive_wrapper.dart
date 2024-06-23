part of 'utilities.dart';

/// A wrapper widget that keeps its child alive using [AutomaticKeepAliveClientMixin].
///
/// This widget ensures that its child widget stays alive even when it's not visible
/// on the screen, preserving its state across different tab views or screen changes.
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  KeepAliveWrapperState createState() => KeepAliveWrapperState();
}

/// State class for [KeepAliveWrapper], implementing [AutomaticKeepAliveClientMixin].
///
/// This state class ensures that the [widget.child] remains alive and its state
/// is preserved across different tab views or screen changes.
class KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
