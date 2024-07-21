part of 'extensions.dart';

extension StringToColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color fromHex() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Lighten the color by [percentage] (0.0 to 1.0).
  Color lighten([double percentage = .1]) {
    assert(
      percentage >= 0 && percentage <= 1,
      'Percentage must be between 0 and 1',
    );

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + percentage).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }

  /// Darken the color by [percentage] (0.0 to 1.0).
  Color darken([double percentage = .1]) {
    assert(
      percentage >= 0 && percentage <= 1,
      'Percentage must be between 0 and 1',
    );

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness(
      (hsl.lightness - percentage).clamp(0.0, 1.0),
    );

    return hslDark.toColor();
  }

  /// Mixes a color with [another]. [amount] is from 0 to 1.
  Color? mix(Color another, double amount) => Color.lerp(this, another, amount);

  /// Returns `true` if the color is dark, otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// bool isDark = color.isDark;
  /// print('Is Dark: $isDark'); // Output: false
  /// ```
  bool get isDark => getBrightness < 128.0;

  /// Returns `true` if the color is light, otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// bool isLight = color.isLight;
  /// print('Is Light: $isLight'); // Output: true
  /// ```
  bool get isLight => !isDark;

  /// Returns the brightness of the color.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// double brightness = color.getBrightness;
  /// print('Brightness: $brightness'); // Output: 110.622
  /// ```
  double get getBrightness => (red * 299 + green * 587 + blue * 114) / 1000;

  /// Returns the luminance of the color.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// double luminance = color.getLuminance;
  /// print('Luminance: $luminance'); // Output: 0.2126
  /// ```
  double get getLuminance => computeLuminance();

  /// Creates a MaterialColor from the color.
  ///
  /// Example:
  /// ```dart
  /// Color color = Colors.blue;
  /// MaterialColor materialColor = color.createMaterialColor();
  /// print('Material Color: $materialColor'); // Output: MaterialColor(primary value: 428051,
  ///                                           //   {50: Color(0xffe3f2fd), 100: Color(0xffbbdefb),
  ///                                           //   200: Color(0xff90caf9), 300: Color(0xff64b5f6),
  ///                                           //   400: Color(0xff42a5f5), 500: Color(0xff2196f3),
  ///                                           //   600: Color(0xff1e88e5), 700: Color(0xff1976d2),
  ///                                           //   800: Color(0xff1565c0), 900: Color(0xff0d47a1)});
  /// ```
  MaterialColor createMaterialColor() {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    int r = red, g = green, b = blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }
}
