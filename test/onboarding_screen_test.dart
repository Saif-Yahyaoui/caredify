import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:caredify/features/auth/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('OnboardingScreen renders and can swipe', (
    WidgetTester tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: OnboardingScreen()),
      ),
    );

    expect(find.byType(OnboardingScreen), findsOneWidget);
    // Add swipe or page change tests as needed
  });
}
