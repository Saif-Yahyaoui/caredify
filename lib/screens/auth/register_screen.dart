import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/accessibility_controls.dart';
import '../../core/utils/validators.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Registration screen with user information and account creation
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
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
    super.dispose();
  }

  /// Handle registration form submission
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;
      if (name.isNotEmpty &&
          phone.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          password == confirmPassword) {
        // Simulate token
        await _secureStorage.write(key: 'auth_token', value: 'demo_token');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.accountCreated),
              backgroundColor: AppColors.healthGreen,
            ),
          );
          context.pushReplacement('/login');
        }
      } else {
        throw Exception(AppLocalizations.of(context)!.fillAllFields);
      }
    } catch (e) {
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

  /// Navigate back to login screen
  void _handleBackToLogin() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createAccount),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: _handleBackToLogin,
        ),
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
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

              const SizedBox(height: 32),

              // Registration form
              _buildRegistrationForm(context),

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
        // Logo
        Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 170,
          fit: BoxFit.fill,
        ),

        const SizedBox(height: 24),

        // App name
        // Text(
        //   AppLocalizations.of(context)!.appTitle,
        //   style: Theme.of(context).textTheme.displaySmall?.copyWith(
        //     color: AppColors.primaryBlue,
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 1.2,
        //   ),
        // ),

        // const SizedBox(height: 8),

        // Welcome message
        Text(
          AppLocalizations.of(context)!.joinHealthSpace,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build registration form with validation
  Widget _buildRegistrationForm(BuildContext context) {
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

          // Name field
          CustomTextField.name(
            controller: _nameController,
            focusNode: _nameFocusNode,
            validator: (value) => Validators.validateName(value, context),
            label: AppLocalizations.of(context)!.fullName,
            hint: AppLocalizations.of(context)!.fullNameHint,
          ),

          const SizedBox(height: 16),

          // Phone number field
          CustomTextField.phone(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            validator: (value) => Validators.validatePhone(value, context),
            label: AppLocalizations.of(context)!.phoneNumber,
            hint: AppLocalizations.of(context)!.phoneNumberHint,
          ),

          const SizedBox(height: 16),

          // Email field
          CustomTextField.email(
            controller: _emailController,
            focusNode: _emailFocusNode,
            validator: (value) => Validators.validateEmail(value, context),
            label: AppLocalizations.of(context)!.email,
            hint: AppLocalizations.of(context)!.emailHint,
          ),

          const SizedBox(height: 16),

          // Password field
          CustomTextField.password(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            validator: (value) => Validators.validatePassword(value, context),
            label: AppLocalizations.of(context)!.password,
            hint: AppLocalizations.of(context)!.passwordHint,
          ),

          const SizedBox(height: 16),

          // Confirm password field
          CustomTextField.password(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            label: AppLocalizations.of(context)!.confirmPassword,
            hint: AppLocalizations.of(context)!.confirmPasswordHint,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.fieldRequired;
              }
              if (value != _passwordController.text) {
                return AppLocalizations.of(context)!.passwordsDoNotMatch;
              }
              return null;
            },
          ),
        ],
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

        const SizedBox(height: 16),

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
                  Icon(
                    Icons.info_outline,
                    color: AppColors.healthGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.termsOfService,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.healthGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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

        const SizedBox(height: 24),

        // Terms and privacy links
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.push('/terms');
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
                context.push('/privacy');
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
