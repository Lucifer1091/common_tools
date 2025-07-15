import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color kColorBackgroundDefault = const Color(0xFF454755);

class SwitchButtonItem<T> {
  SwitchButtonItem({this.title, this.content, this.key});

  ValueKey<T>? key;
  String? title;
  Widget? content;
}

class SwitchButtonWidget<T> extends StatefulWidget {
  const SwitchButtonWidget({
    super.key,
    this.onChange,
    this.items,
    this.colorBackground,
  });
  final void Function(SwitchButtonItem<T>)? onChange;
  final List<SwitchButtonItem<T>>? items;
  final Color? colorBackground;

  @override
  SwitchButtonWidgetState<T> createState() => SwitchButtonWidgetState();
}

class SwitchButtonWidgetState<T> extends State<SwitchButtonWidget<T>> {
  Map<int, Widget> _widgetItem = {};
  int? _indexSelect = 0;

  @override
  void initState() {
    super.initState();

    final items = <Widget>[];

    for (final element in widget.items!) {
      items.add(
        Text(element.title!, style: const TextStyle(color: Colors.white)),
      );
    }
    _widgetItem = List<Widget>.from(items).asMap();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 400,
          child: CupertinoSlidingSegmentedControl<int>(
            backgroundColor: widget.colorBackground ?? kColorBackgroundDefault,
            thumbColor: Theme.of(context).colorScheme.secondary,
            children: _widgetItem,
            onValueChanged: (index) {
              setState(() {
                _indexSelect = index;
              });
            },
            groupValue: _indexSelect,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: widget.items![_indexSelect!].content,
        ),
      ],
    );
  }
}
