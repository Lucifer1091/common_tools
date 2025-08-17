import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import 'example_base.dart';

var navBarkey = GlobalKey();

/// 示例页面控件，建议每个页面返回一个ExampleWidget即可，不用独自封装
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
  }) : assert(
         children.length > 0 || (showSingleChild && singleChild != null),
         'children or singleChild must have at least one',
       );

  /// 标题
  final String title;

  /// 如果封装的children无法满足需求，可以自定义子控件
  final bool showSingleChild;

  /// 自定义的自控件，只有showSingleChild为true才会展示。CodeWrapper的builder构建真正的试图
  final WidgetBuilder? singleChild;

  /// 示例组件模块列表
  final List<ExampleModule> children;

  /// 描述，showSingleChild为false会展示
  final String desc;

  /// 填充
  final EdgeInsetsGeometry? padding;

  /// 背景颜色
  final Color? backgroundColor;

  /// 示例代码路径
  final String exampleCodeGroup;

  /// 测试组件列表
  final List<ExampleItem> test;

  /// 滚动控制组件
  final ScrollController? scrollController;

  /// 悬浮按钮
  final Widget? floatingActionButton;

  /// 悬浮按钮
  final GlobalKey? navBarKey;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late List<ExampleModule> list;
  bool apiVisible = false;
  ExamplePageModel? model;
  bool showAction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var modelTheme = context
          .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
      model = modelTheme?.model;
      model?.codePath = widget.exampleCodeGroup;
      model?.apiVisible = apiVisible;
      setState(() {
        showAction = model?.showAction ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      backgroundColor: widget.backgroundColor ?? ThemeColors.neutral.shade50,
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          trackVisibility: MaterialStateProperty.all(true),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: widget.showSingleChild && widget.singleChild != null
                  ? _singleChild()
                  : MediaQuery(
                      // 去掉底部安全区域,保证示例展示正常
                      data: MediaQuery.of(
                        context,
                      ).copyWith(padding: EdgeInsets.zero),
                      child: ListView.builder(
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
                            return Container();
                          }
                          ExampleModule data;
                          if (index <= widget.children.length) {
                            data = widget.children[index - 1];
                          } else {
                            data = ExampleModule(
                              title: '单元测试',
                              children: [
                                _buildTestExampleItem(),
                                ...widget.test,
                              ],
                            );
                          }
                          return _buildModule(index, data, context);
                        },
                      ),
                    ),
            ),
          ],
        ),
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
            bottom: 0,
            child: Column(
              children: [
                TDButton(
                  text: '返回首页',
                  type: TDButtonType.fill,
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
    desc: '''未在示例稿中体现，但有必要验证的组件样式，请添加到'test'参数中。以下情景必须有测试：
  1.参数为数字。需测试数字为负数、0、较大数值的场景。
  2.参数为枚举，需测试所有枚举组合（示例已有的可不写）''',
    builder: (_) => const TDDivider(),
  );

  Widget _buildHeader(BuildContext context) {
    if (widget.showSingleChild) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDText(widget.title),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: TDText(widget.desc),
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
          child: TDText(
            '${index < 10 ? "0$index" : index} ${data.title}',
            fontWeight: FontWeight.bold,
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

/// 示例模块
class ExampleModule {
  const ExampleModule({Key? key, required this.title, required this.children});

  final String title;

  final List<ExampleItem> children;
}

/// 示例样例数据
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

/// 组件示例
class ExampleItemInherited extends InheritedWidget {
  const ExampleItemInherited({
    required this.path,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final String path;

  @override
  bool updateShouldNotify(covariant ExampleItemInherited oldWidget) {
    return path != oldWidget.path;
  }
}

/// 组件示例
class ExampleItemWidget extends StatefulWidget {
  const ExampleItemWidget({
    required this.data,
    Key? key,
    required this.index,
    this.exampleCodeGroup,
    this.moduleTitle,
  }) : super(key: key);

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
      child = Placeholder();
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
        widget.data.desc.isEmpty
            ? Container()
            : Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: widget.index == 0 ? 8 : 24,
                  bottom: 16,
                ),
                child: TDText(widget.data.desc),
              ),
        child,
      ],
    );
    return child;
  }
}

/// State获取标题的扩展
extension TDStateExs on State {
  String tdTitle() {
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }
}

/// StatelessWidget获取标题的扩展
extension TDWidgetExs on StatelessWidget {
  String tdTitle(BuildContext context) {
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }
}
