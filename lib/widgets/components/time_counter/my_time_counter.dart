import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../index.dart';

RegExp _timeReg = RegExp('D+|H+|m+|s+|S+');

String _toDigits(int n, int l) => n.toString().padLeft(l, '0');

String _getMark(String format, String? type) {
  final part = format.split(type ?? '')[1];
  if (part.isEmpty) return '';

  return part.split('')[0];
}

class MyTimeCounter extends StatefulWidget {
  const MyTimeCounter({
    required this.time,
    super.key,
    this.autoStart = true,
    this.content,
    this.format = 'HH:mm:ss',
    this.millisecond = false,
    this.size = MyTimeCounterSize.medium,
    this.splitWithUnit = false,
    this.theme = MyTimeCounterTheme.defaultTheme,
    this.style,
    this.onChange,
    this.onFinish,
    this.direction = MyTimeCounterDirection.down,
    this.controller,
  });

  final bool autoStart;
  final Widget Function(int time)? content;

  /// Time format, DD-day, HH-hour, mm-minute, ss-second, SSS-millisecond
  /// (the separator must be a non-space character with a length of 1)
  final String format;
  final bool millisecond;
  final MyTimeCounterSize size;
  final bool splitWithUnit;
  final MyTimeCounterTheme theme;
  final int time;
  final MyTimeCounterStyle? style;
  final void Function(int time)? onChange;
  final VoidCallback? onFinish;
  final MyTimeCounterDirection direction;
  final MyTimeCounterController? controller;

  @override
  _MyTimeCounterState createState() => _MyTimeCounterState();
}

class _MyTimeCounterState extends State<MyTimeCounter>
    with SingleTickerProviderStateMixin {
  late MyTimeCounterStyle _style;
  late Map<String, String> timeUnitMap;
  Ticker? _ticker;
  int _time = 0;
  int _tempMilliseconds = 0;
  int _maxTime = 0;

  @override
  void initState() {
    super.initState();
    resetTimer(widget.time, false);
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _style =
        widget.style ??
        MyTimeCounterStyle.generateStyle(
          context,
          size: widget.size,
          theme: widget.theme,
          splitWithUnit: widget.splitWithUnit,
        );

    timeUnitMap = {
      'D': 'day',
      'H': 'hour',
      'm': 'minute',
      's': 'second',
      'S': 'millisecond',
    };
  }

  @override
  void didUpdateWidget(MyTimeCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (widget.time != oldWidget.time) {
      resetTimer(widget.time, false);
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void startTimer() {
    if (_ticker?.isActive ?? false) return;

    _tempMilliseconds = 0;
    _ticker ??= createTicker((Duration elapsed) {
      if ((widget.direction == MyTimeCounterDirection.down && _time > 0) ||
          widget.direction == MyTimeCounterDirection.up && _time < _maxTime) {
        setState(() {
          if (widget.direction == MyTimeCounterDirection.down) {
            _time = max(
              _time - (elapsed.inMilliseconds - _tempMilliseconds),
              0,
            );
          } else {
            _time = min(
              _time + (elapsed.inMilliseconds - _tempMilliseconds),
              _maxTime,
            );
          }
        });
        _tempMilliseconds = elapsed.inMilliseconds;
      } else {
        pauseTimer();
        widget.onFinish?.call();
      }
      setState(() {});
    });

    unawaited(_ticker!.start());
  }

  void pauseTimer() {
    _ticker?.stop();
  }

  void resumeTimer() {
    startTimer();
  }

  void resetTimer([int? time, bool update = true]) {
    _ticker?.stop();
    if (widget.direction == MyTimeCounterDirection.down) {
      _time = time ?? widget.time;
    } else {
      _time = 0;
      _maxTime = time ?? widget.time;
    }
    if (update) setState(() {});

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        startTimer();
      });
    }
  }

  void _onControllerChanged() {
    switch (widget.controller?.value) {
      case MyTimeCounterStatus.start:
        startTimer();
      case MyTimeCounterStatus.pause:
        pauseTimer();
      case MyTimeCounterStatus.resume:
        resumeTimer();
      case MyTimeCounterStatus.reset:
        resetTimer(widget.controller?.time);
      case MyTimeCounterStatus.idle:
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content.isFalsy) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildTimeWidget(context),
      );
    }

    return widget.content!.call(_time);
  }

  List<Widget> _buildTimeWidget(BuildContext context) {
    final format =
        widget.millisecond
            ? '${widget.format.replaceAll(RegExp(r':S+$'), '')}:SSS'
            : widget.format;
    final matches = _timeReg.allMatches(format);
    final timeMap = _getTimeMap(matches.map((e) => e.group(0) ?? '').toList());
    return matches
        .map((match) {
          final timeType = match.group(0) ?? '';
          return _buildTextWidget(
            timeMap[timeType] ?? '0',
            widget.splitWithUnit
                ? timeUnitMap[timeType[0]] ?? ''
                : _getMark(format, timeType),
          );
        })
        .expand((element) => element)
        .toList();
  }

  List<Widget> _buildTextWidget(String time, String split) {
    final children = <Widget>[
      Container(
        width: _style.width,
        height: _style.height,
        padding: _style.padding,
        margin: _style.margin,
        decoration: _style.decoration,
        child: Center(
          child: MyText(
            time,
            style: TextStyle(
              fontSize: _style.fontSize,
              height: _style.fontHeight,
              fontWeight: _style.fontWeight,
              color: _style.color,
            ),
          ),
        ),
      ),
    ];
    if (split.isNotEmpty) {
      children.addAll([
        SizedBox(width: _style.space),
        MyText(
          split,
          style: TextStyle(
            fontSize: _style.splitFontSize,
            height: _style.splitFontHeight,
            fontWeight: _style.splitFontWeight,
            color: _style.splitColor,
          ),
        ),
        SizedBox(width: _style.space),
      ]);
    }
    return children;
  }

  Map<String, String> _getTimeMap(List<String> timeType) {
    var duration = Duration(milliseconds: _time);
    final map = <String, String>{};

    final dayKey = timeType.find((item) => item.startsWith('D'));
    final hourKey = timeType.find((item) => item.startsWith('H'));
    final minuteKey = timeType.find((item) => item.startsWith('m'));
    final secondKey = timeType.find((item) => item.startsWith('s'));
    final millisecondKey = timeType.find((item) => item.startsWith('S'));

    if (dayKey != null) {
      final length = dayKey.length;
      map[dayKey] = _toDigits(duration.inDays, length);
      duration = duration - Duration(days: duration.inDays);
    }
    if (hourKey != null) {
      final length = hourKey.length;
      final upNum = length > 2 ? pow(10, length).toInt() : 24;
      final time = duration.inHours.remainder(upNum);
      map[hourKey] = _toDigits(time, length);
      duration = duration - Duration(hours: time);
    }
    if (minuteKey != null) {
      final length = minuteKey.length;
      final upNum = length > 2 ? pow(10, length).toInt() : 60;
      final time = duration.inMinutes.remainder(upNum);
      map[minuteKey] = _toDigits(time, length);
      duration = duration - Duration(minutes: time);
    }
    if (secondKey != null) {
      final length = secondKey.length;
      final upNum = length > 2 ? pow(10, length).toInt() : 60;
      final time = duration.inSeconds.remainder(upNum);
      map[secondKey] = _toDigits(time, length);
      duration = duration - Duration(seconds: time);
    }
    if (millisecondKey != null) {
      final length = millisecondKey.length;
      map[millisecondKey] = _toDigits(duration.inMilliseconds, length);
    }
    return map;
  }
}
