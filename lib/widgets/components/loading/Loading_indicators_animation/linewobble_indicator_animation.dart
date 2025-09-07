import 'package:flutter/material.dart';

class LineWobbleLoader extends StatefulWidget {
  @override
  _LineWobbleLoaderState createState() => _LineWobbleLoaderState();
}

class _LineWobbleLoaderState extends State<LineWobbleLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1750), // Matches the web speed
    )..repeat(reverse: true);

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
          size: Size(80, 5), // Width 80, height 5 like in the CSS
          painter: LineWobblePainter(_animation),
        ),
      ),
    );
  }
}

class LineWobblePainter extends CustomPainter {
  final Animation<double> animation;
  LineWobblePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.1) // Background bar color
      ..style = PaintingStyle.fill;

    Paint movingBarPaint = Paint()
      ..color = Colors.black // Moving bar color
      ..style = PaintingStyle.fill;

    // Draw static background bar
    RRect backgroundBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(backgroundBar, backgroundPaint);

    // Calculate moving bar position (matches wobble effect)
    double barWidth = size.width * 0.4; // 40% of total width
    double xOffset = (size.width - barWidth) * ((animation.value + 1) / 2);

    RRect movingBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(xOffset, 0, barWidth, size.height),
      Radius.circular(size.height / 2),
    );

    canvas.drawRRect(movingBar, movingBarPaint);
  }

  @override
  bool shouldRepaint(LineWobblePainter oldDelegate) => true;
}
