import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';
import '../../base/example_widget.dart';

class UserModel {
  final String? id;
  final String? title;

  UserModel({this.id, this.title});
}

class MyDropdownPage extends StatefulWidget {
  const MyDropdownPage({super.key});

  @override
  State<MyDropdownPage> createState() => _MyDropdownPageState();
}

class _MyDropdownPageState extends State<MyDropdownPage> {
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
            ExampleItem(desc: 'Form', builder: _formSingleSelect),
            ExampleItem(desc: 'Single Select Search', builder: _singleSearch),
            ExampleItem(desc: 'Multi Select', builder: _multiSelect),
          ],
        ),
      ],
      test: [],
    );
  }

  final fruits = {
    'apple': 'Apple',
    'banana': 'Banana',
    'blueberry': 'Blueberry',
    'grapes': 'Grapes',
    'pineapple': 'Pineapple',
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
          ...fruits.entries.map(
            (e) => MyOption(value: e.key, child: Text(e.value)),
          ),
        ],
        selectedOptionBuilder: (context, value) => Text(fruits[value]!),
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
              print('sadsad $v');
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
      minWidth: 180,
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
            style: context.bodyLarge,
            textAlign: TextAlign.start,
          ),
        ),
        ...fruits.entries.map(
          (e) => MyOption(value: e.key, child: Text(e.value)),
        ),
      ],
      selectedOptionsBuilder: (context, values) =>
          Text(values.map((v) => v.capitalize).join(', ')),
    );
  }
}
