part of 'extensions.dart';

extension NumExtension on num {
  String get compact => NumberFormat.compact().format(this);

  String get formatComma => NumberFormat().format(this);

  String toSignificantDigits({int digit = 2}) {
    NumberFormat formatter = NumberFormat('0' * digit);
    return formatter.format(this);
  }

  String toClockFormat({bool showSeconds = false}) {
    int h, m, s;

    h = this ~/ 3600;

    m = ((this - h * 3600)) ~/ 60;

    s = toInt() - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

    String result;
    if (showSeconds) {
      result = "$hourLeft:$minuteLeft:$secondsLeft";
    } else {
      result = "$hourLeft:$minuteLeft";
    }

    return result;
  }

  String getTimeFormatFromDouble() {
    if (this < 0) return '00:00';
    int flooredValue = floor();
    num decimalValue = this - flooredValue;
    String hourValue = flooredValue.toString();
    String minuteString = _getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getTimeStringFromDouble() {
    if (this < 0) return '00:00';
    int flooredValue = floor();
    num decimalValue = this - flooredValue;
    String hourValue = _getHourString(flooredValue);
    String minuteString = _getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String _getMinuteString(num decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String _getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }
}

extension DoubleExtensions on double {
  double roundWithDigit(int digit) {
    final digitValue = pow(10, digit);
    return (this * digitValue).roundToDouble() / digitValue;
  }

  double floorWithDigit(int digit) {
    final digitValue = pow(10, digit);
    return (this * digitValue).floorToDouble() / digitValue;
  }
}
