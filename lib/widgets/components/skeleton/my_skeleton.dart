import 'package:flutter/material.dart';

import '../../../index.dart';

enum MySkeletonAnimation { gradient, flashed }

enum MySkeletonTheme { avatar, image, text, paragraph }

class MySkeleton extends StatefulWidget {
  factory MySkeleton({
    Key? key,
    MySkeletonAnimation? animation,
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
    this.animation,
    this.delay = 0,
  }) : assert(delay >= 0, '');

  final MySkeletonAnimation? animation;
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

  static const _animationFlashed = .3;

  static LinearGradient _animationGradient(BuildContext context) =>
      LinearGradient(
        colors: [
          Colors.transparent,
          ThemeColors.neutral.shade300,
          Colors.transparent,
        ],
        // 15 deg
        begin: const Alignment(-1, -0.268),
        end: const Alignment(1, 0.268),
      );

  @override
  void initState() {
    super.initState();

    switch (widget.animation) {
      case MySkeletonAnimation.gradient:
        _controller = AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: this,
        )..repeat();
        _animation = Tween<double>(begin: -1, end: 1).animate(_controller!)
          ..addListener(() => setState(() {}));
      case MySkeletonAnimation.flashed:
        _controller = AnimationController(
          duration: const Duration(seconds: 1),
          vsync: this,
        )..repeat(reverse: true);
        _animation = Tween<double>(
          begin: 1,
          end: _animationFlashed,
        ).animate(_controller!)..addListener(() => setState(() {}));
      case null:
        _controller = null;
        _animation = null;
    }

    Future.delayed(
      Duration(milliseconds: widget.delay),
      () => setState(() => _isLoading = false),
    );
  }

  Widget Function(MySkeletonRowColObj) _buildObj(BuildContext context) => (
    MySkeletonRowColObj obj,
  ) {
    Widget skeletonObj = Container(
      width: obj.width,
      height: obj.height,
      margin: obj.margin,
      decoration: BoxDecoration(
        color: obj.style.background(context),
        borderRadius: BorderRadius.circular(obj.style.borderRadius(context)),
      ),
    );

    switch (widget.animation) {
      case MySkeletonAnimation.gradient:
        skeletonObj = ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback:
              (bounds) => _animationGradient(context).createShader(
                Rect.fromLTWH(
                  bounds.width * _animation!.value,
                  0,
                  bounds.width,
                  bounds.height,
                ),
              ),
          child: skeletonObj,
        );
      case MySkeletonAnimation.flashed:
        skeletonObj = Opacity(opacity: _animation!.value, child: skeletonObj);
      case null:
        // No animation, return skeleton object as is
        break;
    }

    return obj.flex == null
        ? skeletonObj
        : Flexible(flex: obj.flex!, child: skeletonObj);
  };

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
