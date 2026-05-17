import 'package:flutter/material.dart';
import 'app_typography.dart';

class AppTheme {
  // ---------------------------------------------------------
  // 🎨 PALETTE ORIGINALE (compatibilité avec tes anciennes vues)
  // ---------------------------------------------------------
  static const Color blueDeep = Color(0xFF0A2342);
  static const Color blueMid = Color(0xFF123A63);
  static const Color blueLight = Color(0xFF1B4F85);
  static const Color yellowSolar = Color(0xFFF2C94C);
  static const Color backgroundLight = Color(0xFFF5F7FA);

  // ---------------------------------------------------------
  // 🎨 PALETTE VERT SOLAIRE (nouveau thème)
  // ---------------------------------------------------------
  static const Color solarGreen = Color(0xFF00C853);
  static const Color solarGreenLight = Color(0xFF69F0AE);
  static const Color darkBackground = Color(0xFF0F1A20);
  static const Color cardBackground = Color(0xFF162228);

  // ---------------------------------------------------------
  // 🧊 WHITE CARD
  // ---------------------------------------------------------
  static BoxDecoration whiteCard = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );

  // ---------------------------------------------------------
  // 🧊 GLASS CARD (ancienne version conservée)
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
        offset: const Offset(0, 8),
      ),
    ],
  );

  // ---------------------------------------------------------
  // 🟩 DASHBOARD CARD (nécessaire pour HomeView)
  // ---------------------------------------------------------
  static BoxDecoration dashboardCard = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // ---------------------------------------------------------
  // 🌞 THEME LIGHT (ancien)
  // ---------------------------------------------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: "Manrope",
    colorScheme: const ColorScheme.light(
      primary: blueDeep,
      secondary: blueLight,
    ),
  );

  // ---------------------------------------------------------
  // 🌙 THEME DARK (nouveau + compatible Flutter 3.22+)
  // ---------------------------------------------------------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    fontFamily: "Manrope",

    colorScheme: const ColorScheme.dark(
      primary: solarGreen,
      secondary: solarGreenLight,
    ),

    cardTheme: const CardThemeData(
      color: cardBackground,
      elevation: 4,
      margin: EdgeInsets.all(8),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
