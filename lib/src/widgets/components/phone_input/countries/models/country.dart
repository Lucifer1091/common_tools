import '../country_data.dart';
import 'currency_info.dart';

class Country {
  const Country({
    required this.name,
    required this.iso2,
    required this.iso3,
    required this.region,
    required this.flagEmoji,
    required this.dialCode,
    required this.currencies,
    required this.languages,
    required this.timezones,
  });

  final String name;
  final String iso2;
  final String iso3;
  final String region;
  final String flagEmoji;
  final String dialCode;
  final List<CurrencyInfo> currencies;
  final List<String> languages;
  final List<String> timezones;

  static Country? fromCountryCode(String? code) {
    if (code == null) return null;

    final query = code.trim().toUpperCase();
    if (query.isEmpty) return null;

    for (final country in CountryData.all) {
      if (country.iso2.toUpperCase() == query ||
          country.iso3.toUpperCase() == query) {
        return country;
      }
    }

    return null;
  }
}
