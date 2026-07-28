import 'package:flutter/material.dart';

import '../extensions/string/converters.dart';
import './color_schemes/amber.dart';
import './color_schemes/black.dart';
import './color_schemes/blue.dart';
import './color_schemes/brown.dart';
import './color_schemes/cyan.dart';
import './color_schemes/emerald.dart';
import './color_schemes/fuchsia.dart';
import './color_schemes/gold.dart';
import './color_schemes/gray.dart';
import './color_schemes/green.dart';
import './color_schemes/indigo.dart';
import './color_schemes/lime.dart';
import './color_schemes/mauve.dart';
import './color_schemes/mist.dart';
import './color_schemes/neutral.dart';
import './color_schemes/olive.dart';
import './color_schemes/orange.dart';
import './color_schemes/pink.dart';
import './color_schemes/purple.dart';
import './color_schemes/red.dart';
import './color_schemes/rose.dart';
import './color_schemes/sky.dart';
import './color_schemes/slate.dart';
import './color_schemes/stone.dart';
import './color_schemes/taupe.dart';
import './color_schemes/teal.dart';
import './color_schemes/violet.dart';
import './color_schemes/yellow.dart';
import './color_schemes/zinc.dart';

enum MyBaseColor {
  slate,
  gray,
  neutral,
  stone,
  zinc,
  mauve,
  olive,
  mist,
  taupe,
}

enum MyAccentColor {
  slate,
  gray,
  neutral,
  stone,
  zinc,
  mauve,
  olive,
  mist,
  taupe,
  red,
  orange,
  amber,
  yellow,
  lime,
  green,
  emerald,
  teal,
  cyan,
  sky,
  blue,
  indigo,
  violet,
  purple,
  fuchsia,
  pink,
  rose,
  brown,
  gold,
  black,
}

class MyColorScheme {
  const MyColorScheme({
    required this.brightness,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.warning,
    required this.warningForeground,
    required this.success,
    required this.successForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.selection,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });

  factory MyColorScheme.fromName(
    String name, {
    Brightness brightness = Brightness.light,
  }) {
    return switch (name.lowercase) {
      'amber' =>
        brightness == Brightness.light
            ? const MyAmberColorScheme.light()
            : const MyAmberColorScheme.dark(),
      'black' =>
        brightness == Brightness.light
            ? const MyBlackColorScheme.light()
            : const MyBlackColorScheme.dark(),
      'blue' =>
        brightness == Brightness.light
            ? const MyBlueColorScheme.light()
            : const MyBlueColorScheme.dark(),
      'brown' =>
        brightness == Brightness.light
            ? const MyBrownColorScheme.light()
            : const MyBrownColorScheme.dark(),
      'cyan' =>
        brightness == Brightness.light
            ? const MyCyanColorScheme.light()
            : const MyCyanColorScheme.dark(),
      'emerald' =>
        brightness == Brightness.light
            ? const MyEmeraldColorScheme.light()
            : const MyEmeraldColorScheme.dark(),
      'fuchsia' =>
        brightness == Brightness.light
            ? const MyFuchsiaColorScheme.light()
            : const MyFuchsiaColorScheme.dark(),
      'gold' =>
        brightness == Brightness.light
            ? const MyGoldColorScheme.light()
            : const MyGoldColorScheme.dark(),
      'gray' =>
        brightness == Brightness.light
            ? const MyGrayColorScheme.light()
            : const MyGrayColorScheme.dark(),
      'green' =>
        brightness == Brightness.light
            ? const MyGreenColorScheme.light()
            : const MyGreenColorScheme.dark(),
      'indigo' =>
        brightness == Brightness.light
            ? const MyIndigoColorScheme.light()
            : const MyIndigoColorScheme.dark(),
      'lime' =>
        brightness == Brightness.light
            ? const MyLimeColorScheme.light()
            : const MyLimeColorScheme.dark(),
      'mauve' =>
        brightness == Brightness.light
            ? const MyMauveColorScheme.light()
            : const MyMauveColorScheme.dark(),
      'mist' =>
        brightness == Brightness.light
            ? const MyMistColorScheme.light()
            : const MyMistColorScheme.dark(),
      'neutral' =>
        brightness == Brightness.light
            ? const MyNeutralColorScheme.light()
            : const MyNeutralColorScheme.dark(),
      'olive' =>
        brightness == Brightness.light
            ? const MyOliveColorScheme.light()
            : const MyOliveColorScheme.dark(),
      'orange' =>
        brightness == Brightness.light
            ? const MyOrangeColorScheme.light()
            : const MyOrangeColorScheme.dark(),
      'pink' =>
        brightness == Brightness.light
            ? const MyPinkColorScheme.light()
            : const MyPinkColorScheme.dark(),
      'purple' =>
        brightness == Brightness.light
            ? const MyPurpleColorScheme.light()
            : const MyPurpleColorScheme.dark(),
      'red' =>
        brightness == Brightness.light
            ? const MyRedColorScheme.light()
            : const MyRedColorScheme.dark(),
      'rose' =>
        brightness == Brightness.light
            ? const MyRoseColorScheme.light()
            : const MyRoseColorScheme.dark(),
      'sky' =>
        brightness == Brightness.light
            ? const MySkyColorScheme.light()
            : const MySkyColorScheme.dark(),
      'slate' =>
        brightness == Brightness.light
            ? const MySlateColorScheme.light()
            : const MySlateColorScheme.dark(),
      'stone' =>
        brightness == Brightness.light
            ? const MyStoneColorScheme.light()
            : const MyStoneColorScheme.dark(),
      'taupe' =>
        brightness == Brightness.light
            ? const MyTaupeColorScheme.light()
            : const MyTaupeColorScheme.dark(),
      'teal' =>
        brightness == Brightness.light
            ? const MyTealColorScheme.light()
            : const MyTealColorScheme.dark(),
      'violet' =>
        brightness == Brightness.light
            ? const MyVioletColorScheme.light()
            : const MyVioletColorScheme.dark(),
      'yellow' =>
        brightness == Brightness.light
            ? const MyYellowColorScheme.light()
            : const MyYellowColorScheme.dark(),
      'zinc' =>
        brightness == Brightness.light
            ? const MyZincColorScheme.light()
            : const MyZincColorScheme.dark(),

      _ => throw Exception('Invalid color scheme name'),
    };
  }

  factory MyColorScheme.fromParts({
    required MyBaseColor base,
    MyAccentColor? accent,
    Brightness brightness = Brightness.light,
  }) {
    final baseScheme = MyColorScheme.fromName(
      base.name,
      brightness: brightness,
    );
    if (accent == null) return baseScheme;

    final accentScheme = MyColorScheme.fromName(
      accent.name,
      brightness: brightness,
    );

    return baseScheme.copyWith(
      primary: accentScheme.primary,
      primaryForeground: accentScheme.primaryForeground,
      selection: accentScheme.selection,
      chart1: accentScheme.chart1,
      chart2: accentScheme.chart2,
      chart3: accentScheme.chart3,
      chart4: accentScheme.chart4,
      chart5: accentScheme.chart5,
    );
  }

  MyColorScheme.fromJson(Map<String, dynamic> json)
    : background = json._col('background'),
      foreground = json._col('foreground'),
      card = json._col('card'),
      cardForeground = json._col('cardForeground'),
      popover = json._col('popover'),
      popoverForeground = json._col('popoverForeground'),
      primary = json._col('primary'),
      primaryForeground = json._col('primaryForeground'),
      secondary = json._col('secondary'),
      secondaryForeground = json._col('secondaryForeground'),
      muted = json._col('muted'),
      mutedForeground = json._col('mutedForeground'),
      accent = json._col('accent'),
      accentForeground = json._col('accentForeground'),
      destructive = json._col('destructive'),
      destructiveForeground = json._col('destructiveForeground'),
      warning = json._col('warning'),
      warningForeground = json._col('warningForeground'),
      success = json._col('success'),
      successForeground = json._col('successForeground'),
      border = json._col('border'),
      input = json._col('input'),
      ring = json._col('ring'),
      selection = json._col('selection'),
      chart1 = json._col('chart1'),
      chart2 = json._col('chart2'),
      chart3 = json._col('chart3'),
      chart4 = json._col('chart4'),
      chart5 = json._col('chart5'),
      brightness =
          Brightness.values
              .where((element) => element.name == json['brightness'])
              .firstOrNull ??
          Brightness.light;

  MyColorScheme.fromColors({
    required Map<String, Color> colors,
    required Brightness brightness,
  }) : this(
         brightness: brightness,
         background: colors._col('background'),
         foreground: colors._col('foreground'),
         card: colors._col('card'),
         cardForeground: colors._col('cardForeground'),
         popover: colors._col('popover'),
         popoverForeground: colors._col('popoverForeground'),
         primary: colors._col('primary'),
         primaryForeground: colors._col('primaryForeground'),
         secondary: colors._col('secondary'),
         secondaryForeground: colors._col('secondaryForeground'),
         muted: colors._col('muted'),
         mutedForeground: colors._col('mutedForeground'),
         accent: colors._col('accent'),
         accentForeground: colors._col('accentForeground'),
         destructive: colors._col('destructive'),
         destructiveForeground: colors._col('destructiveForeground'),
         warning: colors._col('warning'),
         warningForeground: colors._col('warningForeground'),
         success: colors._col('success'),
         successForeground: colors._col('successForeground'),
         border: colors._col('border'),
         input: colors._col('input'),
         ring: colors._col('ring'),
         selection: colors._col('selection'),
         chart1: colors._col('chart1'),
         chart2: colors._col('chart2'),
         chart3: colors._col('chart3'),
         chart4: colors._col('chart4'),
         chart5: colors._col('chart5'),
       );

  final Brightness brightness;
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color warning;
  final Color warningForeground;
  final Color success;
  final Color successForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color selection;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  Map<String, String> toJson() {
    return {
      'background': _hexFromColor(background),
      'foreground': _hexFromColor(foreground),
      'card': _hexFromColor(card),
      'cardForeground': _hexFromColor(cardForeground),
      'popover': _hexFromColor(popover),
      'popoverForeground': _hexFromColor(popoverForeground),
      'primary': _hexFromColor(primary),
      'primaryForeground': _hexFromColor(primaryForeground),
      'secondary': _hexFromColor(secondary),
      'secondaryForeground': _hexFromColor(secondaryForeground),
      'muted': _hexFromColor(muted),
      'mutedForeground': _hexFromColor(mutedForeground),
      'accent': _hexFromColor(accent),
      'accentForeground': _hexFromColor(accentForeground),
      'destructive': _hexFromColor(destructive),
      'destructiveForeground': _hexFromColor(destructiveForeground),
      'warning': _hexFromColor(warning),
      'warningForeground': _hexFromColor(warningForeground),
      'success': _hexFromColor(success),
      'successForeground': _hexFromColor(successForeground),
      'border': _hexFromColor(border),
      'input': _hexFromColor(input),
      'ring': _hexFromColor(ring),
      'selection': _hexFromColor(selection),
      'chart1': _hexFromColor(chart1),
      'chart2': _hexFromColor(chart2),
      'chart3': _hexFromColor(chart3),
      'chart4': _hexFromColor(chart4),
      'chart5': _hexFromColor(chart5),
      'brightness': brightness.name,
    };
  }

  Map<String, Color> toColorMap() {
    return {
      'background': background,
      'foreground': foreground,
      'card': card,
      'cardForeground': cardForeground,
      'popover': popover,
      'popoverForeground': popoverForeground,
      'primary': primary,
      'primaryForeground': primaryForeground,
      'secondary': secondary,
      'secondaryForeground': secondaryForeground,
      'muted': muted,
      'mutedForeground': mutedForeground,
      'accent': accent,
      'accentForeground': accentForeground,
      'destructive': destructive,
      'destructiveForeground': destructiveForeground,
      'warning': warning,
      'warningForeground': warningForeground,
      'success': success,
      'successForeground': successForeground,
      'border': border,
      'input': input,
      'ring': ring,
      'selection': selection,
      'chart1': chart1,
      'chart2': chart2,
      'chart3': chart3,
      'chart4': chart4,
      'chart5': chart5,
    };
  }

  /// Creates a copy of this [MyColorScheme] but with the given fields
  /// replaced with the new values.
  MyColorScheme copyWith({
    Brightness? brightness,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? warning,
    Color? warningForeground,
    Color? success,
    Color? successForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? selection,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
  }) {
    return MyColorScheme(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      selection: selection ?? this.selection,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
    );
  }

  static MyColorScheme lerp(MyColorScheme a, MyColorScheme b, double t) {
    return MyColorScheme(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      card: Color.lerp(a.card, b.card, t)!,
      cardForeground: Color.lerp(a.cardForeground, b.cardForeground, t)!,
      popover: Color.lerp(a.popover, b.popover, t)!,
      popoverForeground: Color.lerp(
        a.popoverForeground,
        b.popoverForeground,
        t,
      )!,
      primary: Color.lerp(a.primary, b.primary, t)!,
      primaryForeground: Color.lerp(
        a.primaryForeground,
        b.primaryForeground,
        t,
      )!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      secondaryForeground: Color.lerp(
        a.secondaryForeground,
        b.secondaryForeground,
        t,
      )!,
      muted: Color.lerp(a.muted, b.muted, t)!,
      mutedForeground: Color.lerp(a.mutedForeground, b.mutedForeground, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      accentForeground: Color.lerp(a.accentForeground, b.accentForeground, t)!,
      destructive: Color.lerp(a.destructive, b.destructive, t)!,
      destructiveForeground: Color.lerp(
        a.destructiveForeground,
        b.destructiveForeground,
        t,
      )!,
      warning: Color.lerp(a.warning, b.warning, t)!,
      warningForeground: Color.lerp(
        a.warningForeground,
        b.warningForeground,
        t,
      )!,
      success: Color.lerp(a.success, b.success, t)!,
      successForeground: Color.lerp(
        a.successForeground,
        b.successForeground,
        t,
      )!,
      border: Color.lerp(a.border, b.border, t)!,
      input: Color.lerp(a.input, b.input, t)!,
      ring: Color.lerp(a.ring, b.ring, t)!,
      selection: Color.lerp(a.selection, b.selection, t)!,
      chart1: Color.lerp(a.chart1, b.chart1, t)!,
      chart2: Color.lerp(a.chart2, b.chart2, t)!,
      chart3: Color.lerp(a.chart3, b.chart3, t)!,
      chart4: Color.lerp(a.chart4, b.chart4, t)!,
      chart5: Color.lerp(a.chart5, b.chart5, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyColorScheme &&
        runtimeType == other.runtimeType &&
        brightness == other.brightness &&
        other.background == background &&
        other.foreground == foreground &&
        other.card == card &&
        other.cardForeground == cardForeground &&
        other.popover == popover &&
        other.popoverForeground == popoverForeground &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.muted == muted &&
        other.mutedForeground == mutedForeground &&
        other.accent == accent &&
        other.accentForeground == accentForeground &&
        other.destructive == destructive &&
        other.destructiveForeground == destructiveForeground &&
        other.warning == warning &&
        other.warningForeground == warningForeground &&
        other.success == success &&
        other.successForeground == successForeground &&
        other.border == border &&
        other.input == input &&
        other.ring == ring &&
        other.selection == selection &&
        chart1 == other.chart1 &&
        chart2 == other.chart2 &&
        chart3 == other.chart3 &&
        chart4 == other.chart4 &&
        chart5 == other.chart5;
  }

  @override
  int get hashCode {
    return brightness.hashCode ^
        background.hashCode ^
        foreground.hashCode ^
        card.hashCode ^
        cardForeground.hashCode ^
        popover.hashCode ^
        popoverForeground.hashCode ^
        primary.hashCode ^
        primaryForeground.hashCode ^
        secondary.hashCode ^
        secondaryForeground.hashCode ^
        muted.hashCode ^
        mutedForeground.hashCode ^
        accent.hashCode ^
        accentForeground.hashCode ^
        destructive.hashCode ^
        destructiveForeground.hashCode ^
        warning.hashCode ^
        warningForeground.hashCode ^
        success.hashCode ^
        successForeground.hashCode ^
        border.hashCode ^
        input.hashCode ^
        ring.hashCode ^
        selection.hashCode ^
        chart1.hashCode ^
        chart2.hashCode ^
        chart3.hashCode ^
        chart4.hashCode ^
        chart5.hashCode;
  }

  @override
  String toString() {
    return 'ColorScheme{brightness: $brightness, background: $background, '
        'foreground: $foreground, card: $card, '
        'cardForeground: $cardForeground, popover: $popover, '
        'popoverForeground: $popoverForeground, primary: $primary, '
        'primaryForeground: $primaryForeground, secondary: $secondary, '
        'secondaryForeground: $secondaryForeground, muted: $muted, '
        'mutedForeground: $mutedForeground, accent: $accent, '
        'accentForeground: $accentForeground, destructive: $destructive, '
        'destructiveForeground: $destructiveForeground, warning: $warning, '
        'warningForeground: $warningForeground, success: $success, '
        'successForeground: $successForeground, border: $border, '
        'input: $input, ring: $ring, selection: $selection, chart1: $chart1, '
        'chart2: $chart2, chart3: $chart3, chart4: $chart4, chart5: $chart5}';
  }

  static const List<String> schemes = <String>[
    'amber',
    'black',
    'blue',
    'brown',
    'cyan',
    'emerald',
    'fuchsia',
    'gold',
    'gray',
    'green',
    'indigo',
    'lime',
    'mauve',
    'mist',
    'neutral',
    'olive',
    'orange',
    'pink',
    'purple',
    'red',
    'rose',
    'sky',
    'slate',
    'stone',
    'taupe',
    'teal',
    'violet',
    'yellow',
    'zinc',
  ];

  static const List<MyBaseColor> baseColors = MyBaseColor.values;

  static const List<MyAccentColor> accentColors = MyAccentColor.values;
}

String _hexFromColor(Color color) {
  return '#${color.toARGB32().toRadixString(16).toUpperCase()}';
}

extension _MapColorGetter on Map<String, Color> {
  Color _col(String name) {
    final Color? color = this[name];
    assert(color != null, 'ColorScheme: Missing color for $name');
    return color!;
  }
}

extension _DynamicMapColorGetter on Map<String, dynamic> {
  Color _col(String name) {
    String? value = this[name]?.toString();
    assert(value != null, 'ColorScheme: Missing color for $name');

    if (value!.startsWith('#')) value = value.substring(1);

    if (value.length == 6) value = 'FF$value';

    final parse = int.tryParse(value, radix: 16);

    assert(parse != null, 'ColorScheme: Invalid hex color value $value');
    return Color(parse!);
  }
}
