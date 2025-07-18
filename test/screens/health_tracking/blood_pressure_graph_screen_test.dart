import 'package:caredify/features/health_tracking/screens/blood_pressure_graph_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  group('BloodPressureGraphScreen Widget Tests', () {
    testWidgets('renders blood pressure graph screen with all components', (
      tester,
    ) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Blood Pressure Analysis'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays current blood pressure status card', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Current Blood Pressure'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.textContaining('Last updated:'), findsOneWidget);
    });

    testWidgets('displays blood pressure values', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 1600);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      final allTexts =
          tester
              .widgetList<Text>(find.byType(Text))
              .map((t) => t.data ?? t.textSpan?.toPlainText() ?? '')
              .toList();
      print('All Texts: $allTexts');
      expect(
        allTexts.any((text) => text.contains('117')),
        isTrue,
        reason: 'Should find systolic value 117',
      );
      expect(
        allTexts.any((text) => text.contains('75')),
        isTrue,
        reason: 'Should find diastolic value 75',
      );

      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });
    });

    testWidgets('displays graph card', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('24-Hour Blood Pressure Trend'), findsOneWidget);
      expect(find.text('Systolic'), findsOneWidget);
      expect(find.text('Diastolic'), findsOneWidget);
    });

    testWidgets('displays analysis card', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Analysis'), findsOneWidget);
      expect(find.text('Avg Systolic'), findsOneWidget);
      expect(find.text('Avg Diastolic'), findsOneWidget);
    });

    testWidgets('displays recommendations card', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.text('Maintain regular exercise'), findsOneWidget);
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
            path: '/bp',
            builder: (context, state) => const BloodPressureGraphScreen(),
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

      // Navigate to /bp
      router.go('/bp');
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.arrow_back);
      expect(iconFinder, findsOneWidget);
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });

    testWidgets('displays time labels on graph', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('displays blood pressure status correctly', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('displays mmHg units in analysis text', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('mmHg'), findsOneWidget);
    });

    testWidgets('displays systolic and diastolic labels', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Systolic'), findsOneWidget);
      expect(find.text('Diastolic'), findsOneWidget);
    });

    testWidgets('displays pulse pressure', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Pulse Pressure'), findsOneWidget);
    });

    testWidgets('displays recommendation items', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Reduce salt intake'), findsOneWidget);
      expect(find.text('Manage stress levels'), findsOneWidget);
    });

    testWidgets('displays average values', (tester) async {
      await tester.pumpWidget(testableWidget(const BloodPressureGraphScreen()));
      await tester.pumpAndSettle();

      expect(find.text('117.8'), findsOneWidget);
      expect(find.text('76.2'), findsOneWidget);
      expect(find.text('41.6'), findsOneWidget);
    });
  });
}
