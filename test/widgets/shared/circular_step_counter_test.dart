import 'package:caredify/shared/widgets/charts/circular_step_counter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('CircularStepCounter Widget Tests', () {
    testWidgets('renders with correct step count', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const CircularStepCounter(steps: 5000, goal: 10000),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('5000'), findsOneWidget);
      expect(find.text('steps'), findsOneWidget);
    });
  });
}
