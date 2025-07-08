import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caredify/providers/theme_provider.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ThemeModeNotifier toggles theme', () async {
    final notifier = ThemeModeNotifier();
    final initialTheme = notifier.state;
    await notifier.toggleTheme();
    expect(notifier.state != initialTheme, true);
  });
}
