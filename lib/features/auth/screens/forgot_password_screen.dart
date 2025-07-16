import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/gradient_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _successMessage = AppLocalizations.of(context)!.resetLinkSent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          t.forgotPasswordTitle,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Header card with icon and title
              _buildHeaderCard(context, t),

              const SizedBox(height: 24),

              // Main form card
              _buildFormCard(context, t),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header card with icon and title
  Widget _buildHeaderCard(BuildContext context, AppLocalizations t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    AppColors.primaryBlue.withValues(alpha: 0.15),
                    AppColors.primaryBlue.withValues(alpha: 0.08),
                  ]
                  : [
                    AppColors.primaryBlue.withValues(alpha: 0.08),
                    AppColors.primaryBlue.withValues(alpha: 0.03),
                  ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              isDark
                  ? AppColors.primaryBlue.withValues(alpha: 0.3)
                  : AppColors.primaryBlue.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              Icons.lock_reset,
              size: 40,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            t.forgotPasswordTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            t.forgotPasswordMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build main form card
  Widget _buildFormCard(BuildContext context, AppLocalizations t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.02),
                  ]
                  : [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.white.withValues(alpha: 0.7),
                  ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section title
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  t.resetPassword,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Error message
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.alertBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.alertRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.alertRed,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.alertRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Success message
            if (_successMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.healthGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.healthGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _successMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.healthGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Email/Phone field
            CustomTextField(
              label: t.emailOrPhone,
              controller: _emailOrPhoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return t.fieldRequired;
                }
                if (value.contains('@')) {
                  return Validators.validateEmail(value, context);
                } else {
                  return Validators.validatePhone(value, context);
                }
              },
            ),
            const SizedBox(height: 24),

            // Submit button
            GradientButton(
              text: t.send,
              onPressed: _isLoading ? null : _handleSubmit,
              isLoading: _isLoading,
              icon: Icons.send,
            ),
            const SizedBox(height: 16),

            // Back to login button
            CustomButton.secondary(
              text: t.backToLogin,
              onPressed: () => context.pop(),
              icon: Icons.arrow_back,
            ),
          ],
        ),
      ),
    );
  }
}
