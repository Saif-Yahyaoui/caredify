import 'package:flutter/material.dart';

/// Models used in the authentication feature

/// Onboarding card data model
class OnboardingCardData {
  final IconData? icon;
  final Color? iconColor;
  final String? imageAsset;
  final String title;
  final String subtitle;
  final List<String> features;
  final String? featuresTitle;
  final String? bottomText;

  const OnboardingCardData({
    this.icon,
    this.iconColor,
    this.imageAsset,
    required this.title,
    required this.subtitle,
    this.features = const [],
    this.featuresTitle,
    this.bottomText,
  });
}

/// Authentication form data model
class AuthFormData {
  final String? email;
  final String? phone;
  final String? password;
  final String? confirmPassword;
  final String? name;

  const AuthFormData({
    this.email,
    this.phone,
    this.password,
    this.confirmPassword,
    this.name,
  });

  AuthFormData copyWith({
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? name,
  }) {
    return AuthFormData(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
    );
  }
}

/// Authentication state model
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  AuthState clearMessages() {
    return copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }
}
