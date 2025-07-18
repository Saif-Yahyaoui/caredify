import 'package:caredify/features/dashboard/screens/data_export_screen.dart';
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

import '../../test_helpers.dart';

// Custom test AuthStateNotifier for premium user
class FakeAuthService implements IAuthService {
  @override
  bool get isLoggedIn => true;
  @override
  UserType get currentUserType => UserType.premium;
  // The rest can throw UnimplementedError or return null
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

void main() {
  setUpAll(() async {
    await TestSetup.setupTestEnvironment();
  });

  Widget localizedTestableWidget(Widget child) {
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

  group('DataExportScreen Widget Tests', () {
    testWidgets('renders and displays all sections', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const DataExportScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DataExportScreen), findsOneWidget);
      expect(find.text('Export Your Health Data'), findsOneWidget);
      expect(find.text('Export Format'), findsOneWidget);
      expect(find.text('Date Range'), findsOneWidget);
      expect(find.text('Data Types'), findsOneWidget);
      expect(find.text('Export History'), findsOneWidget);
    });

    testWidgets('allows format selection', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const DataExportScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('PDF'), findsOneWidget);
      expect(find.text('CSV'), findsOneWidget);
      expect(find.text('JSON'), findsOneWidget);
      expect(find.text('XML'), findsOneWidget);
    });

    testWidgets('allows data type selection', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const DataExportScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('ECG'), findsOneWidget);
      expect(find.text('Heart Rate'), findsOneWidget);
      expect(find.text('Blood Pressure'), findsOneWidget);
      expect(find.text('SpO2'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Water Intake'), findsOneWidget);
      expect(find.text('Medication'), findsOneWidget);
    });

    testWidgets('displays export history', (tester) async {
      await tester.pumpWidget(
        localizedTestableWidget(const DataExportScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('2024-01-15 - PDF'), findsOneWidget);
      expect(find.text('2024-01-10 - CSV'), findsOneWidget);
      expect(find.text('2024-01-05 - PDF'), findsOneWidget);
    });
  });
}
