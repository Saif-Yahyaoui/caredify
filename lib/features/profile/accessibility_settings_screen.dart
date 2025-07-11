import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/accessibility_controls.dart';

/// Accessibility settings screen for profile
class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Accessibility',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              _buildHeader(context),

              const SizedBox(height: 32),

              // Accessibility controls
              const AccessibilityControls(),

              const SizedBox(height: 32),

              // Save button
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.accessibility_new,
            size: 48,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          'Accessibility Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Customize your app experience with accessibility options',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build save button
  Widget _buildSaveButton(BuildContext context) {
    return CustomButton.primary(
      text: AppLocalizations.of(context)?.save ?? 'Save',
      onPressed: () {
        // Show success message and go back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Accessibility settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      },
      icon: Icons.check,
    );
  }
}
