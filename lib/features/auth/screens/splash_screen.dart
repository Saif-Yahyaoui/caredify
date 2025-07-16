import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/services/auth_service.dart';


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
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  Future<void> _startSplashSequence() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 2500));

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
            ? 'assets/images/logo_dark.png'
            : 'assets/images/logo.png';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedLogo(
                logo,
                localizations?.welcomeMessage ?? 'Welcome',
              ),
              const SizedBox(height: 80),
              _buildLoadingIndicator(localizations?.loading ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(String assetPath, String message) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
      builder: (_, __) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              children: [
                Image.asset(
                  assetPath,
                  width: 240,
                  height: 180,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
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
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryBlue.withAlpha((0.8 * 255).round()),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
