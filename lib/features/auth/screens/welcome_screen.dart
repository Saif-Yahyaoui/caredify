import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/route_names.dart';
import '../../../shared/widgets/access/accessibility_controls.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../widgets/auth_logo_header.dart';

/// Welcome screen with accessibility controls and logo
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor:
          isDark ? AuthConstants.backgroundDark : AuthConstants.backgroundLight,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),

        child: Column(
          children: [
            // Logo and welcome message card
            AuthLogoHeader(isDark: isDark, subtitle: t.welcomeMessage),
            // Accessibility controls card
            const AccessibilityControls(),

            // Bottom card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AuthConstants.floatingCardHorizontalPadding,
                vertical: AuthConstants.floatingCardVerticalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton.primary(
                      text: t.signUp,
                      onPressed: () => context.go(RouteNames.register),
                    ),
                  ),
                  const SizedBox(height: AuthConstants.buttonSpacing),
                  // Login text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.alreadyHaveAccount,
                        style: TextStyle(
                          color:
                              isDark
                                  ? Colors.white.withAlpha((0.7 * 255).toInt())
                                  : const Color(0xFF64748B),
                          fontSize: AuthConstants.loginTextFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteNames.login),
                        child: Text(
                          t.login,
                          style: TextStyle(
                            color:
                                isDark
                                    ? const Color(0xFF0092DF)
                                    : const Color(0xFF0092DF),
                            fontWeight: FontWeight.bold,
                            fontSize: AuthConstants.loginTextFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
