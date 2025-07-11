import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/register_screen.dart';
import 'test_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('Shows error if passwords do not match', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: localizedTestableWidget(  const RegisterScreen())),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(RegisterScreen));
    final registerText = AppLocalizations.of(context)!.register;
    final doNotMatchText = AppLocalizations.of(context)!.passwordsDoNotMatch;

    // Fill all fields except confirm password
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Test User'); // name
    await tester.enterText(fields.at(1), '1234567890'); // phone
    await tester.enterText(fields.at(2), 'test@example.com'); // email
    await tester.enterText(fields.at(3), 'password123'); // password
    await tester.enterText(fields.at(4), 'different'); // confirm password

    final registerButton = find.widgetWithText(ElevatedButton, registerText);
    expect(registerButton, findsOneWidget);

    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text(doNotMatchText), findsWidgets);
  });
}
