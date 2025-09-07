import 'package:flutter/material.dart';

import 'progress_indicator.dart';
import 'progress_indicator/ball_scale_progress_indicator.dart';

class LoadingProgressIndicator extends StatefulWidget {
  LoadingProgressIndicator({
    super.key,
    SpinnerIndicator? indicator,
    this.size = 50.0,
    this.color = Colors.white,
  }) : indicator = indicator ?? BallScaleProgressIndicator();

  final SpinnerIndicator? indicator;
  final double size;
  final Color color;

  @override
  State<StatefulWidget> createState() {
    return LoadingProgressState(indicator, size);
  }
}

class LoadingProgressState extends State<LoadingProgressIndicator>
    with TickerProviderStateMixin {
  LoadingProgressState(this.indicator, this.size);
  SpinnerIndicator? indicator;
  double size;

  @override
  void initState() {
    super.initState();
    indicator!.context = this;
    indicator!.start();
  }

  @override
  void dispose() {
    indicator!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(indicator, widget.color),
      size: Size.square(size),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter(this.indicator, this.color) {
    defaultPaint =
        Paint()
          ..strokeCap = StrokeCap.butt
          ..style = PaintingStyle.fill
          ..color = color
          ..isAntiAlias = true;
  }

  SpinnerIndicator? indicator;
  Color color;
  Paint? defaultPaint;

  @override
  void paint(Canvas canvas, Size size) {
    indicator!.paint(canvas, defaultPaint, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
