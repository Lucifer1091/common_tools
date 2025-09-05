import 'package:flutter/material.dart';
import '../about.dart';
import '../config.dart';
import 'example_base.dart';

class MyRoute {
  static final Map<String, ExamplePageModel> pageModelList = {};
  static const String aboutPath = 'about';
  static const String apiPath = 'api';

  static String getApiPath(ExamplePageModel? model) {
    return '$apiPath?${model?.name}';
  }

  static void init() {
    exampleMap.forEach((key, value) {
      for (var model in value) {
        pageModelList[model.name] = model;
      }
    });

    pageModelList[aboutPath] = ExamplePageModel(
      text: 'About',
      name: 'AboutPage',
      pageBuilder: (context, model) => const AboutPage(),
    );
  }

  static void add(ExamplePageModel model) {
    pageModelList[model.name] = model;
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final url = settings.name ?? 'unknown';
    var strings = url.split('?');
    var name = strings[0];
    var model = pageModelList[name];
    var paramsMap = <String, String>{};

    if (strings.length > 1) {
      var params = strings[1].split('&');
      for (var element in params) {
        var kv = element.split('=');
        var key = kv[0];
        var value = '';
        if (kv.length > 1) {
          value = kv[1];
        }
        paramsMap[key] = value;
      }
    }

    if (model != null) {
      if (paramsMap['showAction'] == '1') {
        model.showAction = true;
      }
      final Route route = MaterialPageRoute(
        settings: settings,
        builder: (context) => model.pageBuilder(context, model),
      );
      return route;
    } else {
      if (name.startsWith(apiPath)) {
        if (strings.length > 1) {
          final Route route = MaterialPageRoute(
            settings: settings,
            builder: (context) => Placeholder(),
          );
          return route;
        }
      }

      return MaterialPageRoute(
        settings: settings,
        builder: (context) => Center(child: Text('error, url:$url')),
      );
    }
  }
}
