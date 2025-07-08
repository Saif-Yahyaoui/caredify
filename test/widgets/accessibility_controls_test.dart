import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/widgets/accessibility_controls.dart';
import '../test_helpers.dart';

void main() {
  testWidgets('AccessibilityControls renders all toggles', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const AccessibilityControls()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Language', findRichText: true), findsWidgets);
    expect(find.byType(Switch), findsOneWidget);
  });
}
