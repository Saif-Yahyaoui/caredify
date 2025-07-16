import 'package:caredify/features/health_tracking/screens/water_intake_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('WaterIntakeScreen Widget Tests', () {
    testWidgets('renders water intake screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WaterIntakeScreen), findsOneWidget);
    });
  });
}
