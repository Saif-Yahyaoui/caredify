
import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:caredify/shared/providers/user_type_provider.dart';
import 'package:caredify/shared/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/auth_service_mock.dart';
import '../test_helpers.dart';

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('AuthProvider', () {
    late ProviderContainer container;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      container = TestSetup.createTestContainer(
        overrides: <Override>[
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('authStateProvider', () {
      test('should initialize with default state', () {
        final AuthState authState = container.read(authStateProvider);
        expect(authState.isLoggedIn, isFalse);
        expect(authState.userType, equals(UserType.none));
        expect(authState.isLoading, isFalse);
      });

      test('should initialize auth state correctly', () async {
        // Set up mock to return logged in state
        mockAuthService.setUserType(UserType.premium);

        // Create a new container to trigger initialization
        final ProviderContainer newContainer = TestSetup.createTestContainer(
          overrides: <Override>[
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
        );

        // Wait for initialization
        await Future<void>.delayed(const Duration(milliseconds: 100));

        final AuthState authState = newContainer.read(authStateProvider);
        expect(authState.isLoggedIn, isTrue);
        expect(authState.userType, equals(UserType.premium));
        expect(authState.isLoading, isFalse);

        newContainer.dispose();
      });

      test('should handle login with premium credentials', () async {
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        await notifier.login('20947998', 'premium');

        final AuthState authState = container.read(authStateProvider);
        expect(authState.isLoggedIn, isTrue);
        expect(authState.userType, equals(UserType.premium));
        expect(authState.isLoading, isFalse);
      });

      test('should handle login with basic credentials', () async {
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        await notifier.login('20947998', 'basic');

        final AuthState authState = container.read(authStateProvider);
        expect(authState.isLoggedIn, isTrue);
        expect(authState.userType, equals(UserType.basic));
        expect(authState.isLoading, isFalse);
      });

      test('should handle login with invalid credentials', () async {
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        await notifier.login('12345678', 'wrong');

        final AuthState authState = container.read(authStateProvider);
        expect(authState.isLoggedIn, isFalse);
        expect(authState.userType, equals(UserType.none));
        expect(authState.isLoading, isFalse);
      });

      test('should handle login failure', () async {
        mockAuthService.setShouldFail(true, reason: 'Network error');
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        try {
          await notifier.login('20947998', 'premium');
          fail('Expected exception to be thrown');
        } catch (e) {
          // Exception was thrown as expected
        }

        final AuthState authState = container.read(authStateProvider);
        expect(authState.isLoading, isFalse);
      });

      test('should handle logout', () async {
        // First login
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );
        await notifier.login('20947998', 'premium');

        // Verify logged in
        AuthState authState = container.read(authStateProvider);
        expect(authState.isLoggedIn, isTrue);

        // Then logout
        await notifier.logout();

        // Verify logged out
        authState = container.read(authStateProvider);
        expect(authState.isLoggedIn, isFalse);
        expect(authState.userType, equals(UserType.none));
        expect(authState.isLoading, isFalse);
      });

      test('should handle logout failure', () async {
        mockAuthService.setShouldFail(true, reason: 'Logout error');
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        try {
          await notifier.logout();
          fail('Expected exception to be thrown');
        } catch (e) {
          // Exception was thrown as expected
        }

        final AuthState authState = container.read(authStateProvider);
        expect(authState.isLoading, isFalse);
      });

      test('should show loading state during login', () async {
        // Set up mock to delay response
        mockAuthService.setShouldFail(false);

        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        // Start login (this will be async)
        final Future<void> loginFuture = notifier.login('20947998', 'premium');

        // Check loading state immediately
        AuthState authState = container.read(authStateProvider);
        expect(authState.isLoading, isTrue);

        // Wait for login to complete
        await loginFuture;

        // Check final state
        authState = container.read(authStateProvider);
        expect(authState.isLoading, isFalse);
        expect(authState.isLoggedIn, isTrue);
      });

      test('should show loading state during logout', () async {
        // First login
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );
        await notifier.login('20947998', 'premium');

        // Start logout (this will be async)
        final Future<void> logoutFuture = notifier.logout();

        // Check loading state immediately
        AuthState authState = container.read(authStateProvider);
        expect(authState.isLoading, isTrue);

        // Wait for logout to complete
        await logoutFuture;

        // Check final state
        authState = container.read(authStateProvider);
        expect(authState.isLoading, isFalse);
        expect(authState.isLoggedIn, isFalse);
      });
    });

    group('userTypeProvider', () {
      test('should return none by default', () {
        final UserType userType = container.read(userTypeProvider);
        expect(userType, equals(UserType.none));
      });

      test('should update when auth state changes', () async {
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        await notifier.login('20947998', 'premium');

        final UserType userType = container.read(userTypeProvider);
        expect(userType, equals(UserType.premium));
      });
    });

    group('AuthState', () {
      test('should create with default values', () {
        const AuthState authState = AuthState();
        expect(authState.isLoggedIn, isFalse);
        expect(authState.userType, equals(UserType.none));
        expect(authState.isLoading, isFalse);
      });

      test('should create with custom values', () {
        const AuthState authState = AuthState(
          isLoggedIn: true,
          userType: UserType.premium,
          isLoading: true,
        );
        expect(authState.isLoggedIn, isTrue);
        expect(authState.userType, equals(UserType.premium));
        expect(authState.isLoading, isTrue);
      });

      test('should copy with new values', () {
        const AuthState originalState = AuthState(
          isLoggedIn: false,
          userType: UserType.none,
          isLoading: false,
        );

        final AuthState newState = originalState.copyWith(
          isLoggedIn: true,
          userType: UserType.premium,
        );

        expect(newState.isLoggedIn, isTrue);
        expect(newState.userType, equals(UserType.premium));
        expect(newState.isLoading, isFalse); // Should remain unchanged
      });

      test('should copy with partial values', () {
        const AuthState originalState = AuthState(
          isLoggedIn: true,
          userType: UserType.premium,
          isLoading: false,
        );

        final AuthState newState = originalState.copyWith(isLoading: true);

        expect(newState.isLoggedIn, isTrue); // Should remain unchanged
        expect(
          newState.userType,
          equals(UserType.premium),
        ); // Should remain unchanged
        expect(newState.isLoading, isTrue);
      });
    });

    group('AuthStateNotifier', () {
      test('should initialize with default state', () {
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );
        final AuthState state = notifier.state;

        expect(state.isLoggedIn, isFalse);
        expect(state.userType, equals(UserType.none));
        expect(state.isLoading, isFalse);
      });

      test('should handle state transitions correctly', () async {
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        // Initial state
        expect(notifier.state.isLoggedIn, isFalse);
        expect(notifier.state.userType, equals(UserType.none));

        // Login
        await notifier.login('20947998', 'premium');
        expect(notifier.state.isLoggedIn, isTrue);
        expect(notifier.state.userType, equals(UserType.premium));

        // Logout
        await notifier.logout();
        expect(notifier.state.isLoggedIn, isFalse);
        expect(notifier.state.userType, equals(UserType.none));
      });

      test('should handle multiple rapid state changes', () async {
        final AuthStateNotifier notifier = container.read(
          authStateProvider.notifier,
        );

        // Start multiple operations
        final Future<void> loginFuture1 = notifier.login('20947998', 'premium');
        final Future<void> loginFuture2 = notifier.login('20947998', 'basic');
        final Future<void> logoutFuture = notifier.logout();

        // Wait for all operations to complete
        await Future.wait<void>([loginFuture1, loginFuture2, logoutFuture]);

        // Final state should be logged out
        expect(notifier.state.isLoggedIn, isFalse);
        expect(notifier.state.userType, equals(UserType.none));
      });
    });
  });
}
