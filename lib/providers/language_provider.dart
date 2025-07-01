import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language provider for managing app localization
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

/// Manages language state and persistence
class LanguageNotifier extends StateNotifier<Locale> {
  static const String _languageKey = 'language_code';
  static const String _countryKey = 'country_code';

  LanguageNotifier() : super(const Locale('fr', 'FR')) {
    _loadLanguage();
  }

  /// Load saved language from preferences
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'fr';
      final countryCode = prefs.getString(_countryKey) ?? 'FR';
      state = Locale(languageCode, countryCode);
    } catch (e) {
      // Default to French if loading fails
      state = const Locale('fr', 'FR');
    }
  }

  /// Set specific language
  Future<void> setLanguage(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
      await prefs.setString(_countryKey, locale.countryCode ?? '');
      state = locale;
    } catch (e) {
      // Handle error
      debugPrint('Failed to save language preference: $e');
    }
  }

  /// Get current language as string for UI display
  String get currentLanguageString {
    switch (state.languageCode) {
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'Français';
    }
  }

  /// Get language flag emoji
  String get currentLanguageFlag {
    switch (state.languageCode) {
      case 'fr':
        return '🇫🇷';
      case 'ar':
        return '🇹🇳';
      case 'en':
        return '🇺🇸';
      default:
        return '🇫🇷';
    }
  }

  /// Get supported languages
  static List<Map<String, String>> get supportedLanguages => [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷', 'country': 'FR'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇹🇳', 'country': 'TN'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸', 'country': 'US'},
  ];
}
