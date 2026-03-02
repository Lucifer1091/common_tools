import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';

enum MySkeletonAnimation { gradient, none }

enum MySkeletonTheme { avatar, image, text, paragraph }

class MySkeleton extends StatefulWidget {
  factory MySkeleton({
    Key? key,
    MySkeletonAnimation animation = MySkeletonAnimation.gradient,
    int delay = 0,
    MySkeletonTheme theme = MySkeletonTheme.text,
  }) {
    assert(delay >= 0, '');

    switch (theme) {
      case MySkeletonTheme.avatar:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: MySkeletonRowCol(
            objects: const [
              [MySkeletonRowColObj.circle()],
            ],
          ),
        );
      case MySkeletonTheme.image:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: MySkeletonRowCol(
            objects: const [
              [MySkeletonRowColObj.rect(width: 72, height: 72, flex: null)],
            ],
          ),
        );
      case MySkeletonTheme.text:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: MySkeletonRowCol(
            objects: const [
              [
                MySkeletonRowColObj.text(flex: 24),
                MySkeletonRowColObj.spacer(width: 16),
                MySkeletonRowColObj.text(flex: 76),
              ],
              [MySkeletonRowColObj.text()],
            ],
          ),
        );
      case MySkeletonTheme.paragraph:
        return MySkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: MySkeletonRowCol(
            objects: [
              for (int i = 0; i < 3; i++) [const MySkeletonRowColObj.text()],
              const [
                MySkeletonRowColObj.text(flex: 55),
                MySkeletonRowColObj.spacer(flex: 45),
              ],
            ],
          ),
        );
    }
  }

  const MySkeleton.fromRowCol({
    required this.rowCol,
    super.key,
    this.animation = MySkeletonAnimation.gradient,
    this.delay = 0,
  }) : assert(delay >= 0, '');

  final MySkeletonAnimation animation;
  final int delay;
  final MySkeletonRowCol rowCol;

  @override
  _MySkeletonState createState() => _MySkeletonState();
}

class _MySkeletonState extends State<MySkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _controller;

  late final Animation<double>? _animation;

  bool _isLoading = true;

  static final _loadingWidget = Container();

  static const Color _lightBaseColor = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color _lightHighlightColor = Color(0x44CCCCCC);

  static const Color _darkBaseColor = Color(0xff2A2C2E);
  static const Color _darkHighlightColor = Color(0xff3A3E3F);

  static const List<double> _shimmerStops = <double>[0, 0.35, 0.5, 0.65, 1];

  static Color _shimmerBaseColor(BuildContext context) {
    final brightness = MyTheme.of(context).brightness;
    return brightness == Brightness.dark ? _darkBaseColor : _lightBaseColor;
  }

  static Color _shimmerHighlightColor(BuildContext context) {
    final brightness = MyTheme.of(context).brightness;
    return brightness == Brightness.dark
        ? _darkHighlightColor
        : _lightHighlightColor;
  }

  @override
  void initState() {
    super.initState();

    switch (widget.animation) {
      case MySkeletonAnimation.gradient:
        final controller = AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: this,
        );
        _controller = controller;
        unawaited(controller.repeat());
        _animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: controller, curve: Curves.linear),
        )..addListener(() => setState(() {}));
      case MySkeletonAnimation.none:
        _controller = null;
        _animation = null;
    }

    unawaited(
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (!mounted) return;
        setState(() => _isLoading = false);
      }),
    );
  }

  Widget Function(MySkeletonRowColObj) _buildObj(BuildContext context) => (
    MySkeletonRowColObj obj,
  ) {
    final baseColor = obj.style.background(context);
    final shimmerBaseColor = _shimmerBaseColor(context);
    final shimmerHighlightColor = _shimmerHighlightColor(context);
    final borderRadius = BorderRadius.circular(obj.style.borderRadius(context));
    final percent = _animation?.value ?? 0;
    final hasAnimation =
        widget.animation == MySkeletonAnimation.gradient &&
        _animation != null &&
        baseColor.a > 0;

    Widget skeletonObj = Container(
      width: obj.width,
      height: obj.height,
      margin: obj.margin,
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: borderRadius,
      ),
    );

    if (hasAnimation) {
      skeletonObj = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          final width = bounds.width;
          final height = bounds.height;
          final dx = _offset(-width, width, percent);
          final rect = Rect.fromLTWH(dx - width, 0, 3 * width, height);
          return LinearGradient(
            begin: Alignment.topLeft,
            colors: <Color>[
              shimmerBaseColor,
              shimmerBaseColor,
              shimmerHighlightColor,
              shimmerBaseColor,
              shimmerBaseColor,
            ],
            stops: _shimmerStops,
          ).createShader(rect);
        },
        child: skeletonObj,
      );
    }

    return obj.flex == null
        ? skeletonObj
        : Flexible(flex: obj.flex!, child: skeletonObj);
  };

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _loadingWidget;

    if (widget.rowCol.objects.length == 1) {
      return widget.rowCol.objects.first.length == 1
          // Single object
          ? _buildObj(context)(widget.rowCol.objects.first.first)
          // Single row with multiple objects
          : Flexible(
            child: Row(
              children:
                  widget.rowCol.objects.first.map(_buildObj(context)).toList(),
            ),
          );
    }

    // Multiple lines, multiple objects
    List<Widget> skeletonRows =
        widget.rowCol.objects
            .map((row) => Row(children: row.map(_buildObj(context)).toList()))
            .toList();
    if (widget.rowCol.style.rowSpacing(context) > 0) {
      skeletonRows =
          skeletonRows
              .expand(
                (row) => [
                  row,
                  SizedBox(height: widget.rowCol.style.rowSpacing(context)),
                ],
              )
              .toList()
            ..removeLast();
    }
    final skeletonRowCol = Column(children: skeletonRows); // 行列布局

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
