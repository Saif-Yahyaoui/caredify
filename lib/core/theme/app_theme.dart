import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App theme configuration for CAREDIFY
/// Implements Material 3 design with custom medical app styling
class AppTheme {
  // Font size multipliers for accessibility
  static const double normalFontSize = 1.0;
  static const double largeFontSize = 1.3;

  /// Light theme configuration
  static ThemeData lightTheme(double fontSizeMultiplier) {
    final baseTextTheme = _buildTextTheme(fontSizeMultiplier, true);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.healthGreen,
        error: AppColors.alertRed,
        surface: AppColors.surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: AppColors.textPrimary,
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text theme
      textTheme: baseTextTheme,

      // Button themes
      elevatedButtonTheme: _elevatedButtonTheme(fontSizeMultiplier),
      outlinedButtonTheme: _outlinedButtonTheme(fontSizeMultiplier),
      textButtonTheme: _textButtonTheme(fontSizeMultiplier),

      // Input decoration theme
      inputDecorationTheme: _inputDecorationTheme(fontSizeMultiplier),

      // Card theme
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // Accessibility
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.backgroundLight,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData darkTheme(double fontSizeMultiplier) {
    final baseTextTheme = _buildTextTheme(fontSizeMultiplier, false);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.healthGreen,
        error: AppColors.alertRed,
        surface: AppColors.surfaceDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: AppColors.textLight,
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textLight,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text theme
      textTheme: baseTextTheme,

      // Button themes
      elevatedButtonTheme: _elevatedButtonTheme(fontSizeMultiplier),
      outlinedButtonTheme: _outlinedButtonTheme(fontSizeMultiplier),
      textButtonTheme: _textButtonTheme(fontSizeMultiplier),

      // Input decoration theme
      inputDecorationTheme: _inputDecorationTheme(fontSizeMultiplier),

      // Card theme
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // Accessibility
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.backgroundDark,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textDark,
        ),
        contentTextStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textLight,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// Build text theme with accessibility font scaling
  static TextTheme _buildTextTheme(double fontSizeMultiplier, bool isLight) {
    final baseColor = isLight ? AppColors.textPrimary : AppColors.textSecondary;
    final secondaryColor =
        isLight ? AppColors.textSecondary : AppColors.mediumGray;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32 * fontSizeMultiplier,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28 * fontSizeMultiplier,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24 * fontSizeMultiplier,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 22 * fontSizeMultiplier,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20 * fontSizeMultiplier,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18 * fontSizeMultiplier,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontSize: 16 * fontSizeMultiplier,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14 * fontSizeMultiplier,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: 12 * fontSizeMultiplier,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16 * fontSizeMultiplier,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14 * fontSizeMultiplier,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 12 * fontSizeMultiplier,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.3,
      ),
      labelLarge: TextStyle(
        fontSize: 14 * fontSizeMultiplier,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12 * fontSizeMultiplier,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10 * fontSizeMultiplier,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }

  /// Elevated button theme for primary actions
  static ElevatedButtonThemeData _elevatedButtonTheme(
    double fontSizeMultiplier,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontSize: 16 * fontSizeMultiplier,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(double.infinity, 56), // Accessibility
      ),
    );
  }

  /// Outlined button theme for secondary actions
  static OutlinedButtonThemeData _outlinedButtonTheme(
    double fontSizeMultiplier,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.buttonSecondary,
        side: const BorderSide(color: AppColors.buttonSecondary, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontSize: 16 * fontSizeMultiplier,
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(double.infinity, 56), // Accessibility
      ),
    );
  }

  /// Text button theme for tertiary actions
  static TextButtonThemeData _textButtonTheme(double fontSizeMultiplier) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: TextStyle(
          fontSize: 14 * fontSizeMultiplier,
          fontWeight: FontWeight.w500,
        ),
        minimumSize: const Size(0, 48), // Accessibility
      ),
    );
  }

  /// Input decoration theme for forms
  static InputDecorationTheme _inputDecorationTheme(double fontSizeMultiplier) {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputFocused, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        fontSize: 14 * fontSizeMultiplier,
        color: AppColors.textSecondary,
      ),
      hintStyle: TextStyle(
        fontSize: 14 * fontSizeMultiplier,
        color: AppColors.mediumGray,
      ),
    );
  }
}
