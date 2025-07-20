part of 'constants.dart';

class ThemeColors {
  ThemeColors._();

  static const blue = MaterialColor(0xFF219ED6, <int, Color>{
    50: Color(0xFFF1F9FE),
    100: Color(0xFFE3F1FB),
    200: Color(0xFFC0E4F7),
    300: Color(0xFF88CFF1),
    400: Color(0xFF41B3E6),
    500: Color(0xFF219ED6),
    600: Color(0xFF137EB6),
    700: Color(0xFF116593),
    800: Color(0xFF12567A),
    900: Color(0xFF154865),
    950: Color(0xFF0E2E43),
  });

  static const green = MaterialColor(0xFF22C55E, <int, Color>{
    50: Color(0xFFF0FDF4),
    100: Color(0xFFDCFCE7),
    200: Color(0xFFBBF7D0),
    300: Color(0xFF86EFAC),
    400: Color(0xFF4ADE80),
    500: Color(0xFF22C55E),
    600: Color(0xFF16A34A),
    700: Color(0xFF15803D),
    800: Color(0xFF166534),
    900: Color(0xFF14532D),
    950: Color(0xFF052E16),
  });

  static const red = MaterialColor(0xFFF04338, <int, Color>{
    50: Color(0xFFFEF3F2),
    100: Color(0xFFFEE4E2),
    200: Color(0xFFFECDCA),
    300: Color(0xFFFDA29B),
    400: Color(0xFFF97066),
    500: Color(0xFFF04338),
    600: Color(0xFFDC2626),
    700: Color(0xFFB42318),
    800: Color(0xFF9E1018),
    900: Color(0xFF7A271A),
    950: Color(0xFF450A0A),
  });

  static const orange = MaterialColor(0xFFF79009, <int, Color>{
    50: Color(0xFFFFFAEB),
    100: Color(0xFFFEF0C7),
    200: Color(0xFFFEDF89),
    300: Color(0xFFFEC84B),
    400: Color(0xFFFDB022),
    500: Color(0xFFF79009),
    600: Color(0xFFDC6803),
    700: Color(0xFFB54708),
    800: Color(0xFF93370D),
    900: Color(0xFF7A2E0E),
    950: Color(0xFF4E1D09),
  });

  static const pink = MaterialColor(0xFFEC4899, <int, Color>{
    50: Color(0xFFFDF2F8),
    100: Color(0xFFFCE7F3),
    200: Color(0xFFFBCFE8),
    300: Color(0xFFF9A8D4),
    400: Color(0xFFF472B6),
    500: Color(0xFFEC4899),
    600: Color(0xFFDB2777),
    700: Color(0xFFBE185D),
    800: Color(0xFF9D174D),
    900: Color(0xFF831843),
    950: Color(0xFF500724),
  });

  static const purple = MaterialColor(0xFFD946EF, <int, Color>{
    50: Color(0xFFFAF5FF),
    100: Color(0xFFF3E8FF),
    200: Color(0xFFE9D5FF),
    300: Color(0xFFD8B4FE),
    400: Color(0xFFC084FC),
    500: Color(0xFFD946EF),
    600: Color(0xFFBC26D3),
    700: Color(0xFF9C1CAF),
    800: Color(0xFF90189F),
    900: Color(0xFF861A75),
    950: Color(0xFF4A044E),
  });

  static const indigo = MaterialColor(0xFF6366F1, <int, Color>{
    50: Color(0xFFF5F3FF),
    100: Color(0xFFEDE9FE),
    200: Color(0xFFDDD6FE),
    300: Color(0xFFC4B5FD),
    400: Color(0xFFA78BFA),
    500: Color(0xFF6366F1),
    600: Color(0xFF4F46E5),
    700: Color(0xFF4338CA),
    800: Color(0xFF3730A3),
    900: Color(0xFF312E81),
    950: Color(0xFF1E1B4B),
  });

  static const sky = MaterialColor(0xFF38BDF8, <int, Color>{
    50: Color(0xFFF0F9FF),
    100: Color(0xFFDBEAFE),
    200: Color(0xFFBAE6FD),
    300: Color(0xFF7DD3FC),
    400: Color(0xFF38BDF8),
    500: Color(0xFF0EA5E9),
    600: Color(0xFF0284C7),
    700: Color(0xFF0369A1),
    800: Color(0xFF075985),
    900: Color(0xFF0C4A6E),
    950: Color(0xFF082F49),
  });

  static const lime = MaterialColor(0xFF84CC16, <int, Color>{
    50: Color(0xFFF7FEE7),
    100: Color(0xFFECFCCB),
    200: Color(0xFFD9F99D),
    300: Color(0xFFBEF264),
    400: Color(0xFFA3E635),
    500: Color(0xFF84CC16),
    600: Color(0xFF65A30D),
    700: Color(0xFF4D7C0F),
    800: Color(0xFF3F6212),
    900: Color(0xFF365314),
    950: Color(0xFF1E2E05),
  });

  static const yellow = MaterialColor(0xFFEAB308, <int, Color>{
    50: Color(0xFFFFFDEA),
    100: Color(0xFFFEF0C3),
    200: Color(0xFFFEE28A),
    300: Color(0xFFFDD147),
    400: Color(0xFFFAAC15),
    500: Color(0xFFEAB308),
    600: Color(0xFFCA9A04),
    700: Color(0xFFA17C07),
    800: Color(0xFF86580E),
    900: Color(0xFF7A5112),
    950: Color(0xFF423306),
  });

  static const grey = MaterialColor(0xFF6B7280, <int, Color>{
    50: Color(0xFFF9FAFB),
    100: Color(0xFFF3F4F6),
    200: Color(0xFFE5E7EB),
    300: Color(0xFFD1D5DB),
    400: Color(0xFF9CA3AF),
    500: Color(0xFF6B7280),
    600: Color(0xFF4B5563),
    700: Color(0xFF374151),
    800: Color(0xFF1F2937),
    900: Color(0xFF111827),
    950: Color(0xFF030712),
  });

  static List<MaterialColor> colors = [
    blue,
    green,
    red,
    orange,
    pink,
    purple,
    indigo,
    sky,
    lime,
    yellow,
    grey,
  ];

  static List<Color> picker =
      colors
        ..removeLast()
        ..map((color) => color.shade500).toList();

  static const success = green;

  static const warning = orange;

  static const error = red;

  static const neutral = grey;

  static MaterialColor fromColor(Color color) {
    return colors.firstWhere((element) => element.shade500 == color);
  }

  static MaterialColor fromHex(String hex) {
    return fromColor(hex.fromHex());
  }
}
