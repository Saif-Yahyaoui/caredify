import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/accessibility_controls.dart';
import '../../core/utils/validators.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Login screen with phone number and password authentication
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /// Handle login form submission
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual authentication logic
      final phone = _phoneController.text.trim();
      final password = _passwordController.text;

      // Simulate authentication
      if (phone.isNotEmpty && password.isNotEmpty) {
        // Success - navigate to dashboard
        if (mounted) {
          // TODO: Navigate to dashboard when implemented
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginSuccess),
              backgroundColor: AppColors.healthGreen,
            ),
          );
        }
      } else {
        throw Exception(AppLocalizations.of(context)!.invalidCredentials);
      }
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.loginError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Navigate to forgot password screen
  void _handleForgotPassword() {
    context.push('/forgot-password');
  }

  /// Navigate to registration screen
  void _handleRegister() {
    context.push('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Accessibility controls
              const AccessibilityControls(),

              const SizedBox(height: 32),

              // Header section
              _buildHeader(context),

              const SizedBox(height: 48),

              // Login form
              _buildLoginForm(context),

              const SizedBox(height: 24),

              // Action buttons
              _buildActionButtons(context),

              const SizedBox(height: 32),

              // Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header with logo and welcome message
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Clean Logo
        Image.asset(
          'assets/images/logo.png',
          width: 130,
          height: 120,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 24),

        // App name
        Text(
          AppLocalizations.of(context)!.appTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Welcome message
        Text(
          AppLocalizations.of(context)!.welcomeMessage,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build login form with validation
  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Error message display
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.alertBackground,
                borderRadius: BorderRadius.circular(8),
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

          // Phone number field
          CustomTextField.phone(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            validator: (value) => Validators.validatePhone(value, context),
            label: AppLocalizations.of(context)!.phoneNumber,
            hint: AppLocalizations.of(context)!.phoneNumberHint,
          ),

          const SizedBox(height: 16),

          // Password field
          CustomTextField.password(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            validator: (value) => Validators.validatePassword(value, context),
            onSubmitted: (_) => _handleLogin(),
            label: AppLocalizations.of(context)!.password,
            hint: AppLocalizations.of(context)!.passwordHint,
          ),

          const SizedBox(height: 12),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons (login and register)
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Login button
        CustomButton.primary(
          text: AppLocalizations.of(context)!.login,
          onPressed: _isLoading ? null : _handleLogin,
          isLoading: _isLoading,
          icon: Icons.login,
        ),

        const SizedBox(height: 16),

        // Register button
        CustomButton.secondary(
          text: AppLocalizations.of(context)!.register,
          onPressed: _handleRegister,
          icon: Icons.person_add,
        ),
      ],
    );
  }

  /// Build footer with additional information
  Widget _buildFooter(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Social login buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.googleBackground,
                    foregroundColor: AppColors.googleText,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.googleBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement Google login
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/google.svg',
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Google',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.googleText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.facebookBackground,
                    foregroundColor: AppColors.facebookText,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.facebookBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement Facebook login
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/facebook.svg',
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Facebook',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Terms and privacy links
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // TODO: Navigate to terms of service
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.termsInDevelopment,
                    ),
                    backgroundColor: AppColors.mediumGray,
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.termsOfService,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue),
              ),
            ),
            Text(
              ' • ',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.privacyInDevelopment,
                    ),
                    backgroundColor: AppColors.mediumGray,
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.privacyPolicy,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
