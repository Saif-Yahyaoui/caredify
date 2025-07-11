// test/login_screen_validation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/login_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('Shows error if fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(  const LoginScreen())),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(LoginScreen));
    final loginText = AppLocalizations.of(context)!.login;
    final requiredText = AppLocalizations.of(context)!.fieldRequired;

    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    expect(loginButton, findsOneWidget);

    // Ensure the button is visible before tapping
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text(requiredText), findsWidgets);
  });

  testWidgets('Shows error for invalid phone', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(  const LoginScreen())),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(LoginScreen));
    final loginText = AppLocalizations.of(context)!.login;
    final phoneErrorText = AppLocalizations.of(context)!.phoneMinLength;

    // Use a short numeric string to trigger the min length error
    await tester.enterText(find.byType(TextFormField).first, '123');
    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    expect(loginButton, findsOneWidget);

    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text(phoneErrorText), findsWidgets);
  });
}
