import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

import '../base/example_widget.dart';

class MyCollapsePage extends StatefulWidget {
  const MyCollapsePage({super.key});

  @override
  MyCollapsePageState createState() => MyCollapsePageState();
}

const String randomString =
    "In the heart of the bustling city, a small park offered a sanctuary of tranquility.Children's laughter echoed from the playground, mingling with the soft rustling of leaves in the gentle breeze.Joggers navigated winding paths, their steady breaths in rhythm with the chirping of the early morning birds.Nearby, an elderly man sat on a bench, engrossed in a book, oblivious to the world around him.The park was a microcosm of life, a testament to the city's vibrant spirit and the enduring allure of nature's simple pleasures.";

class MyCollapsePageState extends State<MyCollapsePage> {
  final List<CollapseDataItem> _basicData = generateItems(5);
  final List<CollapseDataItem> _blockStyleData = generateItems(5);
  final List<CollapseDataItem> _cardStyleData = generateItems(5);
  final List<CollapseDataItem> _blockStyleWithOpText = generateItems(5);
  final List<CollapseDataItem> _accordionData = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'collapse',
      desc:
          'A vertically stacked list of items. Each item can be "expanded" or "collapsed" to reveal the content associated with that item.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Basic Collapse', builder: _buildBasicCollapse),
            ExampleItem(
              desc: 'with Operation Instructions',
              builder: _buildCollapseWithOperationText,
            ),
            ExampleItem(
              desc: 'Accordion Style',
              builder: _buildAccordionCollapse,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: 'Block Style', builder: _buildBlockStyleCollapse),
            ExampleItem(desc: 'Card Style', builder: _buildCardCollapse),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicCollapse(BuildContext context) {
    return MyCollapse(
      style: MyCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _basicData[index].isExpanded = !isExpanded;
        });
      },
      children: _basicData.map((CollapseDataItem item) {
        return MyCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return MyText(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const MyText(randomString),
        );
      }).toList(),
    );
  }

  Widget _buildBlockStyleCollapse(BuildContext context) {
    return MyCollapse(
      style: MyCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _blockStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _blockStyleData.map((CollapseDataItem item) {
        return MyCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return MyText(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const MyText(randomString),
        );
      }).toList(),
    );
  }

  Widget _buildCardCollapse(BuildContext context) {
    return MyCollapse(
      style: MyCollapseStyle.card,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _cardStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _cardStyleData.map((CollapseDataItem item) {
        return MyCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return MyText(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const MyText(randomString),
        );
      }).toList(),
    );
  }

  Widget _buildCollapseWithOperationText(BuildContext context) {
    return MyCollapse(
      style: MyCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _blockStyleWithOpText[index].isExpanded = !isExpanded;
        });
      },
      children: _blockStyleWithOpText.map((CollapseDataItem item) {
        return MyCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return MyText(item.headerValue);
          },
          expandIconTextBuilder: (BuildContext context, bool isExpanded) {
            return isExpanded ? 'Collapse' : 'Expand';
          },
          isExpanded: item.isExpanded,
          body: const MyText(randomString),
        );
      }).toList(),
    );
  }

  Widget _buildAccordionCollapse(BuildContext context) {
    return MyCollapse.accordion(
      style: MyCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _accordionData[index].isExpanded = !isExpanded;
        });
      },
      children: _accordionData.map((CollapseDataItem item) {
        return MyCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return MyText(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const MyText(randomString),
          value: item.expandedValue,
        );
      }).toList(),
    );
  }
}

class CollapseDataItem {
  CollapseDataItem({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  final String expandedValue;
  final String headerValue;
  bool isExpanded;
}

List<CollapseDataItem> generateItems(int numOfItems) {
  return List.generate(numOfItems, (index) {
    return CollapseDataItem(
      headerValue: 'Title $index',
      expandedValue: '$index',
    );
  });
}
