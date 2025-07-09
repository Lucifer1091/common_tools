import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class BouncingDraggableWidget extends StatefulWidget {
  const BouncingDraggableWidget({
    required this.content,
    super.key,
    this.height = 200,
    this.width = 400,
  });

  final Widget content;
  final double height;
  final double width;

  @override
  State<BouncingDraggableWidget> createState() =>
      _BouncingDraggableWidgetState();
}

class _BouncingDraggableWidgetState extends State<BouncingDraggableWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: DraggableCard(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.7),
                blurRadius: 30,
              ),
            ],
          ),
          child: widget.content,
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});
  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  final _spring = const SpringDescription(
    mass: 7,
    stiffness: 1200,
    damping: 0.7,
  );
  double _normalizeVelocity(Offset velocity, Size size) {
    final normalizeVelocity = Offset(
      velocity.dx / size.width,
      velocity.dy / size.height,
    );
    return -normalizeVelocity.distance;
  }

  void _runAnimation(Offset velocity, Size size) {
    _animation = _controller.drive(
      AlignmentTween(begin: _dragAlignment, end: Alignment.center),
    );
    final simulation = SpringSimulation(
      _spring,
      0.0,
      1.0,
      _normalizeVelocity(velocity, size),
    );
    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() => _dragAlignment = _animation.value));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanStart: (details) => _controller.stop(canceled: true),
      onPanUpdate:
          (details) => setState(() {
            _dragAlignment += Alignment(
              details.delta.dx / (size.width / 2),
              details.delta.dy / (size.height / 2),
            );
          }),
      onPanEnd:
          (details) => _runAnimation(details.velocity.pixelsPerSecond, size),
      child: Align(alignment: _dragAlignment, child: Card(child: widget.child)),
    );
  }
}
