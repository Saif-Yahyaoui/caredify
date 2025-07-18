import 'package:caredify/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('ForgotPasswordScreen Widget Tests', () {
    testWidgets('renders all key UI elements', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.textContaining('Forgot', findRichText: true), findsWidgets);
      expect(find.textContaining('Send', findRichText: true), findsWidgets);
      expect(find.textContaining('Back to login', findRichText: true), findsWidgets);
    });

    testWidgets('shows error when submitting empty form', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Send'));
      await tester.pumpAndSettle();
      expect(find.textContaining('required', findRichText: true), findsWidgets);
    });

    testWidgets('shows error for invalid email', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.textContaining('Send'));
      await tester.pumpAndSettle();
      expect(find.textContaining('valid email', findRichText: true), findsWidgets);
    });

    testWidgets('shows error for invalid phone', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '123');
      await tester.tap(find.textContaining('Send'));
      await tester.pumpAndSettle();
      expect(find.textContaining('valid phone', findRichText: true), findsWidgets);
    });

    testWidgets('shows success message on valid email', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidget(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'test@email.com');
      await tester.tap(find.textContaining('Send'));
      await tester.pumpAndSettle(const Duration(milliseconds: 600));
      expect(find.textContaining('reset link sent', findRichText: true), findsWidgets);
    });

    testWidgets('navigates back to login on Back to login tap', (tester) async {
      await tester.pumpWidget(TestSetup.createTestWidgetWithRouter(const ForgotPasswordScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Back to login'));
      await tester.pumpAndSettle();
      // Should navigate away from ForgotPasswordScreen
      expect(find.byType(ForgotPasswordScreen), findsNothing);
    });
  });
}
