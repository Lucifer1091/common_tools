import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class UserModel {
  final String? id;
  final String? title;

  UserModel({this.id, this.title});
}

class MyelectPage extends StatefulWidget {
  const MyelectPage({super.key});

  @override
  State<MyelectPage> createState() => _MyelectPageState();
}

class _MyelectPageState extends State<MyelectPage> {
  late final GlobalKey<MyFormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<MyFormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          'Displays a list of options for the user to pick from—triggered by a button.',
      exampleCodeGroup: 'dropdownMenu',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Single Select', builder: _singleSelect),
            ExampleItem(
              desc: 'Scrollable Single Select',
              builder: _scrollableSingleSelect,
            ),
            ExampleItem(desc: 'Select Form Field', builder: _formSingleSelect),
            ExampleItem(desc: 'Single Select Search', builder: _singleSearch),
            ExampleItem(desc: 'Multi Select', builder: _multiSelect),
            ExampleItem(desc: 'Async Select', builder: _asyncSelect),
          ],
        ),
        ExampleModule(
          title: 'Advanced Usage',
          children: [
            ExampleItem(
              desc: 'Builder Options',
              builder: _builderOptionsSelect,
            ),
            ExampleItem(
              desc: 'Flexible Popup Width',
              builder: _flexiblePopupWidthSelect,
            ),
            ExampleItem(
              desc: 'Custom Search UI',
              builder: _customSearchUiSelect,
            ),
            ExampleItem(desc: 'Async Error State', builder: _asyncErrorSelect),
          ],
        ),
      ],
      test: [],
    );
  }

  final List<String> fruits = [
    'Apple',
    'Banana',
    'Blueberry',
    'Grapes',
    'Pineapple',
    'Mango',
    'Strawberry',
    'Orange',
    'Watermelon',
    'Kiwi',
    'Peach',
    'Pear',
    'Pomegranate',
    'Papaya',
    'Cherry',
    'Lemon',
    'Coconut',
  ];

  final releaseChannels = {
    'stable': 'Stable - production ready with the smallest change surface',
    'beta': 'Beta - newer features with moderate release risk',
    'nightly': 'Nightly - fastest updates and the widest API surface',
  };

  Widget _singleSelect(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180),
      child: MySelect<String>(
        placeholder: const Text('Select a fruit'),
        options: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              'Fruits',
              style: context.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.popoverForeground,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          ...fruits
              .sublist(0, 5)
              .map((e) => MyOption(value: e, child: Text(e))),
        ],
        onChanged: print,
      ),
    );
  }

  final timezones = {
    'North America': {
      'est': 'Eastern Standard Time (EST)',
      'cst': 'Central Standard Time (CST)',
      'mst': 'Mountain Standard Time (MST)',
      'pst': 'Pacific Standard Time (PST)',
      'akst': 'Alaska Standard Time (AKST)',
      'hst': 'Hawaii Standard Time (HST)',
    },
    'Europe & Africa': {
      'gmt': 'Greenwich Mean Time (GMT)',
      'cet': 'Central European Time (CET)',
      'eet': 'Eastern European Time (EET)',
      'west': 'Western European Summer Time (WEST)',
      'cat': 'Central Africa Time (CAT)',
      'eat': 'Eastern Africa Time (EAT)',
    },
    'Asia': {
      'msk': 'Moscow Time (MSK)',
      'ist': 'India Standard Time (IST)',
      'cst_china': 'China Standard Time (CST)',
      'jst': 'Japan Standard Time (JST)',
      'kst': 'Korea Standard Time (KST)',
      'ist_indonasia': 'Indonesia Standard Time (IST)',
    },
    'Australia & Pacific': {
      'awst': 'Australian Western Standard Time (AWST)',
      'acst': 'Australian Central Standard Time (ACST)',
      'aest': 'Australian Eastern Standard Time (AEST)',
      'nzst': 'New Zealand Standard Time (NZST)',
      'fjt': 'Fiji Time (FJT)',
    },
    'South America': {
      'art': 'Argentina Time (ART)',
      'bot': 'Bolivia Time (BOT)',
      'brt': 'Brasilia Time (BRT)',
      'clt': 'Chile Standard Time (CLT)',
    },
  };

  List<Widget> getTimezonesWidgets(MyThemeData theme) {
    final widgets = <Widget>[];
    for (final zone in timezones.entries) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            zone.key,
            style: theme.typography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.popoverForeground,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      );
      widgets.addAll(
        zone.value.entries.map(
          (e) => MyOption(value: e.key, child: Text(e.value)),
        ),
      );
    }
    return widgets;
  }

  Widget _scrollableSingleSelect(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280),
      child: MySelect<String>(
        placeholder: const Text('Select a timezone'),
        options: getTimezonesWidgets(context.theme),
        selectedOptionBuilder: (context, value) {
          final timezone = timezones.entries
              .firstWhere((element) => element.value.containsKey(value))
              .value[value];
          return Text(timezone!);
        },
      ),
    );
  }

  final verifiedEmails = ['m@example.com', 'm@google.com', 'm@support.com'];

  Widget _formSingleSelect(BuildContext context) {
    return MyForm(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          MySelectFormField<String>(
            minWidth: 350,
            label: const Text('Email'),
            options: verifiedEmails
                .map((email) => MyOption(value: email, child: Text(email)))
                .toList(),
            selectedOptionBuilder: (context, value) => value == 'none'
                ? const Text('Select a verified email to display')
                : Text(value),
            placeholder: const Text('Select a verified email to display'),
            validator: (v) {
              if (v == null) {
                return 'Please select an email to display';
              }
              return null;
            },
          ),
          MyButton(
            text: 'Submit',
            onTap: () {
              _formKey.currentState?.validate();
            },
          ),
        ],
      ).padding(horizontal: 16),
    );
  }

  final frameworks = {
    'nextjs': 'Next.js',
    'svelte': 'SvelteKit',
    'nuxtjs': 'Nuxt.js',
    'remix': 'Remix',
    'astro': 'Astro',
  };

  var searchValue = '';

  Map<String, String> get filteredFrameworks => {
    for (final framework in frameworks.entries)
      if (framework.value.toLowerCase().contains(searchValue.toLowerCase()))
        framework.key: framework.value,
  };

  Widget _singleSearch(BuildContext context) {
    return MySelect<String>.withSearch(
      minWidth: 200,
      maxWidth: 300,
      placeholder: const Text('Select framework...'),
      onSearchChanged: (value) => setState(() => searchValue = value),
      searchPlaceholder: 'Search framework',
      options: [
        if (filteredFrameworks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('No framework found'),
          ),
        ...frameworks.entries.map((framework) {
          // this offstage is used to avoid the focus loss when the search results appear again
          // because it keeps the widget in the tree.
          return Offstage(
            offstage: !filteredFrameworks.containsKey(framework.key),
            child: MyOption(value: framework.key, child: Text(framework.value)),
          );
        }),
      ],
      selectedOptionBuilder: (context, value) => Text(frameworks[value]!),
    );
  }

  Widget _multiSelect(BuildContext context) {
    return MySelect<String>.multiple(
      minWidth: 340,
      onChanged: print,
      allowDeselection: true,
      closeOnSelect: false,
      placeholder: const Text('Select multiple fruits'),
      options: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            'Fruits',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.popoverForeground,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        ...fruits.map(
          (e) =>
              MyOption(value: e, direction: TextDirection.rtl, child: Text(e)),
        ),
      ],
    );
  }

  Widget _builderOptionsSelect(BuildContext context) {
    final fruitEntries = fruits.toList(growable: false);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220),
      child: MySelect<String>(
        minWidth: 220,
        itemCount: fruitEntries.length + 1,
        placeholder: const Text('Select a fruit with optionsBuilder'),
        optionsBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                'Built lazily',
                style: context.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.popoverForeground,
                ),
                textAlign: TextAlign.start,
              ),
            );
          }

          final fruit = fruitEntries[index - 1];
          return MyOption(value: fruit, child: Text('$fruit)'));
        },
      ),
    );
  }

  Widget _flexiblePopupWidthSelect(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220),
      child: MySelect<String>(
        minWidth: 220,
        maxWidth: 420,
        popupWidth: MySelectPopupWidth.minTrigger,
        placeholder: const Text('Select a release channel'),
        items: MySelectItemList([
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              'Release channels',
              style: context.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.popoverForeground,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          ...releaseChannels.entries.map(
            (entry) => MyOption(value: entry.key, child: Text(entry.value)),
          ),
        ]),
        selectedOptionBuilder: (context, value) =>
            Text(releaseChannels[value]!.split(' - ').first),
      ),
    );
  }

  MySelectItemDelegate _buildTimezoneItems(
    BuildContext context,
    String? searchQuery,
  ) {
    final query = searchQuery?.trim().toLowerCase();
    final matches = <MapEntry<String, String>>[];

    for (final region in timezones.entries) {
      for (final zone in region.value.entries) {
        final searchableText = '${region.key} ${zone.key} ${zone.value}'
            .toLowerCase();
        if (query == null || query.isEmpty || searchableText.contains(query)) {
          matches.add(MapEntry(zone.key, '${zone.value} • ${region.key}'));
        }
      }
    }

    if (matches.isEmpty) {
      return MySelectItemDelegate.empty;
    }

    return MySelectItemList(
      matches
          .map((entry) => MyOption(value: entry.key, child: Text(entry.value)))
          .toList(growable: false),
    );
  }

  Widget _customSearchUiSelect(BuildContext context) {
    return MySelect<String>.withSearch(
      minWidth: 280,
      maxWidth: 360,
      placeholder: const Text('Search a timezone'),
      searchPlaceholder: 'Search by region or timezone',
      searchInputLeading: const Icon(Icons.travel_explore_rounded, size: 18),
      searchPadding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      header: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Text(
          'Results update as you type',
          textAlign: TextAlign.start,
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.popoverForeground,
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Text(
          'Tip: search by region name like Asia or by abbreviations like PST.',
          textAlign: TextAlign.start,
          style: context.bodySmall.copyWith(
            color: context.colorScheme.popoverForeground.withValues(alpha: .7),
          ),
        ),
      ),
      itemsBuilder: _buildTimezoneItems,
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No timezone matched your search'),
      ),
      selectedOptionBuilder: (context, value) {
        final timezone = timezones.entries
            .firstWhere((region) => region.value.containsKey(value))
            .value[value];
        return Text(timezone!);
      },
    );
  }

  Future<MySelectItemDelegate> _buildAsyncFruitItems(
    BuildContext context,
    String? searchQuery,
  ) async {
    final headerStyle = context.bodyMedium.copyWith(
      fontWeight: FontWeight.w600,
      color: context.colorScheme.popoverForeground,
    );
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final query = searchQuery?.trim().toLowerCase();
    final filteredFruits = fruits
        .where(
          (fruit) =>
              query == null ||
              query.isEmpty ||
              fruit.toLowerCase().contains(query),
        )
        .toList();

    if (filteredFruits.isEmpty) {
      return MySelectItemDelegate.empty;
    }

    return MySelectItemList([
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text('Fruits', style: headerStyle, textAlign: TextAlign.start),
      ),
      ...filteredFruits.map(
        (fruit) => MyOption(value: fruit, child: Text(fruit)),
      ),
    ]);
  }

  Future<MySelectItemDelegate> _buildAsyncErrorItems(
    BuildContext context,
    String? searchQuery,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    throw StateError(
      'This example fails intentionally so the custom error state stays visible.',
    );
  }

  Widget _asyncSelect(BuildContext context) {
    return MySelect<String>.multipleWithSearch(
      minWidth: 340,
      onChanged: print,
      placeholder: const Text('Select multiple fruits'),
      itemsBuilder: _buildAsyncFruitItems,
      searchPlaceholder: 'Search fruits',
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No fruits found'),
      ),
    );
  }

  Widget _asyncErrorSelect(BuildContext context) {
    return MySelect<String>.withSearch(
      minWidth: 320,
      placeholder: const Text('Open to preview async error handling'),
      searchPlaceholder: 'This request fails on purpose',
      itemsBuilder: _buildAsyncErrorItems,
      errorBuilder: (context, error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Text(
          'Could not load options.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
