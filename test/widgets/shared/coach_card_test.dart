import 'package:caredify/shared/widgets/cards/coach_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('CoachCard Widget Tests', () {
    testWidgets('renders coach card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const CoachCard(message: 'Test message from coach'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test message from coach'), findsOneWidget);
    });
  });
}
