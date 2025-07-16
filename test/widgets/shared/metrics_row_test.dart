import 'package:caredify/shared/widgets/metrics_row.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('MetricsRow Widget Tests', () {
    testWidgets('renders all metrics', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const MetricsRow(calories: 150.0, distance: 2.5, minutes: 30),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('150'), findsOneWidget);
      expect(find.text('kcal'), findsOneWidget);
      expect(find.text('2.5'), findsOneWidget);
      expect(find.text('km'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('min'), findsOneWidget);
    });
  });
}
