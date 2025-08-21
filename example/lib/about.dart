import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:common_tools/index.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? version;

  String? publishTime;

  @override
  void initState() {
    super.initState();
    _getVersion();
    _getPublishTime();
  }

  Future<void> _getVersion() async {
    version = await rootBundle.loadString('assets/version');
    setState(() {});
  }

  Future<void> _getPublishTime() async {
    var timeStamp = await rootBundle.loadString('assets/publish_time');
    var exactTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(timeStamp.trim()),
    );
    publishTime = '${exactTime.year}-${exactTime.month}-${exactTime.day}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.neutral.shade50,
      appBar: AppBar(
        title: MyText('关于我们', textColor: context.colorScheme.primaryForeground),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            demoRow(context, '版本号：', desc: version),
            demoRow(context, '发版日期：', desc: publishTime),
          ],
        ),
      ),
    );
  }

  Widget demoRow(
    BuildContext context,
    String? title, {
    String? desc,
    bool on = true,
    bool enable = true,
    Color? onColor,
    Color? offColor,
  }) {
    Widget current = Row(
      children: [
        Expanded(child: MyText(title, textColor: ThemeColors.neutral.shade900)),
        MyText(desc ?? '', textColor: ThemeColors.neutral.shade500),
      ],
    );
    current = Container(
      color: context.colorScheme.primaryForeground,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1, top: 1),
      height: 44,
      child: current,
    );
    return current;
  }
}
