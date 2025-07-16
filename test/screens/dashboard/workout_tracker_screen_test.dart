import 'package:caredify/features/health_tracking/screens/workout_tracker_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('WorkoutTrackerScreen Widget Tests', () {
    testWidgets('renders workout tracker screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WorkoutTrackerScreen), findsOneWidget);
    });
  });
}
