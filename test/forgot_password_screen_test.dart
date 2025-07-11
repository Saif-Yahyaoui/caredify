import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:caredify/features/auth/forgot_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_helpers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ForgotPasswordScreen renders and validates', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(  const ForgotPasswordScreen())),
    );

    // Try to submit with empty field
    final buttonFinder = find.byType(ElevatedButton);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    // Get the l10n instance
    final context = tester.element(find.byType(ForgotPasswordScreen));
    final l10n = AppLocalizations.of(context)!;

    expect(find.text(l10n.fieldRequired), findsOneWidget);
  });
}
