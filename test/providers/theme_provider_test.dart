import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/providers/theme_provider.dart';

void main() {
  test('ThemeModeProvider toggles theme', () async {
    final notifier = ThemeModeNotifier();
    final initial = notifier.state;
    await notifier.toggleTheme();
    expect(notifier.state, isNot(initial));
  });
}
