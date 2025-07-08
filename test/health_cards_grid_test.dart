import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/features/dashboard/health_cards_grid.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('HealthCardsGrid renders all cards', (tester) async {
    await tester.pumpWidget(
      localizedTestableWidget(
        HealthCardsGrid(
          heartRate: 70,
          heartRateMax: 100,
          waterIntake: 1000,
          waterGoal: 1500,
          sleepHours: 7,
          sleepGoal: 9,
          workoutMinutes: 30,
          workoutGoal: 60,
        ),
      ),
    );
    expect(find.byType(Card), findsWidgets);
  });
}
