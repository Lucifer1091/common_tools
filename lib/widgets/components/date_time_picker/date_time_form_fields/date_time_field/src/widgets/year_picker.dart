import 'package:flutter/material.dart';

import '../../../../../../../index.dart';

class MyYearPicker extends StatefulWidget {
  const MyYearPicker({
    super.key,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  @override
  State<MyYearPicker> createState() => _MyYearPickerState();
}

class _MyYearPickerState extends State<MyYearPicker> {
  late DateTime selected;

  @override
  void initState() {
    selected = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 400,
          height: 350,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.colorScheme.popover,
            borderRadius: MyBorderRadius.large,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: YearPicker(
                  firstDate: widget.firstDate ?? DateTime(1960),
                  lastDate: widget.lastDate ?? DateTime.now(),
                  selectedDate: selected,
                  onChanged: (val) {
                    setState(() {
                      selected = val;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildButton(
                      'Cancel',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Gap(8),
                    buildButton(
                      'Ok',
                      onTap: () {
                        Navigator.of(context).pop(selected);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, {VoidCallback? onTap}) {
    return TextButton(onPressed: onTap, child: Text(text));
  }
}
