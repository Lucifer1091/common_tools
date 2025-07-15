import 'dart:async';

import 'package:common_tools/common_tools.dart';
import 'package:common_tools/extensions/iterable/converters.dart';
import 'package:common_tools/extensions/num/converters.dart';
import 'package:common_tools/extensions/num/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  Logger.configure();

  // final DateTime date = DateTime(2024, 6, 30);

  // final List<int> a = [];
  final Iterable<int> iterable = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final int b = 5;
  //
  // // log.f(date.isLastWeek);
  // log.w(date.startOfWeek);
  // log.f(date.startOfLastWeek);

  // log
  //   ..i(20000.toClockFormat(showSeconds: true))
  //   ..e(iterable.chunksOrFill(2, fill: () => 99))
  //   ..d(iterable.associateBy((element) => element))
  //   ..w(iterable.where((element) => element.isEven).toList());

  // final userMap = <String, dynamic>{
  //   'name': 'John',
  //   'age': 30,
  //   'scores': [1, 2, 3],
  // };

  // log.i('User from JSON: ${User.fromJson(userMap).toJson()}');

  log.f(iterable.variance());
}

// class User {
//   User({required this.name, required this.age, required this.scores});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       name: json.getString('name', value: 'Unknown'),
//       age: json.getInt('age', value: 0),
//       scores: json.getList<int>('scores', value: [0]),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'name': name, 'age': age, 'scores': scores};
//   }

//   final String name;
//   final int age;
//   final List<int> scores;
// }
