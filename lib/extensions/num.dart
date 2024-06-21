// ignore_for_file: constant_identifier_names, non_constant_identifier_names
part of 'extensions.dart';

extension NumExtension on num {
  String get compact => NumberFormat.compact().format(this);

  String get formatComma => NumberFormat().format(this);

  String toSignificantDigits({int digit = 2}) {
    NumberFormat formatter = NumberFormat('0' * digit);
    return formatter.format(this);
  }

  String get ordinal {
    var specialValue = [11, 12, 13].contains(this % 100);
    if (specialValue) {
      return "${this}th";
    } else if (toString().length == 1) {
      switch (this) {
        case 0:
          return "0";
        case 1:
          return "${this}st";
        case 2:
          return "${this}nd";
        case 3:
          return "${this}rd";
        default:
          return "${this}th";
      }
    } else {
      switch (this % 10) {
        case 1:
          return "${this}st";
        case 2:
          return "${this}nd";
        case 3:
          return "${this}rd";
        default:
          return "${this}th";
      }
    }
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

  String getSizeWithSuffix({required num bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = ["Bytes", "KB", "MB", "GB", "TB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  double getSize({required int bytes, SizeUnit unit = SizeUnit.MB}) {
    if (bytes <= 0) return 0;
    return (bytes / math.pow(1000, unit.id));
  }
}

enum SizeUnit {
  BYTES(0),
  KB(1),
  MB(2),
  GB(3),
  TB(4);

  final int id;
  const SizeUnit(this.id);
}

extension DoubleExtensions on double {
  double roundWithDigit(int digit) {
    final digitValue = math.pow(10, digit);
    return (this * digitValue).roundToDouble() / digitValue;
  }

  double floorWithDigit(int digit) {
    final digitValue = math.pow(10, digit);
    return (this * digitValue).floorToDouble() / digitValue;
  }
}
