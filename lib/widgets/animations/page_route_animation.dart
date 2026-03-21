import 'package:flutter/material.dart';

import '../../index.dart';

/// Enum for page route
enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }

class PageRoute<T> {
  PageRoute._();

  static Duration kDefaultTransitionDuration = 400.milliseconds;

  /// Builds a page route with the specified animation.
  static Route<T> build<T>(
    Widget child,
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
  ) {
    if (pageRouteAnimation != null) {
      if (pageRouteAnimation == PageRouteAnimation.Fade) {
        // Fade animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: duration ?? kDefaultTransitionDuration,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
        // Rotation animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return RotationTransition(
              turns: ReverseAnimation(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? kDefaultTransitionDuration,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
        // Scale animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return ScaleTransition(scale: anim, child: child);
          },
          transitionDuration: duration ?? kDefaultTransitionDuration,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
        // Slide animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              position: Tween(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ).animate(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? kDefaultTransitionDuration,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
        // Slide from bottom to top animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              position: Tween(
                begin: Offset(0, 1),
                end: Offset(0, 0),
              ).animate(anim),
              child: child,
            );
          },
          transitionDuration: duration ?? kDefaultTransitionDuration,
        );
      }
    }
    // Default page route.
    return MaterialPageRoute<T>(builder: (_) => child);
  }
}
