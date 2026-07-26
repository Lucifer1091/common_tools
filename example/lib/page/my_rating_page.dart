import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyRatingBarPage extends StatefulWidget {
  const MyRatingBarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyRatingBarPageState();
  }
}

class MyRatingBarPageState extends State<MyRatingBarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Used to rate a behavior / thing.',
      exampleCodeGroup: 'rate',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Default Rating', builder: _buildMsgRate),
            ExampleItem(
              desc: 'Rating with description',
              builder: _buildRatingWuthDescription,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Styles',
          children: [
            ExampleItem(
              desc: 'Custom Rating Count',
              builder: _buildCustomRatingCount,
            ),
            ExampleItem(desc: 'Custom Color', builder: _buildRatingCustomColor),
            ExampleItem(
              desc: 'Custom Star Icon',
              builder: _buildRatingCustomStarIcon,
            ),
            ExampleItem(
              desc: 'Custom Thumb Icon',
              builder: _buildRatingThumbIcon,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMsgRate(BuildContext context) {
    return MyRatingBar(iconSize: 36, initialRating: 3.5);
  }

  Widget _buildRatingWuthDescription(BuildContext context) {
    return MyRatingBar(iconSize: 36, showRatingText: true, initialRating: 4.5);
  }

  Widget _buildCustomRatingCount(BuildContext context) {
    return MyRatingBar(
      iconSize: 36,
      initialRating: 3.5,
      maxRating: 7,
      activeColor: Colors.teal,
    );
  }

  Widget _buildRatingCustomColor(BuildContext context) {
    return MyRatingBar(
      initialRating: 2.5,
      iconSize: 36,
      activeColor: context.colorScheme.primary,
    );
  }

  Widget _buildRatingCustomStarIcon(BuildContext context) {
    return MyRatingBar(
      initialRating: 1.5,
      iconSize: 32,
      activeColor: context.colorScheme.primary,
      activeIcon: LucideIcons.star,
      inactiveIcon: LucideIcons.star,
    );
  }

  Widget _buildRatingThumbIcon(BuildContext context) {
    return MyRatingBar(
      initialRating: 1.5,
      iconSize: 32,
      activeColor: context.colorScheme.primary,
      activeIcon: LucideIcons.thumbsUp,
      inactiveIcon: LucideIcons.thumbsUp,
    );
  }
}
