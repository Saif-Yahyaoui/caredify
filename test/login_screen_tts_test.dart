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
      ProviderScope(child: localizedTestableWidget(LoginScreen())),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(LoginScreen));
    final loginText = AppLocalizations.of(context)!.login;

    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('required', findRichText: true), findsWidgets);
  });

  testWidgets('Shows error for invalid phone', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(LoginScreen())),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(LoginScreen));
    final loginText = AppLocalizations.of(context)!.login;

    await tester.enterText(find.byType(TextFormField).first, 'abc');
    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('phone', findRichText: true), findsWidgets);
  });
}
