import 'package:caredify/features/health_tracking/screens/heart_tracker_screen.dart';
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
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      home: child,
    ),
  );
}

Widget testableWidgetWithRouter() {
  final router = GoRouter(
    initialLocation: '/main/dashboard',
    routes: [
      GoRoute(
        path: '/main/dashboard',
        builder: (context, state) => const Scaffold(body: Text('Dashboard Screen')),
      ),
      GoRoute(
        path: '/heart',
        builder: (context, state) => const HeartTrackerScreen(),
      ),
    ],
  );
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
    ),
  );
}

void main() {
  group('HeartTrackerScreen Widget Tests', () {
    testWidgets('renders heart tracker screen with all components', (tester) async {
      await tester.pumpWidget(testableWidget(const HeartTrackerScreen()));
      await tester.pumpAndSettle();
      final t = AppLocalizations.of(tester.element(find.byType(HeartTrackerScreen)))!;
      expect(find.text(t.heartTrackerTitle), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays BPM card', (tester) async {
      await tester.pumpWidget(testableWidget(const HeartTrackerScreen()));
      await tester.pumpAndSettle();
      expect(find.text('BPM'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('displays BPM value', (tester) async {
      await tester.pumpWidget(testableWidget(const HeartTrackerScreen()));
      await tester.pumpAndSettle();
      expect(find.text('72'), findsOneWidget);
    });

    testWidgets('displays heart rate trend chart', (tester) async {
      await tester.pumpWidget(testableWidget(const HeartTrackerScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Heart Rate Trend (7 days)'), findsOneWidget);
    });

    testWidgets('navigates back to dashboard on back button tap', (tester) async {
      final router = GoRouter(
        initialLocation: '/main/dashboard',
        routes: [
          GoRoute(
            path: '/main/dashboard',
            builder: (context, state) => const Scaffold(body: Text('Dashboard Screen')),
          ),
          GoRoute(
            path: '/heart',
            builder: (context, state) => const HeartTrackerScreen(),
          ),
        ],
      );
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('ar'),
          ],
        ),
      ));
      await tester.pumpAndSettle();
      // Push /heart on top of /main/dashboard
      router.push('/heart');
      await tester.pumpAndSettle();
      final iconFinder = find.byIcon(Icons.arrow_back);
      expect(iconFinder, findsOneWidget);
      await tester.tap(iconFinder);
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });
  });
}
