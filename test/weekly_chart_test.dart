import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/features/dashboard/weekly_chart.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('WeeklyChart renders', (tester) async {
    await tester.pumpWidget(
      localizedTestableWidget(
         const  WeeklyChart(
          data: [0.5, 0.7, 0.9, 0.6, 0.8, 0.7, 0.5],
          barColor: Colors.blue,
        ),
      ),
    );
    expect(find.byType(WeeklyChart), findsOneWidget);
  });
}
