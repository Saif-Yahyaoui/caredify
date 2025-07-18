import 'package:caredify/features/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('RegisterScreen Widget Tests', () {
    testWidgets('renders all form fields and buttons', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const RegisterScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.textContaining('Register'), findsWidgets);
      expect(find.textContaining('Already have an account'), findsWidgets);
    });

    testWidgets('shows error when submitting empty form', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const RegisterScreen()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Register').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('required', findRichText: true), findsWidgets);
    });

    testWidgets('shows error when passwords do not match', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(const RegisterScreen()),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), '1234567890');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(3), 'password1');
      await tester.enterText(find.byType(TextFormField).at(4), 'password2');
      await tester.tap(find.textContaining('Register').first);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('do not match', findRichText: true),
        findsWidgets,
      );
    });

    testWidgets('navigates to login on Already have an account', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestSetup.createTestWidgetWithRouter(const RegisterScreen()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Already have an account'));
      await tester.pumpAndSettle();
      // Should navigate away from RegisterScreen
      expect(find.byType(RegisterScreen), findsNothing);
    });

    testWidgets('shows success and navigates on valid registration', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestSetup.createTestWidgetWithRouter(const RegisterScreen()),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), '1234567890');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(3), 'password1');
      await tester.enterText(find.byType(TextFormField).at(4), 'password1');
      await tester.tap(find.textContaining('Register').first);
      await tester.pumpAndSettle();
      // Should show success message and navigate
      expect(
        find.textContaining('account created', findRichText: true),
        findsWidgets,
      );
      expect(find.byType(RegisterScreen), findsNothing);
    });
  });
}
