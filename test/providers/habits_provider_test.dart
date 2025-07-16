import 'package:caredify/shared/providers/habits_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HabitsProvider Tests', () {
    test('HabitsProvider toggles and adds habit', () {
      final notifier = HabitsNotifier();
      final initial = notifier.state[0].completed;
      notifier.toggleHabit(0);
      expect(notifier.state[0].completed, !initial);
      final len = notifier.state.length;
      notifier.addHabit('Test');
      expect(notifier.state.length, len + 1);
    });
  });
}
