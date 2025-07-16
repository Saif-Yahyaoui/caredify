import 'package:caredify/shared/widgets/vital_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('VitalCard Widget Tests', () {
    testWidgets('renders vital card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const VitalCard(
            title: 'Heart Rate',
            value: '72',
            time: '2:30 PM',
            color: Colors.red,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Heart Rate'), findsOneWidget);
      expect(find.text('72'), findsOneWidget);
      expect(find.text('2:30 PM'), findsOneWidget);
    });
  });
}
