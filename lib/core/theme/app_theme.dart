import 'package:flutter/material.dart';
import 'app_typography.dart';

class AppTheme {
  // ---------------------------------------------------------
  // 🎨 PALETTE OFFICIELLE SOLARDESIGNPRO
  // ---------------------------------------------------------
  static const Color blueDeep = Color(0xFF0A2342);
  static const Color blueMid = Color(0xFF123A63);
  static const Color blueLight = Color(0xFF1B4F85);
  static const Color yellowSolar = Color(0xFFF2C94C);

  static const Color backgroundLight = Color(0xFFF5F7FA);

  // ---------------------------------------------------------
  // 🧊 WHITE CARD (INDISPENSABLE POUR TES COURBES)
  // ---------------------------------------------------------
  static BoxDecoration whiteCard = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.05),
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ],
  );

  // ---------------------------------------------------------
  // 🌈 GRADIENT PREMIUM
  // ---------------------------------------------------------
  static const LinearGradient mainGradient = LinearGradient(
    colors: [blueDeep, blueMid, blueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ---------------------------------------------------------
  // 🧊 GLASS CARD PREMIUM
  // ---------------------------------------------------------
  static BoxDecoration glassCard = BoxDecoration(
    color: Colors.white.withOpacity(0.12),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(
      color: Colors.white.withOpacity(0.25),
      width: 1.2,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ],
  );

  // ---------------------------------------------------------
  // 🌞 THEME LIGHT PREMIUM
  // ---------------------------------------------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: "Manrope",

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTypography.h2,
      iconTheme: IconThemeData(color: Colors.black87),
    ),

    textTheme: const TextTheme(
      bodyMedium: AppTypography.body,
      bodyLarge: AppTypography.h3,
      titleLarge: AppTypography.h1,
      titleMedium: AppTypography.h2,
    ),
  );

  // ---------------------------------------------------------
  // 🌙 MODE SOMBRE
  // ---------------------------------------------------------
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF0E0E0F),
    colorScheme: const ColorScheme.dark(
      primary: blueLight,
      secondary: yellowSolar,
    ),
  );
}
