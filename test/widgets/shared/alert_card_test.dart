import 'package:caredify/shared/widgets/alert_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('AlertCard Widget Tests', () {
    testWidgets('renders alert card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const AlertCard(text: 'Test Alert', color: Colors.red),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Alert'), findsOneWidget);
    });
  });
}
