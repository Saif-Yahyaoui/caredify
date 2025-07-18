import 'package:caredify/features/auth/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('OnboardingScreen Widget Tests', () {
    testWidgets('renders onboarding screen and all navigation controls', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const OnboardingScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(IconButton), findsNothing); // uses custom icon buttons
      expect(
        find.textContaining('Welcome to your health space'),
        findsOneWidget,
      );
      expect(find.textContaining('Sign up'), findsWidgets);
      expect(find.textContaining('Already have an account'), findsWidgets);
      expect(find.textContaining('Log in'), findsWidgets);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('can swipe between onboarding pages', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const OnboardingScreen()),
      );
      await tester.pumpAndSettle();
      final pageView = find.byType(PageView);
      expect(pageView, findsOneWidget);
      await tester.fling(pageView, const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      // Should be on next page (check for a unique title)
      expect(find.text('Cardio-AI'), findsOneWidget);
    });

    testWidgets('skip button navigates to welcome', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidgetWithRouter(const OnboardingScreen()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      // Should navigate away from OnboardingScreen
      expect(find.byType(OnboardingScreen), findsNothing);
    });

    testWidgets('continue button advances pages and finish navigates', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestSetup.createTestWidgetWithRouter(const OnboardingScreen()),
      );
      await tester.pumpAndSettle();
      // Tap forward arrow until last page
      for (int i = 0; i < 4; i++) {
        final nextBtn = find.byIcon(Icons.arrow_forward_ios);
        expect(nextBtn, findsOneWidget);
        await tester.tap(nextBtn);
        await tester.pumpAndSettle();
      }
      // On last page, tap check icon
      final checkBtn = find.byIcon(Icons.check);
      expect(checkBtn, findsOneWidget);
      await tester.tap(checkBtn);
      await tester.pumpAndSettle();
      // Should navigate away from OnboardingScreen
      expect(find.byType(OnboardingScreen), findsNothing);
    });

    testWidgets('sign up and login buttons navigate', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidgetWithRouter(const OnboardingScreen()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Sign up').last);
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingScreen), findsNothing);
      // Re-pump to test login
      await tester.pumpWidget(
        TestSetup.createTestWidgetWithRouter(const OnboardingScreen()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Log in').last);
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingScreen), findsNothing);
    });
  });
}
