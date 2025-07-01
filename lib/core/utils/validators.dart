import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Validation utilities for form inputs
class Validators {
  /// Validate phone number format
  static String? validatePhone(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }

    // Remove spaces and special characters
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check for minimum length (8 digits for most countries)
    if (cleanPhone.length < 8) {
      return AppLocalizations.of(context)!.phoneMinLength;
    }

    // Check for maximum length (15 digits max)
    if (cleanPhone.length > 15) {
      return AppLocalizations.of(context)!.phoneMaxLength;
    }

    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }

    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMinLength;
    }

    // Optional: Add more password strength requirements
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
    //   return 'Le mot de passe doit contenir au moins une lettre majuscule, une lettre minuscule et un chiffre';
    // }

    return null;
  }

  /// Validate email format
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.emailInvalid;
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(
    String? value,
    String fieldName,
    BuildContext context,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppLocalizations.of(context)!.fieldRequired.toLowerCase()}';
    }
    return null;
  }

  /// Validate name format
  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.nameRequired;
    }

    if (value.trim().length < 2) {
      return AppLocalizations.of(context)!.nameMinLength;
    }

    // Check for valid name characters (letters and spaces only)
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.nameInvalid;
    }

    return null;
  }
}
