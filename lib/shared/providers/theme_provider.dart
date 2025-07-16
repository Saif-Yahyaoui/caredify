import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode provider for light/dark theme switching
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Font size provider for accessibility
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});

/// Manages theme mode state and persistence
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }
  
  /// Load saved theme mode from preferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      state = ThemeMode.values[themeIndex];
    } catch (e) {
      // Default to light theme if loading fails
      state = ThemeMode.light;
    }
  }
  
  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newTheme);
  }
  
  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
      state = themeMode;
    } catch (e) {
      // Handle error - maybe show a snackbar
      debugPrint('Failed to save theme preference: $e');
    }
  }
  
  /// Get current theme mode as string for UI display
  String get currentThemeString {
    switch (state) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Système';
    }
  }
}

/// Manages font size for accessibility
class FontSizeNotifier extends StateNotifier<double> {
  static const String _fontSizeKey = 'font_size';
  static const double normalSize = 1.0;
  static const double largeSize = 1.3;
  
  FontSizeNotifier() : super(normalSize) {
    _loadFontSize();
  }
  
  /// Load saved font size from preferences
  Future<void> _loadFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fontSize = prefs.getDouble(_fontSizeKey) ?? normalSize;
      state = fontSize;
    } catch (e) {
      // Default to normal size if loading fails
      state = normalSize;
    }
  }
  
  /// Toggle between normal and large font size
  Future<void> toggleFontSize() async {
    final newSize = state == normalSize ? largeSize : normalSize;
    await setFontSize(newSize);
  }
  
  /// Set specific font size
  Future<void> setFontSize(double fontSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, fontSize);
      state = fontSize;
    } catch (e) {
      // Handle error
      debugPrint('Failed to save font size preference: $e');
    }
  }
  
  /// Check if current size is large
  bool get isLargeSize => state == largeSize;
  
  /// Get current font size as string for UI display
  String get currentSizeString {
    return state == normalSize ? 'Normal' : 'Grande';
  }
}

/// Provider for system brightness (used for automatic theme detection)
final systemBrightnessProvider = Provider<Brightness>((ref) {
  return WidgetsBinding.instance.platformDispatcher.platformBrightness;
});

/// Combined provider for effective theme mode considering system setting
final effectiveThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  
  if (themeMode == ThemeMode.system) {
    final systemBrightness = ref.watch(systemBrightnessProvider);
    return systemBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }
  
  return themeMode;
});