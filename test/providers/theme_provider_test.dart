import 'package:caredify/shared/providers/theme_provider.dart';
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

  group('ThemeProvider Tests', () {
    test('ThemeModeNotifier toggles theme', () async {
      final notifier = ThemeModeNotifier();
      final initialTheme = notifier.state;
      await notifier.toggleTheme();
      expect(notifier.state != initialTheme, true);
    });
  });
}
