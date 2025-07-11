import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../core/utils/validators.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import '../../services/auth_service.dart';

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
  //final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  //final LocalAuthentication _localAuth = LocalAuthentication();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
              // Header section
              _buildHeader(context),

              const SizedBox(height: 30),

              // Login form
              _buildLoginForm(context),

              const SizedBox(height: 20),

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
          Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/logo_dark.png'
              : 'assets/images/logo.png',
          width: 250,
          height: 170,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 24),

        // Welcome message
        Text(
          AppLocalizations.of(context)?.welcomeMessage ?? 'Welcome Message',
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
            label: AppLocalizations.of(context)!.phoneNumber,
            hint: AppLocalizations.of(context)!.phoneNumberHint,
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            validator: (value) => Validators.validatePhone(value, context),
          ),

          const SizedBox(height: 16),

          // Password field
          CustomTextField.password(
            label: AppLocalizations.of(context)!.password,
            hint: AppLocalizations.of(context)!.passwordHint,
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            validator: (value) => Validators.validatePassword(value, context),
          ),

          const SizedBox(height: 12),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                AppLocalizations.of(context)?.forgotPassword ??
                    'Forgot Password',
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
          text: AppLocalizations.of(context)?.login ?? 'Login',
          onPressed:
              _isLoading
                  ? null
                  : () async {
                    // Validate form first
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    setState(() => _isLoading = true);
                    try {
                      final success = await _authService.loginWithCredentials(
                        _phoneController.text.trim(),
                        _passwordController.text,
                      );
                      if (success) {
                        // Navigate to dashboard on success
                        if (!mounted) return;
                        context.pushReplacement('/dashboard');
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Invalid credentials or network error.',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login error: $e')),
                      );
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
          isLoading: _isLoading,
          icon: Icons.login,
        ),

        const SizedBox(height: 16),

        // Register button
        CustomButton.secondary(
          text: AppLocalizations.of(context)?.register ?? 'Register',
          onPressed: _handleRegister,
          icon: Icons.person_add,
        ),

        const SizedBox(height: 16),

        // Biometric login buttons (always visible)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/icons/fingerprint.png',
                width: 40,
                height: 40,
              ),
              tooltip: 'Login with fingerprint',
              onPressed: () async {
                final success = await _authService.loginWithBiometrics(
                  BiometricType.fingerprint,
                  context,
                );
                if (success) {
                  if (!mounted) return;
                  context.pushReplacement('/dashboard');
                }
                // Error handled in AuthService
              },
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: Image.asset(
                'assets/icons/facial.png',
                width: 40,
                height: 40,
              ),
              tooltip: 'Login with face',
              onPressed: () async {
                final success = await _authService.loginWithBiometrics(
                  BiometricType.face,
                  context,
                );
                if (success) {
                  if (!mounted) return;
                  context.pushReplacement('/dashboard');
                }
                // Error handled in AuthService
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Build footer with additional information
  Widget _buildFooter(BuildContext context) {
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
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            setState(() => _isLoading = true);
                            try {
                              final userCredential =
                                  await _authService.signInWithGoogle();
                              if (userCredential != null) {
                                // Navigate to dashboard or show success
                                if (!mounted) return;
                                context.pushReplacement('/dashboard');
                              } else {
                                // User cancelled sign-in
                                if (!mounted) return;
                                setState(() {
                                  _errorMessage = 'Google sign-in cancelled.';
                                });
                              }
                            } catch (e) {
                              if (!mounted) return;
                              setState(() {
                                _errorMessage = 'Google sign-in failed: $e';
                              });
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
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
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppLocalizations.of(context)?.google ?? 'Google',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppLocalizations.of(context)?.facebook ?? 'Facebook',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.push('/terms');
              },
              child: Text(
                AppLocalizations.of(context)?.termsOfService ??
                    'Terms of Service',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
