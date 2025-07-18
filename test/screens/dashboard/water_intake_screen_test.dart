import 'package:caredify/features/health_tracking/screens/water_intake_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  Widget localizedTestableWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
        home: child,
      ),
    );
  }

  group('WaterIntakeScreen Widget Tests', () {
    testWidgets('renders water intake screen with all components', (
      tester,
    ) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Water Intake'), findsNWidgets(2));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays water card', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('L'), findsWidgets);
      expect(find.text('Today'), findsOneWidget);
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
    });

    testWidgets('displays hydration streak', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Hydration streak'), findsOneWidget);
      expect(find.textContaining('days in a row'), findsOneWidget);
    });

    testWidgets('displays water intake trend chart', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Water Intake Trend (7 days)'), findsOneWidget);
    });

    testWidgets('displays benefits section', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Benefits of Hydration'), findsOneWidget);
      expect(find.textContaining('Boosts energy'), findsOneWidget);
      expect(find.textContaining('Improves skin'), findsOneWidget);
      expect(find.textContaining('Supports metabolism'), findsOneWidget);
      expect(find.textContaining('Aids digestion'), findsOneWidget);
    });

    testWidgets('displays reminders section', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Set a reminder'), findsOneWidget);
      expect(find.byIcon(Icons.alarm), findsOneWidget);
    });

    testWidgets('displays needs calculator', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('How much water do you need?'), findsOneWidget);
      expect(
        find.textContaining('Recommended: 35ml per kg of body weight.'),
        findsOneWidget,
      );
    });

    testWidgets('displays export button', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WaterIntakeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Export Hydration Log'), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('navigates back to dashboard on back button tap', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/main/dashboard',
        routes: [
          GoRoute(
            path: '/main/dashboard',
            builder:
                (context, state) =>
                    const Scaffold(body: Text('Dashboard Screen')),
          ),
          GoRoute(
            path: '/water',
            builder: (context, state) => const WaterIntakeScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to /water
      router.go('/water');
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.arrow_back);
      expect(iconFinder, findsOneWidget);
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });
  });
}
