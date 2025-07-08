import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/providers/habits_provider.dart';

void main() {
  test('HabitsProvider toggles and adds habit', () {
    final notifier = HabitsNotifier();
    final initial = notifier.state[0].completed;
    notifier.toggleHabit(0);
    expect(notifier.state[0].completed, !initial);
    final len = notifier.state.length;
    notifier.addHabit('Test');
    expect(notifier.state.length, len + 1);
  });
}
