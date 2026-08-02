import 'package:example/common_tools_catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

enum _AutoCompleteFilterMode { contains, startsWith }

class MyInputViewPage extends StatefulWidget {
  const MyInputViewPage({super.key});

  @override
  State<MyInputViewPage> createState() => _MyInputViewPageState();
}

class _MyInputViewPageState extends State<MyInputViewPage> {
  var controller = <TextEditingController>[];
  late final GlobalKey<MyFormState> _formKey;
  final _externalAutoCompleteController = TextEditingController();
  final _filteredAutoCompleteController = TextEditingController();
  final _chipInputController = MyChipEditingController<String>();
  List<String> _externalSuggestions = const [];
  List<String> _chipSuggestions = const [];
  MyAutoCompleteMode _autoCompleteMode = MyAutoCompleteMode.replaceWord;
  _AutoCompleteFilterMode _filterMode = _AutoCompleteFilterMode.contains;

  static const _fruits = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Grape',
    'Kiwi',
    'Lemon',
    'Mango',
    'Orange',
    'Peach',
    'Pear',
    'Pineapple',
    'Strawberry',
    'Watermelon',
  ];

  @override
  void initState() {
    _formKey = GlobalKey<MyFormState>();

    for (var i = 0; i < 28; i++) {
      controller.add(TextEditingController());
    }
    _chipInputController.addListener(_updateChipSuggestions);
    super.initState();
  }

  @override
  void dispose() {
    for (var e in controller) {
      e.dispose();
    }
    _externalAutoCompleteController.dispose();
    _filteredAutoCompleteController.dispose();
    _chipInputController.dispose();
    super.dispose();
  }

  bool enabled = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc:
          'Displays a form input field or a component that looks like an input field.',
      exampleCodeGroup: 'input',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(
              desc: 'Text Field',
              builder: (context) {
                return MyInputFormField(
                  label: Text('Email'),
                  placeholder: 'abs@gmail.com',
                  controller: TextEditController(),
                ).padding(horizontal: 16);
              },
            ),
            ExampleItem(
              desc: 'With leading and trailing',
              builder: (context) {
                return Column(
                  spacing: 16,
                  children: [
                    Row(
                      children: [
                        MyCell(
                          title: 'Enabled',
                          hover: false,
                          rightIconWidget: MySwitch(
                            isOn: enabled,
                            onChanged: (value) {
                              setState(() => enabled = value);
                              return value;
                            },
                          ),
                        ).expanded(),
                        Gap(16),
                        MyCell(
                          title: 'Obscure',
                          hover: false,
                          rightIconWidget: MySwitch(
                            isOn: obscure,
                            onChanged: (value) {
                              setState(() => obscure = value);
                              return value;
                            },
                          ),
                        ).expanded(),
                      ],
                    ),
                    MyInput(
                      enabled: enabled,
                      leading: Icon(
                        LucideIcons.mail,
                        color: context.colorScheme.mutedForeground,
                        size: 18,
                      ),
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    MyInput(
                      enabled: enabled,
                      obscureText: obscure,
                      placeholder: 'Password',
                      leading: Icon(
                        LucideIcons.lock,
                        color: context.colorScheme.mutedForeground,
                        size: 18,
                      ),
                      trailing: MyButton(
                        enabled: enabled,
                        height: 20,
                        width: 20,
                        padding: EdgeInsets.zero,
                        focus: MyFocusableParams(canRequestFocus: false),
                        type: MyButtonType.text,
                        shape: MyButtonShape.square,
                        icon: obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                        onTap: () {
                          setState(() => obscure = !obscure);
                        },
                      ),
                    ),
                  ],
                ).padding(horizontal: 16);
              },
            ),
            ExampleItem(
              desc: 'Text Form Field',
              builder: (context) {
                return MyForm(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      MyInputFormField(
                        id: 'username',
                        label: const Text('Username'),
                        placeholder: 'Enter your username',
                        description: const Text(
                          'This is your public display name.',
                        ),
                        validator: (v) {
                          if (v.length < 2) {
                            return 'Username must be at least 2 characters.';
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
              },
            ),
          ],
        ),
        ExampleModule(
          title: 'Chip Input',
          children: [
            ExampleItem(
              desc: 'Inline autocomplete',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildChipInput,
            ),
          ],
        ),
        ExampleModule(
          title: 'Autocomplete',
          children: [
            ExampleItem(
              desc: 'External suggestions',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildExternalAutoComplete,
            ),
            ExampleItem(
              desc: 'Built-in filtering playground',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildFilteredAutoComplete,
            ),
          ],
        ),
      ],
    );
  }

  void _updateChipSuggestions() {
    final query = _chipInputController.textAtCursor;
    final suggestions = query.isEmpty
        ? const <String>[]
        : _fruits
              .where((option) => option.toLowerCase().startsWith(query))
              .toList(growable: false);
    if (listEquals(suggestions, _chipSuggestions)) return;
    setState(() => _chipSuggestions = suggestions);
  }

  Widget _buildChipInput(BuildContext context) {
    return MyAutoComplete(
      controller: _chipInputController,
      suggestions: _chipSuggestions,
      child: MyChipInput<String>(
        controller: _chipInputController,
        placeholder: 'Type a fruit and press Enter',
        clipboardHandler: const MyDecoratedChipClipboardHandler<String>(
          prefix: '@',
          delimiter: ';',
          chipDeserializer: _deserializeChip,
        ),
        onChipSubmitted: (value) {
          setState(() => _chipSuggestions = const []);
          return value;
        },
        chipBuilder: (context, chip) => Text('@$chip'),
      ),
    );
  }

  static String _deserializeChip(String value) => value;

  void _updateExternalSuggestions(String value) {
    final currentWord = _externalAutoCompleteController.currentWord;
    setState(() {
      if (currentWord == null || currentWord.isEmpty) {
        _externalSuggestions = const [];
      } else {
        final query = currentWord.toLowerCase();
        _externalSuggestions = _fruits
            .where((fruit) => fruit.toLowerCase().contains(query))
            .toList(growable: false);
      }
    });
  }

  Widget _buildExternalAutoComplete(BuildContext context) {
    return MyAutoComplete(
      controller: _externalAutoCompleteController,
      suggestions: _externalSuggestions,
      child: MyInput(
        controller: _externalAutoCompleteController,
        placeholder: 'Type a fruit',
        leading: Icon(
          LucideIcons.search,
          size: 18,
          color: context.colorScheme.mutedForeground,
        ),
        trailing: ListenableBuilder(
          listenable: _externalAutoCompleteController,
          builder: (context, child) {
            if (_externalAutoCompleteController.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return MyButton(
              height: 28,
              width: 28,
              padding: EdgeInsets.zero,
              type: MyButtonType.text,
              shape: MyButtonShape.square,
              icon: LucideIcons.x,
              focus: MyFocusableParams(canRequestFocus: false),
              onTap: () {
                _externalAutoCompleteController.clear();
                _updateExternalSuggestions('');
              },
            );
          },
        ),
        onChanged: _updateExternalSuggestions,
      ),
    );
  }

  Widget _buildFilteredAutoComplete(BuildContext context) {
    final filterLabel = switch (_filterMode) {
      _AutoCompleteFilterMode.contains => 'Contains',
      _AutoCompleteFilterMode.startsWith => 'Starts with',
    };
    final modeLabel = switch (_autoCompleteMode) {
      MyAutoCompleteMode.append => 'Append',
      MyAutoCompleteMode.replaceWord => 'Replace word',
      MyAutoCompleteMode.replaceAll => 'Replace all',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 180,
              child: MySelect<MyAutoCompleteMode>(
                initialValue: _autoCompleteMode,
                placeholder: const Text('Completion mode'),
                selectedOptionBuilder: (context, value) => Text(modeLabel),
                options: const [
                  MyOption(
                    value: MyAutoCompleteMode.append,
                    child: Text('Append'),
                  ),
                  MyOption(
                    value: MyAutoCompleteMode.replaceWord,
                    child: Text('Replace word'),
                  ),
                  MyOption(
                    value: MyAutoCompleteMode.replaceAll,
                    child: Text('Replace all'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _autoCompleteMode = value);
                  }
                },
              ),
            ),
            SizedBox(
              width: 180,
              child: MySelect<_AutoCompleteFilterMode>(
                initialValue: _filterMode,
                placeholder: const Text('Filter behavior'),
                selectedOptionBuilder: (context, value) => Text(filterLabel),
                options: const [
                  MyOption(
                    value: _AutoCompleteFilterMode.contains,
                    child: Text('Contains'),
                  ),
                  MyOption(
                    value: _AutoCompleteFilterMode.startsWith,
                    child: Text('Starts with'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _filterMode = value);
                },
              ),
            ),
          ],
        ),
        MyAutoComplete.filtered(
          controller: _filteredAutoCompleteController,
          options: _fruits,
          mode: _autoCompleteMode,
          popoverConstraints: const BoxConstraints(maxHeight: 220),
          suggestionFilter: (option, query) {
            final normalizedOption = option.toLowerCase();
            final normalizedQuery = query.toLowerCase();
            return switch (_filterMode) {
              _AutoCompleteFilterMode.contains => normalizedOption.contains(
                normalizedQuery,
              ),
              _AutoCompleteFilterMode.startsWith => normalizedOption.startsWith(
                normalizedQuery,
              ),
            };
          },
          itemBuilder: (context, suggestion, highlighted) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: highlighted ? context.colorScheme.accent : null,
                borderRadius: MyBorderRadius.small,
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(
                    LucideIcons.apple,
                    size: 16,
                    color: context.colorScheme.mutedForeground,
                  ),
                  const Gap(8),
                  Text(suggestion),
                  const Spacer(),
                  if (highlighted)
                    Icon(
                      LucideIcons.cornerDownLeft,
                      size: 14,
                      color: context.colorScheme.mutedForeground,
                    ),
                ],
              ),
            );
          },
          child: MyInput(
            controller: _filteredAutoCompleteController,
            placeholder: 'Try a completion mode',
            leading: Icon(
              LucideIcons.wandSparkles,
              size: 18,
              color: context.colorScheme.mutedForeground,
            ),
          ),
        ),
        const Gap(300),
      ],
    );
  }
}
