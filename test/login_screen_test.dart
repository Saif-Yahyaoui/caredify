import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/login_screen.dart';
import 'package:caredify/providers/auth_provider.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'mocks/auth_service_mock.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Login screen shows form fields and login button', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(MockAuthService())],
        child: localizedTestableWidget(const LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Check if login screen is rendered
    expect(find.byType(LoginScreen), findsOneWidget);

    // Check if form fields are present (phone and password)
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Check if login button is present
    final context = tester.element(find.byType(LoginScreen));
    final loginText = AppLocalizations.of(context)!.login;
    expect(find.widgetWithText(ElevatedButton, loginText), findsOneWidget);
  });

  testWidgets('Shows validation error for empty fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(MockAuthService())],
        child: localizedTestableWidget(const LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(LoginScreen));
    final loginText = AppLocalizations.of(context)!.login;
    final requiredText = AppLocalizations.of(context)!.fieldRequired;

    // Tap login button without entering any data
    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Should show validation errors
    expect(find.text(requiredText), findsWidgets);
  });

  testWidgets('Shows validation error for invalid phone', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(MockAuthService())],
        child: localizedTestableWidget(const LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(LoginScreen));
    final loginText = AppLocalizations.of(context)!.login;
    final phoneErrorText = AppLocalizations.of(context)!.phoneMinLength;

    // Enter invalid phone number
    await tester.enterText(find.byType(TextFormField).first, '123');

    // Tap login button
    final loginButton = find.widgetWithText(ElevatedButton, loginText);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Should show phone validation error
    expect(find.text(phoneErrorText), findsWidgets);
  });
}
