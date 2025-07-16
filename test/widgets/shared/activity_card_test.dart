import 'package:caredify/shared/widgets/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('ActivityCard Widget Tests', () {
    testWidgets('renders activity card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          ActivityCard(
            key: const Key('activity_card'),
            title: 'Test Activity',
            metrics: [
              ActivityMetric(
                label: 'steps',
                value: '50',
                iconAsset: 'assets/icons/walking.svg',
                color: Colors.blue,
              ),
            ],
            progress: 0.5,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Activity'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });
  });
}
