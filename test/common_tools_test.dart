import 'package:common_tools/index.dart';

void main() {
  print(MyDate.now().dayOfYear);

  var now = MyDate.now(); // Get the date of January 1st of the current year
  final DateTime jan1st = DateTime(now.year);

  // Calculate the difference in days between the current date and January 1st
  final int difference = now.difference(jan1st).inDays + 1;

  print('diff ${difference}');
}
