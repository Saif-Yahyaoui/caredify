import 'package:caredify/features/dashboard/screens/dashboard_screen.dart';
import 'package:caredify/shared/widgets/cards/unified_vital_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:caredify/shared/providers/auth_provider.dart'
    show authStateProvider, AuthState, AuthStateNotifier;
import 'package:caredify/shared/services/auth_service.dart'
    show UserType, IAuthService;
import 'package:firebase_auth/firebase_auth.dart' show UserCredential;
import 'package:go_router/go_router.dart';

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

Widget testableWidgetWithRouter(Widget child) {
  final router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(path: '/dashboard', builder: (context, state) => child),
      GoRoute(
        path: '/main/dashboard/ecg-analysis',
        builder:
            (context, state) =>
                const Scaffold(body: Text('ECG Details Screen')),
      ),
      GoRoute(
        path: '/ecg',
        builder:
            (context, state) =>
                const Scaffold(body: Text('ECG Details Screen')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => TestAuthStateNotifier()),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
    ),
  );
}

void main() {
  group('DashboardScreen Widget Tests', () {
    testWidgets('renders dashboard screen with all components', (tester) async {
      await tester.pumpWidget(testableWidget(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(UnifiedVitalCards), findsOneWidget);
    });

    testWidgets('displays unified vital cards', (tester) async {
      await tester.pumpWidget(testableWidget(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(UnifiedVitalCards), findsOneWidget);
    });

    testWidgets('navigates to ECG details on ECG card tap', (tester) async {
      await tester.pumpWidget(
        testableWidgetWithRouter(const DashboardScreen()),
      );
      await tester.pumpAndSettle();
      final ecgFinder = find.textContaining('ECG');
      expect(ecgFinder, findsWidgets);
      await tester.ensureVisible(ecgFinder.first);
      await tester.tap(ecgFinder.first);
      await tester.pumpAndSettle();
      expect(find.text('ECG Details Screen'), findsOneWidget);
    });
  });
}
