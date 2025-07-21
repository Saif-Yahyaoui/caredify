// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/constants/error_messages.dart';
import '../../../core/navigation/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/mixins/auth_mixin.dart';
import '../../../shared/models/auth_models.dart' as auth_models;
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/buttons/custom_button.dart';
import '../../../shared/widgets/forms/custom_text_field.dart';
import '../widgets/auth_biometric_button.dart';
import '../widgets/auth_floating_card.dart';
import '../widgets/auth_logo_header.dart';
import '../widgets/auth_social_button_row.dart';

/// Login screen with phone number and password authentication
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with AuthMixin<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  auth_models.AuthFormData _formData = const auth_models.AuthFormData();
  auth_models.AuthState _authState = const auth_models.AuthState();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
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
  @override
  void navigateToForgotPassword() {
    context.push(RouteNames.forgotPassword);
  }

  /// Navigate to registration screen
  @override
  void navigateToRegister() {
    context.push(RouteNames.register);
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _authState = _authState.copyWith(isLoading: true, errorMessage: null);
    });
    try {
      await ref
          .read(authStateProvider.notifier)
          .login(_phoneController.text.trim(), _passwordController.text);
      if (!mounted) return;
      final authState = ref.read(authStateProvider);
      if (authState.isLoggedIn) {
        if (authState.userType == UserType.premium) {
          navigateToDashboard();
        } else if (authState.userType == UserType.basic) {
          navigateToHome();
        } else {
          setState(() {
            _authState = _authState.copyWith(
              errorMessage: ErrorMessages.invalidCredentials,
            );
          });
        }
      } else {
        setState(() {
          _authState = _authState.copyWith(
            errorMessage: ErrorMessages.invalidCredentials,
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      showErrorMessage(ErrorMessages.unknownError);
    } finally {
      if (mounted) {
        setState(() {
          _authState = _authState.copyWith(isLoading: false);
        });
      }
    }
  }

  void navigateToDashboard() => context.go('/main/dashboard');
  void navigateToHome() => context.go('/main/home');

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AuthConstants.paddingAll24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthLogoHeader(isDark: isDark, subtitle: t.welcomeMessage),
              const SizedBox(height: AuthConstants.spacingSmall),
              AuthFloatingCard(
                isFormCard: true,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildErrorMessage(_authState.errorMessage),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: navigateToForgotPassword,
                          style: TextButton.styleFrom(
                            padding: AuthConstants.paddingSymmetricH8,
                          ),
                          child: Text(
                            t.forgotPassword,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingLarge),
              // Action buttons outside the card
              Column(
                children: [
                  CustomButton.primary(
                    text: t.login,
                    onPressed: _authState.isLoading ? null : _handleLogin,
                    isLoading: _authState.isLoading,
                  ),
                  const SizedBox(height: AuthConstants.buttonSpacing),
                  CustomButton.secondary(
                    text: t.register,
                    onPressed: navigateToRegister,
                    icon: Icons.person_add,
                  ),
                ],
              ),
              const SizedBox(height: AuthConstants.spacingLarge),
              AuthFloatingCard(
                child: Column(
                  children: [
                    Text(
                      t.quickAccess,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AuthConstants.buttonSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AuthBiometricButton(
                          iconAsset: AuthConstants.fingerprintIcon,
                          label: t.fingerprint,
                          isDark: isDark,
                          onPressed: () async {
                            final success = await _authService
                                .loginWithBiometrics(
                                  BiometricType.fingerprint,
                                  context,
                                );
                            if (success) {
                              if (!mounted) return;
                              final authState = ref.read(authStateProvider);
                              if (authState.userType == UserType.premium) {
                                navigateToDashboard();
                              } else {
                                navigateToHome();
                              }
                            }
                          },
                        ),
                        AuthBiometricButton(
                          iconAsset: AuthConstants.facialIcon,
                          label: t.faceId,
                          isDark: isDark,
                          onPressed: () async {
                            final success = await _authService
                                .loginWithBiometrics(
                                  BiometricType.face,
                                  context,
                                );
                            if (success) {
                              if (!mounted) return;
                              final authState = ref.read(authStateProvider);
                              if (authState.userType == UserType.premium) {
                                navigateToDashboard();
                              } else {
                                navigateToHome();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AuthConstants.buttonSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.textSecondary.withAlpha(
                                    (0.3 * 255).toInt(),
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: AuthConstants.paddingSymmetricH16,
                          child: Text(
                            t.orContinueWith,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
                                  AppColors.textSecondary.withAlpha(
                                    (0.3 * 255).toInt(),
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AuthConstants.buttonSpacing),
                    AuthSocialButtonRow(
                      isLoading: _authState.isLoading,
                      onGooglePressed: () async {
                        setState(
                          () =>
                              _authState = _authState.copyWith(isLoading: true),
                        );
                        try {
                          final userCredential =
                              await _authService.signInWithGoogle();
                          if (userCredential != null) {
                            if (!mounted) return;
                            final authState = ref.read(authStateProvider);
                            if (authState.userType == UserType.premium) {
                              navigateToDashboard();
                            } else {
                              navigateToHome();
                            }
                          } else {
                            if (!mounted) return;
                            setState(() {
                              _authState = _authState.copyWith(
                                errorMessage: ErrorMessages.unknownError,
                              );
                            });
                          }
                        } catch (e) {
                          if (!mounted) return;
                          setState(() {
                            _authState = _authState.copyWith(
                              errorMessage: ErrorMessages.unknownError,
                            );
                          });
                        } finally {
                          if (mounted) {
                            setState(
                              () =>
                                  _authState = _authState.copyWith(
                                    isLoading: false,
                                  ),
                            );
                          }
                        }
                      },
                      onFacebookPressed: () async {
                        setState(
                          () =>
                              _authState = _authState.copyWith(isLoading: true),
                        );
                        try {
                          final userCredential =
                              await _authService.signInWithFacebook();
                          if (userCredential != null) {
                            if (!mounted) return;
                            final authState = ref.read(authStateProvider);
                            if (authState.userType == UserType.premium) {
                              navigateToDashboard();
                            } else {
                              navigateToHome();
                            }
                          } else {
                            if (!mounted) return;
                            setState(() {
                              _authState = _authState.copyWith(
                                errorMessage: ErrorMessages.unknownError,
                              );
                            });
                          }
                        } catch (e) {
                          if (!mounted) return;
                          setState(() {
                            _authState = _authState.copyWith(
                              errorMessage: ErrorMessages.unknownError,
                            );
                          });
                        } finally {
                          if (mounted) {
                            setState(
                              () =>
                                  _authState = _authState.copyWith(
                                    isLoading: false,
                                  ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: AuthConstants.buttonSpacing),
                    buildFooter(),
                  ],
                ),
              ),
              const SizedBox(height: AuthConstants.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }
}
