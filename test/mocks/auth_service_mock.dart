import 'package:caredify/shared/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

// Generate mocks - will be created by build_runner
// @GenerateMocks([IAuthService])
// import 'auth_service_mock.mocks.dart';

/// Mock implementation of IAuthService for testing
class MockAuthService implements IAuthService {
  UserType _currentUserType = UserType.none;
  bool _isLoggedIn = false;
  bool _shouldFail = false;
  String _failureReason = '';

  /// Set the current user type for testing
  void setUserType(UserType userType) {
    _currentUserType = userType;
    _isLoggedIn = userType != UserType.none;
  }

  /// Set whether the service should fail
  void setShouldFail(bool shouldFail, {String reason = 'Mock failure'}) {
    _shouldFail = shouldFail;
    _failureReason = reason;
  }

  /// Reset the mock state
  void reset() {
    _currentUserType = UserType.none;
    _isLoggedIn = false;
    _shouldFail = false;
    _failureReason = '';
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    if (_shouldFail) {
      throw Exception(_failureReason);
    }

    // Simulate successful Google sign-in for premium users
    if (_currentUserType == UserType.premium) {
      return null; // Mock UserCredential
    }
    return null;
  }

  @override
  Future<UserCredential?> signInWithFacebook() async {
    if (_shouldFail) {
      throw Exception(_failureReason);
    }

    // Simulate successful Facebook sign-in for basic users
    if (_currentUserType == UserType.basic) {
      return null; // Mock UserCredential
    }
    return null;
  }

  @override
  Future<bool> loginWithBiometrics(
    BiometricType type,
    BuildContext context,
  ) async {
    if (_shouldFail) {
      throw Exception(_failureReason);
    }

    // Simulate biometric authentication
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUserType != UserType.none;
  }

  @override
  Future<UserType> loginWithCredentials(String phone, String password) async {
    if (_shouldFail) {
      throw Exception(_failureReason);
    }

    // Simulate credential validation
    await Future.delayed(const Duration(milliseconds: 100));

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone == '20947998' && password == 'premium') {
      _currentUserType = UserType.premium;
      _isLoggedIn = true;
      return UserType.premium;
    } else if (cleanPhone == '20947998' && password == 'basic') {
      _currentUserType = UserType.basic;
      _isLoggedIn = true;
      return UserType.basic;
    } else {
      _currentUserType = UserType.none;
      _isLoggedIn = false;
      return UserType.none;
    }
  }

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  Future<void> signOut() async {
    if (_shouldFail) {
      throw Exception(_failureReason);
    }

    await Future.delayed(const Duration(milliseconds: 100));
    _currentUserType = UserType.none;
    _isLoggedIn = false;
  }

  @override
  UserType get currentUserType => _currentUserType;
}

/// Test scenarios for auth service
class AuthServiceTestScenarios {
  static const String validPhone = '20947998';
  static const String premiumPassword = 'premium';
  static const String basicPassword = 'basic';
  static const String invalidPhone = '12345678';
  static const String invalidPassword = 'wrong';

  /// Test valid premium login
  static Future<UserType> testValidPremiumLogin(
    IAuthService authService,
  ) async {
    return await authService.loginWithCredentials(validPhone, premiumPassword);
  }

  /// Test valid basic login
  static Future<UserType> testValidBasicLogin(IAuthService authService) async {
    return await authService.loginWithCredentials(validPhone, basicPassword);
  }

  /// Test invalid login
  static Future<UserType> testInvalidLogin(IAuthService authService) async {
    return await authService.loginWithCredentials(
      invalidPhone,
      invalidPassword,
    );
  }

  /// Test biometric authentication
  static Future<bool> testBiometricAuth(
    IAuthService authService,
    BuildContext context,
  ) async {
    return await authService.loginWithBiometrics(
      BiometricType.fingerprint,
      context,
    );
  }

  /// Test Google sign-in
  static Future<UserCredential?> testGoogleSignIn(
    IAuthService authService,
  ) async {
    return await authService.signInWithGoogle();
  }

  /// Test Facebook sign-in
  static Future<UserCredential?> testFacebookSignIn(
    IAuthService authService,
  ) async {
    return await authService.signInWithFacebook();
  }
}
