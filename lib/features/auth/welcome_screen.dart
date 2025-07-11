import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/accessibility_controls.dart';

/// Welcome screen with accessibility controls and logo
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo section
              _buildLogoSection(context),

              const SizedBox(height: 10),

              // Accessibility controls
              const AccessibilityControls(),

              const SizedBox(height: 15),

              // Continue button
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build logo section
  Widget _buildLogoSection(BuildContext context) {
    return Column(
      children: [
        // Logo
        Image.asset(
          Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/logo_dark.png'
              : 'assets/images/logo.png',
          width: 250,
          height: 170,
          fit: BoxFit.fill,
        ),

        // Welcome message
        Text(
          AppLocalizations.of(context)?.welcomeMessage ?? 'Welcome to Caredify',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Configure your accessibility preferences before continuing',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build continue button
  Widget _buildContinueButton(BuildContext context) {
    return CustomButton.primary(
      text: 'Continue',
      onPressed: () => context.pushReplacement('/login'),
      icon: Icons.arrow_forward,
    );
  }
}
