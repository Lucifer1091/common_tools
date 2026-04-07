import 'dart:async';

import 'package:common_tools/index.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyListsPage extends StatelessWidget {
  const MyListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'lists',
      desc:
          'Examples for the list, paging, expansion, and reorder widgets exported from lib/widgets/lists.',
      children: [
        ExampleModule(
          title: 'Tiles & Expansion',
          children: [
            ExampleItem(
              desc: 'Bullet List',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildBulletList,
            ),
            ExampleItem(
              desc: 'Custom List Tile',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildCustomListTile,
            ),
          ],
        ),
        _buildModule('Tiles & Expansion', _tileEntries),
        _buildModule('Scroll & Content', _contentEntries),
        _buildModule('Paging & State', _pagingEntries),
      ],
    );
  }

  ExampleModule _buildModule(String title, List<ListDemoEntry> entries) {
    return ExampleModule(
      title: title,
      children: [
        ExampleItem(
          center: false,
          padding: EdgeInsets.only(top: 16),
          builder: (context) => _ListEntryGroup(entries: entries),
        ),
      ],
    );
  }

  Widget _buildBulletList(BuildContext context) {
    return MyBulletList(
      rowPadding: const EdgeInsets.only(bottom: 4),
      children: [
        MyText('Audit item spacing and padding in the final layout.'),
        MyText('Choose the right indicator style for paging or steps.'),
        MyText('Add expansion behavior only where extra detail is useful.'),
      ],
    );
  }

  Widget _buildCustomListTile(BuildContext context) {
    final textStyle = context.bodyMedium.copyWith(
      color: context.colorScheme.foreground,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomListTile(
          inkwellRadius: BorderRadius.circular(18),
          leading: CircleAvatar(
            backgroundColor: context.colorScheme.primary.withValues(
              alpha: 0.14,
            ),
            child: Icon(
              Icons.layers_outlined,
              color: context.colorScheme.primary,
            ),
          ),
          title: Text(
            'Design system',
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          subtitle: Text(
            'Shared styles, tokens, and spacing presets.',
            style: context.bodySmall.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: context.colorScheme.secondaryForeground,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CustomListTile tapped')),
            );
          },
        ),
        MyDivider(height: 1, color: context.colorScheme.border),
        CustomListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF92400E).withValues(alpha: 0.14),
            child: const Icon(Icons.bolt_rounded, color: Color(0xFF92400E)),
          ),
          title: Text(
            'Quick actions',
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          subtitle: Text(
            'The trailing widget can be anything, not just an icon.',
            style: context.bodySmall.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          trailing: _StatusChip(
            label: 'New',
            active: true,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class ListDemoEntry {
  const ListDemoEntry({
    required this.title,
    required this.subtitle,
    required this.pageDescription,
    required this.demoBuilder,
  });

  final String title;
  final String subtitle;
  final String pageDescription;
  final WidgetBuilder demoBuilder;
}

class _ListEntryGroup extends StatelessWidget {
  const _ListEntryGroup({required this.entries});

  final List<ListDemoEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MyCellGroup(
        bordered: true,
        theme: MyCellGroupTheme.card,
        style: MyCellStyle.style(
          context,
        ).copyWith(cardPadding: EdgeInsets.zero),
        cells: [
          for (final entry in entries)
            MyCell(
              title: entry.title,
              description: entry.subtitle,
              arrow: true,
              onTap: (_) => _openListEntry(context, entry),
            ),
        ],
      ),
    );
  }
}

void _openListEntry(BuildContext context, ListDemoEntry entry) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => _ListExamplePage(entry: entry)),
  );
}

class _ListExamplePage extends StatelessWidget {
  const _ListExamplePage({required this.entry});

  final ListDemoEntry entry;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: entry.title,
      desc: entry.pageDescription,
      exampleCodeGroup: 'lists',
      children: [
        ExampleModule(
          title: 'Live Example',
          children: [
            ExampleItem(
              center: false,
              padding: EdgeInsets.only(top: 16),
              builder: entry.demoBuilder,
            ),
          ],
        ),
      ],
    );
  }
}

final List<ListDemoEntry> _tileEntries = [
  ListDemoEntry(
    title: 'CustomListTile',
    subtitle: 'A more configurable ListTile with custom inkwell radius.',
    pageDescription:
        'CustomListTile mirrors Flutter ListTile but exposes a few styling knobs that make card and menu layouts easier to tune.',
    demoBuilder: _buildCustomListTileDemo,
  ),
  ListDemoEntry(
    title: 'CustomExpansionTile',
    subtitle: 'Expansion tile with decoration and radius control.',
    pageDescription:
        'CustomExpansionTile gives expansion panels a more card-like presentation with decoration, padding, and custom tile corners.',
    demoBuilder: _buildCustomExpansionTileDemo,
  ),
  ListDemoEntry(
    title: 'ExpandableListTile',
    subtitle: 'Compact expand and collapse behavior in a custom row.',
    pageDescription:
        'ExpandableListTile is a simpler custom expansion row that works well for compact settings, FAQs, and secondary detail blocks.',
    demoBuilder: _buildExpandableListTileDemo,
  ),
  ListDemoEntry(
    title: 'ExpansionWidget',
    subtitle: 'Flexible title row plus expandable body content.',
    pageDescription:
        'ExpansionWidget is useful for form sections and optional controls where you want the title bar and body styling to stay separate.',
    demoBuilder: _buildExpansionWidgetDemo,
  ),
  ListDemoEntry(
    title: 'OptimizedCard',
    subtitle: 'Card wrapper with a softer, customizable shadow treatment.',
    pageDescription:
        'OptimizedCard keeps Material card behavior while adding a more adjustable outer shadow for elevated content panels.',
    demoBuilder: _buildOptimizedCardDemo,
  ),
  ListDemoEntry(
    title: 'OptimizedListTile',
    subtitle: 'List-tile layout already wrapped in an OptimizedCard.',
    pageDescription:
        'OptimizedListTile is handy when you want title, subtitle, leading, and trailing content in a padded card with minimal setup.',
    demoBuilder: _buildOptimizedListTileDemo,
  ),
];

final List<ListDemoEntry> _contentEntries = [
  ListDemoEntry(
    title: 'HorizontalList',
    subtitle: 'Wrap-like horizontal scroller for variable-width children.',
    pageDescription:
        'HorizontalList works well when your items do not share a fixed width and you still want an easy horizontal scroller.',
    demoBuilder: _buildHorizontalListDemo,
  ),
  ListDemoEntry(
    title: 'HorizontalListView',
    subtitle: 'Fixed-size horizontal builder for repeated cards.',
    pageDescription:
        'HorizontalListView is a builder-based horizontal row with per-item width and height, useful for repeating card rails.',
    demoBuilder: _buildHorizontalListViewDemo,
  ),
  ListDemoEntry(
    title: 'MarqueeWidget',
    subtitle: 'Auto-scroll overflowing content in one or two directions.',
    pageDescription:
        'MarqueeWidget keeps long text or chip rows moving automatically when the content is wider than the available space.',
    demoBuilder: _buildMarqueeWidgetDemo,
  ),
  ListDemoEntry(
    title: 'OptimizedScrollView',
    subtitle: 'Fill the viewport while keeping the child scrollable.',
    pageDescription:
        'OptimizedScrollView is useful for full-height detail views where the content should stretch to the viewport and still scroll naturally.',
    demoBuilder: _buildOptimizedScrollViewDemo,
  ),
  ListDemoEntry(
    title: 'TypedListView',
    subtitle: 'Type-safe ListView with header, footer, separators, and paging.',
    pageDescription:
        'TypedListView reduces repetitive casting and boilerplate while still supporting headers, separators, footers, and loading rows.',
    demoBuilder: _buildTypedListViewDemo,
  ),
  ListDemoEntry(
    title: 'ReorderableGridView',
    subtitle: 'Drag-and-drop reordering for grid layouts.',
    pageDescription:
        'ReorderableGridView makes it easy to build rearrangeable dashboards, favorite collections, and media boards.',
    demoBuilder: _buildReorderableGridViewDemo,
  ),
];

final List<ListDemoEntry> _pagingEntries = [
  ListDemoEntry(
    title: 'DotIndicator',
    subtitle: 'Interactive dots that sync with a PageController.',
    pageDescription:
        'DotIndicator pairs with PageView and lets people tap a dot to jump directly to a page.',
    demoBuilder: _buildDotIndicatorDemo,
  ),
  ListDemoEntry(
    title: 'PageViewIndicators',
    subtitle: 'Simple linear page bars for a current index.',
    pageDescription:
        'PageViewIndicators renders a compact strip of bars driven by the current page index from your own controller or state.',
    demoBuilder: _buildPageViewIndicatorsDemo,
  ),
  ListDemoEntry(
    title: 'TimerSmoothPageIndicator',
    subtitle: 'Animated progress bars for timed carousels or stories.',
    pageDescription:
        'TimerSmoothPageIndicator is useful when each step advances on a timer and the indicator should show elapsed progress, not just position.',
    demoBuilder: _buildTimerSmoothPageIndicatorDemo,
  ),
  ListDemoEntry(
    title: 'PreloadPageView',
    subtitle: 'PageView variant that preloads adjacent pages.',
    pageDescription:
        'PreloadPageView helps smooth out image-heavy or expensive pages by building nearby pages ahead of time.',
    demoBuilder: _buildPreloadPageViewDemo,
  ),
  ListDemoEntry(
    title: 'MyIndexedStack',
    subtitle: 'Indexed stack with caching and preload controls.',
    pageDescription:
        'MyIndexedStack is useful for tab and section switching when you want tighter control over page caching and disposal.',
    demoBuilder: _buildMyIndexedStackDemo,
  ),
  ListDemoEntry(
    title: 'Storyboard',
    subtitle: 'Story-style timed sequence with tap and hold controls.',
    pageDescription:
        'Storyboard creates Instagram-style slides that auto-advance, support previous and next taps, and pause while pressed.',
    demoBuilder: _buildStoryboardDemo,
  ),
];

Widget _buildBulletListDemo(BuildContext context) {
  final textStyle = context.bodyMedium.copyWith(
    color: context.colorScheme.secondaryForeground,
  );

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Release checklist',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 12),
          MyBulletList(
            symbolType: MySymbolType.numbered,
            prefixText: 'Step',
            padding: 12,
            rowPadding: const EdgeInsets.only(bottom: 10),
            children: [
              Text(
                'Audit item spacing and padding in the final layout.',
                style: textStyle,
              ),
              Text(
                'Choose the right indicator style for paging or steps.',
                style: textStyle,
              ),
              Text(
                'Add expansion behavior only where extra detail is useful.',
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildCustomListTileDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colorScheme.background,
              border: Border.all(color: context.colorScheme.border),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomListTile(
                  inkwellRadius: BorderRadius.circular(18),
                  leading: CircleAvatar(
                    backgroundColor: context.colorScheme.primary.withValues(
                      alpha: 0.14,
                    ),
                    child: Icon(
                      Icons.layers_outlined,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    'Design system',
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.foreground,
                    ),
                  ),
                  subtitle: Text(
                    'Shared styles, tokens, and spacing presets.',
                    style: context.bodySmall.copyWith(
                      color: context.colorScheme.secondaryForeground,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: context.colorScheme.secondaryForeground,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('CustomListTile tapped')),
                    );
                  },
                ),
                MyDivider(height: 1, color: context.colorScheme.border),
                CustomListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(
                      0xFF92400E,
                    ).withValues(alpha: 0.14),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  title: Text(
                    'Quick actions',
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.foreground,
                    ),
                  ),
                  subtitle: Text(
                    'The trailing widget can be anything, not just an icon.',
                    style: context.bodySmall.copyWith(
                      color: context.colorScheme.secondaryForeground,
                    ),
                  ),
                  trailing: _StatusChip(
                    label: 'New',
                    active: true,
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildCustomExpansionTileDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: Material(
        color: Colors.transparent,
        child: CustomExpansionTile(
          title: Text(
            'Project handoff',
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          subtitle: Text(
            'Expand to see the final delivery checklist.',
            style: context.bodySmall.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          leading: Icon(
            Icons.assignment_turned_in_outlined,
            color: context.colorScheme.primary,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.colorScheme.border),
          ),
          inkwellRadius: BorderRadius.circular(18),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            _detailRow(
              context,
              icon: Icons.check_circle_outline_rounded,
              text: 'Exported the final list widget examples page.',
            ),
            _detailRow(
              context,
              icon: Icons.check_circle_outline_rounded,
              text: 'Registered the route under the Base section.',
            ),
            _detailRow(
              context,
              icon: Icons.check_circle_outline_rounded,
              text: 'Verified the demos with formatter and analyzer.',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildExpandableListTileDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            border: Border.all(color: context.colorScheme.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ExpandableListTile(
            backgroundColor: context.colorScheme.background,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                Icons.tune_rounded,
                color: context.colorScheme.primary,
              ),
            ),
            title: Text(
              'Filter presets',
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.foreground,
              ),
            ),
            subtitle: Text(
              'Open this row to reveal quick preset combinations.',
              style: context.bodySmall.copyWith(
                color: context.colorScheme.secondaryForeground,
              ),
            ),
            children: const [
              _SimpleListLine(label: 'Only show recently updated items'),
              _SimpleListLine(label: 'Pin critical alerts to the top'),
              _SimpleListLine(label: 'Hide archived results by default'),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildExpansionWidgetDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            border: Border.all(color: context.colorScheme.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ExpansionWidget(
            title: Text(
              'Advanced layout controls',
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.foreground,
              ),
            ),
            tooltip: 'Tap to show optional list tuning controls.',
            showDivider: true,
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _StatusChip(
                    label: 'Dense spacing',
                    active: true,
                    color: context.colorScheme.primary,
                  ),
                  const _StatusChip(label: 'Sticky header'),
                  const _StatusChip(label: 'Page preload'),
                  const _StatusChip(label: 'Animated switch'),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildOptimizedCardDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity,
      child: OptimizedCard(
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(22),
        color: context.colorScheme.background,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OptimizedCard pressed')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'Elevated summary',
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colorScheme.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This card uses the custom shadow path from OptimizedCard to create a softer surface than a plain Material card.',
              style: context.bodyMedium.copyWith(
                color: context.colorScheme.secondaryForeground,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatusChip(
                  label: 'Pressable',
                  active: true,
                  color: context.colorScheme.primary,
                ),
                const _StatusChip(label: 'Soft shadow'),
                const _StatusChip(label: 'Rounded corners'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildOptimizedListTileDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: OptimizedListTile(
      leading: CircleAvatar(
        backgroundColor: context.colorScheme.primary.withValues(alpha: 0.14),
        child: Icon(Icons.insights_rounded, color: context.colorScheme.primary),
      ),
      title: Text(
        'List performance',
        style: context.titleSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: context.colorScheme.foreground,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          'Pairs card styling with a ready-to-use leading, content, and trailing row.',
          style: context.bodySmall.copyWith(
            color: context.colorScheme.secondaryForeground,
          ),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18,
        color: context.colorScheme.secondaryForeground,
      ),
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    ),
  );
}

Widget _buildHorizontalListDemo(BuildContext context) {
  final items = [
    ('Overview', 130.0),
    ('Pinned updates', 170.0),
    ('Needs review', 150.0),
    ('Ready to ship', 145.0),
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Variable-width cards',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 14),
          HorizontalList(
            itemCount: items.length,
            spacing: 12,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: item.$2,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _palette[index].withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _palette[index].withValues(alpha: 0.24),
                  ),
                ),
                child: Text(
                  item.$1,
                  style: context.titleSmall.copyWith(
                    color: context.colorScheme.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildHorizontalListViewDemo(BuildContext context) {
  final items = ['Queue', 'Drafts', 'Review', 'Published'];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: HorizontalListView<String>(
        itemCount: items.length,
        listHeight: 136,
        itemWidth: 170,
        padding: EdgeInsets.zero,
        builder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.background,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: context.colorScheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusChip(
                    label: '${index + 1} of ${items.length}',
                    active: true,
                    color: _palette[index],
                  ),
                  const Spacer(),
                  Text(
                    items[index],
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fixed-width builder item',
                    style: context.bodySmall.copyWith(
                      color: context.colorScheme.secondaryForeground,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildMarqueeWidgetDemo(BuildContext context) {
  final labels = [
    'Long-running sync completed',
    '3 list demos added',
    'Reorder enabled',
    'Page cache warmed',
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scrolling headline',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.colorScheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colorScheme.border),
            ),
            child: ClipRect(
              child: MarqueeWidget(
                animationDuration: const Duration(seconds: 8),
                backDuration: const Duration(seconds: 8),
                pauseDuration: const Duration(milliseconds: 600),
                child: Row(
                  children: [
                    for (final label in labels) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          label,
                          style: context.bodyMedium.copyWith(
                            color: context.colorScheme.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildOptimizedScrollViewDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            border: Border.all(color: context.colorScheme.border),
          ),
          child: OptimizedScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Viewport-aware panel',
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The body stretches to fill the available height, then still scrolls naturally when the content grows.',
                    style: context.bodyMedium.copyWith(
                      color: context.colorScheme.secondaryForeground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final label in [
                    'Sticky controls',
                    'Persistent composer',
                    'Safe bottom spacing',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _StatusChip(label: label, active: true),
                    ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.colorScheme.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colorScheme.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Bottom actions stay visually anchored even inside a scroll view.',
                            style: context.bodyMedium.copyWith(
                              color: context.colorScheme.secondaryForeground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildTypedListViewDemo(BuildContext context) {
  final items = ['Inbox', 'Scheduled', 'In review', 'Approved'];

  Widget header = Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      'Pipeline',
      style: context.titleMedium.copyWith(
        fontWeight: FontWeight.w800,
        color: context.colorScheme.foreground,
      ),
    ),
  );

  Widget footer = Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    child: Text(
      'Footer slot: helpful for totals, captions, or next actions.',
      style: context.bodySmall.copyWith(
        color: context.colorScheme.secondaryForeground,
      ),
    ),
  );

  Widget pagination = Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Center(
      child: _StatusChip(
        label: 'Loading next page',
        active: true,
        color: context.colorScheme.primary,
      ),
    ),
  );

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      height: 320,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            border: Border.all(color: context.colorScheme.border),
          ),
          child: TypedListView<String>(
            items: items,
            header: header,
            footer: footer,
            paginationWidget: pagination,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: context.colorScheme.border),
            itemBuilder: (index, item) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _palette[index].withValues(alpha: 0.14),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: _palette[index],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  item,
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.foreground,
                  ),
                ),
                subtitle: Text(
                  'Typed item builder receives index and value together.',
                  style: context.bodySmall.copyWith(
                    color: context.colorScheme.secondaryForeground,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _buildReorderableGridViewDemo(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: _ReorderableGridViewDemo(),
  );
}

Widget _buildDotIndicatorDemo(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: _DotIndicatorDemo(),
  );
}

Widget _buildPageViewIndicatorsDemo(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: _PageViewIndicatorsDemo(),
  );
}

Widget _buildTimerSmoothPageIndicatorDemo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timed progression',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Each segment expands and fills automatically over two seconds.',
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          const SizedBox(height: 18),
          TimerSmoothPageIndicator(
            totalLength: 4,
            durationInSeconds: 2,
            indicatorWidth: 28,
            activeIndicatorWidth: 56,
            indicatorHeight: 8,
            indicatorColor: context.colorScheme.primary.withValues(alpha: 0.18),
            progressColor: context.colorScheme.primary,
          ),
        ],
      ),
    ),
  );
}

Widget _buildPreloadPageViewDemo(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: _PreloadPageViewDemo(),
  );
}

Widget _buildMyIndexedStackDemo(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: _MyIndexedStackDemo(),
  );
}

Widget _buildStoryboardDemo(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: _StoryboardDemo(),
  );
}

class _ReorderableGridViewDemo extends StatefulWidget {
  const _ReorderableGridViewDemo();

  @override
  State<_ReorderableGridViewDemo> createState() =>
      _ReorderableGridViewDemoState();
}

class _ReorderableGridViewDemoState extends State<_ReorderableGridViewDemo> {
  late final List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = List.generate(6, (index) => 'Card ${index + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Drag to reorder',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Press and drag a card to rearrange the grid.',
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int index = 0; index < _items.length; index++)
                _StatusChip(
                  label: '${index + 1}: ${_items[index]}',
                  active: true,
                  color: _palette[index % _palette.length],
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ReorderableGridView.builder(
              dragStartDelay: Duration.zero,
              itemCount: _items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
              ),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final color = _palette[index % _palette.length];
                return Container(
                  key: ValueKey(_items[index]),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: color.withValues(alpha: 0.24)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.drag_indicator_rounded, color: color),
                      const Spacer(),
                      Text(
                        _items[index],
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.colorScheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Hold and move',
                        style: context.bodySmall.copyWith(
                          color: context.colorScheme.secondaryForeground,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicatorDemo extends StatefulWidget {
  const _DotIndicatorDemo();

  @override
  State<_DotIndicatorDemo> createState() => _DotIndicatorDemoState();
}

class _DotIndicatorDemoState extends State<_DotIndicatorDemo> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(4, (index) => index);
    return _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PagerCard(
                    title: 'Page ${index + 1}',
                    message: 'Tap a dot below to jump directly to this panel.',
                    color: _palette[index],
                  ),
                );
              },
            ),
          ),
          DotIndicator<int>(
            pageController: _controller,
            pages: pages,
            indicatorColor: context.colorScheme.primary,
            unselectedIndicatorColor: context.colorScheme.primary.withValues(
              alpha: 0.18,
            ),
            selectedSize: 14,
            size: 8,
          ),
        ],
      ),
    );
  }
}

class _PageViewIndicatorsDemo extends StatefulWidget {
  const _PageViewIndicatorsDemo();

  @override
  State<_PageViewIndicatorsDemo> createState() =>
      _PageViewIndicatorsDemoState();
}

class _PageViewIndicatorsDemoState extends State<_PageViewIndicatorsDemo> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  _index = value;
                });
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PagerCard(
                    title: 'State ${index + 1}',
                    message:
                        'This indicator is driven by a page index in state.',
                    color: _palette[index],
                  ),
                );
              },
            ),
          ),
          PageViewIndicators(
            index: _index,
            length: 3,
            width: 36,
            height: 6,
            selectedColor: context.colorScheme.primary,
            unselectedColor: context.colorScheme.primary.withValues(
              alpha: 0.16,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreloadPageViewDemo extends StatefulWidget {
  const _PreloadPageViewDemo();

  @override
  State<_PreloadPageViewDemo> createState() => _PreloadPageViewDemoState();
}

class _PreloadPageViewDemoState extends State<_PreloadPageViewDemo> {
  late final PreloadPageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PreloadPageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateTo(int page) async {
    if (!_controller.hasClients) return;
    await _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preloaded pages',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Nearby pages are built ahead of time, which helps expensive carousels feel smoother.',
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: PreloadPageView.builder(
              controller: _controller,
              itemCount: 4,
              preloadPagesCount: 2,
              onPageChanged: (page) {
                setState(() {
                  _index = page;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _PagerCard(
                    title: 'Preloaded ${index + 1}',
                    message:
                        'This page is created early when it moves into the preload window.',
                    color: _palette[index],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          PageViewIndicators(
            index: _index,
            length: 4,
            width: 28,
            height: 6,
            selectedColor: context.colorScheme.primary,
            unselectedColor: context.colorScheme.primary.withValues(
              alpha: 0.16,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(
                text: 'Previous',
                type: MyButtonType.outline,
                onTap: _index == 0
                    ? null
                    : () => unawaited(_animateTo(_index - 1)),
              ),
              MyButton(
                text: 'Next',
                onTap: _index == 3
                    ? null
                    : () => unawaited(_animateTo(_index + 1)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyIndexedStackDemo extends StatefulWidget {
  const _MyIndexedStackDemo();

  @override
  State<_MyIndexedStackDemo> createState() => _MyIndexedStackDemoState();
}

class _MyIndexedStackDemoState extends State<_MyIndexedStackDemo> {
  late final MyIndexedStackController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MyIndexedStackController(
      initialIndex: 0,
      totalPages: 3,
      preloadIndexes: const [0],
      disposeUnused: true,
      maxCachedPages: 2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final currentIndex = _controller.currentIndex;
          final loaded = _controller.loadedIndexes.toList()..sort();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cached pages: ${loaded.join(", ")}',
                style: context.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.foreground,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final index in loaded)
                    _StatusChip(
                      label: 'Loaded $index',
                      active: true,
                      color: _palette[index % _palette.length],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MyIndexedStack(
                    controller: _controller,
                    children: [
                      _StackPage(
                        title: 'Overview',
                        color: _palette[0],
                        message: 'Always preloaded as the first visible page.',
                      ),
                      _StackPage(
                        title: 'Insights',
                        color: _palette[1],
                        message:
                            'Moves in when selected and can be cached briefly.',
                      ),
                      _StackPage(
                        title: 'Settings',
                        color: _palette[2],
                        message:
                            'Older pages are disposed when the cache limit is reached.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (int index = 0; index < 3; index++)
                    MyButton(
                      text: 'Page ${index + 1}',
                      type: index == currentIndex
                          ? MyButtonType.primary
                          : MyButtonType.outline,
                      onTap: () => _controller.jumpTo(index),
                    ),
                  MyButton(
                    text: 'Preload adjacent',
                    type: MyButtonType.outline,
                    onTap: () => _controller.preloadAdjacentPages(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StoryboardDemo extends StatefulWidget {
  const _StoryboardDemo();

  @override
  State<_StoryboardDemo> createState() => _StoryboardDemoState();
}

class _StoryboardDemoState extends State<_StoryboardDemo> {
  int _seed = 0;
  bool _ended = false;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(
                label: _ended ? 'Sequence finished' : 'Playing',
                active: true,
                color: _ended ? MyColors.green : context.colorScheme.primary,
              ),
              const _StatusChip(label: 'Tap left or right'),
              const _StatusChip(label: 'Hold to pause'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 420,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Storyboard(
                key: ValueKey(_seed),
                storyDuration: const Duration(seconds: 2),
                onEnd: () {
                  if (!mounted) return;
                  setState(() {
                    _ended = true;
                  });
                },
                stories: [
                  _storySlide(
                    title: 'Morning brief',
                    message: 'Review the overnight queue and priorities.',
                    color: const Color(0xFF2563EB),
                    icon: Icons.wb_sunny_outlined,
                  ),
                  _storySlide(
                    title: 'Refine the layout',
                    message: 'Adjust spacing, density, and expansion defaults.',
                    color: const Color(0xFF0F766E),
                    icon: Icons.tune_rounded,
                  ),
                  _storySlide(
                    title: 'Ship the update',
                    message:
                        'Run analysis, sanity check the flows, and publish.',
                    color: const Color(0xFF7C3AED),
                    icon: Icons.rocket_launch_outlined,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          MyButton(
            text: 'Replay stories',
            type: MyButtonType.outline,
            onTap: () {
              setState(() {
                _seed++;
                _ended = false;
              });
            },
          ),
        ],
      ),
    );
  }
}

StoryBuilder _storySlide({
  required String title,
  required String message,
  required Color color,
  required IconData icon,
}) {
  return (context, controller, headerHeight) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = Curves.easeOut.transform(controller.value);
        final offset = 24 * (1 - t);

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.75)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, headerHeight + 24, 24, 24),
              child: Transform.translate(
                offset: Offset(0, offset),
                child: Opacity(opacity: 0.35 + (0.65 * t), child: child),
              ),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const Spacer(),
          Text(
            title,
            style: context.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: context.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  };
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.colorScheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, this.active = false, this.color});

  final String label;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? context.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? accent.withValues(alpha: 0.12)
            : context.colorScheme.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? accent.withValues(alpha: 0.3)
              : context.colorScheme.border,
        ),
      ),
      child: Text(
        label,
        style: context.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorScheme.foreground,
        ),
      ),
    );
  }
}

class _SimpleListLine extends StatelessWidget {
  const _SimpleListLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: [
          Icon(
            Icons.chevron_right_rounded,
            color: context.colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: context.bodyMedium.copyWith(
                color: context.colorScheme.secondaryForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PagerCard extends StatelessWidget {
  const _PagerCard({
    required this.title,
    required this.message,
    required this.color,
  });

  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusChip(label: title, active: true, color: Colors.white),
          const Spacer(),
          Text(
            title,
            style: context.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: context.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _StackPage extends StatelessWidget {
  const _StackPage({
    required this.title,
    required this.message,
    required this.color,
  });

  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.76)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusChip(label: title, active: true, color: Colors.white),
            const Spacer(),
            Text(
              title,
              style: context.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _detailRow(
  BuildContext context, {
  required IconData icon,
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: context.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.secondaryForeground,
            ),
          ),
        ),
      ],
    ),
  );
}

const List<Color> _palette = [
  Color(0xFF2563EB),
  Color(0xFF0F766E),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
];
