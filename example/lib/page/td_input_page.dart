import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../../base/example_widget.dart';

import 'dart:async';

class TDInputViewPage extends StatefulWidget {
  const TDInputViewPage({Key? key}) : super(key: key);

  @override
  _TDInputViewPageState createState() => _TDInputViewPageState();
}

class _TDInputViewPageState extends State<TDInputViewPage> {
  String inputText = '请输入...';
  var controller = [];
  var browseOn = false;
  var confirmText = '发送验证码';
  var countDownText = '重发';
  Timer? _timer;
  int _countdownTime = 0;

  @override
  void initState() {
    for (var i = 0; i < 28; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);
    var callback = (timer) => {
      setState(() {
        if (_countdownTime < 1) {
          _timer?.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      }),
    };
    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  Widget build(BuildContext context) {
    var childBuilder = (context) {
      return ExamplePage(
        backgroundColor: const Color(0xFFF0F2F5),
        title: tdTitle(),
        desc: '用于在预设的一组选项中执行单项选择，并呈现选择结果。',
        exampleCodeGroup: 'input',
        children: [],
      );
    };
    return childBuilder.call(context);
  }
}
