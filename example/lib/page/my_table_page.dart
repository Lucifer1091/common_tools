import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyTablePage extends StatelessWidget {
  const MyTablePage({super.key});

  List<Json> _getData(int index) {
    var data = <Json>[];
    for (var i = 0; i < 10; i++) {
      if (i == index) {
        data.add({
          'title1': 'Content Content Content Content',
          'title2': 'Content',
          'title3': 'Content',
          'title4': 'Content',
        });
      } else {
        data.add({
          'title1': 'Content',
          'title2': 'Content',
          'title3': 'Content',
          'title4': 'Content',
        });
      }
    }
    return data;
  }

  List<Json> _getData2() {
    var data = <Json>[];
    for (var i = 0; i < 10; i++) {
      if (i == 0) {
        data.add({
          'title1': 'Horizontal tiled content not omitted',
          'title2': 'Horizontal tiled content not omitted',
          'title3': 'Horizontal tiled content not omitted',
        });
      } else {
        data.add({
          'title1': 'Content',
          'title2': 'Content',
          'title3': 'Content',
        });
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'Tables are commonly used to display multiple data sets with similar structures, facilitating organization, comparison, and analysis. They also allow for data searching, filtering, and sorting. Generally, they consist of three parts: a header, data rows, and a footer.',
      exampleCodeGroup: 'table',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Basic Table', builder: _basicTable),
            ExampleItem(desc: 'Sortable Table', builder: _sortableTable),
            ExampleItem(
              desc: 'Table with Actions or Buttons',
              builder: _operationBtnTable,
            ),
            ExampleItem(
              builder: _operationIconTable,
              padding: const EdgeInsets.only(top: 16),
            ),
            ExampleItem(
              desc: 'Fixed FirstColTable',
              builder: _fixedFirstColTable,
            ),
            ExampleItem(desc: 'Fixed EndColTable', builder: _fixedEndColTable),
            ExampleItem(
              desc: 'Horizontal Tiled Scrollable Table',
              builder: _horizontalScrollTable,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(
              desc: 'Table Style with Zebra Stripe',
              builder: _stripeTable,
            ),
            ExampleItem(desc: 'Table Style with Border', builder: _borderTable),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: 'Fixed Header', builder: _fixedHeaderTable),
        ExampleItem(
          desc: 'Fixed Column Footer + Scrolling Table',
          builder: _fixedScrollTable,
        ),
        ExampleItem(desc: 'Centered Table', builder: _centerTable),
        ExampleItem(desc: 'Empty Data Table', builder: _emptyTable),
        ExampleItem(desc: 'Loading Animation Table', builder: _loadingTable),
        ExampleItem(desc: 'Optional Table', builder: _selectTable),
      ],
    );
  }

  Widget _basicTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', ellipsis: true),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(title: 'Title', field: 'title4'),
      ],
      data: _getData(9),
    );
  }

  Widget _sortableTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(
          title: 'Title',
          field: 'title1',
          ellipsis: true,
          sortable: true,
        ),
        MyTableColumn(title: 'Title', field: 'title2', sortable: true),
        MyTableColumn(title: 'Title', field: 'title3', sortable: true),
        MyTableColumn(title: 'Title', field: 'title4', sortable: true),
      ],
      data: _getData(9),
    );
  }

  Widget _operationBtnTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', ellipsis: true),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(
          title: 'Title',
          field: 'title4',
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  'Revise',
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
                MyText(
                  'Pass',
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ],
            );
          },
        ),
      ],
      data: _getData(9),
    );
  }

  Widget _operationIconTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', ellipsis: true),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(
          title: 'Title',
          field: 'title4',
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.upload,
                  color: context.colorScheme.primary,
                  size: 16,
                ),
                Icon(
                  Icons.delete,
                  color: context.colorScheme.primary,
                  size: 16,
                ),
              ],
            );
          },
        ),
      ],
      data: _getData(9),
    );
  }

  Widget _fixedFirstColTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1'),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(
          title: 'Title',
          field: 'title4',
          fixed: MyTableColFixed.left,
        ),
      ],
      data: _getData(10),
    );
  }

  Widget _fixedEndColTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1'),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(
          title: 'Title',
          field: 'title4',
          fixed: MyTableColFixed.right,
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  'Revise',
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
                MyText(
                  'Pass',
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
      ],
      data: _getData(10),
    );
  }

  Widget _horizontalScrollTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', width: 160),
        MyTableColumn(title: 'Title', field: 'title2', width: 160),
        MyTableColumn(title: 'Title', field: 'title3', width: 160),
      ],
      data: _getData2(),
    );
  }

  Widget _stripeTable(BuildContext context) {
    return MyTable(
      stripe: true,
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', ellipsis: true),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(title: 'Title', field: 'title4'),
      ],
      data: _getData(9),
    );
  }

  Widget _borderTable(BuildContext context) {
    return MyTable(
      bordered: true,
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', ellipsis: true),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(title: 'Title', field: 'title4'),
      ],
      data: _getData(9),
    );
  }

  Widget _fixedHeaderTable(BuildContext context) {
    return MyTable(
      bordered: true,
      height: 240,
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', ellipsis: true),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(title: 'Title', field: 'title4'),
      ],
      data: _getData(9),
    );
  }

  Widget _fixedScrollTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1', width: 200),
        MyTableColumn(title: 'Title', field: 'title2', width: 160),
        MyTableColumn(title: 'Title', field: 'title3', width: 160),
        MyTableColumn(
          title: 'Title',
          field: 'title4',
          fixed: MyTableColFixed.right,
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  'Revise',
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
                MyText(
                  'Pass',
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
      ],
      data: _getData2(),
    );
  }

  Widget _centerTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(
          title: 'Title',
          field: 'title1',
          align: MyTableColAlign.center,
        ),
        MyTableColumn(
          title: 'Title',
          field: 'title2',
          align: MyTableColAlign.center,
        ),
        MyTableColumn(
          title: 'Title',
          field: 'title3',
          align: MyTableColAlign.center,
        ),
        MyTableColumn(
          title: 'Title',
          field: 'title4',
          align: MyTableColAlign.center,
        ),
      ],
      data: _getData(10),
    );
  }

  Widget _emptyTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1'),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(title: 'Title', field: 'title4'),
      ],
    );
  }

  Widget _loadingTable(BuildContext context) {
    return MyTable(
      columns: [
        MyTableColumn(title: 'Title', field: 'title1'),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(title: 'Title', field: 'title4'),
      ],
      loading: true,
    );
  }

  Widget _selectTable(BuildContext context) {
    return MyTable(
      data: _getData(10),
      columns: [
        MyTableColumn(
          selection: true,
          checked: (index, row) {
            return index == 0;
          },
          width: 50,
          selectable: (index, row) {
            return index % 2 == 0;
          },
        ),
        MyTableColumn(title: 'Title', field: 'title1'),
        MyTableColumn(title: 'Title', field: 'title2'),
        MyTableColumn(title: 'Title', field: 'title3'),
        MyTableColumn(title: 'Title', field: 'title4'),
      ],
    );
  }
}
