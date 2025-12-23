import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyTableColFixed { left, right, none }

enum MyTableColAlign { left, center, right }

typedef OnCellTap = void Function(int rowIndex, Json? row, MyTableColumn col);
typedef OnScroll = void Function(ScrollController controller);
typedef OnSelect = void Function(List<dynamic>? data);
typedef OnRowSelect = void Function(int index, bool checked);
typedef SelectableFunc = bool Function(int index, Json? row);
typedef RowCheckFunc = bool Function(int index, Json row);

class MyTableColumn {
  MyTableColumn({
    this.title,
    this.colKey,
    this.width,
    this.fixed = MyTableColFixed.none,
    this.ellipsis,
    this.ellipsisTitle,
    this.cellBuilder,
    this.align = MyTableColAlign.left,
    this.sortable = false,
    this.selection,
    this.selectable,
    this.checked,
  });

  /// Whether to display a checkbox in the row, invalid when customizing columns
  bool? selection;
  String? title;
  String? colKey;
  double? width;
  MyTableColFixed? fixed;
  bool? ellipsis;
  bool? ellipsisTitle;
  IndexedWidgetBuilder? cellBuilder;
  MyTableColAlign? align;
  bool? sortable;

  /// Whether the CheckBox of the current row is selectable, only selection: true is valid
  SelectableFunc? selectable;

  /// Is the current row selected ?
  RowCheckFunc? checked;

  double? get widthPx => width;
}

class MyTableEmpty {
  MyTableEmpty({this.assetUrl, this.text});

  String? assetUrl;
  String? text;
}

class MyTable extends StatefulWidget {
  const MyTable({
    required this.columns,
    super.key,
    this.bordered,
    this.data,
    this.empty,
    this.height,
    this.rowHeight,
    this.loading = false,
    this.loadingWidget,
    this.showHeader = true,
    this.stripe = false,
    this.backgroundColor,
    this.width,
    this.defaultSort,
    this.onCellTap,
    this.onScroll,
    this.onSelect,
    this.onRowSelect,
  });

  final bool? bordered;
  final List<MyTableColumn> columns;
  final List<Json>? data;
  final MyTableEmpty? empty;
  final double? height;
  final double? rowHeight;
  final bool? loading;
  final Widget? loadingWidget;
  final bool? showHeader;
  final bool? stripe;
  final Color? backgroundColor;
  final double? width;
  final String? defaultSort;
  final OnCellTap? onCellTap;
  final OnScroll? onScroll;
  final OnSelect? onSelect;
  final OnRowSelect? onRowSelect;

  @override
  State<MyTable> createState() => MyTableState();
}

class MyTableState extends State<MyTable> {
  bool? _sortable;
  String? _sortKey;
  int _hasChecked = 0;
  int _totalSelectable = 0;
  late MyTableColumn _selectableCol;
  late List<bool> _checkedList;
  final _scrollController = ScrollController();

  Alignment _getVerticalAlign(MyTableColAlign x) {
    var xPos = 0.0;
    switch (x) {
      case MyTableColAlign.left:
        xPos = -1;
      case MyTableColAlign.center:
        xPos = 0;
      case MyTableColAlign.right:
        xPos = 1;
    }
    return Alignment(xPos, 0);
  }

  List<MyTableColumn> _getCol(MyTableColFixed fixed) {
    return widget.columns.where((col) => col.fixed == fixed).toList();
  }

  Widget _getTableHeader(BuildContext context) {
    final fixedLeftCol = _getCol(MyTableColFixed.left);
    final fixedNonCol = _getCol(MyTableColFixed.none);
    final fixedRightCol = _getCol(MyTableColFixed.right);
    var start = 0;
    final fixedLeftCells = <Widget>[],
        cells = <Widget>[],
        fixedRightCells = <Widget>[];

    for (var i = 0; i < fixedLeftCol.length; i++) {
      final cell = _getCell(fixedLeftCol[i], true, null, start, i == 0);
      if (fixedLeftCol[i].width != null) {
        fixedLeftCells.add(SizedBox(width: fixedLeftCol[i].width, child: cell));
      } else {
        fixedLeftCells.add(Expanded(child: cell));
      }
      start++;
    }

    start = fixedLeftCol.length;

    for (var i = 0; i < fixedNonCol.length; i++) {
      final cell = _getCell(fixedNonCol[i], true, null, start, i == 0);
      if (fixedNonCol[i].width != null) {
        cells.add(SizedBox(width: fixedNonCol[i].width, child: cell));
      } else {
        cells.add(Expanded(child: cell));
      }
      start++;
    }

    for (var i = 0; i < fixedRightCol.length; i++) {
      final cell = _getCell(fixedRightCol[i], true, null, start, i == 0);
      if (fixedRightCol[i].width != null) {
        fixedRightCells.add(
          SizedBox(width: fixedRightCol[i].width, child: cell),
        );
      } else {
        fixedRightCells.add(Expanded(child: cell));
      }
      start++;
    }

    return Row(children: [...fixedLeftCells, ...cells, ...fixedRightCells]);
  }

  Widget _getTableContent(BuildContext context) {
    if (widget.loading ?? false) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: widget.loadingWidget ?? const MyLoader(),
        ),
      );
    }

    if (widget.data == null || widget.data!.isEmpty) {
      return _getEmpty('No data yet.');
    }

    final cells = <Widget>[];
    final fixedLeftCol = _getCol(MyTableColFixed.left);
    final fixedNonCol = _getCol(MyTableColFixed.none);
    final fixedRightCol = _getCol(MyTableColFixed.right);
    final headerCol = [...fixedLeftCol, ...fixedNonCol, ...fixedRightCol];
    for (var i = 0; i < widget.data!.length; i++) {
      final data = widget.data![i];
      final row = <Widget>[];
      for (var j = 0; j < headerCol.length; j++) {
        final cell = _getCell(
          headerCol[j],
          false,
          data,
          i,
          j == (fixedLeftCol.length - 1) ||
              j == (fixedLeftCol.length + fixedNonCol.length),
        );
        if (headerCol[j].width != null) {
          row.add(SizedBox(width: headerCol[j].width, child: cell));
        } else {
          row.add(Expanded(child: cell));
        }
      }

      cells.add(
        ColoredBox(
          color:
              (widget.stripe ?? false) && i.isEven
                  ? const Color(0xffF3F3F3)
                  : context.colorScheme.background,
          child: Row(children: row),
        ),
      );
    }
    return Column(children: cells);
  }

  Widget _getCell(
    MyTableColumn col,
    bool isHeader,
    data,
    int index,
    bool fixedBorder,
  ) {
    final String title =
        isHeader
            ? (col.title ?? '')
            : ((data as Map?)?[col.colKey]?.toString() ?? '');
    final ellipsis = (isHeader ? col.ellipsisTitle : col.ellipsis) ?? false;
    final sortable = col.sortable ?? false;

    final halfBorder = const BorderSide(width: 0.5, color: Color(0xffE7E7E7));
    final doubleBorder = const BorderSide(width: 2, color: Color(0xffE7E7E7));

    var topBorder = BorderSide.none,
        rightBorder = BorderSide.none,
        leftBorder = BorderSide.none;

    final bottomBorder = halfBorder;
    if (widget.bordered ?? false) {
      rightBorder = halfBorder;
    }
    if (fixedBorder && col.fixed == MyTableColFixed.left) {
      rightBorder = doubleBorder;
    }
    if (fixedBorder && col.fixed == MyTableColFixed.right) {
      leftBorder = doubleBorder;
    }

    final text = _getCellText(col, title, ellipsis, isHeader, sortable, index);
    var content = text;

    if ((col.selection ?? false) && col.cellBuilder == null) {
      final enable = col.selectable?.call(index, widget.data?[index]) ?? true;

      var checkBox = MyCheckbox(
        id: 'index:$index',
        checked: _checkedList[index],
        enabled: enable,
        customIconBuilder: (context, checked) {
          if (checked ?? false) {
            return Icon(
              Icons.check_box_rounded,
              size: 16,
              color: context.colorScheme.primary,
            );
          }
          return Icon(
            Icons.check_box_outline_blank_rounded,
            size: 16,
            color:
                enable
                    ? ThemeColors.neutral.shade900
                    : ThemeColors.neutral.shade700,
          );
        },
        onChanged: (checked) {
          setState(() {
            _checkedList[index] = checked ?? false;
            if (checked ?? false) {
              _hasChecked += 1;
            } else {
              _hasChecked -= 1;
            }
            final selectList = <Json>[];
            for (var i = 0; i < _checkedList.length; i++) {
              if (_checkedList[i]) {
                selectList.add(widget.data![i]);
              }
            }
            widget.onSelect?.call(selectList);
            widget.onRowSelect?.call(index, checked ?? false);
            print('!!!!::::$_hasChecked');
          });
        },
      );

      if (isHeader) {
        checkBox = MyCheckbox(
          id: 'header',
          checked: _hasChecked == _totalSelectable,
          customIconBuilder: (context, checked) {
            if (_hasChecked == 0) {
              return Icon(
                Icons.check_box_outline_blank_rounded,
                size: 16,
                color: ThemeColors.neutral.shade700,
              );
            }
            final allCheck = _hasChecked >= _totalSelectable;
            final halfSelected =
                _hasChecked > 0 && _hasChecked < widget.data!.length;
            return getAllIcon(allCheck, halfSelected);
          },
          onChanged: (checked) {
            setState(() {
              _hasChecked = checked ?? false ? _totalSelectable : 0;
              for (var i = 0; i < widget.data!.length; i++) {
                _checkedList[i] = checked ?? false;
                // Unselect rows where selectable == false
                if (_selectableCol.selectable!(i, widget.data![i])) {
                  _checkedList[i] = checked ?? false;
                }
              }
              widget.onSelect?.call(checked ?? false ? widget.data : []);
            });
          },
        );
      }

      content = Row(children: [checkBox, text]);
    }

    final cell = GestureDetector(
      onTap: () {
        if (!isHeader) widget.onCellTap?.call(index, data as Json, col);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: topBorder,
            right: rightBorder,
            bottom: bottomBorder,
            left: leftBorder,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SizedBox(
            height: widget.rowHeight ?? 22,
            child: Align(
              alignment: _getVerticalAlign(col.align!),
              child: content,
            ),
          ),
        ),
      ),
    );

    return cell;
  }

  Widget _getCellText(
    MyTableColumn col,
    String title,
    bool ellipsis,
    bool isHeader,
    bool sortable,
    int index,
  ) {
    final overflow = ellipsis ? TextOverflow.ellipsis : TextOverflow.visible;
    final titleWidget = MyText(
      title,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color:
            isHeader
                ? ThemeColors.neutral.shade700
                : ThemeColors.neutral.shade900,
        fontSize: 14,
        height: 1,
        letterSpacing: 0,
      ),
    );

    if (isHeader) {
      final selectColor = context.colorScheme.primary;
      final unSelectColor = context.colorScheme.foreground.withValues(
        alpha: 0.5,
      );
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget,
          Visibility(
            visible: isHeader && sortable,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: MyGestureDetector(
                onTap: () {
                  setState(() {
                    if (_sortKey != col.colKey) {
                      _sortable = true;
                    } else {
                      if (_sortable == false) {
                        _sortable = null;
                      } else {
                        _sortable = !(_sortable ?? false);
                      }
                    }
                    _sortKey = col.colKey;
                    widget.data?.sort((a, b) {
                      final aValue = a[col.colKey];
                      final bValue = b[col.colKey];
                      if (_sortable == false) {
                        if (bValue is Comparable && aValue is Comparable) {
                          return bValue.compareTo(aValue);
                        }
                        return 0;
                      }
                      if (aValue is Comparable && bValue is Comparable) {
                        return aValue.compareTo(bValue);
                      }
                      return 0;
                    });
                  });
                },
                child: CustomPaint(
                  size: const Size(16, 16),
                  painter: ChevronPainter(
                    upColor:
                        (_sortable ?? false) && (_sortKey == col.colKey)
                            ? selectColor
                            : unSelectColor,
                    downColor:
                        (_sortable == false) && (_sortKey == col.colKey)
                            ? selectColor
                            : unSelectColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (col.cellBuilder != null) {
      return Builder(builder: (_) => col.cellBuilder!(context, index));
    }

    return titleWidget;
  }

  double _getColsWidth() {
    var width = 0.0;
    for (final col in widget.columns) {
      width += col.width ?? 0;
    }
    return width;
  }

  @override
  void initState() {
    super.initState();
    _sortKey = widget.defaultSort;
    _sortable = widget.defaultSort != null;
    _scrollController.addListener(() {
      widget.onScroll?.call(_scrollController);
    });
    _initCols();
  }

  @override
  void didUpdateWidget(covariant MyTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCols();
  }

  void _initCols() {
    _totalSelectable = 0;
    _hasChecked = 0;
    _checkedList = List.generate(widget.data?.length ?? 0, (index) => false);
    final cols = widget.columns.where((col) => col.selection ?? false);
    if (cols.length > 1) {
      throw FlutterError('Selectable column must be only one');
    }
    if (widget.data != null && cols.isNotEmpty) {
      _selectableCol = cols.first;
      final data = widget.data!;
      for (var i = 0; i < data.length; i++) {
        final check = _selectableCol.checked?.call(i, data[i]) ?? false;
        _checkedList[i] = check;
        if (check) {
          _hasChecked++;
        }
        if (_selectableCol.selectable?.call(i, data[i]) ?? false) {
          _totalSelectable++;
        }
      }
    }
  }

  Widget _getFixedTable(BuildContext context) {
    final fixedLeftCol = _getCol(MyTableColFixed.left);
    final fixedNonCol = _getCol(MyTableColFixed.none);
    final fixedRightCol = _getCol(MyTableColFixed.right);

    final fixedLeftTitle = _getCellsText(fixedLeftCol);
    final fixedNonTitle = _getCellsText(fixedNonCol);
    final fixedRightTitle = _getCellsText(fixedRightCol);

    final width = widget.width ?? MediaQuery.of(context).size.width;
    final cellWidth = width / widget.columns.length;

    final fixedLeftCols = _getVerticalCell(
      fixedLeftCol,
      fixedLeftTitle,
      cellWidth,
    );

    final fixedNonCols = _getVerticalCell(
      fixedNonCol,
      fixedNonTitle,
      cellWidth,
    );

    final fixedRightCols = _getVerticalCell(
      fixedRightCol,
      fixedRightTitle,
      cellWidth,
    );

    var fixedCellsWidth = 0.0;
    for (final tableCol in widget.columns) {
      if (tableCol.fixed == MyTableColFixed.left ||
          tableCol.fixed == MyTableColFixed.right) {
        fixedCellsWidth += tableCol.width ?? cellWidth;
      }
    }

    var fixedNonCellsWidth = 0.0;
    for (final col in fixedNonCol) {
      fixedNonCellsWidth += col.width ?? cellWidth;
    }

    if ((width - fixedCellsWidth) < fixedNonCellsWidth) {
      var content = [Row(children: fixedNonCols), _getEmpty('No data yet')];
      if (widget.loading ?? false) {
        content = [
          Row(children: fixedNonCols),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: widget.loadingWidget ?? const MyLoader(),
            ),
          ),
        ];
      }
      return Container(
        width: width,
        color: widget.backgroundColor ?? context.colorScheme.background,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [...fixedLeftCols]),
            SizedBox(
              width: width - fixedCellsWidth,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(children: content),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [...fixedRightCols],
            ),
          ],
        ),
      );
    }
    final child = Container(
      width: width,
      color: widget.backgroundColor ?? context.colorScheme.background,
      child: Row(
        children: [...fixedLeftCols, ...fixedNonCols, ...fixedRightCols],
      ),
    );
    var placeholder = _getEmpty('No data yet');
    if (widget.loading ?? false) {
      placeholder = Align(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: widget.loadingWidget ?? const MyLoader(),
        ),
      );
    }

    return ColoredBox(
      color: widget.backgroundColor ?? context.colorScheme.background,
      child: Column(children: [child, placeholder]),
    );
  }

  Widget _getEmpty(String defaultText) {
    return Visibility(
      visible: widget.data == null || widget.data!.isEmpty,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 38),
          child: MyError(
            icon: Visibility(
              visible: widget.empty?.assetUrl != null,
              child: _getEmptyImage(),
            ),
            title: widget.empty?.text ?? defaultText,
          ),
        ),
      ),
    );
  }

  MyImage _getEmptyImage() {
    final url = widget.empty?.assetUrl ?? '';
    return MyImage(source: url);
  }

  List<Widget> _getVerticalCell(
    List<MyTableColumn> cols,
    List<List<String>> titles,
    double cellWidth,
  ) {
    final rows = <Widget>[];
    for (var i = 0; i < titles.length; i++) {
      final cells = <Widget>[];
      for (var j = 0; j < titles[i].length; j++) {
        final col = cols[i];
        final cell = _getCell(
          col,
          j == 0,
          j == 0 ? '' : widget.data?[j - 1],
          i,
          i == titles.length - 1,
        );
        cells.add(SizedBox(width: col.width ?? cellWidth, child: cell));
      }
      rows.add(Column(children: cells));
    }
    return rows;
  }

  List<List<String>> _getCellsText(List<MyTableColumn> cols) {
    final list = <List<String>>[];
    for (final col in cols) {
      final titles = <String>[col.title ?? ''];
      if (widget.loading == false) {
        final dataList = <String>[];
        for (var i = 0; i < (widget.data?.length ?? 0); i++) {
          final data = widget.data![i];
          dataList.add((data as Map?)?[col.colKey]?.toString() ?? '');
        }
        titles.addAll(dataList);
      }
      list.add(titles);
    }
    return list;
  }

  Widget getAllIcon(bool checked, bool halfSelected) {
    return Icon(
      checked
          ? Icons.check_box_rounded
          : halfSelected
          ? Icons.indeterminate_check_box_rounded
          : Icons.circle,
      // checked ? TDIcons.check_rectangle_filled : halfSelected ? TDIcons.minus_rectangle_filled : TDIcons.check_rectangle,
      size: 16,
      color:
          (checked || halfSelected)
              ? context.colorScheme.primary
              : ThemeColors.neutral.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? MediaQuery.of(context).size.width;
    final fixedCols = [
      ..._getCol(MyTableColFixed.left),
      ..._getCol(MyTableColFixed.right),
    ];

    if (fixedCols.isNotEmpty) {
      return _getFixedTable(context);
    }

    if (width < _getColsWidth()) {
      return Container(
        width: width,
        color: widget.backgroundColor ?? context.colorScheme.background,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Visibility(
                visible: widget.showHeader.isTrue,
                child: _getTableHeader(context),
              ),
              SizedBox(
                height: widget.height,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: _getTableContent(context),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      width: width,
      color: widget.backgroundColor ?? context.colorScheme.background,
      child: Column(
        children: [
          Visibility(
            visible: widget.showHeader.isTrue,
            child: _getTableHeader(context),
          ),
          SizedBox(
            height: widget.height,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: _getTableContent(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ChevronPainter extends CustomPainter {
  ChevronPainter({required this.upColor, required this.downColor});

  final Color upColor;
  final Color downColor;

  @override
  void paint(Canvas canvas, Size size) {
    final upPaint =
        Paint()
          ..color = upColor
          ..strokeWidth = 1.4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final clientX = size.width;
    final clientY = size.height;
    final centerX = clientX / 2;
    final centerY = clientY / 2;

    final upPath =
        Path()
          ..moveTo(3.6, centerY - 1.8)
          ..lineTo(centerX, 2)
          ..lineTo(clientX - 3.6, centerY - 1.8);

    final downPaint =
        Paint()
          ..color = downColor
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final downPath =
        Path()
          ..moveTo(3.6, centerY + 1.8)
          ..lineTo(centerX, clientY - 2)
          ..lineTo(clientX - 3.6, centerY + 1.8);

    canvas
      ..drawPath(upPath, upPaint)
      ..drawPath(downPath, downPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
