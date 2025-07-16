import 'package:caredify/features/watch/screens/health_watch_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('HealthWatchScreen Widget Tests', () {
    testWidgets('renders health watch screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const HealthWatchScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HealthWatchScreen), findsOneWidget);
    });
  });
}
