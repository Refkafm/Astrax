import 'package:flutter/material.dart';

class Palette {
  static const canvas = Color(0xFFFFF9E8),
      ink = Color(0xFF171916),
      secondary = Color(0xFF555A51),
      mint = Color(0xFFE2F2DF),
      primary = Color(0xFF55B98A),
      butter = Color(0xFFF6DF83),
      coral = Color(0xFFF0B0A4),
      lilac = Color(0xFFE4DDF6),
      subtle = Color(0xFFF4F0E5),
      danger = Color(0xFFA12B27),
      success = Color(0xFF21633F);
}

ThemeData appTheme() {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Palette.ink, width: 2),
  );
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Palette.canvas,
    fontFamily: 'PlusJakartaSans',
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: Palette.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: Palette.ink,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Palette.ink,
          error: Palette.danger,
        ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.12,
      ),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.canvas,
      foregroundColor: Palette.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 72,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: Palette.success, width: 2.5),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Palette.ink,
        minimumSize: const Size(48, 52),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Palette.ink, width: 2),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.ink,
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: Palette.ink, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFD8D9D0)),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Palette.canvas,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Palette.mint,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
