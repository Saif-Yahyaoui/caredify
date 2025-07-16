import 'dart:ui';
import 'package:caredify/shared/providers/language_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LanguageProvider Tests', () {
    test('LanguageNotifier sets language', () async {
      final notifier = LanguageNotifier();
      await notifier.setLanguage(const Locale('en'));
      expect(notifier.state.languageCode, 'en');
    });
  });
}
