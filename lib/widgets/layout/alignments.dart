import 'package:flutter/material.dart';

class TopLeft extends Align {
  const TopLeft({super.key, super.widthFactor, super.heightFactor, super.child})
    : super(alignment: Alignment.topLeft);
}

class TopCenter extends Align {
  const TopCenter({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  }) : super(alignment: Alignment.topCenter);
}

class TopRight extends Align {
  const TopRight({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  }) : super(alignment: Alignment.topRight);
}

class CenterLeft extends Align {
  const CenterLeft({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  }) : super(alignment: Alignment.centerLeft);
}

class CenterRight extends Align {
  const CenterRight({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  }) : super(alignment: Alignment.centerRight);
}

class BottomLeft extends Align {
  const BottomLeft({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  }) : super(alignment: Alignment.bottomLeft);
}

class BottomCenter extends Align {
  const BottomCenter({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  }) : super(alignment: Alignment.bottomCenter);
}

class BottomRight extends Align {
  const BottomRight({
    super.key,
    super.widthFactor,
    super.heightFactor,
    super.child,
  }) : super(alignment: Alignment.bottomRight);
}
