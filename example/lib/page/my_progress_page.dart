import 'dart:async';

import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class MyProgressPage extends StatefulWidget {
  const MyProgressPage({super.key});

  final examplePadding = const EdgeInsets.symmetric(horizontal: 16);

  @override
  State<StatefulWidget> createState() {
    return _MyProgressPageState();
  }
}

class _MyProgressPageState extends State<MyProgressPage> {
  MyLabelWidget buttonLabel = const MyTextLabel('Start');
  double progressValue = 0.0;
  Timer? _timer;
  bool isProgressing = false;
  bool isPlaying = false;
  double microProgressValue = 0.3;
  Timer? _microTimer;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Used to display the current progress of a task.',
      exampleCodeGroup: 'progress',
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Linear Progress Bar',
              padding: widget.examplePadding,
              builder: _buildRightLabelLinear,
            ),
            ExampleItem(
              desc: 'Percent Internal Display',
              padding: widget.examplePadding,
              builder: _buildInsideLabelLinear,
            ),
            ExampleItem(
              desc: 'Circular Progress Bar',
              padding: widget.examplePadding,
              center: false,
              builder: _buildCircle,
            ),
            ExampleItem(
              desc: 'Miniature Circular Progress Bar',
              padding: widget.examplePadding,
              center: false,
              builder: _buildMicro,
            ),
            ExampleItem(
              desc: 'Button Progress Bar',
              padding: widget.examplePadding,
              builder: _buildButton,
            ),
            ExampleItem(
              desc: 'Miniature Button Progress Bar',
              padding: widget.examplePadding,
              center: false,
              builder: _buildMicroButton,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component State',
          children: [
            ExampleItem(
              desc: 'Linear Progress Bar',
              padding: widget.examplePadding,
              builder: _buildPrimary,
            ),
            ExampleItem(padding: widget.examplePadding, builder: _buildWarning),
            ExampleItem(padding: widget.examplePadding, builder: _buildDanger),
            ExampleItem(padding: widget.examplePadding, builder: _buildSuccess),
            ExampleItem(
              desc: 'Circular Progress Bar',
              padding: widget.examplePadding,
              center: false,
              builder: _buildCirclePrimary,
            ),
            ExampleItem(
              padding: widget.examplePadding,
              center: false,
              builder: _buildCircleWarning,
            ),
            ExampleItem(
              padding: widget.examplePadding,
              center: false,
              builder: _buildCircleDanger,
            ),
            ExampleItem(
              padding: widget.examplePadding,
              center: false,
              builder: _buildCircleSuccess,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightLabelLinear(BuildContext context) {
    return MyProgress(
      type: MyProgressType.linear,
      value: 0.8,
      strokeWidth: 6,
      progressLabelPosition: MyProgressLabelPosition.right,
    );
  }

  Widget _buildInsideLabelLinear(BuildContext context) {
    return MyProgress(type: MyProgressType.linear, value: 0.8);
  }

  Widget _buildCircle(BuildContext context) {
    return MyProgress(type: MyProgressType.circular, value: 0.3);
  }

  Widget _buildMicro(BuildContext context) {
    return MyProgress(type: MyProgressType.micro, value: 0.75);
  }

  Widget _buildButton(BuildContext context) {
    return MyProgress(
      type: MyProgressType.button,
      onTap: _toggleProgress,
      onLongPress: _resetProgress,
      value: progressValue,
      label: buttonLabel,
    );
  }

  Widget _buildMicroButton(BuildContext context) {
    return MyProgress(
      type: MyProgressType.micro,
      value: microProgressValue,
      onTap: _toggleMicroProgress,
      label: MyIconLabel(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildPrimary(BuildContext context) {
    return MyProgress(
      type: MyProgressType.linear,
      progressStatus: MyProgressStatus.primary,
      value: 0.8,
      strokeWidth: 6,
      progressLabelPosition: MyProgressLabelPosition.right,
    );
  }

  Widget _buildWarning(BuildContext context) {
    return MyProgress(
      type: MyProgressType.linear,
      progressStatus: MyProgressStatus.warning,
      value: 0.8,
      strokeWidth: 6,
      progressLabelPosition: MyProgressLabelPosition.right,
    );
  }

  Widget _buildDanger(BuildContext context) {
    return MyProgress(
      type: MyProgressType.linear,
      progressStatus: MyProgressStatus.danger,
      value: 0.8,
      strokeWidth: 6,
      progressLabelPosition: MyProgressLabelPosition.right,
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return MyProgress(
      type: MyProgressType.linear,
      progressStatus: MyProgressStatus.success,
      value: 0.8,
      strokeWidth: 6,
      progressLabelPosition: MyProgressLabelPosition.right,
    );
  }

  Widget _buildCirclePrimary(BuildContext context) {
    return MyProgress(
      type: MyProgressType.circular,
      progressStatus: MyProgressStatus.primary,
      value: 0.3,
    );
  }

  Widget _buildCircleWarning(BuildContext context) {
    return MyProgress(
      type: MyProgressType.circular,
      progressStatus: MyProgressStatus.warning,
      value: 0.3,
    );
  }

  Widget _buildCircleDanger(BuildContext context) {
    return MyProgress(
      type: MyProgressType.circular,
      progressStatus: MyProgressStatus.danger,
      value: 0.3,
    );
  }

  Widget _buildCircleSuccess(BuildContext context) {
    return MyProgress(
      type: MyProgressType.circular,
      progressStatus: MyProgressStatus.success,
      value: 1,
    );
  }

  void _toggleProgress() {
    if (isProgressing) {
      // 暂停进度
      _timer?.cancel();
      setState(() {
        buttonLabel = const MyTextLabel('Continue');
        isProgressing = false;
      });
    } else {
      // 开始或继续进度
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (progressValue < 1.0) {
            progressValue += 0.01;
            buttonLabel = MyTextLabel('${(progressValue * 100).toInt()}%');
          } else {
            _timer?.cancel();
            buttonLabel = const MyTextLabel('Finish');
            isProgressing = false;
          }
        });
      });
      setState(() {
        isProgressing = true;
      });
    }
  }

  void _resetProgress() {
    _timer?.cancel();
    setState(() {
      progressValue = 0.0;
      buttonLabel = const MyTextLabel('Start');
      isProgressing = false;
    });
  }

  void _toggleMicroProgress() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      _microTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (microProgressValue < 1.0) {
            microProgressValue += 0.01;
          } else {
            _microTimer?.cancel();
            isPlaying = false;
            microProgressValue = 0.0;
          }
        });
      });
    } else {
      _microTimer?.cancel();
    }
  }
}
