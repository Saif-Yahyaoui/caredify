import 'package:caredify/features/health_tracking/screens/heart_tracker_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HeartTrackerScreen Widget Tests', () {
    testWidgets('renders heart tracker screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const HeartTrackerScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HeartTrackerScreen), findsOneWidget);
    });
  });
}
