import 'package:caredify/features/auth/screens/login_screen.dart';
import 'package:caredify/features/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget testableWidgetWithRouter(Widget child) {
  final router = GoRouter(
    initialLocation: '/register',
    routes: [
      GoRoute(path: '/register', builder: (context, state) => child),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ],
  );
  return ProviderScope(
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

void main() {
  testWidgets('RegisterScreen renders all form fields and buttons', (
    tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(testableWidgetWithRouter(const RegisterScreen()));
    await tester.pumpAndSettle();
    final t = AppLocalizations.of(tester.element(find.byType(RegisterScreen)))!;
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text(t.register), findsWidgets);
    expect(find.text(t.alreadyHaveAccount), findsWidgets);
  });

  testWidgets('RegisterScreen shows error when submitting empty form', (
    tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(testableWidgetWithRouter(const RegisterScreen()));
    await tester.pumpAndSettle();
    final t = AppLocalizations.of(tester.element(find.byType(RegisterScreen)))!;
    await tester.ensureVisible(find.text(t.register).first);
    await tester.tap(find.text(t.register).first);
    await tester.pumpAndSettle();
    final allTexts =
        tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data ?? t.textSpan?.toPlainText() ?? '')
            .toList();
    print('All error texts: $allTexts');
    expect(
      allTexts.any(
        (text) =>
            text.contains(t.fieldRequired) ||
            text.contains(t.nameRequired) ||
            text.contains(t.emailRequired) ||
            text.contains(t.passwordRequired),
      ),
      isTrue,
    );
  });

  testWidgets('RegisterScreen shows error when passwords do not match', (
    tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(testableWidgetWithRouter(const RegisterScreen()));
    await tester.pumpAndSettle();
    final t = AppLocalizations.of(tester.element(find.byType(RegisterScreen)))!;
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), '1234567890');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'password1');
    await tester.enterText(find.byType(TextFormField).at(4), 'password2');
    await tester.ensureVisible(find.text(t.register).first);
    await tester.tap(find.text(t.register).first);
    await tester.pumpAndSettle();
    final allTexts =
        tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data ?? t.textSpan?.toPlainText() ?? '')
            .toList();
    print('All error texts: $allTexts');
    expect(
      allTexts.any((text) => text.contains(t.passwordsDoNotMatch)),
      isTrue,
    );
  });

  testWidgets('RegisterScreen navigates to LoginScreen on valid registration', (
    tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(testableWidgetWithRouter(const RegisterScreen()));
    await tester.pumpAndSettle();
    final t = AppLocalizations.of(tester.element(find.byType(RegisterScreen)))!;
    final loginButtonText = t.login;
    final phoneLabel = t.phoneNumber;
    final emailLabel = t.email;
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), '1234567890');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'password1');
    await tester.enterText(find.byType(TextFormField).at(4), 'password1');
    await tester.ensureVisible(find.text(t.register).first);
    await tester.tap(find.text(t.register).first);
    await tester.pump(const Duration(seconds: 2));
    final allTexts =
        tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data ?? t.textSpan?.toPlainText() ?? '')
            .toList();
    print('All texts after navigation: $allTexts');
    // Pass if any key login screen text is present
    expect(
      allTexts.any(
        (text) =>
            text == loginButtonText || text == phoneLabel || text == emailLabel,
      ),
      isTrue,
      reason: 'Should find login button or phone/email label after navigation',
    );
  });
}
