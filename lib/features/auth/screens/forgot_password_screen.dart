import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/mixins/auth_mixin.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/auth_floating_card.dart';
import '../widgets/auth_section_title.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with AuthMixin<ForgotPasswordScreen> {
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
    await Future.delayed(AuthConstants.validationDelay);
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
          isDark ? AuthConstants.backgroundDark : AuthConstants.backgroundLight,
      appBar: AppBar(
        title: Text(
          t.forgotPasswordTitle,
          style: TextStyle(
            color: isDark ? AuthConstants.darkTextColor : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AuthConstants.darkTextColor : AppColors.textPrimary,
            size: AuthConstants.iconSize,
          ),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AuthConstants.paddingAll24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AuthConstants.spacingLarge),
              AuthFloatingCard(
                isPrimary: true,
                child: Column(
                  children: [
                    Container(
                      width: AuthConstants.iconSizeLarge,
                      height: AuthConstants.iconSizeLarge,
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AuthConstants.white.withAlpha(
                                  (0.1 * 255).toInt(),
                                )
                                : AuthConstants.white.withAlpha(
                                  (0.8 * 255).toInt(),
                                ),
                        borderRadius: BorderRadius.circular(
                          AuthConstants.borderRadius12,
                        ),
                        border: Border.all(
                          color:
                              isDark
                                  ? AuthConstants.white.withAlpha(
                                    (0.2 * 255).toInt(),
                                  )
                                  : AuthConstants.white.withAlpha(
                                    (0.5 * 255).toInt(),
                                  ),
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_reset,
                        size: AuthConstants.iconSize,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: AuthConstants.spacingLarge),
                    Text(
                      t.forgotPasswordTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AuthConstants.spacingLarge),
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
              ),
              const SizedBox(height: AuthConstants.spacingLarge),
              AuthFloatingCard(
                isFormCard: true,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthSectionTitle(
                        icon: Icons.email_outlined,
                        title: t.resetPassword,
                      ),
                      const SizedBox(height: AuthConstants.spacingLarge),
                      buildErrorMessage(_errorMessage),
                      buildSuccessMessage(_successMessage),
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
                      const SizedBox(height: AuthConstants.spacingLarge),
                      CustomButton(
                        text: t.send,
                        onPressed: _isLoading ? null : _handleSubmit,
                        isLoading: _isLoading,
                        icon: Icons.send,
                      ),
                      const SizedBox(height: AuthConstants.spacingLarge),
                      CustomButton.secondary(
                        text: t.backToLogin,
                        onPressed: () => context.pop(),
                        icon: Icons.arrow_back,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
