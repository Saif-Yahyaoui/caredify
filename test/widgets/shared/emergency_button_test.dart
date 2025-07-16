import 'package:caredify/shared/widgets/emergency_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('EmergencyButton Widget Tests', () {
    testWidgets('renders emergency button', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(EmergencyButton(onPressed: () {})),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EmergencyButton), findsOneWidget);
      expect(find.text('Appeler aide'), findsOneWidget);
      expect(find.text('Appuyez pour appeler'), findsOneWidget);
    });
  });
}
