import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../common/my_decoration.dart';
import '../../common/portal.dart';
import '../input/my_input.dart';
import '../select/select.dart';
import 'countries/country_data.dart';
import 'countries/models/models.dart';

class MyPhoneNumber {
  const MyPhoneNumber({required this.country, required this.nationalNumber});

  final Country? country;
  final String nationalNumber;

  String get internationalNumber {
    final country = this.country;
    if (country == null) return nationalNumber;
    return '${country.dialCode}$nationalNumber';
  }

  String? get value {
    if (country == null || nationalNumber.isEmpty) return null;
    return internationalNumber;
  }

  MyPhoneNumber copyWith({Country? country, String? nationalNumber}) {
    return MyPhoneNumber(
      country: country ?? this.country,
      nationalNumber: nationalNumber ?? this.nationalNumber,
    );
  }

  @override
  String toString() => value ?? '';

  @override
  bool operator ==(Object other) {
    return other is MyPhoneNumber &&
        other.country == country &&
        other.nationalNumber == nationalNumber;
  }

  @override
  int get hashCode => Object.hash(country, nationalNumber);
}

class MyPhoneInput extends StatefulWidget {
  const MyPhoneInput({
    super.key,
    this.initialCountry,
    this.initialValue,
    this.controller,
    this.countries,
    this.enabled = true,
    this.readOnly = false,
    this.placeholder,
    this.searchPlaceholder,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.decoration,
    this.keyboardToolbarBuilder,
  });

  final Country? initialCountry;
  final MyPhoneNumber? initialValue;
  final TextEditingController? controller;
  final List<Country>? countries;
  final bool enabled;
  final bool readOnly;
  final String? placeholder;
  final String? searchPlaceholder;
  final ValueChanged<MyPhoneNumber?>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final MyDecoration? decoration;
  final WidgetBuilder? keyboardToolbarBuilder;

  @override
  State<MyPhoneInput> createState() => _MyPhoneInputState();
}

class _MyPhoneInputState extends State<MyPhoneInput> {
  late List<Country> _effectiveCountries;
  late MySelectController<Country> _countryController;
  late TextEditingController _controller;
  TextEditingController? _internalController;
  Country? _selectedCountry;
  bool _updatingController = false;

  @override
  void initState() {
    super.initState();
    _effectiveCountries = _resolveCountries(widget.countries);
    _selectedCountry = _resolveInitialCountry();
    _controller = widget.controller ?? _createInternalController();
    _countryController = MySelectController<Country>(
      initialValue: {?_selectedCountry},
    );
    _controller.addListener(_handleControllerChanged);
    _normalizeControllerText(emitChanged: false);
  }

  @override
  void didUpdateWidget(covariant MyPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.countries != widget.countries) {
      _effectiveCountries = _resolveCountries(widget.countries);
      final nextCountry =
          _countryFromEffective(_selectedCountry) ?? _resolveInitialCountry();
      _setSelectedCountry(nextCountry, emitChanged: false);
    }

    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleControllerChanged);
      if (oldWidget.controller == null && widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      }
      if (oldWidget.controller != null && widget.controller == null) {
        _internalController = TextEditingController(text: _controller.text);
      }
      _controller = widget.controller ?? _internalController!;
      _controller.addListener(_handleControllerChanged);
      _normalizeControllerText(emitChanged: false);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _countryController.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  TextEditingController _createInternalController() {
    return _internalController = TextEditingController(
      text: widget.initialValue?.nationalNumber ?? '',
    );
  }

  List<Country> _resolveCountries(List<Country>? countries) {
    final source = countries ?? CountryData.all;
    return source
        .where((country) => country.dialCode.trim().isNotEmpty)
        .toList(growable: false);
  }

  Country? _resolveInitialCountry() {
    final preferred =
        widget.initialValue?.country ??
        widget.initialCountry ??
        Country.fromCountryCode('US');
    return _countryFromEffective(preferred) ??
        _countryByCode('US') ??
        (_effectiveCountries.isEmpty ? null : _effectiveCountries.first);
  }

  Country? _countryFromEffective(Country? country) {
    if (country == null) return null;
    for (final candidate in _effectiveCountries) {
      if (identical(candidate, country) ||
          candidate.iso2.toUpperCase() == country.iso2.toUpperCase() ||
          candidate.iso3.toUpperCase() == country.iso3.toUpperCase()) {
        return candidate;
      }
    }
    return null;
  }

  Country? _countryByCode(String code) {
    final query = code.toUpperCase();
    for (final country in _effectiveCountries) {
      if (country.iso2.toUpperCase() == query ||
          country.iso3.toUpperCase() == query) {
        return country;
      }
    }
    return null;
  }

  Country? _countryByDialCode(String text) {
    final normalized = text.startsWith('+') ? text : '+$text';
    final countries = _effectiveCountries.toList(growable: false)
      ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

    for (final country in countries) {
      if (normalized.startsWith(country.dialCode)) {
        return country;
      }
    }
    return null;
  }

  bool _matchesCountry(Country country, String? searchQuery) {
    final query = searchQuery?.trim().toLowerCase();
    if (query == null || query.isEmpty) return true;
    return country.name.toLowerCase().contains(query) ||
        country.iso2.toLowerCase().contains(query) ||
        country.iso3.toLowerCase().contains(query) ||
        country.dialCode.toLowerCase().contains(query);
  }

  void _handleControllerChanged() {
    if (_updatingController) return;
    _normalizeControllerText(emitChanged: true);
  }

  void _normalizeControllerText({required bool emitChanged}) {
    final current = _controller.value;
    final rawText = current.text;
    final pastedInternationalNumber = rawText.startsWith('+');
    Country? detectedCountry;
    var nationalNumber = rawText;

    if (pastedInternationalNumber) {
      detectedCountry = _countryByDialCode(rawText);
      if (detectedCountry != null) {
        nationalNumber = rawText.substring(detectedCountry.dialCode.length);
      }
    }

    nationalNumber = nationalNumber.replaceAll(RegExp(r'\D'), '');

    if (nationalNumber != rawText) {
      _updatingController = true;
      _controller.value = TextEditingValue(
        text: nationalNumber,
        selection: TextSelection.collapsed(offset: nationalNumber.length),
      );
      _updatingController = false;
    }

    if (detectedCountry != null && detectedCountry != _selectedCountry) {
      _setSelectedCountry(detectedCountry, emitChanged: false);
    }

    if (emitChanged) {
      widget.onChanged?.call(value);
    }
  }

  void _setSelectedCountry(Country? country, {required bool emitChanged}) {
    if (country == _selectedCountry) return;
    setState(() {
      _selectedCountry = country;
      _countryController.value = {?country};
    });
    if (emitChanged) {
      widget.onChanged?.call(value);
    }
  }

  MyPhoneNumber? get value {
    return MyPhoneNumber(
      country: _selectedCountry,
      nationalNumber: _controller.text,
    );
  }

  Widget _buildSelectedCountry(BuildContext context, Country country) {
    return SizedBox(
      width: 24,
      child: Text(
        country.flagEmoji,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, height: 1),
      ),
    );
  }

  Widget _buildCountryOption(BuildContext context, Country country) {
    return MyOption<Country>(
      value: country,
      key: ValueKey(country.iso2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              country.flagEmoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, height: 1),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(country.name, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 16),
          Text(
            country.dialCode,
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountrySelector(BuildContext context) {
    return SizedBox(
      key: const Key('my-phone-input-country-selector'),
      width: 28,
      height: 28,
      child: MySelect<Country>.withSearch(
        controller: _countryController,
        enabled: widget.enabled && !widget.readOnly,
        initialValue: _selectedCountry,
        minWidth: 0,
        maxWidth: 250,
        maxHeight: 300,
        popupWidth: MySelectPopupWidth.minTrigger,
        decoration: MyDecoration.none,
        padding: const EdgeInsets.only(right: 4),
        optionsPadding: const EdgeInsets.all(4),
        anchor: const MyAnchorAuto(
          followerAnchor: Alignment.topLeft,
          targetAnchor: Alignment.bottomLeft,
          offset: Offset(-12, 8),
        ),
        showScrollToBottomChevron: false,
        showScrollToTopChevron: false,
        searchPlaceholder: widget.searchPlaceholder,
        trailing: const SizedBox.shrink(),
        selectedOptionBuilder: _buildSelectedCountry,
        placeholder: const Text('Country'),
        itemsBuilder: (context, searchQuery) {
          final countries = _effectiveCountries
              .where((country) => _matchesCountry(country, searchQuery))
              .toList(growable: false);
          return MySelectItemList([
            for (final country in countries)
              _buildCountryOption(context, country),
          ]);
        },
        onChanged: (country) {
          _setSelectedCountry(country, emitChanged: true);
        },
      ),
    );
  }

  Widget _buildPhonePrefix(BuildContext context) {
    final country = _selectedCountry;
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCountrySelector(context),
          const SizedBox(width: 8),
          Container(width: 1, height: 28, color: context.colorScheme.input),
          const SizedBox(width: 12),
          if (country != null) Text(country.dialCode),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyInput(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      placeholder: widget.placeholder,
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      autofillHints:
          widget.autofillHints ?? const [AutofillHints.telephoneNumber],
      inputFormatters: [
        const _PhoneInputTextFormatter(),
        ...?widget.inputFormatters,
      ],
      decoration: widget.decoration,
      keyboardToolbarBuilder: widget.keyboardToolbarBuilder,
      leading: _buildPhonePrefix(context),
    );
  }
}

class _PhoneInputTextFormatter extends TextInputFormatter {
  const _PhoneInputTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final buffer = StringBuffer();
    for (var i = 0; i < newValue.text.length; i++) {
      final character = newValue.text[i];
      if (i == 0 && character == '+') {
        buffer.write(character);
      } else if (_isDigit(character)) {
        buffer.write(character);
      }
    }

    final text = buffer.toString();
    if (text == newValue.text) return newValue;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  bool _isDigit(String value) {
    final codeUnit = value.codeUnitAt(0);
    return codeUnit >= 48 && codeUnit <= 57;
  }
}
