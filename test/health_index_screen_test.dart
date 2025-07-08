import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:caredify/features/dashboard/health_index_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('HealthIndexScreen renders main card', (
    WidgetTester tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: HealthIndexScreen()),
      ),
    );

    // Get the l10n instance if you want to check for localized text
    final context = tester.element(find.byType(HealthIndexScreen));
    final l10n = AppLocalizations.of(context)!;

    // Example: expect(find.text(l10n.healthIndex), findsOneWidget);
    expect(find.byType(HealthIndexScreen), findsOneWidget);
  });
}
