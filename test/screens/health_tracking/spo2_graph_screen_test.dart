import 'package:caredify/features/health_tracking/screens/spo2_graph_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('SpO2GraphScreen Widget Tests', () {
    testWidgets('renders SpO2 graph screen with all components', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SpO2GraphScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('SpO2 Analysis'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays current SpO2 status card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SpO2GraphScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Current SpO2'), findsOneWidget);
      expect(find.byIcon(Icons.air_rounded), findsOneWidget);
      expect(find.textContaining('Last updated:'), findsOneWidget);
    });

    testWidgets('displays SpO2 value', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SpO2GraphScreen()),
      );
      await tester.pumpAndSettle();

      // The value is e.g. '91%' from the mock data
      expect(find.textContaining('%'), findsWidgets);
    });

    testWidgets('displays graph card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SpO2GraphScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('24-Hour SpO2 Trend'), findsOneWidget);
    });

    testWidgets('displays stat items', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SpO2GraphScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Average'), findsOneWidget);
      expect(find.text('Min'), findsOneWidget);
      expect(find.text('Max'), findsOneWidget);
      expect(find.text('92.3%'), findsOneWidget);
      expect(find.text('90%'), findsOneWidget);
      expect(find.text('94%'), findsOneWidget);
    });

    testWidgets('displays analysis card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SpO2GraphScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Analysis'), findsOneWidget);
      expect(find.textContaining('normal range'), findsOneWidget);
    });

    testWidgets('displays recommendations card', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const SpO2GraphScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.text('Practice deep breathing exercises'), findsOneWidget);
      expect(find.text('Maintain good posture'), findsOneWidget);
      expect(find.text('Stay hydrated'), findsOneWidget);
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
            path: '/spo2',
            builder: (context, state) => const SpO2GraphScreen(),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      // Navigate to /spo2
      router.go('/spo2');
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.arrow_back);
      expect(iconFinder, findsOneWidget);
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });
  });
}
