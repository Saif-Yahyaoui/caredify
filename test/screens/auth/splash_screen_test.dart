import 'package:caredify/features/auth/screens/splash_screen.dart';
import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:caredify/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/auth_service_mock.dart';

class _TestAuthStateNotifier extends AuthStateNotifier {
  _TestAuthStateNotifier(AuthState state) : super(MockAuthService()) {
    this.state = state;
  }
}

Widget testableWidgetWithRouter({
  required Widget child,
  List<Override> overrides = const [],
}) {
  final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => child),
      GoRoute(
        path: '/main/home',
        builder: (context, state) => const Scaffold(body: Text('Home Screen')),
      ),
      GoRoute(
        path: '/main/dashboard',
        builder:
            (context, state) => const Scaffold(body: Text('Dashboard Screen')),
      ),
      GoRoute(
        path: '/onboarding',
        builder:
            (context, state) => const Scaffold(body: Text('Onboarding Screen')),
      ),
    ],
  );
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
    ),
  );
}

Override authStateOverride(AuthState state) {
  return authStateProvider.overrideWith((ref) => _TestAuthStateNotifier(state));
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SplashScreen shows logo, loading, and welcome', (tester) async {
    const fakeAuth = AuthState(isLoggedIn: false, userType: UserType.none);
    await tester.pumpWidget(
      testableWidgetWithRouter(
        child: const SplashScreen(disableNavigation: true),
        overrides: [authStateOverride(fakeAuth)],
      ),
    );
    await tester.pump(const Duration(milliseconds: 100)); // allow initial build
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.textContaining('Welcome'), findsWidgets);
    expect(find.textContaining('Loading'), findsWidgets);

    // Let all timers complete (use 6 seconds to be safe)
    await tester.pump(const Duration(seconds: 6));
    // Remove the widget to trigger dispose and clean up timers
    await tester.pumpWidget(Container());
    await tester.pump();
  });

  testWidgets('Navigates to /main/dashboard for premium user', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    const premiumAuth = AuthState(isLoggedIn: true, userType: UserType.premium);
    await tester.pumpWidget(
      testableWidgetWithRouter(
        child: const SplashScreen(),
        overrides: [authStateOverride(premiumAuth)],
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard Screen'), findsOneWidget);
  });

  testWidgets('Navigates to /main/home for basic user', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    const basicAuth = AuthState(isLoggedIn: true, userType: UserType.basic);
    await tester.pumpWidget(
      testableWidgetWithRouter(
        child: const SplashScreen(),
        overrides: [authStateOverride(basicAuth)],
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets(
    'Navigates to /main/home if onboarding complete and not logged in',
    (tester) async {
      SharedPreferences.setMockInitialValues({'onboarding_complete': true});
      const notLoggedIn = AuthState(isLoggedIn: false, userType: UserType.none);
      await tester.pumpWidget(
        testableWidgetWithRouter(
          child: const SplashScreen(),
          overrides: [authStateOverride(notLoggedIn)],
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Home Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'Navigates to /onboarding if onboarding not complete and not logged in',
    (tester) async {
      SharedPreferences.setMockInitialValues({'onboarding_complete': false});
      const notLoggedIn = AuthState(isLoggedIn: false, userType: UserType.none);
      await tester.pumpWidget(
        testableWidgetWithRouter(
          child: const SplashScreen(),
          overrides: [authStateOverride(notLoggedIn)],
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('Onboarding Screen'), findsOneWidget);
    },
  );
}
