import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import 'base/example_route.dart';
import 'config.dart';
import 'localizations/app_localizations.dart';

var _kShowTodoComponent = false;

typedef OnThemeChange = Function(MyThemeData themeData);

typedef OnLocaleChange = Function(Locale locale);

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    this.onThemeChange,
    this.locale,
    this.onLocaleChange,
  });

  final String title;

  final OnThemeChange? onThemeChange;

  final OnLocaleChange? onLocaleChange;

  final Locale? locale;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool useConch = false;
  String searchText = '';
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    TDExampleRoute.init();
    sideBarExamplePage.forEach(TDExampleRoute.add);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        backgroundColor: context.colorScheme.primary,
        titleTextStyle: context.textTheme.titleLarge,
        title: Text(widget.title),
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: TDText(
                widget.locale?.languageCode == 'en' ? '中文' : 'English',
                textColor: context.colorScheme.primaryForeground,
              ),
            ),
            onTap: () {
              if (widget.locale?.languageCode == 'en') {
                widget.onLocaleChange?.call(const Locale('zh'));
              } else {
                widget.onLocaleChange?.call(const Locale('en'));
              }
            },
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: TDText(
                AppLocalizations.of(context)?.about,
                textColor: context.colorScheme.primaryForeground,
              ),
            ),
            onTap: () {
              focusNode.unfocus();
              Navigator.pushNamed(context, TDExampleRoute.aboutPath);
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildChildren(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    var children = <Widget>[];

    children.add(
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 4),
                  child: MyTheme(
                    data: MyThemeData.defaults(),
                    child: TDButton(
                      text: AppLocalizations.of(context)?.defaultTheme,
                      theme: TDButtonTheme.primary,
                      onTap: () {
                        widget.onThemeChange?.call(MyThemeData.defaults());
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: MyTheme(
                    data: MyThemeData(colorScheme: MyGreenColorScheme.light()),
                    child: TDButton(
                      text: AppLocalizations.of(context)?.greenTheme,
                      theme: TDButtonTheme.primary,
                      onTap: () async {
                        var newData = MyThemeData(
                          colorScheme: MyGreenColorScheme.light(),
                        );
                        widget.onThemeChange?.call(newData);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: MyTheme(
                    data: MyThemeData(colorScheme: MyRedColorScheme.light()),
                    child: TDButton(
                      text: AppLocalizations.of(context)?.redTheme,
                      theme: TDButtonTheme.danger,
                      onTap: () async {
                        var newData = MyThemeData(
                          colorScheme: MyRedColorScheme.light(),
                        );
                        widget.onThemeChange?.call(newData);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // children.add(
    //   TDSearchBar(
    //     placeHolder: '请输入组件名称',
    //     focusNode: focusNode,
    //     onTextChanged: (value) {
    //       setState(() {
    //         searchText = value;
    //       });
    //     },
    //   ),
    // );

    exampleMap.forEach((key, value) {
      var subList = <Widget>[];
      for (var model in value) {
        if (searchText.isNotEmpty &&
            !model.text.toLowerCase().contains(searchText.toLowerCase())) {
          continue;
        }
        if (model.isTodo) {
          if (_kShowTodoComponent) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 8,
                  bottom: 8,
                ),
                child: TDButton(
                  size: TDButtonSize.medium,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.filled,
                  theme: TDButtonTheme.defaults,
                  textStyle: TextStyle(color: ThemeColors.neutral.shade400),
                  onTap: () {
                    Navigator.pushNamed(context, '${model.name}?showAction=1');
                  },
                  text: model.text,
                ),
              ),
            );
          }
        } else {
          subList.add(
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 8,
                bottom: 8,
              ),
              child: TDButton(
                size: TDButtonSize.medium,
                type: TDButtonType.outline,
                shape: TDButtonShape.filled,
                theme: TDButtonTheme.primary,
                onTap: () {
                  focusNode.unfocus();
                  Navigator.pushNamed(context, '${model.name}?showAction=1');
                },
                text: model.text,
              ),
            ),
          );
        }
      }
      children.add(
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(MyRadius.large),
            ),
          ),
          child: TDText(
            '$key(${subList.length})',
            textColor: context.colorScheme.primaryForeground,
          ),
        ),
      );
      children.addAll(subList);
    });
    return children;
  }
}
