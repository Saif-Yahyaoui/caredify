import 'package:caredify/features/auth/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

Widget onboardingTestWrapper(Widget child) {
  return TestSetup.createTestWidget(
    MediaQuery(data: const MediaQueryData(size: Size(400, 2000)), child: child),
  );
}

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('OnboardingScreen Widget Tests', () {
    testWidgets('renders and can swipe', (tester) async {
      await tester.pumpWidget(onboardingTestWrapper(const OnboardingScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('displays onboarding content', (tester) async {
      await tester.pumpWidget(onboardingTestWrapper(const OnboardingScreen()));
      await tester.pumpAndSettle();
      // Add your onboarding content checks here
    });

    testWidgets('handles page navigation', (tester) async {
      await tester.pumpWidget(onboardingTestWrapper(const OnboardingScreen()));
      await tester.pumpAndSettle();
      // Add your page navigation checks here
    });

    testWidgets('has proper layout structure', (tester) async {
      await tester.pumpWidget(onboardingTestWrapper(const OnboardingScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
