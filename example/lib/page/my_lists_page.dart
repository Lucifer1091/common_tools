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
              desc: 'Marquee Widget',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildMarqueeWidget,
            ),
          ],
        ),
        ExampleModule(
          title: 'Scroll & Content',
          children: [
            ExampleItem(
              desc: 'List View - Header , Footer & Pagination',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildMyListView,
            ),
            ExampleItem(
              desc: 'Grid View - Header , Footer & Pagination',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildMyGridView,
            ),
            ExampleItem(
              desc: 'Reorderable Grid View',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildReorderableGridView,
            ),
          ],
        ),
        ExampleModule(
          title: 'Paging & State',
          children: [
            ExampleItem(desc: 'Dot Indicator', builder: _buildDotIndicator),
            ExampleItem(desc: 'Bar Indicator', builder: _buildBarIndicator),
          ],
        ),
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

  Widget _buildMarqueeWidget(BuildContext context) {
    final labels = [
      'Long-running sync completed',
      '3 list demos added',
      'Reorder enabled',
      'Page cache warmed',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            borderRadius: MyBorderRadius.large,
            border: Border.all(color: context.colorScheme.border),
          ),
          child: MyMarqueeWidget(
            child: Row(
              children: [
                const SizedBox(width: 12),
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
      ],
    );
  }

  Widget _buildMyListView(BuildContext context) {
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

    return SizedBox(
      height: 320,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.background,
          borderRadius: MyBorderRadius.large,
          border: Border.all(color: context.colorScheme.border),
        ),
        child: MyListView<String>(
          items: items,
          header: header,
          footer: footer,
          paginationWidget: pagination,
          separatorBuilder: (_, __) => const MyDivider(),
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
    );
  }

  Widget _buildMyGridView(BuildContext context) {
    final items = ['Backlog', 'Planning', 'In progress', 'Ready to ship'];

    Widget header = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        'Board snapshot',
        style: context.titleMedium.copyWith(
          fontWeight: FontWeight.w800,
          color: context.colorScheme.foreground,
        ),
      ),
    );

    Widget pagination = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: _StatusChip(
          label: 'Fetching next cards',
          active: true,
          color: context.colorScheme.primary,
        ),
      ),
    );

    Widget footer = Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        'Header, loading state, and footer stay full-width while items remain in a true sliver grid.',
        style: context.bodySmall.copyWith(
          color: context.colorScheme.secondaryForeground,
        ),
      ),
    );

    return SizedBox(
      height: 420,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.background,
          borderRadius: MyBorderRadius.large,
          border: Border.all(color: context.colorScheme.border),
        ),
        child: MyGridView<String>(
          items: items,
          padding: const EdgeInsets.all(16),
          header: header,
          paginationWidget: pagination,
          footer: footer,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (index, item) {
            final color = _palette[index % _palette.length];
            return DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withValues(alpha: 0.24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Grid builder receives the typed value and index together.',
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

  Widget _buildReorderableGridView(BuildContext context) {
    return const _ReorderableGridViewDemo();
  }

  Widget _buildDotIndicator(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _PageIndicatorDemo(),
    );
  }

  Widget _buildBarIndicator(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _PageIndicatorDemo(type: MyPageIndicatorType.bar),
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

final List<ListDemoEntry> _pagingEntries = [
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
    return Container(
      padding: EdgeInsets.all(16).except(bottom: 0),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        borderRadius: MyBorderRadius.large,
        border: Border.all(color: context.colorScheme.border),
      ),
      child: SizedBox(
        height: 350,
        child: ReorderableGridView.builder(
          shrinkWrap: true,
          itemCount: _items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
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
    );
  }
}

class _PageIndicatorDemo extends StatefulWidget {
  final MyPageIndicatorType type;

  const _PageIndicatorDemo({this.type = MyPageIndicatorType.dot});

  @override
  State<_PageIndicatorDemo> createState() => _PageIndicatorDemoState();
}

class _PageIndicatorDemoState extends State<_PageIndicatorDemo> {
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

  Future<void> _animateTo(int page) async {
    if (!_controller.hasClients) return;
    await _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDot = widget.type == MyPageIndicatorType.dot;
    final pages = List.generate(4, (index) => index);

    return Column(
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
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: _PagerCard(
                  title: 'Page ${index + 1}',
                  message: isDot
                      ? 'Tap a dot below to jump directly to this panel.'
                      : 'This indicator is driven by a page index in state.',
                  color: _palette[index],
                ),
              );
            },
          ),
        ),
        MyPageIndicator(
          length: pages.length,
          currentIndex: _index,
          type: widget.type,
          height: 4,
          width: 36,
          shrinkIndicator: !isDot,
          onTap: isDot
              ? (page) {
                  setState(() {
                    _index = page;
                  });
                  unawaited(_animateTo(page));
                }
              : null,
        ),
      ],
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
          MyPageIndicator(
            length: 4,
            currentIndex: _index,
            type: MyPageIndicatorType.bar,
            onTap: (page) {
              setState(() {
                _index = page;
              });
              unawaited(_animateTo(page));
            },
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
          color: color ?? context.colorScheme.foreground,
        ),
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

const List<Color> _palette = [
  Color(0xFF2563EB),
  Color(0xFF0F766E),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
];
