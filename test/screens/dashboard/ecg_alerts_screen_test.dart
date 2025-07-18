import 'package:caredify/features/dashboard/screens/ecg_alerts_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('EcgAlertsScreen Widget Tests', () {
    testWidgets('renders and displays alerts', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const EcgAlertsScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EcgAlertsScreen), findsOneWidget);
      expect(find.text('AI ECG Alerts'), findsOneWidget);
    });

    testWidgets('displays no alerts message when empty', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const EcgAlertsScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('No active AI alerts'), findsOneWidget);
    });
  });
}
