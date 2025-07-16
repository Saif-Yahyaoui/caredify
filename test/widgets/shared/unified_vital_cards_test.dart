import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caredify/shared/widgets/unified_vital_cards.dart';
import 'package:caredify/shared/providers/auth_provider.dart';
import 'package:caredify/shared/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthService implements IAuthService {
  @override
  Future<UserCredential?> signInWithGoogle() async => null;
  @override
  Future<UserCredential?> signInWithFacebook() async => null;
  @override
  Future<bool> loginWithBiometrics(type, context) async => false;
  @override
  Future<UserType> loginWithCredentials(String phone, String password) async =>
      UserType.premium;
  @override
  bool get isLoggedIn => true;
  @override
  Future<void> signOut() async {}
  @override
  UserType get currentUserType => UserType.premium;
}

void main() {
  group('UnifiedVitalCards', () {
    testWidgets('renders and shows ECG label', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(MockAuthService()),
            authStateProvider.overrideWith(
              (ref) => AuthStateNotifier(MockAuthService()),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: UnifiedVitalCards()),
            ),
          ),
        ),
      );
      expect(find.byType(UnifiedVitalCards), findsOneWidget);
      expect(find.textContaining('ECG', findRichText: true), findsWidgets);
    });
  });
}
