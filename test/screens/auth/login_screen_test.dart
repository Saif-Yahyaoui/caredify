import 'package:caredify/features/auth/screens/login_screen.dart';
import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('LoginScreen UI', () {
    testWidgets('shows logo, welcome, fields, and buttons', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const LoginScreen(),
          overrides: [
            authServiceProvider.overrideWith(
              (ref) => ref.watch(testAuthServiceProvider),
            ),
          ],
        ),
      );

      // Wait for any animations
      await tester.pumpAndSettle();

      // Check for logo image (there are multiple images: logo, fingerprint, facial)
      expect(find.byType(Image), findsNWidgets(3));

      // Check for welcome text
      expect(find.text('Welcome to your health space'), findsOneWidget);

      // Check for form fields
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Check for field labels
      expect(find.text('Phone number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Check for placeholder text
      expect(find.text('Enter your phone number'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);

      // Check for buttons and links (using actual text from debug output)
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);

      // Check for social login buttons
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Facebook'), findsOneWidget);

      // Check for legal links
      expect(find.text('Terms of service'), findsOneWidget);
      expect(find.text('Privacy policy'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const LoginScreen(),
          overrides: [
            authServiceProvider.overrideWith(
              (ref) => ref.watch(testAuthServiceProvider),
            ),
          ],
        ),
      );

      // Enter phone and password
      await tester.enterText(find.byType(TextFormField).first, '1234567890');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.pumpAndSettle();

      // Verify text was entered
      expect(find.text('1234567890'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('taps sign in button safely', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const LoginScreen(),
          overrides: [
            authServiceProvider.overrideWith(
              (ref) => ref.watch(testAuthServiceProvider),
            ),
          ],
        ),
      );

      // Enter valid credentials
      await tester.enterText(find.byType(TextFormField).first, '1234567890');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap sign in button
      await TestUtils.safeTap(tester, find.text('Sign in'));
      await tester.pumpAndSettle();

      // Should remain on login screen (mocked auth service)
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('taps forgot password link with router', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidgetWithRouter(
          const LoginScreen(),
          overrides: [
            authServiceProvider.overrideWith(
              (ref) => ref.watch(testAuthServiceProvider),
            ),
          ],
        ),
      );

      // Tap forgot password link
      await TestUtils.safeTap(tester, find.text('Forgot password?'));
      await tester.pumpAndSettle();

      // Should navigate away from login screen
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('shows all UI elements correctly', (tester) async {
      await tester.pumpWidget(
        TestSetup.createTestWidget(
          const LoginScreen(),
          overrides: [
            authServiceProvider.overrideWith(
              (ref) => ref.watch(testAuthServiceProvider),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify all key UI elements are present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });
  });
}
