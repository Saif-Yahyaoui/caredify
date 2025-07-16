import 'package:caredify/features/auth/screens/splash_screen.dart';
import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:caredify/shared/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../mocks/auth_service_mock.dart';

/// Mock AuthState for testing navigation
class MockAuthState extends AuthState {
  MockAuthState({
    super.isLoggedIn,
    super.userType = UserType.basic,
    super.isLoading,
  });
}

void main() {
  late ProviderContainer container;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith(
          (ref) => AuthStateNotifier(MockAuthService()),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('SplashScreen renders and shows animated logo and loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SplashScreen(disableNavigation: true)),
      ),
    );

    // Start initial animations
    await tester.pump(); // first frame
    await tester.pump(const Duration(milliseconds: 300)); // scale animation
    await tester.pump(
      const Duration(milliseconds: 2500),
    ); // wait for transition

    // Find image by type
    expect(find.byType(Image), findsOneWidget);

    // Welcome message (via localization fallback)
    expect(find.byType(Text), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SplashScreen displays loading text and progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SplashScreen(disableNavigation: true)),
      ),
    );

    // Let the splash timer and animations complete (3 seconds total)
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.textContaining('Loading', findRichText: true),
      findsOneWidget,
    ); // Using English fallback
  });

  testWidgets('SplashScreen does not navigate when disableNavigation is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SplashScreen(disableNavigation: true)),
      ),
    );

    // Let the splash timer and animations complete (3 seconds total)
    await tester.pump(const Duration(seconds: 3));

    // No navigation is expected, we just assert it's still showing SplashScreen
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
