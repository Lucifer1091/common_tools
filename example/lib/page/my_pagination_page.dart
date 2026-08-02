import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';

import '../base/example_widget.dart';

class MyPaginationPage extends StatelessWidget {
  const MyPaginationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc: 'Navigate through paged content with compact page controls.',
      exampleCodeGroup: 'pagination',
      children: [
        ExampleModule(
          title: 'Basic',
          children: [
            ExampleItem(
              desc: 'A controlled pagination with page state owned by the app.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: (_) => const _BasicPaginationExample(),
            ),
          ],
        ),
        ExampleModule(
          title: 'Compact',
          children: [
            ExampleItem(
              desc: 'Icon-only previous and next controls for dense layouts.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: (_) => const _CompactPaginationExample(),
            ),
          ],
        ),
        ExampleModule(
          title: 'Large Dataset',
          children: [
            ExampleItem(
              desc: 'Ellipsis controls jump through a larger page set.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: (_) => const _LargePaginationExample(),
            ),
          ],
        ),
        ExampleModule(
          title: 'Boundary Behavior',
          children: [
            ExampleItem(
              desc: 'Previous and next controls can be hidden at boundaries.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: (_) => const _BoundaryPaginationExample(),
            ),
          ],
        ),
      ],
    );
  }
}

class _BasicPaginationExample extends StatefulWidget {
  const _BasicPaginationExample();

  @override
  State<_BasicPaginationExample> createState() =>
      _BasicPaginationExampleState();
}

class _BasicPaginationExampleState extends State<_BasicPaginationExample> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return _PaginationExampleLayout(
      page: _page,
      totalPages: 10,
      child: MyPagination(
        page: _page,
        totalPages: 10,
        maxPages: 5,
        onPageChanged: (page) => setState(() => _page = page),
      ),
    );
  }
}

class _CompactPaginationExample extends StatefulWidget {
  const _CompactPaginationExample();

  @override
  State<_CompactPaginationExample> createState() =>
      _CompactPaginationExampleState();
}

class _CompactPaginationExampleState extends State<_CompactPaginationExample> {
  int _page = 6;

  @override
  Widget build(BuildContext context) {
    return _PaginationExampleLayout(
      page: _page,
      totalPages: 16,
      child: MyPagination(
        page: _page,
        totalPages: 16,
        maxPages: 5,
        showLabel: false,
        onPageChanged: (page) => setState(() => _page = page),
      ),
    );
  }
}

class _LargePaginationExample extends StatefulWidget {
  const _LargePaginationExample();

  @override
  State<_LargePaginationExample> createState() =>
      _LargePaginationExampleState();
}

class _LargePaginationExampleState extends State<_LargePaginationExample> {
  int _page = 58;

  @override
  Widget build(BuildContext context) {
    return _PaginationExampleLayout(
      page: _page,
      totalPages: 120,
      child: MyPagination(
        page: _page,
        totalPages: 120,
        maxPages: 5,
        showLabel: false,
        onPageChanged: (page) => setState(() => _page = page),
      ),
    );
  }
}

class _BoundaryPaginationExample extends StatefulWidget {
  const _BoundaryPaginationExample();

  @override
  State<_BoundaryPaginationExample> createState() =>
      _BoundaryPaginationExampleState();
}

class _BoundaryPaginationExampleState
    extends State<_BoundaryPaginationExample> {
  int _firstPage = 1;
  int _lastPage = 8;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        _PaginationExampleLayout(
          label: 'First page',
          page: _firstPage,
          totalPages: 8,
          child: MyPagination(
            page: _firstPage,
            totalPages: 8,
            maxPages: 4,
            hidePreviousOnFirstPage: true,
            onPageChanged: (page) => setState(() => _firstPage = page),
          ),
        ),
        _PaginationExampleLayout(
          label: 'Last page',
          page: _lastPage,
          totalPages: 8,
          child: MyPagination(
            page: _lastPage,
            totalPages: 8,
            maxPages: 4,
            hideNextOnLastPage: true,
            onPageChanged: (page) => setState(() => _lastPage = page),
          ),
        ),
      ],
    );
  }
}

class _PaginationExampleLayout extends StatelessWidget {
  const _PaginationExampleLayout({
    required this.page,
    required this.totalPages,
    required this.child,
    this.label,
  });

  final int page;
  final int totalPages;
  final Widget child;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          if (label != null)
            MyText(
              label!,
              style: context.bodySmall.copyWith(
                color: context.colorScheme.mutedForeground,
              ),
            ),
          child,
          MyText(
            'Page $page of $totalPages',
            style: context.bodySmall.copyWith(
              color: context.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
