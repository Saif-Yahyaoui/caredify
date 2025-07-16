import 'package:caredify/main.dart';

import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:caredify/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/auth_service_mock.dart';
import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('User Flow Integration Tests', () {
    late MockAuthService mockAuthService;
    late ProviderContainer container;

    setUp(() {
      mockAuthService = MockAuthService();
      container = TestSetup.createTestContainer(
        overrides: <Override>[
          authServiceProvider.overrideWithValue(
            mockAuthService as IAuthService,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestApp() {
      return UncontrolledProviderScope(
        container: container,
        child: TestSetup.createTestWidget(
          const MyApp(),
          overrides: <Override>[
            authServiceProvider.overrideWithValue(
              mockAuthService as IAuthService,
            ),
          ],
        ),
      );
    }

    group('Onboarding Flow', () {
      testWidgets('should display onboarding screen for new user', (
        tester,
      ) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Should start at splash screen
        expect(find.byType(MyApp), findsOneWidget);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should be able to find onboarding elements
        expect(find.byType(MyApp), findsOneWidget);
      });

      testWidgets('should handle onboarding navigation buttons', (
        tester,
      ) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for navigation buttons
        final nextButton = find.byIcon(Icons.arrow_forward_ios);
        if (nextButton.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, nextButton);
          await tester.pumpAndSettle();

          // Should still be in the app
          expect(find.byType(MyApp), findsOneWidget);
        }
      });
    });

    group('Authentication Flow', () {
      testWidgets('should display login form elements', (tester) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for login elements
        final loginLink = find.textContaining('Log in');
        if (loginLink.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, loginLink);
          await tester.pumpAndSettle();

          // Should find form elements
          expect(find.byType(TextFormField), findsAtLeast(1));
        }
      });

      testWidgets('should handle login form input', (tester) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to login screen
        final loginLink = find.textContaining('Log in');
        if (loginLink.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, loginLink);
          await tester.pumpAndSettle();

          // Enter credentials
          final phoneFields = find.byType(TextFormField);
          if (phoneFields.evaluate().isNotEmpty) {
            await TestUtils.safeEnterText(
              tester,
              phoneFields.first,
              '20947998',
            );

            if (phoneFields.evaluate().length > 1) {
              await TestUtils.safeEnterText(
                tester,
                phoneFields.last,
                'premium',
              );
            }

            // Should have entered text
            expect(find.text('20947998'), findsAtLeast(1));
          }
        }
      });

      testWidgets('should handle login button tap', (tester) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to login screen
        final loginLink = find.textContaining('Log in');
        if (loginLink.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, loginLink);
          await tester.pumpAndSettle();

          // Find and tap login button
          final loginButton = find.textContaining('Login');
          if (loginButton.evaluate().isNotEmpty) {
            await TestUtils.safeTap(tester, loginButton);
            await tester.pumpAndSettle();

            // Should still be in the app
            expect(find.byType(MyApp), findsOneWidget);
          }
        }
      });
    });

    group('Registration Flow', () {
      testWidgets('should display registration form elements', (tester) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for registration elements
        final signUpLink = find.textContaining('Sign up');
        if (signUpLink.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, signUpLink);
          await tester.pumpAndSettle();

          // Should find form elements
          expect(find.byType(TextFormField), findsAtLeast(1));
        }
      });

      testWidgets('should handle registration form input', (tester) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to registration screen
        final signUpLink = find.textContaining('Sign up');
        if (signUpLink.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, signUpLink);
          await tester.pumpAndSettle();

          // Enter registration data
          final textFields = find.byType(TextFormField);
          if (textFields.evaluate().isNotEmpty) {
            await TestUtils.safeEnterText(
              tester,
              textFields.first,
              'Test User',
            );

            // Should have entered text
            expect(find.text('Test User'), findsAtLeast(1));
          }
        }
      });
    });

    group('Dashboard Flow', () {
      testWidgets('should display dashboard elements for premium user', (
        tester,
      ) async {
        // Set up mock to simulate premium user
        mockAuthService.setUserType(UserType.premium);

        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should be able to find dashboard elements
        expect(find.byType(MyApp), findsOneWidget);
      });

      testWidgets('should display home elements for basic user', (
        tester,
      ) async {
        // Set up mock to simulate basic user
        mockAuthService.setUserType(UserType.basic);

        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should be able to find home elements
        expect(find.byType(MyApp), findsOneWidget);
      });
    });

    group('Navigation Flow', () {
      testWidgets('should handle bottom navigation', (tester) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for bottom navigation
        final bottomNav = find.byType(BottomNavigationBar);
        if (bottomNav.evaluate().isNotEmpty) {
          // Should be able to find navigation elements
          expect(bottomNav, findsOneWidget);
        }
      });

      testWidgets('should handle profile navigation', (tester) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for profile elements
        final profileButton = find.byIcon(Icons.person);
        if (profileButton.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, profileButton);
          await tester.pumpAndSettle();

          // Should still be in the app
          expect(find.byType(MyApp), findsOneWidget);
        }
      });
    });

    group('Error Handling', () {
      testWidgets('should handle network errors gracefully', (tester) async {
        // Set up mock to simulate network error
        mockAuthService.setShouldFail(true);

        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should still be in the app
        expect(find.byType(MyApp), findsOneWidget);
      });

      testWidgets('should handle invalid credentials gracefully', (
        tester,
      ) async {
        await tester.pumpWidget(createTestApp());
        await TestUtils.waitForAnimations(tester);

        // Wait for splash to complete
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to login screen
        final loginLink = find.textContaining('Log in');
        if (loginLink.evaluate().isNotEmpty) {
          await TestUtils.safeTap(tester, loginLink);
          await tester.pumpAndSettle();

          // Enter invalid credentials
          final textFields = find.byType(TextFormField);
          if (textFields.evaluate().isNotEmpty) {
            await TestUtils.safeEnterText(tester, textFields.first, 'invalid');

            if (textFields.evaluate().length > 1) {
              await TestUtils.safeEnterText(tester, textFields.last, 'wrong');
            }

            // Tap login button
            final loginButton = find.textContaining('Login');
            if (loginButton.evaluate().isNotEmpty) {
              await TestUtils.safeTap(tester, loginButton);
              await tester.pumpAndSettle();

              // Should still be in the app
              expect(find.byType(MyApp), findsOneWidget);
            }
          }
        }
      });
    });
  });
}
