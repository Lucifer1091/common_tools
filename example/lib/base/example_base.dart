import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

typedef PageBuilder =
    Widget Function(BuildContext context, ExamplePageModel model);

class ExamplePageModel {
  ExamplePageModel({
    required this.text,
    required this.name,
    this.apiVisible = false,
    this.showAction = false,
    this.isTodo = false,
    this.pageName,
    required this.pageBuilder,
  });

  final String text;
  final String name;
  String? codePath;
  String? spline;
  bool apiVisible;
  bool showAction;
  String? pageName;
  bool isTodo;
  final PageBuilder pageBuilder;
}

class ExamplePageInheritedTheme extends InheritedWidget {
  final ExamplePageModel model;

  const ExamplePageInheritedTheme({
    required this.model,
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant ExamplePageInheritedTheme oldWidget) {
    return model != oldWidget.model;
  }
}

class ScreenUtil {
  static bool isLargeScreen(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return width > height;
  }

  static bool isWebLargeScreen(BuildContext context) {
    return PlatformChecker.isWeb && isLargeScreen(context);
  }
}
