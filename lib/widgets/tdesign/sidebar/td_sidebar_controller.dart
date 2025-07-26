import 'package:flutter/material.dart';

import 'td_sidebar.dart';

class TDSideBarController extends ChangeNotifier {
  int currentValue = 0;
  List<SideItemProps> children = [];
  bool loading = false;

  void selectTo(int value) {
    currentValue = value;
    notifyListeners();
  }

  void init(List<SideItemProps> data) {
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
