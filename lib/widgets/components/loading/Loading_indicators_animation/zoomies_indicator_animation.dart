import 'package:flutter/material.dart';

class ZoomiesLoader extends StatefulWidget {
  @override
  _ZoomiesLoaderState createState() => _ZoomiesLoaderState();
}

class _ZoomiesLoaderState extends State<ZoomiesLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CustomPaint(
          size: Size(80, 10), // Loader size
          painter: ZoomiesPainter(_animation),
        ),
      ),
    );
  }
}

class ZoomiesPainter extends CustomPainter {
  final Animation<double> animation;
  ZoomiesPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.1) // Background opacity
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;

    Paint movingBarPaint = Paint()
      ..color = Colors.black // Moving bar color
      ..style = PaintingStyle.fill;

    // Draw background bar
    RRect backgroundBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(backgroundBar, backgroundPaint);

    // Calculate moving bar position
    double barWidth = size.width * 0.4; // Width of moving bar
    double xOffset = (size.width - barWidth) * ((animation.value + 1) / 2);

    RRect movingBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(xOffset, 0, barWidth, size.height),
      Radius.circular(size.height / 2),
    );

    canvas.drawRRect(movingBar, movingBarPaint);
  }

  @override
  bool shouldRepaint(ZoomiesPainter oldDelegate) => true;
}
