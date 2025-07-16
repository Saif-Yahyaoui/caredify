import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';

class HabitsNotifier extends StateNotifier<List<Habit>> {
  HabitsNotifier()
    : super([
        Habit(name: 'Drink 2L of water'),
        Habit(name: 'Eat healthy breakfast', completed: true),
        Habit(name: 'Workout for 45 min', completed: true),
        Habit(name: 'Stretching'),
      ]);

  void toggleHabit(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Habit(name: state[i].name, completed: !state[i].completed)
        else
          state[i],
    ];
  }

  void addHabit(String name) {
    state = [...state, Habit(name: name)];
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>(
  (ref) => HabitsNotifier(),
);
