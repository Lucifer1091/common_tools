import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';

enum MySkeletonAnimation { gradient, none }

enum MySkeletonTheme { avatar, image, text, paragraph }

enum MySkeletonDirection { ltr, rtl, ttb, btt }

class MySkeleton extends StatefulWidget {
  factory MySkeleton({
    Key? key,
    MySkeletonAnimation animation = MySkeletonAnimation.gradient,
    MySkeletonTheme theme = MySkeletonTheme.text,
    MySkeletonStyle style = const MySkeletonStyle(),
  }) {
    switch (theme) {
      case MySkeletonTheme.avatar:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          style: style,
          rowCol: MySkeletonRowCol(
            objects: const [
              [MySkeletonItem.circle()],
            ],
          ),
        );
      case MySkeletonTheme.image:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          style: style,
          rowCol: MySkeletonRowCol(
            objects: const [
              [MySkeletonItem.rect(width: 72, height: 72, flex: null)],
            ],
          ),
        );
      case MySkeletonTheme.text:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          style: style,
          rowCol: MySkeletonRowCol(
            objects: const [
              [
                MySkeletonItem.text(flex: 24),
                MySkeletonItem.spacer(width: 16),
                MySkeletonItem.text(flex: 76),
              ],
              [MySkeletonItem.text()],
            ],
          ),
        );
      case MySkeletonTheme.paragraph:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          style: style,
          rowCol: MySkeletonRowCol(
            objects: [
              for (int i = 0; i < 3; i++) [const MySkeletonItem.text()],
              const [
                MySkeletonItem.text(flex: 55),
                MySkeletonItem.spacer(flex: 45),
              ],
            ],
          ),
        );
    }
  }

  factory MySkeleton.lines({
    Key? key,
    int count = 3,
    double rowSpacing = 8,
    MySkeletonAnimation animation = MySkeletonAnimation.gradient,
    MySkeletonStyle style = const MySkeletonStyle(),
  }) {
    assert(count > 0, '');
    assert(rowSpacing >= 0, '');

    final rows = <List<MySkeletonItem>>[];
    if (count == 1) {
      rows.add(const [MySkeletonItem.text()]);
    } else {
      for (int i = 0; i < count - 1; i++) {
        rows.add(const [MySkeletonItem.text()]);
      }
      rows.add(const [
        MySkeletonItem.text(flex: 70),
        MySkeletonItem.spacer(flex: 30),
      ]);
    }

    return MySkeleton.fromRowCol(
      key: key,
      animation: animation,
      style: style,
      rowCol: MySkeletonRowCol(
        style: MySkeletonRowColStyle(rowSpacing: (_) => rowSpacing),
        objects: rows,
      ),
    );
  }

  factory MySkeleton.card({
    Key? key,
    double mediaHeight = 140,
    double rowSpacing = 12,
    MySkeletonAnimation animation = MySkeletonAnimation.gradient,
    MySkeletonStyle style = const MySkeletonStyle(),
  }) {
    assert(mediaHeight > 0, '');
    assert(rowSpacing >= 0, '');

    return MySkeleton.fromRowCol(
      key: key,
      animation: animation,
      style: style,
      rowCol: MySkeletonRowCol(
        style: MySkeletonRowColStyle(rowSpacing: (_) => rowSpacing),
        objects: [
          [MySkeletonItem.rect(height: mediaHeight)],
          const [MySkeletonItem.text()],
          const [
            MySkeletonItem.text(flex: 60),
            MySkeletonItem.spacer(flex: 40),
          ],
        ],
      ),
    );
  }

  const MySkeleton.fromRowCol({
    required this.rowCol,
    super.key,
    this.animation = MySkeletonAnimation.gradient,
    this.style = const MySkeletonStyle(),
  });

  final MySkeletonAnimation animation;
  final MySkeletonStyle style;
  final MySkeletonRowCol rowCol;

  @override
  _MySkeletonState createState() => _MySkeletonState();
}

class _MySkeletonState extends State<MySkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _syncAnimationController();
  }

  @override
  void didUpdateWidget(covariant MySkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.style != widget.style) {
      _syncAnimationController();
    }
  }

  void _syncAnimationController() {
    _controller?.dispose();
    _controller = null;
    _animation = null;

    if (widget.animation == MySkeletonAnimation.none || !widget.style.enabled) {
      return;
    }

    final controller = AnimationController(
      duration: widget.style.duration,
      vsync: this,
    );
    _controller = controller;
    _animation = CurvedAnimation(parent: controller, curve: widget.style.curve);
    unawaited(controller.repeat());
  }

  Widget _buildObj(
    BuildContext context,
    MySkeletonItem obj,
    List<Color> shimmerColors,
  ) {
    final baseColor = obj.style.background(context);
    final borderRadius = BorderRadius.circular(obj.style.borderRadius(context));
    final animation = _animation;

    Widget skeletonObj = Container(
      width: obj.width,
      height: obj.height,
      margin: obj.margin,
      decoration: BoxDecoration(color: baseColor, borderRadius: borderRadius),
    );

    if (widget.animation == MySkeletonAnimation.gradient &&
        widget.style.enabled &&
        animation != null &&
        baseColor.a > 0) {
      skeletonObj = _AnimatedSkeletonMask(
        animation: animation,
        colors: shimmerColors,
        stops: widget.style.stops,
        direction: widget.style.direction,
        child: skeletonObj,
      );
    }

    return obj.flex == null
        ? skeletonObj
        : Flexible(flex: obj.flex!, child: skeletonObj);
  }

  @override
  Widget build(BuildContext context) {
    final shimmerColors = widget.style.resolveColors(context);

    if (widget.rowCol.objects.length == 1) {
      return widget.rowCol.objects.first.length == 1
          ? _buildObj(context, widget.rowCol.objects.first.first, shimmerColors)
          : Flexible(
            child: Row(
              children:
                  widget.rowCol.objects.first
                      .map((obj) => _buildObj(context, obj, shimmerColors))
                      .toList(),
            ),
          );
    }

    final rowSpacing = widget.rowCol.style.rowSpacing(context);
    List<Widget> skeletonRows =
        widget.rowCol.objects
            .map(
              (row) => Row(
                children:
                    row
                        .map((obj) => _buildObj(context, obj, shimmerColors))
                        .toList(),
              ),
            )
            .toList();
    if (rowSpacing > 0) {
      skeletonRows =
          skeletonRows
              .expand((row) => [row, SizedBox(height: rowSpacing)])
              .toList()
            ..removeLast();
    }
    final skeletonRowCol = Column(children: skeletonRows);

    return widget.rowCol.objects.any(
          (row) => row.any((obj) => obj.flex != null),
        )
        ? Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: widget.rowCol.visualHeight(context),
            ),
            child: skeletonRowCol,
          ),
        )
        : skeletonRowCol;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class _AnimatedSkeletonMask extends StatelessWidget {
  const _AnimatedSkeletonMask({
    required this.animation,
    required this.colors,
    required this.stops,
    required this.direction,
    required this.child,
  });

  final Animation<double> animation;
  final List<Color> colors;
  final List<double> stops;
  final MySkeletonDirection direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: RepaintBoundary(child: child),
      builder: (BuildContext context, Widget? child) {
        final percent = animation.value;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            final rect = _shaderRect(bounds, percent);
            return LinearGradient(
              begin: _gradientBegin(direction),
              end: _gradientEnd(direction),
              colors: colors,
              stops: stops,
            ).createShader(rect);
          },
          child: child,
        );
      },
    );
  }

  Rect _shaderRect(Rect bounds, double percent) {
    final width = bounds.width;
    final height = bounds.height;
    switch (direction) {
      case MySkeletonDirection.rtl:
        final dx = _offset(width, -width, percent);
        return Rect.fromLTWH(dx - width, 0, 3 * width, height);
      case MySkeletonDirection.ttb:
        final dy = _offset(-height, height, percent);
        return Rect.fromLTWH(0, dy - height, width, 3 * height);
      case MySkeletonDirection.btt:
        final dy = _offset(height, -height, percent);
        return Rect.fromLTWH(0, dy - height, width, 3 * height);
      case MySkeletonDirection.ltr:
        final dx = _offset(-width, width, percent);
        return Rect.fromLTWH(dx - width, 0, 3 * width, height);
    }
  }

  Alignment _gradientBegin(MySkeletonDirection direction) {
    switch (direction) {
      case MySkeletonDirection.ttb:
      case MySkeletonDirection.btt:
        return Alignment.topCenter;
      case MySkeletonDirection.ltr:
      case MySkeletonDirection.rtl:
        return Alignment.centerLeft;
    }
  }

  Alignment _gradientEnd(MySkeletonDirection direction) {
    switch (direction) {
      case MySkeletonDirection.ttb:
      case MySkeletonDirection.btt:
        return Alignment.bottomCenter;
      case MySkeletonDirection.ltr:
      case MySkeletonDirection.rtl:
        return Alignment.centerRight;
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
