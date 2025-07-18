import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/mixins/auth_mixin.dart';
import '../../../shared/models/auth_models.dart';
import '../../../shared/providers/voice_feedback_provider.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/forms/custom_text_field.dart';
import '../widgets/auth_floating_card.dart';
import '../widgets/auth_logo_header.dart';

/// Registration screen with user information and account creation
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with AuthMixin<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthFormData _formData = const AuthFormData();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  String? _errorMessage;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
      if (voiceFeedbackEnabled) {
        final t = AppLocalizations.of(context)!;
        try {
          final result = await _tts.setLanguage(getLanguageCode());
          if (result != 1) {
            await _tts.setLanguage('en-US');
          }
        } catch (e) {
          await _tts.setLanguage('en-US');
        }
        try {
          await _tts.speak('${t.createAccount}. ${t.joinHealthSpace}');
        } catch (e) {
          //ignore: no TTS support
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    try {
      await _secureStorage.write(
        key: AuthConstants.authTokenKey,
        value: AuthConstants.demoToken,
      );
      if (!mounted) return;
      if (name.isNotEmpty &&
          phone.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          password == confirmPassword) {
        showSuccessMessage(AppLocalizations.of(context)!.accountCreated);
        navigateToLogin();
      } else {
        throw Exception(AppLocalizations.of(context)!.fillAllFields);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.registrationError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBackToLogin() {
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AuthConstants.paddingAll24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthLogoHeader(isDark: isDark, subtitle: t.joinHealthSpace),
              const SizedBox(height: AuthConstants.spacingLarge),
              AuthFloatingCard(
                isFormCard: true,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildErrorMessage(_errorMessage),
                      CustomTextField.name(
                        label: t.fullName,
                        hint: t.fullNameHint,
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        validator:
                            (value) => Validators.validateName(value, context),
                        onChanged:
                            (value) => setState(() {
                              _formData = _formData.copyWith(name: value);
                            }),
                      ),
                      const SizedBox(height: AuthConstants.buttonSpacing),
                      CustomTextField.phone(
                        label: t.phoneNumber,
                        hint: t.phoneNumberHint,
                        controller: _phoneController,
                        focusNode: _phoneFocusNode,
                        validator:
                            (value) => Validators.validatePhone(value, context),
                        onChanged:
                            (value) => setState(() {
                              _formData = _formData.copyWith(phone: value);
                            }),
                      ),
                      const SizedBox(height: AuthConstants.buttonSpacing),
                      CustomTextField.email(
                        label: t.email,
                        hint: t.emailHint,
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        validator:
                            (value) => Validators.validateEmail(value, context),
                        onChanged:
                            (value) => setState(() {
                              _formData = _formData.copyWith(email: value);
                            }),
                      ),
                      const SizedBox(height: AuthConstants.buttonSpacing),
                      CustomTextField.password(
                        label: t.password,
                        hint: t.passwordHint,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        validator:
                            (value) =>
                                Validators.validatePassword(value, context),
                        onChanged:
                            (value) => setState(() {
                              _formData = _formData.copyWith(password: value);
                            }),
                      ),
                      const SizedBox(height: AuthConstants.buttonSpacing),
                      CustomTextField.password(
                        label: t.confirmPassword,
                        hint: t.confirmPasswordHint,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.fieldRequired;
                          }
                          if (value != _passwordController.text) {
                            return t.passwordsDoNotMatch;
                          }
                          return null;
                        },
                        onChanged:
                            (value) => setState(() {
                              _formData = _formData.copyWith(
                                confirmPassword: value,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingLarge),
              _buildActionButtons(context),
              const SizedBox(
                height: AuthConstants.spacingLarge + AuthConstants.spacingSmall,
              ),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build action buttons (register and back to login)
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Register button
        CustomButton.primary(
          text: AppLocalizations.of(context)!.register,
          onPressed: _isLoading ? null : _handleRegister,
          isLoading: _isLoading,
          icon: Icons.person_add,
        ),

        const SizedBox(height: AuthConstants.buttonSpacing),

        // Back to login button
        CustomButton.secondary(
          text: AppLocalizations.of(context)!.alreadyHaveAccount,
          onPressed: _handleBackToLogin,
          icon: Icons.login,
        ),
      ],
    );
  }

  /// Build footer with terms and privacy information
  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        // Terms acceptance info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.successBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.healthGreen.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.healthGreen,
                    size: 20,
                  ),
                  const SizedBox(width: AuthConstants.spacingSmall),
                  Text(
                    AppLocalizations.of(context)!.termsOfService,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.healthGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AuthConstants.spacingSmall),
              Text(
                AppLocalizations.of(context)!.termsOfServiceDescription,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: AuthConstants.spacingLarge),

        // Terms and privacy links
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.push(RouteNames.terms),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  AppLocalizations.of(context)!.termsOfService,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: 3,
              height: 16,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => context.push(RouteNames.privacy),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  AppLocalizations.of(context)!.privacyPolicy,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
