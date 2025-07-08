import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caredify/providers/language_provider.dart';
import 'dart:ui';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('LanguageNotifier sets language', () async {
    final notifier = LanguageNotifier();
    await notifier.setLanguage(const Locale('en'));
    expect(notifier.state.languageCode, 'en');
  });
}
