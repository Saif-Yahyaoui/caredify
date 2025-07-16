// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/constants/error_messages.dart';
import '../../../core/navigation/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

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
  late final IAuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = ref.read(authServiceProvider);
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
    context.push(RouteNames.forgotPassword);
  }

  /// Navigate to registration screen
  void _handleRegister() {
    context.push(RouteNames.register);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Top floating card - Logo and welcome message
              _buildTopCard(context, t),

              const SizedBox(height: 24),

              // Center floating card - Login form
              _buildLoginFormCard(context, t),

              const SizedBox(height: 24),

              // Bottom floating card - Social login and biometrics
              _buildBottomCard(context, t),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Build top floating card with logo and welcome message
  Widget _buildTopCard(BuildContext context, AppLocalizations t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryBlue.withValues(alpha: 0.1)
                : AppColors.primaryBlue.withValues(alpha: 0.05),
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryBlue.withValues(alpha: 0.05)
                : AppColors.primaryBlue.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : AppColors.primaryBlue.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.3)
                    : AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/logo_dark.png'
                : 'assets/images/logo.png',
            width: 200,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),

          // Welcome message
          Text(
            t.welcomeMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build center floating card with login form
  Widget _buildLoginFormCard(BuildContext context, AppLocalizations t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.8),
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error message display
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

            // Phone number field
            CustomTextField.phone(
              label: t.phoneNumber,
              hint: t.phoneNumberHint,
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              validator: (value) => Validators.validatePhone(value, context),
            ),

            const SizedBox(height: 16),

            // Password field
            CustomTextField.password(
              label: t.password,
              hint: t.passwordHint,
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              validator: (value) => Validators.validatePassword(value, context),
            ),

            const SizedBox(height: 10),

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _handleForgotPassword,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                child: Text(
                  t.forgotPassword,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Login button
            CustomButton(
              text: t.login,
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
                          // Use the new auth state provider
                          await ref
                              .read(authStateProvider.notifier)
                              .login(
                                _phoneController.text.trim(),
                                _passwordController.text,
                              );
                          if (!mounted) return;

                          // Get the updated auth state
                          final authState = ref.read(authStateProvider);

                          if (authState.isLoggedIn) {
                            if (authState.userType == UserType.premium) {
                              context.go('/main/dashboard');
                            } else if (authState.userType == UserType.basic) {
                              context.go('/main/home');
                            } else {
                              setState(() {
                                _errorMessage =
                                    ErrorMessages.invalidCredentials;
                              });
                            }
                          } else {
                            setState(() {
                              _errorMessage = ErrorMessages.invalidCredentials;
                            });
                          }
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(ErrorMessages.unknownError),
                            ),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
              isLoading: _isLoading,
            ),

            const SizedBox(height: 16),

            // Register button
            CustomButton.secondary(
              text: t.register,
              onPressed: _handleRegister,
              icon: Icons.person_add,
            ),
          ],
        ),
      ),
    );
  }

  /// Build bottom floating card with social login and biometrics
  Widget _buildBottomCard(BuildContext context, AppLocalizations t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryBlue.withValues(alpha: 0.1)
                : AppColors.primaryBlue.withValues(alpha: 0.05),
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryBlue.withValues(alpha: 0.05)
                : AppColors.primaryBlue.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : AppColors.primaryBlue.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.3)
                    : AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Biometric login section
          Text(
            t.quickAccess,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Biometric login buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBiometricButton(
                context,
                'assets/icons/fingerprint.png',
                t.fingerprint,
                () async {
                  final success = await _authService.loginWithBiometrics(
                    BiometricType.fingerprint,
                    context,
                  );
                  if (success) {
                    if (!mounted) return;
                    final authState = ref.read(authStateProvider);
                    if (authState.userType == UserType.premium) {
                      context.go('/main/dashboard');
                    } else {
                      context.go('/main/home');
                    }
                  }
                },
              ),
              _buildBiometricButton(
                context,
                'assets/icons/facial.png',
                t.faceId,
                () async {
                  final success = await _authService.loginWithBiometrics(
                    BiometricType.face,
                    context,
                  );
                  if (success) {
                    if (!mounted) return;
                    final authState = ref.read(authStateProvider);
                    if (authState.userType == UserType.premium) {
                      context.go('/main/dashboard');
                    } else {
                      context.go('/main/home');
                    }
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.textSecondary.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  t.orContinueWith,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.textSecondary.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Social login buttons
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  context,
                  'assets/icons/google.svg',
                  t.google,
                  AppColors.googleBackground,
                  AppColors.googleText,
                  AppColors.googleBlue,
                  () async {
                    setState(() => _isLoading = true);
                    try {
                      final userCredential =
                          await _authService.signInWithGoogle();
                      if (userCredential != null) {
                        if (!mounted) return;
                        final authState = ref.read(authStateProvider);
                        if (authState.userType == UserType.premium) {
                          context.go('/main/dashboard');
                        } else {
                          context.go('/main/home');
                        }
                      } else {
                        if (!mounted) return;
                        setState(() {
                          _errorMessage = ErrorMessages.unknownError;
                        });
                      }
                    } catch (e) {
                      if (!mounted) return;
                      setState(() {
                        _errorMessage = ErrorMessages.unknownError;
                      });
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSocialButton(
                  context,
                  'assets/icons/facebook.svg',
                  t.facebook,
                  AppColors.facebookBackground,
                  AppColors.facebookText,
                  AppColors.facebookBlue,
                  () async {
                    setState(() => _isLoading = true);
                    try {
                      final userCredential =
                          await _authService.signInWithFacebook();
                      if (userCredential != null) {
                        if (!mounted) return;
                        final authState = ref.read(authStateProvider);
                        if (authState.userType == UserType.premium) {
                          context.go('/main/dashboard');
                        } else {
                          context.go('/main/home');
                        }
                      } else {
                        if (!mounted) return;
                        setState(() {
                          _errorMessage = ErrorMessages.unknownError;
                        });
                      }
                    } catch (e) {
                      if (!mounted) return;
                      setState(() {
                        _errorMessage = ErrorMessages.unknownError;
                      });
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

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
                    t.termsOfService,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 1,
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
                    t.privacyPolicy,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build biometric button
  Widget _buildBiometricButton(
    BuildContext context,
    String iconPath,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(iconPath, width: 36, height: 36),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build social login button
  Widget _buildSocialButton(
    BuildContext context,
    String iconPath,
    String label,
    Color backgroundColor,
    Color textColor,
    Color borderColor,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath, width: 24, height: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
