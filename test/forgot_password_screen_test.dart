import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/forgot_password_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('ForgotPasswordScreen renders and validates', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const ForgotPasswordScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('password', findRichText: true), findsWidgets);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.textContaining('required', findRichText: true), findsWidgets);
  });
}
