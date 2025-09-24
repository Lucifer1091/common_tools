part of 'my_check_icon.dart';

class _MyCheckboxIconBase extends StatelessWidget {
  const _MyCheckboxIconBase({
    required this.animation,
    required this.colors,
    required this.context,
    required this.disabled,
    required this.size,
    required this.strokeWidth,
    required this.style,
    this.shape = MyCheckboxShape.circle,
    this.borderRadius,
  });

  final Animation<double> animation;
  final BuildContext context;
  final MyCheckboxStyle style;
  final MyCheckboxColors colors;
  final bool disabled;
  final double size;
  final double strokeWidth;
  final MyCheckboxShape shape;
  final BorderRadius? borderRadius;

  MyCheckboxIconState get state => MyCheckboxIconState(
    context: context,
    disabled: disabled,
    style: style,
    shape: shape,
  );

  @override
  Widget build(BuildContext context) {
    if (shape == MyCheckboxShape.check) {
      return _CheckMarkCheckbox(parent: this);
    }

    switch (style) {
      case MyCheckboxStyle.stroke:
        return _StrokeCheckbox(parent: this);
      case MyCheckboxStyle.fillScaleColor:
        return _FillScaleColorCheckbox(parent: this);
      case MyCheckboxStyle.fillScaleCheck:
        return _FillScaleCheckCheckbox(parent: this);
      case MyCheckboxStyle.fillFade:
        return _FillFadeCheckbox(parent: this);
    }
  }

  Color fillColor() => colors.fillColor(state);

  Color checkColor() => colors.checkColor(state);

  Color tintColor() => colors.tintColor(state);

  double get checkStroke => size / 12;
}

class _CheckMarkCheckbox extends StatelessWidget {
  const _CheckMarkCheckbox({required this.parent});

  final _MyCheckboxIconBase parent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: parent.animation,
      builder: (context, child) {
        return MyCheck(
          color: parent.checkColor(),
          size: parent.size,
          strokeWidth: parent.checkStroke,
          fillPercentage:
              parent.animation
                  .drive(CurveTween(curve: Curves.easeInOutCubic))
                  .value,
        );
      },
    );
  }
}

class _FillFadeCheckbox extends StatelessWidget {
  const _FillFadeCheckbox({required this.parent});

  final _MyCheckboxIconBase parent;

  @override
  Widget build(BuildContext context) {
    final animation = parent.animation.drive(CurveTween(curve: Curves.ease));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: parent.size + parent.strokeWidth,
                width: parent.size + parent.strokeWidth,
                decoration: BoxDecoration(
                  borderRadius: parent.borderRadius,
                  shape:
                      parent.shape == MyCheckboxShape.circle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                  color: parent.fillColor(),
                ),
              ),
              MyCheck(
                color: parent.checkColor(),
                fillPercentage: 1,
                size: parent.size * 0.4,
                strokeWidth: parent.checkStroke,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FillScaleCheckCheckbox extends StatelessWidget {
  const _FillScaleCheckCheckbox({required this.parent});

  final _MyCheckboxIconBase parent;

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = parent.animation.drive(
      CurveTween(curve: Curves.easeOutCubic),
    );

    final checkAnimation = parent.animation.drive(
      CurveTween(curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: parent.animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: fadeAnimation.value,
              child: Container(
                height: parent.size + parent.strokeWidth,
                width: parent.size + parent.strokeWidth,
                decoration: BoxDecoration(
                  borderRadius: parent.borderRadius,
                  shape:
                      parent.shape == MyCheckboxShape.circle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                  color: parent.fillColor(),
                ),
              ),
            ),
            Container(
              transform: Transform.scale(scale: checkAnimation.value).transform,
              transformAlignment: Alignment.center,
              child: MyCheck(
                color: parent.checkColor(),
                fillPercentage: 1,
                size: parent.size * 0.4,
                strokeWidth: parent.checkStroke,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FillScaleColorCheckbox extends StatelessWidget {
  const _FillScaleColorCheckbox({required this.parent});
  final _MyCheckboxIconBase parent;

  @override
  Widget build(BuildContext context) {
    final animation = parent.animation.drive(
      Tween<double>(
        begin: 0,
        end: parent.size + parent.strokeWidth,
      ).chain(CurveTween(curve: Curves.easeOutCirc)),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: animation.value,
              width: animation.value,
              decoration: BoxDecoration(
                borderRadius: parent.borderRadius,
                shape:
                    parent.shape == MyCheckboxShape.circle
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                color: parent.fillColor(),
              ),
            ),
            Opacity(
              opacity: parent.animation.value,
              child: MyCheck(
                color: parent.checkColor(),
                fillPercentage: 1,
                size: parent.size * 0.4,
                strokeWidth: parent.checkStroke,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StrokeCheckbox extends StatelessWidget {
  const _StrokeCheckbox({required this.parent});

  final _MyCheckboxIconBase parent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: parent.animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (parent.shape == MyCheckboxShape.circle)
              MyArc(
                color: parent.tintColor(),
                startAngle: pi / 4,
                sweepAngle:
                    parent.animation
                        .drive(CurveTween(curve: Curves.easeInOutCubic))
                        .drive(Tween<double>(begin: 0, end: 2 * pi))
                        .value,
                strokeWidth: parent.strokeWidth,
                size: parent.size,
              )
            else
              MyRoundShape(
                borderRadius: parent.borderRadius ?? MyBorderRadius.small,
                color: parent.tintColor(),
                startAngle: pi,
                sweepAngle:
                    parent.animation
                        .drive(CurveTween(curve: Curves.easeInOutCubic))
                        .drive(Tween<double>(begin: 0, end: 2 * pi))
                        .value,
                strokeWidth: parent.strokeWidth,
                size: parent.size,
              ),
            MyCheck(
              color: parent.checkColor(),
              size: parent.size * 0.4,
              strokeWidth: parent.checkStroke,
              fillPercentage:
                  parent.animation
                      .drive(CurveTween(curve: Curves.easeInOutCubic))
                      .value,
            ),
          ],
        );
      },
    );
  }
}

/// A callback function which returns a [Color] based on a given [MyCheckboxIconState]
typedef ColorFromState = Color Function(MyCheckboxIconState);

/// A color configuration for [MyCheckboxIcon]. This class gives a more fine-grained
/// level of control over the coloring of the checkbox, by allowing colors to be specified
/// for each component of the checkbox.
class MyCheckboxColors {
  /// Construct an MSHColorConfig
  const MyCheckboxColors({
    ColorFromState? borderColor,
    ColorFromState? tintColor,
    ColorFromState? fillColor,
    ColorFromState? checkColor,
  }) : borderColor = borderColor ?? _defaultBorderColor,
       tintColor = tintColor ?? _defaultTintColor,
       fillColor = fillColor ?? _defaultFillColor,
       checkColor = checkColor ?? _defaultCheckColor;

  /// Presents a simplified interface for constructing an [MyCheckboxColors].
  factory MyCheckboxColors.fromCheckedUncheckedDisabled({
    /// The color of the check and border or fill when [MyCheckbox.checked] is `true`.
    Color? checkedColor,

    /// The color of the checkbox when [MyCheckbox.checked] is `false`.
    Color? uncheckedColor,

    /// The color of the checkbox when [MyCheckbox.enabled] is `false`.
    Color? disabledColor,
  }) {
    Color disable(MyCheckboxIconState state) =>
        disabledColor ?? state.context.colorScheme.muted;

    return MyCheckboxColors(
      borderColor:
          (state) =>
              state.disabled
                  ? disable(state)
                  : uncheckedColor ?? state.context.colorScheme.border,
      tintColor:
          (state) =>
              state.disabled
                  ? disable(state)
                  : (checkedColor ?? _defaultToggleableColor(state)),
      fillColor:
          (state) =>
              state.disabled
                  ? disable(state)
                  : (checkedColor ?? _defaultToggleableColor(state)),
      checkColor: (state) {
        if (state.style == MyCheckboxStyle.stroke ||
            state.shape == MyCheckboxShape.check) {
          return state.disabled
              ? disable(state)
              : (checkedColor ?? _defaultToggleableColor(state));
        } else {
          return state.context.colorScheme.primaryForeground;
        }
      },
    );
  }

  /// The color of the border of the checkbox when [MyCheckbox.checked] is `false`.
  final ColorFromState borderColor;

  /// The color of the border of the checkbox when [MyCheckbox.checked] is `true`.
  final ColorFromState tintColor;

  /// The background fill color for the checkbox when [MyCheckbox.checked] is `true`.
  final ColorFromState fillColor;

  /// The color of the check mark.
  final ColorFromState checkColor;

  static Color _defaultBorderColor(MyCheckboxIconState state) {
    return state.context.colorScheme.border;
  }

  static Color _defaultTintColor(MyCheckboxIconState state) {
    return _defaultToggleableColor(state);
  }

  static Color _defaultFillColor(MyCheckboxIconState state) {
    return _defaultToggleableColor(state);
  }

  static Color _defaultCheckColor(MyCheckboxIconState state) {
    if (state.style == MyCheckboxStyle.stroke) {
      return _defaultToggleableColor(state);
    } else {
      return state.context.colorScheme.primaryForeground;
    }
  }

  static Color _defaultToggleableColor(MyCheckboxIconState state) {
    return state.context.colorScheme.primary;
  }
}

class MyCheckboxIconState {
  const MyCheckboxIconState({
    required this.context,
    required this.disabled,
    required this.style,
    required this.shape,
  });

  final BuildContext context;
  final bool disabled;
  final MyCheckboxStyle style;
  final MyCheckboxShape shape;
}
