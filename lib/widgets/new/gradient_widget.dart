import 'package:flutter/material.dart';

/// A [GradientWidget] applies a gradient effect to its child widget
/// and offers extensive customization options for blending, alignment,
/// and opacity.
///
/// This widget uses a [ShaderMask] to overlay the provided [gradient] on top
/// of the [child] widget. Additionally, it provides options to control how the
/// gradient interacts with the child, including blend mode, child alignment, and opacity.
///
/// Example usage:
/// ```dart
/// GradientWidget(
///   gradient: LinearGradient(
///     colors: [Colors.blue, Colors.purple, Colors.pink],
///     begin: AlignmentDirectional.topStart,
///     end: AlignmentDirectional.bottomEnd,
///   ),
///   blendMode: BlendMode.srcIn,
///   opacity: 0.8,
///   child: Text(
///     'Gradient Text!',
///     style: TextStyle(fontSize: 40, color: Colors.white),
///   ),
/// )
/// ```
///
/// The gradient can be customized with any [Gradient], and the child can
/// be any widget, not limited to just text.
class GradientWidget extends StatelessWidget {
  /// Creates a [GradientWidget] with customizable gradient, blend mode, opacity,
  /// and alignments for both the gradient and the child.
  const GradientWidget({
    required this.child,
    required this.gradient,
    this.blendMode = BlendMode.srcIn,
    this.opacity = 1.0,
    this.alignment = AlignmentDirectional.center,
    super.key,
  }) : assert(
         opacity >= 0.0 && opacity <= 1.0,
         'Opacity must be between 0.0 and 1.0',
       );

  /// The widget that will have the gradient applied to it.
  final Widget child;

  /// The gradient to apply on the child widget.
  /// Use the gradient's own positioning properties (like begin/end for LinearGradient)
  /// to control its placement.
  final Gradient gradient;

  /// The blend mode to determine how the gradient interacts with the
  /// child widget's existing colors. Defaults to [BlendMode.srcIn].
  final BlendMode blendMode;

  /// The opacity of the gradient, ranging from 0.0 (fully transparent)
  /// to 1.0 (fully opaque). Defaults to 1.0.
  final double opacity;

  /// The alignment of the child within the widget. Useful if the child does not
  /// fill the entire available space. Defaults to [AlignmentDirectional.center].
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: ShaderMask(
        blendMode: blendMode,
        shaderCallback: gradient.createShader,
        child: Align(alignment: alignment, child: child),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText({
    required this.textWidget,
    required this.gradient,
    super.key,
  });

  GradientText.colors({
    required this.textWidget,
    required List<Color> colors,
    super.key,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
  }) : gradient = LinearGradient(colors: colors, begin: begin, end: end);

  final Text textWidget;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(shaderCallback: gradient.createShader, child: textWidget);
  }
}
