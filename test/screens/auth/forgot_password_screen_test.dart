import 'package:caredify/features/auth/screens/forgot_password_screen.dart';
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
  group('ForgotPasswordScreen Widget Tests', () {
    testWidgets('renders all key UI elements', (tester) async {
      await tester.pumpWidget(testableWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      final t =
          AppLocalizations.of(
            tester.element(find.byType(ForgotPasswordScreen)),
          )!;
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(
        find.textContaining(t.forgotPasswordTitle, findRichText: true),
        findsWidgets,
      );
      expect(find.textContaining(t.send, findRichText: true), findsWidgets);
      expect(
        find.textContaining(t.backToLogin, findRichText: true),
        findsWidgets,
      );
    });

    testWidgets('shows error when submitting empty form', (tester) async {
      await tester.pumpWidget(testableWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      final t =
          AppLocalizations.of(
            tester.element(find.byType(ForgotPasswordScreen)),
          )!;
      await tester.tap(find.textContaining(t.send));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(t.fieldRequired, findRichText: true),
        findsWidgets,
      );
    });

    testWidgets('shows error for invalid email', (tester) async {
      await tester.pumpWidget(testableWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      final t =
          AppLocalizations.of(
            tester.element(find.byType(ForgotPasswordScreen)),
          )!;
      // Use an input that contains '@' to trigger email validation
      await tester.enterText(find.byType(TextFormField), 'invalid@email');
      await tester.tap(find.textContaining(t.send));
      await tester.pumpAndSettle();
      final allTexts =
          tester
              .widgetList<Text>(find.byType(Text))
              .map((t) => t.data ?? t.textSpan?.toPlainText() ?? '')
              .toList();
      debugPrint('All error texts: $allTexts');
      expect(
        allTexts.any(
          (text) => text.toLowerCase().contains(t.emailInvalid.toLowerCase()),
        ),
        isTrue,
        reason: 'Should show email invalid error',
      );
    });

    testWidgets('shows error for invalid phone', (tester) async {
      await tester.pumpWidget(testableWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      final t =
          AppLocalizations.of(
            tester.element(find.byType(ForgotPasswordScreen)),
          )!;
      await tester.enterText(find.byType(TextFormField), '123');
      await tester.tap(find.textContaining(t.send));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(t.phoneMinLength, findRichText: true),
        findsWidgets,
      );
    });

    testWidgets('shows success message on valid email', (tester) async {
      await tester.pumpWidget(testableWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();

      final t =
          AppLocalizations.of(
            tester.element(find.byType(ForgotPasswordScreen)),
          )!;
      await tester.enterText(find.byType(TextFormField), 'test@email.com');
      await tester.tap(find.textContaining(t.send));
      await tester.pumpAndSettle(const Duration(milliseconds: 600));
      expect(
        find.textContaining(t.resetLinkSent, findRichText: true),
        findsWidgets,
      );
    });

    testWidgets('navigates back to login on Back to login tap', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;

      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/login',
            builder:
                (context, state) => const Scaffold(body: Text('Login Screen')),
          ),
          GoRoute(
            path: '/forgot',
            builder: (context, state) => const ForgotPasswordScreen(),
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

      // Push /forgot on top of /login
      router.push('/forgot');
      await tester.pumpAndSettle();

      final t =
          AppLocalizations.of(
            tester.element(find.byType(ForgotPasswordScreen)),
          )!;
      final backToLoginFinder = find.textContaining(t.backToLogin);
      await tester.ensureVisible(backToLoginFinder);
      await tester.tap(backToLoginFinder);
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
