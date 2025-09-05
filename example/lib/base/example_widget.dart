import 'package:common_tools/index.dart';
import 'package:example/base/app_bar.dart';
import 'package:flutter/material.dart';

import 'example_base.dart';

var navBarkey = GlobalKey();

class ExamplePage extends StatefulWidget {
  const ExamplePage({
    super.key,
    this.navBarKey,
    required this.title,
    this.desc = '',
    this.children = const [],
    this.padding,
    this.backgroundColor,
    required this.exampleCodeGroup,
    this.test = const [],
    this.showSingleChild = false,
    this.singleChild,
    this.scrollController,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String title;

  final bool showSingleChild;

  final WidgetBuilder? singleChild;

  final List<ExampleModule> children;

  final String desc;

  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;

  final String exampleCodeGroup;

  final List<ExampleItem> test;

  final ScrollController? scrollController;

  final Widget? floatingActionButton;

  final Widget? bottomNavigationBar;

  final GlobalKey? navBarKey;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late List<ExampleModule> list;
  ExamplePageModel? model;
  bool showAction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        showAction = model?.showAction ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      backgroundColor: context.colorScheme.background,
      appBar: MyAppBar(title: widget.title),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: widget.showSingleChild && widget.singleChild != null
                ? _singleChild()
                : ListView.builder(
                    controller: widget.scrollController,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 24, bottom: 24),
                    itemCount: widget.children.length + 3,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildHeader(context);
                      }
                      if (index == widget.children.length + 2) {
                        return const NoWidget();
                      }
                      ExampleModule? data;
                      if (index <= widget.children.length) {
                        data = widget.children[index - 1];
                      } else {
                        if (widget.test.isNotEmpty) {
                          data = ExampleModule(
                            title: 'Unit Testing',
                            children: [_buildTestExampleItem(), ...widget.test],
                          );
                        }
                      }

                      if (data == null) return const SizedBox.shrink();

                      return _buildModule(index, data, context);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _singleChild() {
    return ExampleItemInherited(
      path: widget.exampleCodeGroup,
      child: Stack(
        children: [
          widget.singleChild!.call(context),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                MyButton(
                  text: 'Return to homepage',
                  type: MyButtonType.primary,
                  shape: MyButtonShape.round,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ExampleItem _buildTestExampleItem() => ExampleItem(
    desc:
        '''Component styles not included in the sample draft but necessary for verification should be added to the 'test' parameter. The following scenarios must be tested:
1. The parameter is a number. Test scenarios with negative numbers, 0, and larger values.
2. The parameter is an enumeration. Test all enumeration combinations (optional combinations are optional).''',
    builder: (_) => const MyDivider(),
  );

  Widget _buildHeader(BuildContext context) {
    if (widget.showSingleChild) return const NoWidget();

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(widget.title, style: context.titleLarge),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: MyText(widget.desc),
          ),
          // Expanded(child: ),
        ],
      ),
    );
  }

  Widget _buildModule(int index, ExampleModule data, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: MyText(
            '${index < 10 ? "0$index" : index} ${data.title}',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        for (var index = 0; index < data.children.length; index++)
          _buildExampleItem(data, index),
      ],
    );
  }

  Widget _buildExampleItem(ExampleModule data, int index) {
    return Container(
      margin: widget.padding,
      child: ExampleItemWidget(
        data: data.children[index],
        index: index,
        exampleCodeGroup: widget.exampleCodeGroup,
        moduleTitle: data.title,
      ),
    );
  }
}

class ExampleModule {
  const ExampleModule({Key? key, required this.title, required this.children});

  final String title;

  final List<ExampleItem> children;
}

class ExampleItem {
  const ExampleItem({
    Key? key,
    this.desc = '',
    required this.builder,
    this.methodName,
    this.center = true,
    this.ignoreCode = false,
    this.padding,
  });

  final String desc;

  final WidgetBuilder builder;

  final String? methodName;

  final bool center;

  final bool ignoreCode;

  final EdgeInsetsGeometry? padding;
}

class ExampleItemInherited extends InheritedWidget {
  const ExampleItemInherited({
    required this.path,
    super.key,
    required super.child,
  });

  final String path;

  @override
  bool updateShouldNotify(covariant ExampleItemInherited oldWidget) {
    return path != oldWidget.path;
  }
}

class ExampleItemWidget extends StatefulWidget {
  const ExampleItemWidget({
    required this.data,
    super.key,
    required this.index,
    this.exampleCodeGroup,
    this.moduleTitle,
  });

  final ExampleItem data;
  final int index;
  final String? exampleCodeGroup;
  final String? moduleTitle;

  @override
  State<ExampleItemWidget> createState() => _ExampleItemWidgetState();
}

class _ExampleItemWidgetState extends State<ExampleItemWidget> {
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.data.ignoreCode) {
      child = widget.data.builder(context);
      if (widget.data.center) {
        child = Center(child: widget.data.builder(context));
      }
    } else {
      child = widget.data.builder(context);
      if (widget.data.center) {
        child = Center(child: widget.data.builder(context));
      }
    }

    if (widget.data.padding != null) {
      child = Padding(padding: widget.data.padding!, child: child);
    }

    child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.data.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (widget.data.desc.isNotEmpty)
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              top: widget.index == 0 ? 8 : 24,
              bottom: 16,
            ),
            child: MyText(widget.data.desc),
          ),
        child,
      ],
    );
    return child;
  }
}

extension MyStateExs on State {
  String tdTitle() {
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }
}

extension MyWidgetExs on StatelessWidget {
  String tdTitle(BuildContext context) {
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }
}
