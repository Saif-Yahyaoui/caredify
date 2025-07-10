import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:caredify/widgets/accessibility_controls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../test_helpers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AccessibilityControls renders all toggles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(Scaffold(body: AccessibilityControls())),
      ),
    );

    expect(find.byType(AccessibilityControls), findsOneWidget);
    expect(find.byType(Switch), findsWidgets);
  });
}
