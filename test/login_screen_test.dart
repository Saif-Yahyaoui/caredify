import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/login_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Shows error if fields are empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const LoginScreen())),
    );
    await tester.pumpAndSettle();

    final loginScreenFinder = find.byType(LoginScreen);
    expect(loginScreenFinder, findsOneWidget);

    final context = tester.element(loginScreenFinder);
    final loginText = AppLocalizations.of(context)!.login;
    final requiredText = AppLocalizations.of(context)!.fieldRequired;

    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    expect(loginButton, findsOneWidget);

    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text(requiredText), findsWidgets);
  });

  testWidgets('Shows error for invalid phone', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(const LoginScreen())),
    );
    await tester.pumpAndSettle();

    final loginScreenFinder = find.byType(LoginScreen);
    expect(loginScreenFinder, findsOneWidget);

    final context = tester.element(loginScreenFinder);
    final loginText = AppLocalizations.of(context)!.login;
    final phoneErrorText = AppLocalizations.of(context)!.phoneMinLength;

    await tester.enterText(find.byType(TextFormField).first, '123');

    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text(phoneErrorText), findsWidgets);
  });
}
