import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color accent = Color(0xFFB5D936);
  static const Color accentGlow = Color(0xFFCCFF00);

  static const Color surface = Color(0xFFF4F7F0);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color darkBg = Color(0xFF1A2E1A);
  static const Color darkCard = Color(0xFF243224);

  static const Color textPrimary = Color(0xFF1B2E1B);
  static const Color textSecondary = Color(0xFF6B8F6B);
  static const Color textMuted = Color(0xFF9DB89D);

  static const Color phColor = Color(0xFF00BCD4);
  static const Color ppmColor = Color(0xFFFF9800);
  static const Color waterTempColor = Color(0xFF2196F3);
  static const Color airTempColor = Color(0xFFFF5722);
  static const Color humidityColor = Color(0xFF9C27B0);

  static const Color danger = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color success = Color(0xFF43A047);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: textPrimary,
      ),
    );
  }
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenSplash = LinearGradient(
    colors: [Color(0xFFB5D936), Color(0xFF4CAF50)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardPh = LinearGradient(
    colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardPpm = LinearGradient(
    colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardWaterTemp = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardAirTemp = LinearGradient(
    colors: [Color(0xFFFBE9E7), Color(0xFFFFCCBC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
