import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Google sign in
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
    if (gUser == null) return null;
    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  /// Biometric login (fingerprint or face)
  Future<bool> loginWithBiometrics(
    BiometricType type,
    BuildContext context,
  ) async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!isDeviceSupported || !canCheckBiometrics) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric not available on this device'),
          ),
        );
        return false;
      }
      final available = await _localAuth.getAvailableBiometrics();
      print('Available biometrics: $available'); // Debug
      if (available.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No biometrics enrolled on this device.'),
          ),
        );
        return false;
      }
      // Allow any available biometric
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason:
            type == BiometricType.fingerprint
                ? 'Authenticate with fingerprint'
                : 'Authenticate with face',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication error: $e')),
      );
      return false;
    }
  }

  /// Simple hardcoded credential login
  Future<bool> loginWithCredentials(String phone, String password) async {
    // Hardcoded credentials for temporary use
    const validPhone = '20947998';
    const validPassword = '20947998saif';

    // Clean the phone number (remove any non-digit characters)
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Check if credentials match
    return cleanPhone == validPhone && password == validPassword;
  }

  /// Get current user (simulated)
  bool get isLoggedIn => true; // Always return true for now

  /// Sign out (simulated)
  Future<void> signOut() async {
    // Simulate sign out
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
