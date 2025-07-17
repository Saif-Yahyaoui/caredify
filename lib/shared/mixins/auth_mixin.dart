import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/auth_constants.dart';
import '../../core/navigation/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/widgets/auth_floating_card.dart';
import '../../features/auth/widgets/auth_logo_header.dart';
import '../../features/auth/widgets/auth_message_container.dart';
import '../widgets/custom_button.dart';

/// Mixin providing common authentication functionality
mixin AuthMixin<T extends StatefulWidget> on State<T> {
  /// Shows error message in a snackbar
  void showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.alertRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows success message in a snackbar
  void showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.healthGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Navigate to login screen
  void navigateToLogin() {
    context.go(RouteNames.login);
  }

  /// Navigate to register screen
  void navigateToRegister() {
    context.go(RouteNames.register);
  }

  /// Navigate to forgot password screen
  void navigateToForgotPassword() {
    context.push(RouteNames.forgotPassword);
  }

  /// Navigate to terms of service
  void navigateToTerms() {
    context.push(RouteNames.terms);
  }

  /// Navigate to privacy policy
  void navigateToPrivacy() {
    context.push(RouteNames.privacy);
  }

  /// Build common header with logo
  Widget buildAuthHeader({required bool isDark, String? subtitle}) {
    return AuthFloatingCard(
      isPrimary: true,
      child: AuthLogoHeader(isDark: isDark, subtitle: subtitle),
    );
  }

  /// Build common error message container
  Widget buildErrorMessage(String? errorMessage) {
    if (errorMessage == null) return const SizedBox.shrink();

    return AuthMessageContainer(message: errorMessage, isError: true);
  }

  /// Build common success message container
  Widget buildSuccessMessage(String? successMessage) {
    if (successMessage == null) return const SizedBox.shrink();

    return AuthMessageContainer(message: successMessage, isError: false);
  }

  /// Build common action buttons
  Widget buildActionButtons({
    required String primaryText,
    required VoidCallback onPrimaryPressed,
    String? secondaryText,
    VoidCallback? onSecondaryPressed,
    bool isLoading = false,
    IconData? primaryIcon,
    IconData? secondaryIcon,
  }) {
    return Column(
      children: [
        CustomButton.primary(
          text: primaryText,
          onPressed: isLoading ? null : onPrimaryPressed,
          isLoading: isLoading,
          icon: primaryIcon,
        ),
        if (secondaryText != null) ...[
          const SizedBox(height: AuthConstants.spacingSmall),
          CustomButton.secondary(
            text: secondaryText,
            onPressed: onSecondaryPressed,
            icon: secondaryIcon,
          ),
        ],
      ],
    );
  }

  /// Build common footer with terms and privacy links
  Widget buildFooter() {
    final t = AppLocalizations.of(context)!;
    
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: navigateToTerms,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              t.termsOfService,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 16,
          color: AppColors.textSecondary.withAlpha((0.3 * 255).toInt()),
        ),
        Expanded(
          child: TextButton(
            onPressed: navigateToPrivacy,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              t.privacyPolicy,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  /// Get appropriate language code for TTS
  String getLanguageCode() {
    final locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'ar':
        return AuthConstants.arabicLanguageCode;
      case 'fr':
        return AuthConstants.frenchLanguageCode;
      default:
        return AuthConstants.englishLanguageCode;
    }
  }
}
