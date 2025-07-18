import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/route_names.dart';
import '../../../shared/widgets/access/accessibility_controls.dart';
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
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and welcome message card
              AuthLogoHeader(isDark: isDark, subtitle: t.welcomeMessage),
              // Accessibility controls card
              const AccessibilityControls(),
              // Bottom card
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sign up button (blue, 18px, bold)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2140D2), // Blue
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.go(RouteNames.register),
                      child: Text(
                        t.signUp,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => context.go(RouteNames.login),
                        child: Text(
                          t.login,
                          style: const TextStyle(
                            color: Color(0xFF2140D2),
                            fontWeight: FontWeight.w600, // Semibold
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
