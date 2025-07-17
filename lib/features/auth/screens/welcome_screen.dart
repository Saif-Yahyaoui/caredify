import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/route_names.dart';
import '../../../shared/widgets/accessibility_controls.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/auth_floating_card.dart';

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
        child: Column(
          children: [
            // Main accessibility controls area
            const Expanded(
              child: AuthFloatingCard(
                isPrimary: true,
                margin: EdgeInsets.symmetric(horizontal: 16),
                borderRadius: AuthConstants.floatingCardBorderRadius,
                padding: EdgeInsets.zero,
                child: AccessibilityControls(),
              ),
            ),
            // Bottom card - fixed at bottom
            AuthFloatingCard(
              isPrimary: true,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              borderRadius: AuthConstants.floatingCardBorderRadius,
              child: Padding(
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
                                    ? Colors.white.withAlpha(
                                      (0.7 * 255).toInt(),
                                    )
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
            ),
          ],
        ),
      ),
    );
  }
}
