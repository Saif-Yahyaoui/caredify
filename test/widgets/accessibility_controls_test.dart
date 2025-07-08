import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/widgets/accessibility_controls.dart';
import '../test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('AccessibilityControls renders all toggles', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const AccessibilityControls()),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(AccessibilityControls));
    final language = AppLocalizations.of(context)!.language;
    expect(find.text(language), findsWidgets);
    expect(find.byType(Switch), findsOneWidget);
  });
}
