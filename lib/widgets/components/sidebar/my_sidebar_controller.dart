import 'package:flutter/material.dart';

import 'my_sidebar.dart';

class MySideBarController extends ChangeNotifier {
  int currentValue = 0;
  List<MySideItemProps> children = [];
  bool loading = false;

  void selectTo(int value) {
    currentValue = value;
    notifyListeners();
  }

  void init(List<MySideItemProps> data) {
    closeLoading(false, needNotify: false);
    children = data;
    notifyListeners();
  }

  void closeLoading(bool load, {bool needNotify = true}) {
    loading = load;

    if (needNotify) notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    currentValue = 0;
  }
}
