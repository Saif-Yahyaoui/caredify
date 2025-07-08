import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/features/auth/register_screen.dart';

void main() {
  testWidgets('Shows error if passwords do not match', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: RegisterScreen())),
    );

    // Fill all fields except confirm password
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Test User'); // name
    await tester.enterText(fields.at(1), '1234567890'); // phone
    await tester.enterText(fields.at(2), 'test@example.com'); // email
    await tester.enterText(fields.at(3), 'password123'); // password
    await tester.enterText(fields.at(4), 'different'); // confirm password

    await tester.tap(find.textContaining('Register').first);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('do not match', findRichText: true),
      findsWidgets,
    );
  });
}
