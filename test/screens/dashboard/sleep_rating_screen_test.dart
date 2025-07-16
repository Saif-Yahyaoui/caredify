import 'package:caredify/features/health_tracking/screens/sleep_rating_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('SleepRatingScreen Widget Tests', () {
    testWidgets('renders sleep rating screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SleepRatingScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SleepRatingScreen), findsOneWidget);
    });
  });
}
