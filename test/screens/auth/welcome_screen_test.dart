import 'package:caredify/features/auth/screens/welcome_screen.dart';
import 'package:caredify/features/auth/widgets/auth_logo_header.dart';
import 'package:caredify/shared/widgets/access/accessibility_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget testableWidget(Widget child, {GoRouter? router}) {
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig:
          router ??
          GoRouter(
            initialLocation: '/welcome',
            routes: [
              GoRoute(path: '/welcome', builder: (context, state) => child),
              GoRoute(
                path: '/register',
                builder:
                    (context, state) =>
                        const Scaffold(body: Text('Register Screen')),
              ),
              GoRoute(
                path: '/login',
                builder:
                    (context, state) =>
                        const Scaffold(body: Text('Login Screen')),
              ),
            ],
          ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
      builder:
          (context, child) => MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: child!,
          ),
    ),
  );
}

void printAllTexts(WidgetTester tester) {
  final texts = find.byType(Text);
  for (final t in texts.evaluate()) {
    final widget = t.widget as Text;
    debugPrint('VISIBLE TEXT: "${widget.data}"');
  }
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('renders welcome screen UI', (tester) async {
    await tester.pumpWidget(testableWidget(const WelcomeScreen()));
    await tester.pumpAndSettle();
    printAllTexts(tester);
    // Logo and welcome message
    expect(find.byType(AuthLogoHeader), findsOneWidget);
    // Accessibility controls
    expect(find.byType(AccessibilityControls), findsOneWidget);
    // Sign up button
    final context = tester.element(find.byType(WelcomeScreen));
    final t = AppLocalizations.of(context);
    expect(find.widgetWithText(ElevatedButton, t!.signUp), findsOneWidget);
    // Already have an account text
    expect(find.text(t.alreadyHaveAccount), findsOneWidget);
    // Login link
    expect(find.widgetWithText(GestureDetector, t.login), findsOneWidget);
  });

  testWidgets('navigates to register and login screens', (tester) async {
    final router = GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/register',
          builder:
              (context, state) => const Scaffold(body: Text('Register Screen')),
        ),
        GoRoute(
          path: '/login',
          builder:
              (context, state) => const Scaffold(body: Text('Login Screen')),
        ),
      ],
    );
    await tester.pumpWidget(
      testableWidget(const WelcomeScreen(), router: router),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(WelcomeScreen));
    final t = AppLocalizations.of(context);
    final signUpButton = find.widgetWithText(ElevatedButton, t!.signUp);
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();
    expect(find.text('Register Screen'), findsOneWidget);
    // Go back to welcome
    router.go('/welcome');
    await tester.pumpAndSettle();
    // Tap login
    final loginLink = find.widgetWithText(GestureDetector, t.login);
    await tester.ensureVisible(loginLink);
    await tester.tap(loginLink);
    await tester.pumpAndSettle();
    expect(find.text('Login Screen'), findsOneWidget);
  });
}
