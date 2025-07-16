import 'package:caredify/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('DashboardScreen Widget Tests', () {
    testWidgets('renders dashboard screen', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const DashboardScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });
}
