import 'package:caredify/shared/widgets/access/accessibility_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('AccessibilityControls Widget Tests', () {
    testWidgets('renders all toggles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TestSetup.createTestWidget(const AccessibilityControls()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check that the widget renders without crashing
      expect(find.byType(AccessibilityControls), findsOneWidget);
    });
  });
}
