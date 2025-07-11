import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:caredify/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthService implements IAuthService {
  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<bool> loginWithBiometrics(
    BiometricType type,
    BuildContext context,
  ) async => true;

  @override
  Future<bool> loginWithCredentials(String phone, String password) async =>
      true;

  @override
  bool get isLoggedIn => true;

  @override
  Future<void> signOut() async {}
}
