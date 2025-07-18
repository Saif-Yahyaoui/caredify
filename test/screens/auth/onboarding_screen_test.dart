import 'package:caredify/features/auth/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget testableWidgetWithRouter({required Widget child}) {
  final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (context, state) => child),
      GoRoute(
        path: '/welcome',
        builder:
            (context, state) => const Scaffold(body: Text('Welcome Screen')),
      ),
      GoRoute(
        path: '/register',
        builder:
            (context, state) => const Scaffold(body: Text('Register Screen')),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Scaffold(body: Text('Login Screen')),
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('OnboardingScreen renders all cards and controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      testableWidgetWithRouter(child: const OnboardingScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.textContaining('Welcome to your health space'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.textContaining('Already have an account'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('Can swipe between onboarding pages', (tester) async {
    await tester.pumpWidget(
      testableWidgetWithRouter(child: const OnboardingScreen()),
    );
    await tester.pumpAndSettle();
    final pageView = find.byType(PageView);
    expect(pageView, findsOneWidget);
    await tester.fling(pageView, const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Cardio-AI'), findsOneWidget);
  });

  testWidgets('Skip button sets onboarding complete and navigates to welcome', (
    tester,
  ) async {
    await tester.pumpWidget(
      testableWidgetWithRouter(child: const OnboardingScreen()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Welcome Screen'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_complete'), isTrue);
  });

  testWidgets(
    'Continue/check button on last page sets onboarding complete and navigates to welcome',
    (tester) async {
      await tester.pumpWidget(
        testableWidgetWithRouter(child: const OnboardingScreen()),
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
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Welcome Screen'), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('onboarding_complete'), isTrue);
    },
  );

  testWidgets('Sign up and login buttons navigate', (tester) async {
    await tester.pumpWidget(
      testableWidgetWithRouter(child: const OnboardingScreen()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    expect(find.text('Register Screen'), findsOneWidget);
    // Re-pump to test login
    await tester.pumpWidget(
      testableWidgetWithRouter(child: const OnboardingScreen()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Login Screen'), findsOneWidget);
  });
}
