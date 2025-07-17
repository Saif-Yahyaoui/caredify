import 'package:caredify/shared/widgets/cards/healthy_habits.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HealthyHabitsScreen Widget Tests', () {
    testWidgets('renders healthy habits screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const HealthyHabitsScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HealthyHabitsScreen), findsOneWidget);
    });
  });
}
