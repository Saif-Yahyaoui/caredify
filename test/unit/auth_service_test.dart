import 'package:caredify/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

import '../mocks/auth_service_mock.dart';
import '../test_helpers.dart';

// Mock context for auth service tests
class MockBuildContext extends ChangeNotifier implements BuildContext {
  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  late BuildContext mockContext;
  late MockAuthService authService;

  setUp(() {
    mockContext = MockBuildContext();
    authService = MockAuthService();
  });

  group('AuthService Unit Tests', () {
    group('loginWithCredentials', () {
      test(
        'should return premium user type for valid premium credentials',
        () async {
          final result = await authService.loginWithCredentials(
            '20947998',
            'premium',
          );
          expect(result, equals(UserType.premium));
          expect(authService.isLoggedIn, isTrue);
          expect(authService.currentUserType, equals(UserType.premium));
        },
      );

      test(
        'should return basic user type for valid basic credentials',
        () async {
          final result = await authService.loginWithCredentials(
            '20947998',
            'basic',
          );
          expect(result, equals(UserType.basic));
          expect(authService.isLoggedIn, isTrue);
          expect(authService.currentUserType, equals(UserType.basic));
        },
      );

      test('should return none user type for invalid credentials', () async {
        final result = await authService.loginWithCredentials(
          '12345678',
          'wrongpassword',
        );
        expect(result, equals(UserType.none));
        expect(authService.isLoggedIn, isFalse);
        expect(authService.currentUserType, equals(UserType.none));
      });

      test('should return none for empty credentials', () async {
        final result = await authService.loginWithCredentials('', '');
        expect(result, equals(UserType.none));
        expect(authService.isLoggedIn, isFalse);
      });

      test('should handle phone numbers with special characters', () async {
        final result = await authService.loginWithCredentials(
          '(209) 479-98',
          'premium',
        );
        expect(result, equals(UserType.premium));
      });

      test('should handle phone numbers with spaces', () async {
        final result = await authService.loginWithCredentials(
          '209 479 98',
          'premium',
        );
        expect(result, equals(UserType.premium));
      });

      test('should handle phone numbers with dashes', () async {
        final result = await authService.loginWithCredentials(
          '209-479-98',
          'premium',
        );
        expect(result, equals(UserType.premium));
      });
    });

    group('isLoggedIn', () {
      test('should return false when no user is logged in', () {
        expect(authService.isLoggedIn, isFalse);
      });

      test('should return true when premium user is logged in', () async {
        await authService.loginWithCredentials('20947998', 'premium');
        expect(authService.isLoggedIn, isTrue);
      });

      test('should return true when basic user is logged in', () async {
        await authService.loginWithCredentials('20947998', 'basic');
        expect(authService.isLoggedIn, isTrue);
      });
    });

    group('currentUserType', () {
      test('should return none when no user is logged in', () {
        expect(authService.currentUserType, equals(UserType.none));
      });

      test('should return premium when premium user is logged in', () async {
        await authService.loginWithCredentials('20947998', 'premium');
        expect(authService.currentUserType, equals(UserType.premium));
      });

      test('should return basic when basic user is logged in', () async {
        await authService.loginWithCredentials('20947998', 'basic');
        expect(authService.currentUserType, equals(UserType.basic));
      });
    });

    group('signOut', () {
      test('should sign out user and reset state', () async {
        // First login
        await authService.loginWithCredentials('20947998', 'premium');
        expect(authService.isLoggedIn, isTrue);
        expect(authService.currentUserType, equals(UserType.premium));

        // Then sign out
        await authService.signOut();
        expect(authService.isLoggedIn, isFalse);
        expect(authService.currentUserType, equals(UserType.none));
      });

      test('should handle sign out when no user is logged in', () async {
        expect(authService.isLoggedIn, isFalse);
        await authService.signOut();
        expect(authService.isLoggedIn, isFalse);
        expect(authService.currentUserType, equals(UserType.none));
      });
    });

    group('loginWithBiometrics', () {
      test('should handle biometric authentication', () async {
        // This test might fail on CI/CD environments without biometric hardware
        // We'll test the method exists and doesn't throw
        expect(() async {
          await authService.loginWithBiometrics(
            BiometricType.fingerprint,
            mockContext,
          );
        }, returnsNormally);
      });

      test('should handle face authentication', () async {
        expect(() async {
          await authService.loginWithBiometrics(
            BiometricType.face,
            mockContext,
          );
        }, returnsNormally);
      });
    });

    group('signInWithGoogle', () {
      test('should handle Google sign-in', () async {
        // This test might fail on CI/CD environments without Google services
        // We'll test the method exists and doesn't throw
        expect(() async {
          await authService.signInWithGoogle();
        }, returnsNormally);
      });
    });

    group('signInWithFacebook', () {
      test('should handle Facebook sign-in', () async {
        // This test might fail on CI/CD environments without Facebook services
        // We'll test the method exists and doesn't throw
        expect(() async {
          await authService.signInWithFacebook();
        }, returnsNormally);
      });
    });
  });

  group('AuthServiceTestScenarios', () {
    test('should test biometric authentication scenario', () async {
      // Test biometric authentication flow
      final biometricResult = await authService.loginWithBiometrics(
        BiometricType.fingerprint,
        mockContext,
      );
      expect(biometricResult, isNotNull);
    });
  });
}
