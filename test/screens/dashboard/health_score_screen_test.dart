import 'package:caredify/features/dashboard/screens/health_score_screen.dart';
import 'package:caredify/shared/providers/auth_provider.dart'
    show authStateProvider, AuthState, AuthStateNotifier;
import 'package:caredify/shared/services/auth_service.dart'
    show UserType, IAuthService;
import 'package:firebase_auth/firebase_auth.dart' show UserCredential;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthService implements IAuthService {
  @override
  bool get isLoggedIn => true;
  @override
  UserType get currentUserType => UserType.premium;
  @override
  Future<void> signOut() async => throw UnimplementedError();
  @override
  Future<UserType> loginWithCredentials(String phone, String password) async =>
      UserType.premium;
  @override
  Future<UserCredential?> signInWithGoogle() async =>
      throw UnimplementedError();
  @override
  Future<UserCredential?> signInWithFacebook() async =>
      throw UnimplementedError();
  @override
  Future<bool> loginWithBiometrics(type, context) async =>
      throw UnimplementedError();
}

class TestAuthStateNotifier extends AuthStateNotifier {
  TestAuthStateNotifier() : super(FakeAuthService()) {
    state = const AuthState(isLoggedIn: true, userType: UserType.premium);
  }
}

Widget testableWidget(Widget child) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => TestAuthStateNotifier()),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
      home: child,
    ),
  );
}

void main() {
  group('HealthScoreScreen Widget Tests', () {
    testWidgets('renders and displays all tabs', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 1600);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(testableWidget(const HealthScoreScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Overview'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();
      expect(find.text('Breakdown'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.trending_up));
      await tester.pumpAndSettle();
      expect(find.text('Trends'), findsOneWidget);

      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });
    });

    testWidgets('switches between tabs and displays content', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 1600);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(testableWidget(const HealthScoreScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Overview'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();
      expect(find.text('Breakdown'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.trending_up));
      await tester.pumpAndSettle();
      expect(find.text('Trends'), findsOneWidget);

      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });
    });
  });
}
