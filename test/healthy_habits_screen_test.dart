import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/dashboard/healthy_habits_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('HealthyHabitsScreen renders and shows habits', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const HealthyHabitsScreen()),
      ),
    );
    expect(find.textContaining('Habits'), findsWidgets);
  });
}
