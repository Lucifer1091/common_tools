import 'package:flutter/material.dart';

import '../about.dart';
import '../config.dart';
import '../home.dart';
import 'example_base.dart';

class MyRoute {
  MyRoute._();

  static final Map<String, ExamplePageModel> pageModelList = {};

  static const String homePath = '/';
  static const String aboutPath = '/about';
  static const String componentsPath = 'components';
  static const String apiPath = 'api';

  static bool _initialized = false;

  static void init() {
    pageModelList.clear();

    for (final entry in exampleMap.entries) {
      for (final model in entry.value) {
        pageModelList[model.name] = model;
      }
    }

    for (final model in sideBarExamplePage) {
      add(model);
    }

    pageModelList['about'] = ExamplePageModel(
      text: 'About',
      name: 'about',
      pageBuilder: (context, model) => const AboutPage(),
    );

    _initialized = true;
  }

  static void ensureInitialized() {
    if (!_initialized) init();
  }

  static void add(ExamplePageModel model) {
    pageModelList[model.name] = model;
  }

  static String pagePath(ExamplePageModel model) {
    return namedPagePath(model.name);
  }

  static String namedPagePath(String name) {
    return Uri(
      path: '/$componentsPath/${Uri.encodeComponent(name)}',
    ).toString();
  }

  static String getApiPath(ExamplePageModel? model) {
    return Uri(
      path: '/$apiPath/${Uri.encodeComponent(model?.name ?? '')}',
    ).toString();
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    ensureInitialized();

    final uri = _parseRouteUri(settings.name);
    final routeSettings = RouteSettings(name: uri.toString());

    if (_isHome(uri) || _isComponentsIndex(uri)) {
      return _materialRoute(
        settings: routeSettings,
        builder: (context) => const MyHomePage(title: 'My Components'),
      );
    }

    if (_isAbout(uri)) {
      return _materialRoute(
        settings: routeSettings,
        builder: (context) => const AboutPage(),
      );
    }

    if (_isApiRoute(uri)) {
      return _materialRoute(
        settings: routeSettings,
        builder: (context) => _PlaceholderRoutePage(uri: uri),
      );
    }

    final model = _resolvePageModel(uri);
    if (model != null) {
      return _materialRoute(
        settings: routeSettings,
        builder: (context) => model.pageBuilder(context, model),
      );
    }

    return _materialRoute(
      settings: routeSettings,
      builder: (context) => _NotFoundRoutePage(uri: uri),
    );
  }

  static Uri _parseRouteUri(String? routeName) {
    final value = routeName == null || routeName.isEmpty ? homePath : routeName;
    final uri = Uri.parse(value);

    if (uri.path.isEmpty) {
      return uri.replace(path: homePath);
    }

    return uri;
  }

  static bool _isHome(Uri uri) {
    return uri.path == homePath;
  }

  static bool _isComponentsIndex(Uri uri) {
    return _trimSlashes(uri.path) == componentsPath;
  }

  static bool _isAbout(Uri uri) {
    final path = _trimSlashes(uri.path);
    return path == _trimSlashes(aboutPath) || path == 'AboutPage';
  }

  static bool _isApiRoute(Uri uri) {
    return (uri.pathSegments.isNotEmpty && uri.pathSegments.first == apiPath) ||
        _trimSlashes(uri.path).startsWith(apiPath);
  }

  static ExamplePageModel? _resolvePageModel(Uri uri) {
    final segments = uri.pathSegments;

    if (segments.length >= 2 && segments.first == componentsPath) {
      return pageModelList[Uri.decodeComponent(segments[1])];
    }

    final legacyName = _trimSlashes(uri.path);
    if (legacyName.isNotEmpty) {
      return pageModelList[Uri.decodeComponent(legacyName)];
    }

    return null;
  }

  static MaterialPageRoute<dynamic> _materialRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return MaterialPageRoute(settings: settings, builder: builder);
  }

  static String _trimSlashes(String value) {
    return value.replaceAll(RegExp(r'^/+|/+$'), '');
  }
}

class _NotFoundRoutePage extends StatelessWidget {
  const _NotFoundRoutePage({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No example page matches "${uri.toString()}".'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(MyRoute.homePath, (route) => false);
                },
                child: const Text('Return home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderRoutePage extends StatelessWidget {
  const _PlaceholderRoutePage({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API route')),
      body: Center(child: Text('No API preview is registered for $uri.')),
    );
  }
}
