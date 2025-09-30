import 'package:flutter/cupertino.dart';

import '../../../index.dart';

typedef OnGroupChange = void Function(List<String> checkedIds);

class MyCheckboxGroupController {
  MyCheckboxGroupState? _state;

  void toggleAll(bool check) {
    _state?.toggleAll(check);
  }

  void reverseAll() {
    _state?._reverseAll();
  }

  void toggle(String id, bool? check) {
    _state?.toggle(id, check, true);
  }

  bool? state(int total) {
    final list = allChecked();

    final length = list.length - (checked('index:0') ? 1 : 0);
    final allCheck = total - 1 == length;

    if (list.isEmpty) return false;

    if (allCheck) return true;

    return null;
  }

  List<String> allChecked() {
    return MapScrewdriver(
      _state?.checkBoxStates ?? <String, bool?>{},
    ).where((k, v) => v ?? false).keys.toList();
  }

  bool hasUnchecked(int total) {
    final list = allChecked();
    return list.length != total;
  }

  bool checked(String id) {
    final list = allChecked();
    return list.contains(id);
  }
}

///
/// CheckBox group, you can use a controller to control the selection state of multiple CheckBoxes within the group.
///
/// The child property can be any container component that contains a TDCheckBox. For example:
/// ```dart
/// MyCheckboxGroup(
///   child: Row(
///     children: [
///       MyCheckBox(),
///       Column(
///         children: [
///           MyCheckBox()
///           ...
///         ]
///       )
///       ...
///     ]
///   )
/// )
/// ```
///
///
class MyCheckboxGroup extends StatefulWidget {
  const MyCheckboxGroup({
    required this.child,
    super.key,
    this.onChangeGroup,
    this.controller,
    this.checkedIds,
    this.maxChecked,
    this.titleMaxLine,
    this.customContentBuilder,
    this.contentDirection,
    this.shape,
    this.spacing,
    this.customIconBuilder,
    this.onOverloadChecked,
  });

  ///
  /// It can be any container containing MyCheckbox, for example:
  /// ```dart
  /// Row(
  ///   children: [
  ///     MyCheckBox(),
  ///     MyCheckBox(),
  ///     ...
  ///   ]
  /// )
  /// ```
  ///
  final Widget child;

  final OnGroupChange? onChangeGroup;

  final MyCheckboxGroupController? controller;

  final int? maxChecked;

  final List<String>? checkedIds;

  final VoidCallback? onOverloadChecked;

  final int? titleMaxLine;

  final ContentBuilder? customContentBuilder;

  final double? spacing;

  final MyCheckboxShape? shape;

  final MyContentDirection? contentDirection;

  final IconBuilder? customIconBuilder;

  @override
  State<StatefulWidget> createState() {
    return MyCheckboxGroupState();
  }
}

class MyCheckboxGroupState extends State<MyCheckboxGroup> {
  ///
  /// Manage the status of all child CheckBoxes
  ///
  Map<String, bool?> checkBoxStates = {};

  @override
  void initState() {
    super.initState();
    // If there is a controller, set the state to the controller
    widget.controller?._state = this;

    _syncCheckState(widget.checkedIds);
  }

  /// Synchronize the default selected id configured in the group to the status
  void _syncCheckState(List<String>? checkIds) {
    checkBoxStates.clear();
    checkIds?.forEach((element) {
      checkBoxStates[element] = true;
    });
  }

  @override
  void didUpdateWidget(MyCheckboxGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCheckIds = oldWidget.checkedIds;
    final newCheckIds = widget.checkedIds;
    if (oldCheckIds != newCheckIds) {
      _syncCheckState(newCheckIds);
    }
  }

  ///
  /// Get the check status of a CheckBox based on its ID
  ///
  ///
  bool? getCheckBoxStateById(String id, bool? checked) {
    if (!checkBoxStates.containsKey(id)) checkBoxStates[id] = checked;

    return checkBoxStates[id];
  }

  /// Check a single Checkbox
  bool toggle(String id, bool? check, [bool notify = false]) {
    // Check whether the maximum number of check boxes set by the user is exceeded
    if (widget.maxChecked != null && (check ?? false)) {
      if (checkBoxStates.count((k, v) => v ?? false) >= widget.maxChecked!) {
        widget.onOverloadChecked?.call();
        return false;
      }
    }

    checkBoxStates[id] = check;

    if (notify) setState(() {});

    _notifyChange();

    return true;
  }

  /// Toggle all CheckBox
  void toggleAll(bool check, [bool notify = true]) {
    var isChanged = false;
    checkBoxStates.forEachCanBreak((k, v) {
      if (check) {
        // Check failed, exit the loop
        if (!toggle(k, check)) return true;
      } else {
        toggle(k, check);
      }
      isChanged = true;
      return false;
    });

    if (isChanged && notify) {
      setState(() {});
      _notifyChange();
    }
  }

  /// Invert selection
  void _reverseAll() {
    final reverseValue = checkBoxStates.map(
      (key, value) => MapEntry(key, !(value ?? false)),
    );
    checkBoxStates
      ..forEach((key, value) {
        checkBoxStates[key] = false;
      })
      ..forEach((k, v) {
        final check = reverseValue[k] ?? false;
        toggle(k, check);
      });

    setState(() {});
    _notifyChange();
  }

  void _notifyChange() {
    final change = widget.onChangeGroup;
    if (change != null) {
      final checkedIds =
          MapScrewdriver(
            checkBoxStates,
          ).where((k, v) => v ?? false).keys.toList();
      change.call(checkedIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyCheckboxGroupInherited(this, widget.child);
  }
}

class MyCheckboxGroupInherited extends InheritedWidget {
  const MyCheckboxGroupInherited(this.state, Widget child, {super.key})
    : super(child: child);

  final MyCheckboxGroupState state;

  ///
  /// Get the Group node on the tree
  ///
  static MyCheckboxGroupInherited? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MyCheckboxGroupInherited>();
  }

  @override
  bool updateShouldNotify(covariant MyCheckboxGroupInherited oldWidget) {
    return true;
  }
}

class MyCheckboxGroupContainer extends MyCheckboxGroup {
  MyCheckboxGroupContainer({
    super.key,
    Widget? child, // If you use child, do not set direction
    Axis? direction, // direction works on directional MyRadios
    List<MyCheckbox>? directionalTdCheckboxes,
    List<String>? selectIds, // Default selection id group
    bool?
    passThrough, // Non-full-bar radio selection style for use with child or direction == Axis.vertical scenarios
    bool cardMode = false,
    super.titleMaxLine,
    int? maxSelected,
    // Maximum number of checkboxes
    super.shape,
    super.controller,
    super.customIconBuilder,
    super.customContentBuilder,
    super.spacing, // The distance between icon and text
    super.contentDirection,
    OnCheckBoxGroupChange? onCheckBoxGroupChange,
    super.onOverloadChecked,
  }) : assert(() {
         // If you use the direction attribute, you must use directional MyCheckboxes, and the child field is invalid.
         if (direction != null && directionalTdCheckboxes == null) {
           throw FlutterError(
             '[MyCheckboxGroupContainer] direction and directionalTdCheckboxes must set at the same time',
           );
         }
         // If direction is not used, child must be set
         if (direction == null && child == null) {
           throw FlutterError(
             '[MyCheckboxGroupContainer] direction means use child as the exact one, but child is null',
           );
         }
         if (direction == Axis.horizontal && directionalTdCheckboxes != null) {
           for (final element in directionalTdCheckboxes) {
             if (element.subTitle != null) {
               throw FlutterError(
                 'horizontal checkbox style should not have subTilte, '
                 'because there left no room for it',
               );
             }
           }
         }
         // Card mode requires that each MyRadio must set the cardMode property to true and cannot have a subtitle (insufficient space)
         if (cardMode) {
           assert(direction != null && directionalTdCheckboxes != null, '');
           for (final element in directionalTdCheckboxes!) {
             // if use cardMode at MyRadioGroup, then every MyRadio should
             // set it's own carMode to true.
             if (!element.cardMode) {
               throw FlutterError(
                 'if use cardMode at MyCheckboxGroupContainer, then every '
                 "TDCheckbox should set it's own carMode to true.",
               );
             }
             if (element.subTitle != null && direction == Axis.horizontal) {
               throw FlutterError(
                 'horizontal card style should not have subTilte, '
                 'because there left no room for it',
               );
             }
           }
         }
         return true;
       }(), ''),
       super(
         child: Container(
           clipBehavior:
               (passThrough ?? false) && direction != Axis.horizontal
                   ? Clip.hardEdge
                   : Clip.none,
           decoration:
               (passThrough ?? false) && direction != Axis.horizontal
                   ? BoxDecoration(borderRadius: BorderRadius.circular(10))
                   : null,
           margin:
               (passThrough ?? false) && direction != Axis.horizontal
                   ? const EdgeInsets.symmetric(horizontal: 16)
                   : null,
           child:
               direction == null
                   ? child!
                   : (direction == Axis.vertical
                       ? ListView.separated(
                         padding: EdgeInsets.zero,
                         shrinkWrap: true,
                         physics: const NeverScrollableScrollPhysics(),
                         itemBuilder: (BuildContext context, int index) {
                           return Container(
                             margin:
                                 cardMode
                                     ? const EdgeInsets.symmetric(
                                       horizontal: 16,
                                     )
                                     : null,
                             height: cardMode ? 82 : null,
                             child: directionalTdCheckboxes[index],
                           );
                         },
                         itemCount: directionalTdCheckboxes!.length,
                         separatorBuilder: (BuildContext context, int index) {
                           if (cardMode) {
                             return const SizedBox(height: 12);
                           }
                           return const SizedBox.shrink();
                         },
                       )
                       : Container(
                         margin:
                             cardMode
                                 ? EdgeInsets.symmetric(horizontal: 16)
                                 : null,
                         alignment: cardMode ? Alignment.topLeft : null,
                         child:
                             cardMode
                                 ? Wrap(
                                   spacing: 12,
                                   runSpacing: 12,
                                   runAlignment: WrapAlignment.spaceEvenly,
                                   children:
                                       directionalTdCheckboxes!.map((element) {
                                         return SizedBox(
                                           width: 106.3,
                                           height: 56,
                                           child: element,
                                         );
                                       }).toList(),
                                 )
                                 : Row(
                                   mainAxisSize: MainAxisSize.min,
                                   children:
                                       directionalTdCheckboxes!
                                           .map((e) => Expanded(child: e))
                                           .toList(),
                                 ),
                       )),
         ),
         onChangeGroup: (ids) {
           selectIds = ids;
           onCheckBoxGroupChange?.call(ids);
         },
         checkedIds: selectIds,
         maxChecked: maxSelected,
       );

  @override
  State<StatefulWidget> createState() {
    return MyCheckboxGroupContainerState();
  }
}

class MyCheckboxGroupContainerState extends MyCheckboxGroupState {}

typedef OnCheckBoxGroupChange = void Function(List<String> ids);
