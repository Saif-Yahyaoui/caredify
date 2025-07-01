import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Splash screen with CAREDIFY logo and smooth transition
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations and navigation
    _startSplashSequence();
  }

  /// Start the splash screen animation sequence
  void _startSplashSequence() async {
    // Start fade animation
    _fadeController.forward();

    // Start scale animation after a short delay
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();

    // Navigate to login after splash duration
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      context.pushReplacement('/login');
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section with animations
              AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          // CAREDIFY Logo
                          Image.asset(
                            'assets/images/logo.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.fill,
                          ),

                          const SizedBox(height: 24),

                          // App name
                          Text(
                            AppLocalizations.of(context)!.appTitle,
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Tagline
                          Text(
                            AppLocalizations.of(context)!.welcomeMessage,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),

              // Loading indicator
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
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
                              AppColors.primaryBlue.withOpacity(0.8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          AppLocalizations.of(context)!.loading,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
