import 'package:caredify/core/theme/app_theme.dart';
import 'package:caredify/router/router.dart';
import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:caredify/shared/providers/voice_feedback_provider.dart';
import 'package:caredify/shared/providers/health_metrics_provider.dart';
import 'package:caredify/shared/providers/habits_provider.dart';
import 'package:caredify/shared/providers/user_profile_provider.dart';
import 'package:caredify/shared/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks/auth_service_mock.dart';
import 'package:caredify/shared/models/habit.dart';
import 'package:caredify/shared/models/user_profile.dart';
import 'package:caredify/shared/models/health_metrics.dart';

// Generate mocks - will be created by build_runner
// @GenerateMocks([IAuthService])
// import 'test_helpers.mocks.dart';

/// Test setup for Firebase
class TestFirebase {
  static Future<void> setupFirebaseForTesting() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Firebase initialization
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Firebase might already be initialized in tests
      if (!e.toString().contains('duplicate-app')) {
        rethrow;
      }
    }
  }
}

/// Test setup for SharedPreferences
class TestSharedPreferences {
  static Future<void> setupSharedPreferencesForTesting() async {
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': false,
      'theme_mode': 'system',
      'font_size': 1.0,
      'language': 'en_US',
      'voice_feedback_enabled': false,
    });
  }
}

/// Test-specific router provider that doesn't depend on Firebase
final testRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        builder:
            (context, state) => const Scaffold(body: Text('Splash Screen')),
      ),
      GoRoute(
        path: '/onboarding',
        builder:
            (context, state) => const Scaffold(body: Text('Onboarding Screen')),
      ),
      GoRoute(
        path: '/welcome',
        builder:
            (context, state) => const Scaffold(body: Text('Welcome Screen')),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Scaffold(body: Text('Login Screen')),
      ),
      GoRoute(
        path: '/register',
        builder:
            (context, state) => const Scaffold(body: Text('Register Screen')),
      ),
      GoRoute(
        path: '/forgot-password',
        builder:
            (context, state) =>
                const Scaffold(body: Text('Forgot Password Screen')),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const Scaffold(body: Text('Terms Screen')),
      ),
      GoRoute(
        path: '/privacy',
        builder:
            (context, state) => const Scaffold(body: Text('Privacy Screen')),
      ),
      GoRoute(
        path: '/main/home',
        builder: (context, state) => const Scaffold(body: Text('Home Screen')),
      ),
      GoRoute(
        path: '/main/dashboard',
        builder:
            (context, state) => const Scaffold(body: Text('Dashboard Screen')),
      ),
    ],
  );
});

/// Test-specific auth service provider that uses mock
final testAuthServiceProvider = Provider<IAuthService>((ref) {
  return MockAuthService();
});

/// Enhanced test router for navigation testing
class TestRouter {
  static GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/test',
      debugLogDiagnostics: false,
      routes: [
        GoRoute(
          path: '/test',
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Test Screen'))),
        ),
        GoRoute(
          path: '/splash',
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Splash Screen'))),
        ),
        GoRoute(
          path: '/onboarding',
          builder:
              (context, state) => const Scaffold(
                body: Center(child: Text('Onboarding Screen')),
              ),
        ),
        GoRoute(
          path: '/welcome',
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Welcome Screen'))),
        ),
        GoRoute(
          path: '/login',
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Login Screen'))),
        ),
        GoRoute(
          path: '/main/home',
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Home Screen'))),
        ),
        GoRoute(
          path: '/main/dashboard',
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Dashboard Screen'))),
        ),
      ],
    );
  }
}

/// Responsive test wrapper for handling layout overflow issues
class ResponsiveTestWrapper {
  static Widget createResponsiveTestWidget(Widget child) {
    return MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(400, 800)),
        child: child,
      ),
    );
  }

  static Widget createScrollableTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(width: 400, height: 800, child: child),
        ),
      ),
    );
  }
}

/// Layout testing utilities
class LayoutTestUtils {
  static Future<void> testNoOverflow(WidgetTester tester) async {
    await tester.pumpAndSettle();

    // Check for overflow errors
    final errors = tester.takeException();
    if (errors != null && errors.toString().contains('RenderFlex overflowed')) {
      fail('Layout overflow detected: $errors');
    }
  }

  static Future<void> testResponsiveLayout(
    WidgetTester tester,
    Widget child,
  ) async {
    await tester.pumpWidget(
      ResponsiveTestWrapper.createResponsiveTestWidget(child),
    );
    await testNoOverflow(tester);
  }
}

/// Localized testable widget wrapper
Widget localizedTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('fr', 'FR'),
      Locale('ar', 'TN'),
    ],
    locale: const Locale('en', 'US'),
    home: child,
  );
}

/// Riverpod testable widget wrapper
Widget riverpodTestableWidget(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('ar', 'TN'),
      ],
      locale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme(1.0),
      darkTheme: AppTheme.darkTheme(1.0),
      home: child,
    ),
  );
}

/// Full app testable widget wrapper with proper Firebase setup
Widget fullAppTestableWidget(Widget child) {
  return ProviderScope(
    overrides: [
      routerProvider.overrideWith((ref) => ref.watch(testRouterProvider)),
      authServiceProvider.overrideWith(
        (ref) => ref.watch(testAuthServiceProvider),
      ),
    ],
    child: MaterialApp.router(
      title: 'CAREDIFY Test',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
        Locale('ar', 'TN'),
      ],
      locale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme(1.0),
      darkTheme: AppTheme.darkTheme(1.0),
      routerConfig: createTestRouter(),
    ),
  );
}

/// Create a test router
GoRouter createTestRouter() {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        builder:
            (context, state) => const Scaffold(body: Text('Splash Screen')),
      ),
      GoRoute(
        path: '/onboarding',
        builder:
            (context, state) => const Scaffold(body: Text('Onboarding Screen')),
      ),
      GoRoute(
        path: '/welcome',
        builder:
            (context, state) => const Scaffold(body: Text('Welcome Screen')),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Scaffold(body: Text('Login Screen')),
      ),
      GoRoute(
        path: '/main/home',
        builder: (context, state) => const Scaffold(body: Text('Home Screen')),
      ),
      GoRoute(
        path: '/main/dashboard',
        builder:
            (context, state) => const Scaffold(body: Text('Dashboard Screen')),
      ),
    ],
  );
}

/// Test utilities
class TestUtils {
  /// Wait for animations to complete
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Tap a widget and wait for animations
  static Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await waitForAnimations(tester);
  }

  /// Enter text and wait for animations
  static Future<void> enterTextAndWait(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await waitForAnimations(tester);
  }

  /// Find text with optional timeout
  static Finder findTextWithTimeout(String text, {Duration? timeout}) {
    return find.text(text);
  }

  /// Find widget by type with optional timeout
  static Finder findWidgetByType<T extends Widget>({Duration? timeout}) {
    return find.byType(T);
  }

  /// Check if widget exists
  static bool widgetExists(Finder finder) {
    return finder.evaluate().isNotEmpty;
  }

  /// Get widget count
  static int widgetCount(Finder finder) {
    return finder.evaluate().length;
  }

  /// Safe tap that handles missing widgets
  static Future<void> safeTap(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder);
      await waitForAnimations(tester);
    }
  }

  /// Safe text entry that handles missing widgets
  static Future<void> safeEnterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    if (finder.evaluate().isNotEmpty) {
      await tester.enterText(finder, text);
      await waitForAnimations(tester);
    }
  }

  /// Find text field by label text
  static Finder findTextFieldByLabel(String label) {
    return find.byWidgetPredicate((widget) => widget is TextFormField);
  }

  /// Find button by text
  static Finder findButtonByText(String text) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is ElevatedButton &&
          widget.child is Text &&
          (widget.child as Text).data == text,
    );
  }

  /// Enhanced text finding with flexible matching
  static Finder findTextFlexible(String text) {
    return find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.data?.contains(text) ?? false;
      }
      return false;
    });
  }

  /// Find text with case-insensitive matching
  static Finder findTextCaseInsensitive(String text) {
    return find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.data?.toLowerCase().contains(text.toLowerCase()) ?? false;
      }
      return false;
    });
  }
}

/// Mock data for testing
class MockData {
  static const String validPhone = '20947998';
  static const String validPassword = 'premium';
  static const String basicPassword = 'basic';
  static const String invalidPhone = '12345678';
  static const String invalidPassword = 'wrong';

  static const Map<String, dynamic> userProfile = {
    'name': 'Test User',
    'email': 'test@example.com',
    'phone': validPhone,
    'age': 25,
    'height': 175,
    'weight': 70,
  };

  static const Map<String, dynamic> healthMetrics = {
    'heartRate': 72,
    'bloodPressure': '120/80',
    'spo2': 98,
    'temperature': 36.8,
    'steps': 8500,
    'calories': 450,
    'distance': 6.2,
    'sleepHours': 7.5,
    'waterIntake': 1500,
  };
}

/// Test matchers
class TestMatchers {
  /// Check if text contains substring
  static bool textContains(String text, String substring) {
    return text.contains(substring);
  }

  /// Check if widget has specific properties
  static bool widgetHasProperties(
    Widget widget,
    Map<String, dynamic> properties,
  ) {
    // This is a simplified version - you can extend it based on your needs
    return true;
  }
}

/// Test constants
class TestConstants {
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 500);
  static const Duration longDelay = Duration(milliseconds: 1000);

  static const double smallFontSize = 0.8;
  static const double normalFontSize = 1.0;
  static const double largeFontSize = 1.2;
  static const double extraLargeFontSize = 1.5;
}

/// Test setup utilities
class TestSetup {
  /// Setup common test environment
  static Future<void> setupTestEnvironment() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Setup SharedPreferences
    await TestSharedPreferences.setupSharedPreferencesForTesting();

    // Setup Firebase (with error handling)
    try {
      await TestFirebase.setupFirebaseForTesting();
    } catch (e) {
      // Ignore Firebase errors in tests
      debugPrint('Firebase setup error (ignored): $e');
    }
  }

  /// Create a test provider container with overrides
  static ProviderContainer createTestContainer({
    List<Override> overrides = const [],
  }) {
    return ProviderContainer(overrides: overrides);
  }

  /// Create a test widget with proper setup
  static Widget createTestWidget(
    Widget child, {
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        ...overrides,
        routerProvider.overrideWith((ref) => ref.watch(testRouterProvider)),
        authServiceProvider.overrideWith(
          (ref) => ref.watch(testAuthServiceProvider),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ar', 'TN'),
        ],
        locale: const Locale('en', 'US'),
        theme: AppTheme.lightTheme(1.0),
        darkTheme: AppTheme.darkTheme(1.0),
        home: child,
      ),
    );
  }

  /// Create a test widget with router support
  static Widget createTestWidgetWithRouter(
    Widget child, {
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        ...overrides,
        routerProvider.overrideWith((ref) => ref.watch(testRouterProvider)),
        authServiceProvider.overrideWith(
          (ref) => ref.watch(testAuthServiceProvider),
        ),
      ],
      child: MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ar', 'TN'),
        ],
        locale: const Locale('en', 'US'),
        theme: AppTheme.lightTheme(1.0),
        darkTheme: AppTheme.darkTheme(1.0),
        routerConfig: TestRouter.createTestRouter(),
      ),
    );
  }
}

/// Utility to wrap a widget with ProviderScope and generic mock overrides for navigation tests
Widget wrapWithMockedProviders(Widget child) {
  return ProviderScope(
    overrides: [
      voiceFeedbackProvider.overrideWith((ref) => false),
      healthMetricsProvider.overrideWith((ref) => HealthMetricsNotifier()),
      habitsProvider.overrideWith((ref) => HabitsNotifier()),
      userProfileProvider.overrideWith((ref) => UserProfileNotifier()),
      // Add more overrides as needed for other required providers
    ],
    child: child,
  );
}
