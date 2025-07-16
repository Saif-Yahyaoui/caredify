import 'package:caredify/shared/widgets/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('WeeklyChart Widget Tests', () {
    testWidgets('renders weekly chart with data', (tester) async {
      const testData = [0.7, 0.8, 0.6, 0.9, 0.5, 0.8, 0.7];

      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const WeeklyChart(data: testData, barColor: Colors.blue),
        ),
      );
      await tester.pumpAndSettle();

      // Check that the widget renders
      expect(find.byType(WeeklyChart), findsOneWidget);
    });
  });
}
