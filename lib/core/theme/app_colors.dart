import 'package:flutter/material.dart';

/// CAREDIFY Official Color Palette
/// Based on the medical app requirements and design specifications
class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF0092DF); // Technology & Trust
  static const Color alertRed = Color(0xFFE53935); // Critical alerts
  static const Color healthGreen = Color(0xFF00C853); // Positive states
  
  // Neutral Grays
  static const Color lightGray = Color(0xFFF5F7FA); // Backgrounds, cards
  static const Color mediumGray = Color(0xFFB0BEC5); // Secondary text, icons
  static const Color darkGray = Color(0xFF455A64); // Secondary titles, borders
  
  // Background variations
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFF5F7FA);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  
  // Alert state backgrounds
  static const Color alertBackground = Color(0xFFFFF4F4);
  static const Color successBackground = Color(0xFFE8F5E9);
  static const Color warningBackground = Color(0xFFFFF3E0);
  
  // Button colors
  static const Color buttonPrimary = primaryBlue;
  static const Color buttonSecondary = healthGreen;
  static const Color buttonDisabled = Color(0xFFE0E0E0);
  
  // Input field colors
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocused = primaryBlue;
  static const Color inputError = alertRed;
  
  // ECG and medical data colors
  static const Color ecgLine = primaryBlue;
  static const Color heartRate = alertRed;
  static const Color healthMetrics = healthGreen;
  
  // Accessibility - High contrast variants
  static const Color highContrastPrimary = Color(0xFF0066CC);
  static const Color highContrastText = Color(0xFF000000);
  static const Color highContrastBackground = Color(0xFFFFFFFF);
  
  // Gradient definitions for modern UI
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF0078D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient healthGradient = LinearGradient(
    colors: [healthGreen, Color(0xFF00A846)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}