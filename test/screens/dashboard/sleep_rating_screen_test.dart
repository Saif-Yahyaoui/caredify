import 'package:caredify/features/health_tracking/screens/sleep_rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget testableWidget(Widget child) {
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

void main() {
  group('SleepRatingScreen Widget Tests', () {
    testWidgets('renders sleep rating screen with all components', (
      tester,
    ) async {
      await tester.pumpWidget(testableWidget(const SleepRatingScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Your Sleep Rating'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays total sleep card', (tester) async {
      await tester.pumpWidget(testableWidget(const SleepRatingScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Total Sleep'), findsOneWidget);
      expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
      expect(find.text('7.0 h'), findsOneWidget); // More specific
    });

    testWidgets('displays sleep trend chart', (tester) async {
      await tester.pumpWidget(testableWidget(const SleepRatingScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sleep Trend (7 days)'), findsOneWidget);
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
            path: '/sleep',
            builder: (context, state) => const SleepRatingScreen(),
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

      // Navigate to /sleep
      router.go('/sleep');
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.arrow_back);
      expect(iconFinder, findsOneWidget);
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });
  });
}
