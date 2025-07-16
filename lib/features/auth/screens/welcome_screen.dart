import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/route_names.dart';
import '../../../shared/widgets/accessibility_controls.dart';
import '../../../shared/widgets/gradient_button.dart';

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
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Main accessibility controls area
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        isDark
                            ? [
                              const Color(
                                0xFF1E293B,
                              ).withAlpha((0.9 * 255).toInt()),
                              const Color(
                                0xFF334155,
                              ).withAlpha((0.7 * 255).toInt()),
                            ]
                            : [
                              const Color(0xFFE3F0FF),
                              const Color(0xFFF8FAFC),
                            ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color:
                        isDark
                            ? const Color(
                              0xFF475569,
                            ).withAlpha((0.3 * 255).toInt())
                            : const Color(
                              0xFFB6D0E2,
                            ).withAlpha((0.5 * 255).toInt()),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark
                              ? Colors.black.withAlpha((0.4 * 255).toInt())
                              : const Color(
                                0xFF60A5FA,
                              ).withAlpha((0.10 * 255).toInt()),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: AccessibilityControls(),
                ),
              ),
            ),
            // Bottom card - fixed at bottom
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDark
                          ? [
                            const Color(
                              0xFF1E293B,
                            ).withAlpha((0.9 * 255).toInt()),
                            const Color(
                              0xFF334155,
                            ).withAlpha((0.7 * 255).toInt()),
                          ]
                          : [const Color(0xFFE3F0FF), const Color(0xFFF8FAFC)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      isDark
                          ? const Color(
                            0xFF475569,
                          ).withAlpha((0.3 * 255).toInt())
                          : const Color(
                            0xFFB6D0E2,
                          ).withAlpha((0.5 * 255).toInt()),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark
                            ? Colors.black.withAlpha((0.4 * 255).toInt())
                            : const Color(
                              0xFF60A5FA,
                            ).withAlpha((0.10 * 255).toInt()),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: t.signUp,
                        onPressed: () => context.go(RouteNames.register),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Login text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t.alreadyHaveAccount,
                          style: TextStyle(
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.7)
                                    : const Color(0xFF64748B),
                            fontSize: 15,
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
                              fontSize: 15,
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
