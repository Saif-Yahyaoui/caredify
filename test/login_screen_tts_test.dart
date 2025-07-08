// test/login_screen_validation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/login_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('Shows error if fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(LoginScreen())),
    );

    // Tap login button without entering anything
    final loginButton = find.textContaining('Login');
    await tester.tap(loginButton.first);
    await tester.pumpAndSettle();

    // Should show validation error (assuming your validators show a message)
    expect(find.textContaining('required', findRichText: true), findsWidgets);
  });

  testWidgets('Shows error for invalid phone', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(LoginScreen())),
    );

    // Enter invalid phone
    await tester.enterText(find.byType(TextFormField).first, 'abc');
    await tester.tap(find.textContaining('Login').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('phone', findRichText: true), findsWidgets);
  });
}
