import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/providers/language_provider.dart';
import 'dart:ui';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('LanguageProvider sets language', () async {
    final notifier = LanguageNotifier();
    await notifier.setLanguage(const Locale('en', 'US'));
    expect(notifier.state.languageCode, 'en');
  });
}
