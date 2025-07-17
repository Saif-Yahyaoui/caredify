import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_colors.dart';
import 'auth_social_button.dart';

/// A reusable widget that displays a row of social login buttons.
///
/// This widget creates a horizontal layout with Google and Facebook login buttons,
/// commonly used in authentication screens. The buttons are equally sized and
/// share the same loading state.
///
/// Example usage:
/// ```dart
/// AuthSocialButtonRow(
///   isLoading: _isLoading,
///   onGooglePressed: () => _handleGoogleSignIn(),
///   onFacebookPressed: () => _handleFacebookSignIn(),
/// )
/// ```
class AuthSocialButtonRow extends StatelessWidget {
  /// Whether the buttons should show a loading state.
  ///
  /// When true, both buttons will be disabled and show loading indicators.
  final bool isLoading;

  /// Callback function triggered when the Google button is pressed.
  final VoidCallback onGooglePressed;

  /// Callback function triggered when the Facebook button is pressed.
  final VoidCallback onFacebookPressed;

  /// Creates an AuthSocialButtonRow widget.
  ///
  /// The [isLoading] parameter controls the loading state of both buttons.
  /// The [onGooglePressed] and onFacebookPressed] callbacks handle the respective
  /// button press events.
  const AuthSocialButtonRow({
    super.key,
    required this.isLoading,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: AuthSocialButton(
            iconPath: AuthConstants.googleIcon,
            label: t.google,
            backgroundColor: AppColors.googleBackground,
            textColor: AppColors.googleText,
            borderColor: AppColors.googleBlue,
            isLoading: isLoading,
            onPressed: onGooglePressed,
          ),
        ),
        const SizedBox(width: AuthConstants.spacingSmall),
        Expanded(
          child: AuthSocialButton(
            iconPath: AuthConstants.facebookIcon,
            label: t.facebook,
            backgroundColor: AppColors.facebookBackground,
            textColor: AppColors.facebookText,
            borderColor: AppColors.facebookBlue,
            isLoading: isLoading,
            onPressed: onFacebookPressed,
          ),
        ),
      ],
    );
  }
}
