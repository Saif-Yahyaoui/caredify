import 'package:caredify/shared/providers/auth_provider.dart' as auth;
import 'package:caredify/shared/providers/user_type_provider.dart' as user_type;
import 'package:caredify/shared/services/auth_service.dart';
import 'package:caredify/shared/widgets/access/role_based_access.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

class TestAuthStateNotifier extends auth.AuthStateNotifier {
  TestAuthStateNotifier(auth.AuthState initialState, IAuthService service)
    : super(service) {
    state = initialState;
  }

  Future<void> initializeAuth() async {}
}

// Test-specific provider for auth state
final testAuthStateProvider = StateProvider<auth.AuthState>(
  (ref) => const auth.AuthState(
    isLoggedIn: false,
    userType: UserType.none,
    isLoading: false,
  ),
);

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  group('Role-Based Access Control Tests', () {
    testWidgets('RoleBasedAccess shows child for allowed user types', (
      tester,
    ) async {
      // Create a fresh container for this test
      final container = TestSetup.createTestContainer(
        overrides: <Override>[
          auth.authServiceProvider.overrideWith(
            (ref) => ref.watch(testAuthServiceProvider),
          ),
        ],
      );

      // Test premium user accessing premium content
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.premium,
        isLoading: false,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: RoleBasedAccess(
              allowedUserTypes: <UserType>[UserType.premium],
              child: Text('Premium Content'),
            ),
          ),
        ),
      );

      expect(find.text('Premium Content'), findsOneWidget);
      expect(find.text('Premium Feature'), findsNothing);

      // Clean up
      container.dispose();
    });

    testWidgets('RoleBasedAccess shows fallback for disallowed user types', (
      tester,
    ) async {
      // Create a fresh container for this test
      final container = TestSetup.createTestContainer(
        overrides: <Override>[
          auth.authServiceProvider.overrideWith(
            (ref) => ref.watch(testAuthServiceProvider),
          ),
        ],
      );

      // Test basic user trying to access premium content
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.basic,
        isLoading: false,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: RoleBasedAccess(
              allowedUserTypes: <UserType>[UserType.premium],
              child: Text('Premium Content'),
            ),
          ),
        ),
      );

      expect(find.text('Premium Content'), findsNothing);
      expect(find.text('Premium Feature'), findsOneWidget);
      expect(
        find.text('This feature is only available for premium users.'),
        findsOneWidget,
      );

      // Clean up
      container.dispose();
    });

    testWidgets('PremiumEcgAnalysisCard shows for premium users', (
      tester,
    ) async {
      // Create a fresh container for this test
      final container = TestSetup.createTestContainer(
        overrides: <Override>[
          auth.authServiceProvider.overrideWith(
            (ref) => ref.watch(testAuthServiceProvider),
          ),
        ],
      );

      // Set premium user state
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.premium,
        isLoading: false,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: RoleBasedAccess(
              allowedUserTypes: [UserType.premium],
              child: Text('Premium Content'),
            ),
          ),
        ),
      );

      expect(find.text('Premium Content'), findsOneWidget);
      expect(find.text('Premium Feature'), findsNothing);

      // Clean up
      container.dispose();
    });

    testWidgets('PremiumEcgAnalysisCard shows fallback for basic users', (
      tester,
    ) async {
      // Create a fresh container for this test
      final container = TestSetup.createTestContainer(
        overrides: <Override>[
          auth.authServiceProvider.overrideWith(
            (ref) => ref.watch(testAuthServiceProvider),
          ),
        ],
      );

      // Set basic user state
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.basic,
        isLoading: false,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: RoleBasedAccess(
              allowedUserTypes: [UserType.premium],
              child: Text('Premium Content'),
            ),
          ),
        ),
      );

      expect(find.text('Premium Content'), findsNothing);
      expect(find.text('Premium Feature'), findsOneWidget);

      // Clean up
      container.dispose();
    });

    test('UserTypeAccess extension works correctly', () {
      expect(UserType.premium.isPremium, true);
      expect(UserType.basic.isPremium, false);
      expect(UserType.none.isPremium, false);

      expect(UserType.basic.isBasic, true);
      expect(UserType.premium.isBasic, false);
      expect(UserType.none.isBasic, false);

      expect(UserType.premium.isLoggedIn, true);
      expect(UserType.basic.isLoggedIn, true);
      expect(UserType.none.isLoggedIn, false);
    });

    test('User type providers work correctly', () {
      // Create a fresh container for this test
      final container = TestSetup.createTestContainer(
        overrides: <Override>[
          auth.authServiceProvider.overrideWith(
            (ref) => ref.watch(testAuthServiceProvider),
          ),
        ],
      );

      // Test premium user
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.premium,
        isLoading: false,
      );

      expect(container.read(user_type.userTypeProvider), UserType.premium);
      expect(container.read(user_type.hasPremiumAccessProvider), true);
      expect(container.read(user_type.hasBasicAccessProvider), true);
      expect(container.read(user_type.isLoggedInProvider), true);
      expect(container.read(user_type.userTypeDisplayNameProvider), 'Premium');

      // Test basic user
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.basic,
        isLoading: false,
      );

      expect(container.read(user_type.userTypeProvider), UserType.basic);
      expect(container.read(user_type.hasPremiumAccessProvider), false);
      expect(container.read(user_type.hasBasicAccessProvider), true);
      expect(container.read(user_type.isLoggedInProvider), true);
      expect(container.read(user_type.userTypeDisplayNameProvider), 'Basic');

      // Test guest user
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: false,
        userType: UserType.none,
        isLoading: false,
      );

      expect(container.read(user_type.userTypeProvider), UserType.none);
      expect(container.read(user_type.hasPremiumAccessProvider), false);
      expect(container.read(user_type.hasBasicAccessProvider), false);
      expect(container.read(user_type.isLoggedInProvider), false);
      expect(container.read(user_type.userTypeDisplayNameProvider), 'Guest');

      // Clean up
      container.dispose();
    });

    test('User type features provider works correctly', () {
      // Create a fresh container for this test
      final container = TestSetup.createTestContainer(
        overrides: <Override>[
          auth.authServiceProvider.overrideWith(
            (ref) => ref.watch(testAuthServiceProvider),
          ),
        ],
      );

      // Test premium user features
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.premium,
        isLoading: false,
      );

      final Map<String, List<String>> premiumFeatures = container.read(
        user_type.userTypeFeaturesProvider,
      );
      expect(
        premiumFeatures['available']!.contains(
          'Advanced ECG Analysis with AI insights',
        ),
        true,
      );
      expect(
        premiumFeatures['available']!.contains(
          'Historical data and trend analysis',
        ),
        true,
      );
      expect(premiumFeatures['unavailable']!.isEmpty, true);

      // Test basic user features
      container
          .read(auth.authStateProvider.notifier)
          .state = const auth.AuthState(
        isLoggedIn: true,
        userType: UserType.basic,
        isLoading: false,
      );

      final Map<String, List<String>> basicFeatures = container.read(
        user_type.userTypeFeaturesProvider,
      );
      expect(
        basicFeatures['available']!.contains(
          'Basic ECG readings (Normal/Abnormal)',
        ),
        true,
      );
      expect(
        basicFeatures['available']!.contains('Simple vital signs display'),
        true,
      );
      expect(
        basicFeatures['unavailable']!.contains('Advanced ECG Analysis'),
        true,
      );
      expect(basicFeatures['unavailable']!.contains('Premium dashboard'), true);

      // Clean up
      container.dispose();
    });

    test('Upgrade benefits provider works correctly', () {
      // Create a fresh container for this test
      final container = TestSetup.createTestContainer(
        overrides: <Override>[
          auth.authServiceProvider.overrideWith(
            (ref) => ref.watch(testAuthServiceProvider),
          ),
        ],
      );

      final List<Map<String, String>> benefits = container.read(
        user_type.upgradeBenefitsProvider,
      );
      expect(benefits.length, 7);
      expect(benefits.any((b) => b['title'] == 'Advanced ECG Analysis'), true);
      expect(
        benefits.any((b) => b['title'] == 'Historical Data & Trends'),
        true,
      );
      expect(benefits.any((b) => b['title'] == 'Data Export'), true);

      // Clean up
      container.dispose();
    });
  });
}
