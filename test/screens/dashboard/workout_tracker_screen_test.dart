import 'package:caredify/features/health_tracking/screens/workout_tracker_screen.dart';
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

  group('WorkoutTrackerScreen Widget Tests', () {
    testWidgets('renders workout tracker screen with all components', (
      tester,
    ) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Workout tracker'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays steps card', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Steps'), findsOneWidget);
      expect(find.textContaining('min'), findsNWidgets(2));
      expect(find.textContaining('/'), findsOneWidget); // e.g. '7900 / 10000'
    });

    testWidgets('displays activity trend chart', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Activity Trend (7 days)'), findsOneWidget);
    });

    testWidgets('displays personal bests', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Personal Best'), findsOneWidget);
      expect(find.textContaining('steps'), findsOneWidget);
      expect(find.textContaining('km'), findsOneWidget);
    });

    testWidgets('displays recommended workouts', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recommended Workouts'), findsOneWidget);
      expect(find.textContaining('brisk walk'), findsOneWidget);
      expect(find.textContaining('stretching'), findsOneWidget);
      expect(find.textContaining('cycling'), findsOneWidget);
    });

    testWidgets('displays health info', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('How activity improves your health'), findsOneWidget);
      expect(find.textContaining('Boosts mood'), findsOneWidget);
      expect(find.textContaining('Improves heart health'), findsOneWidget);
      expect(find.textContaining('Increases energy'), findsOneWidget);
      expect(find.textContaining('Supports weight management'), findsOneWidget);
    });

    testWidgets('displays export button', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const WorkoutTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Export Workout Log'), findsOneWidget);
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
            path: '/workout',
            builder: (context, state) => const WorkoutTrackerScreen(),
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

      // Navigate to /workout
      router.go('/workout');
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.arrow_back);
      expect(iconFinder, findsOneWidget);
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });
  });
}
