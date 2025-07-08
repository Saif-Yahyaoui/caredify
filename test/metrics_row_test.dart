import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caredify/features/dashboard/metrics_row.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('MetricsRow renders all metrics', (tester) async {
    await tester.pumpWidget(
      localizedTestableWidget(
        MetricsRow(calories: 100, distance: 2, minutes: 30),
      ),
    );
    expect(find.text('100'), findsOneWidget);
    expect(find.text('2.0'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });
}
