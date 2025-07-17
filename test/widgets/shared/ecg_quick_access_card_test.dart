import 'package:caredify/shared/widgets/cards/ecg_quick_access_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('EcgQuickAccessCard Widget Tests', () {
    testWidgets('renders ECG quick access card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const EcgQuickAccessCard()),
      );
      await tester.pumpAndSettle();
      expect(find.text('ECG'), findsOneWidget);
    });
  });
}
