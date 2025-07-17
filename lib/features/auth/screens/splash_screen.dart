import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/services/auth_service.dart';
import '../widgets/auth_logo_header.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final bool disableNavigation;
  const SplashScreen({super.key, this.disableNavigation = false});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _scaleController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AuthConstants.durationSplashFade,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: AuthConstants.durationSplashScale,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startSplashSequence() async {
    _fadeController.forward();
    await Future.delayed(AuthConstants.durationSplashDelay);
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    final authState = ref.read(authStateProvider);

    // Logging
    debugPrint(
      'Splash: onboarding=$onboardingComplete, '
      'loggedIn=${authState.isLoggedIn}, '
      'userType=${authState.userType}',
    );

    if (widget.disableNavigation || !mounted) return;

    if (authState.isLoggedIn) {
      context.go(
        authState.userType == UserType.premium
            ? '/main/dashboard'
            : '/main/home',
      );
    } else if (onboardingComplete) {
      context.go('/main/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final logo =
        theme.brightness == Brightness.dark
            ? AuthConstants.logoDarkAsset
            : AuthConstants.logoAsset;

    return Scaffold(
      backgroundColor:
          theme.brightness == Brightness.dark
              ? AuthConstants.backgroundDark
              : AuthConstants.backgroundLight,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedLogo(
                logo,
                localizations?.welcomeMessage ?? 'Welcome',
              ),
              const SizedBox(height: AuthConstants.splashLogoSpacing),
              _buildLoadingIndicator(localizations?.loading ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(String assetPath, String message) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (_, __) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo image
              SizedBox(
                width: 240,
                child: AuthLogoHeader(isDark: isDark, subtitle: message),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(String loadingText) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (_, __) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              SizedBox(
                width: AuthConstants.loadingIndicatorSize,
                height: AuthConstants.loadingIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: AuthConstants.loadingIndicatorStrokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryBlue.withAlpha((0.8 * 255).round()),
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.loadingIndicatorTextSpacing),
              Text(
                loadingText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
