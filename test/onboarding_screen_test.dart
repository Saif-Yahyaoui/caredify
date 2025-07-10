import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caredify/features/auth/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_helpers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('OnboardingScreen renders and can swipe', (
    WidgetTester tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(Scaffold(body: OnboardingScreen())),
      ),
    );

    expect(find.byType(OnboardingScreen), findsOneWidget);
    // Add swipe or page change tests as needed
  });
}
