import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/constants/error_messages.dart';

// Add user type enum
enum UserType { basic, premium, none }

// Abstract interface for easier testing
abstract class IAuthService {
  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithFacebook();
  Future<bool> loginWithBiometrics(BiometricType type, BuildContext context);
  Future<UserType> loginWithCredentials(String phone, String password);
  bool get isLoggedIn;
  Future<void> signOut();
  UserType get currentUserType;
}

class AuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final LocalAuthentication _localAuth = LocalAuthentication();
  UserType _currentUserType = UserType.none;
  @override
  UserType get currentUserType => _currentUserType;

  @override
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

  @override
  /// Facebook sign in
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        // Sign in to Firebase with the credential
        return await _firebaseAuth.signInWithCredential(credential);
      } else {
        // User cancelled or login failed
        return null;
      }
    } catch (e) {
      // Handle any errors
      debugPrint('Facebook sign-in error: $e');
      return null;
    }
  }

  @override
  /// Biometric login (fingerprint or face)
  Future<bool> loginWithBiometrics(
    BiometricType type,
    BuildContext context,
  ) async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!isDeviceSupported || !canCheckBiometrics) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(ErrorMessages.biometricUnavailable)),
          );
        }
        return false;
      }
      final available = await _localAuth.getAvailableBiometrics();
      if (available.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(ErrorMessages.noBiometricsEnrolled)),
          );
        }
        return false;
      }
      // Allow any available biometric
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason:
            type == BiometricType.fingerprint
                ? 'Authenticate with fingerprint'
                : 'Authenticate with face', // Consider localizing this
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ErrorMessages.biometricAuthError}: $e')),
        );
      }
      return false;
    }
  }

  @override
  /// Simple hardcoded credential login
  Future<UserType> loginWithCredentials(String phone, String password) async {
    // Clean the phone number (remove any non-digit characters)
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone == '20947998' && password == 'premium') {
      _currentUserType = UserType.premium;
      return UserType.premium;
    } else if (cleanPhone == '20947998' && password == 'basic') {
      _currentUserType = UserType.basic;
      return UserType.basic;
    } else {
      _currentUserType = UserType.none;
      return UserType.none;
    }
  }

  @override
  /// Get current user (simulated)
  bool get isLoggedIn {
    final result = _currentUserType != UserType.none;
    debugPrint(
      'AuthService: isLoggedIn called, returning $result (userType: $_currentUserType)',
    );
    return result;
  }

  @override
  /// Sign out (simulated)
  Future<void> signOut() async {
    // Simulate sign out
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUserType = UserType.none;
  }
}
