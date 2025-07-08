import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/forgot_password_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('ForgotPasswordScreen renders and validates', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: localizedTestableWidget(const ForgotPasswordScreen()),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(ForgotPasswordScreen));
    final passwordText = AppLocalizations.of(context)!.forgotPasswordTitle;
    expect(find.text(passwordText), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    final requiredText = AppLocalizations.of(context)!.fieldRequired;
    expect(find.text(requiredText), findsWidgets);
  });
}
