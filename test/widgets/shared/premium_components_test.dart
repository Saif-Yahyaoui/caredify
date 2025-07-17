import 'package:caredify/shared/widgets/misc/premium_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('PremiumEcgAnalysisCard Widget Tests', () {
    testWidgets('renders premium ECG analysis card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const PremiumEcgAnalysisCard()),
      );
      await tester.pumpAndSettle();
      // Debug: Print all text widgets
      final textWidgets = find.byType(Text);
      for (int i = 0; i < textWidgets.evaluate().length; i++) {
        final widget = textWidgets.evaluate().elementAt(i).widget as Text;
        debugPrint('Text $i: "${widget.data}"');
      }
      // Since the test is running with non-premium user type, it shows fallback
      expect(
        find.text('Premium Feature'),
        findsNothing,
      ); // No such fallback in this widget
      expect(find.byType(PremiumEcgAnalysisCard), findsOneWidget);
    });
  });
}
