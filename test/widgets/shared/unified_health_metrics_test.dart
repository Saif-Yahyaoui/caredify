import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/shared/widgets/unified_health_metrics.dart';

void main() {
  group('UnifiedHealthMetrics', () {
    testWidgets('renders and shows Heart Rate label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: UnifiedHealthMetrics(
                heartRate: 72,
                heartRateMax: 120,
                waterIntake: 1500,
                waterGoal: 2000,
                sleepHours: 7.5,
                sleepGoal: 8.0,
                workoutMinutes: 30,
                workoutGoal: 60,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(UnifiedHealthMetrics), findsOneWidget);
      expect(find.textContaining('Heart', findRichText: true), findsWidgets);
    });
  });
}
