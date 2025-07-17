// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/route_names.dart';
import '../../../shared/models/auth_models.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/auth_floating_card.dart';
import '../widgets/auth_onboarding_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingCardData> _pages = [
    const OnboardingCardData(
      imageAsset: AuthConstants.logoLight,
      title: 'Welcome to CAREDIFY',
      subtitle: 'Your heart under 24/7 monitoring',
      features: [],
      bottomText: 'Smart cardiac monitoring',
    ),
    const OnboardingCardData(
      icon: Icons.flash_on,
      iconColor: Color(0xFFB388FF),
      title: 'Cardio-AI',
      subtitle: 'Intelligence that cares for your heart.',
      features: [
        'Personalized analysis',
        'Predictions based on your habits',
        'Helpful tips, day and night',
      ],
      featuresTitle: 'Advanced technology',
    ),
    const OnboardingCardData(
      icon: Icons.bar_chart,
      iconColor: Color(0xFFB388FF),
      title: 'Your health at a glance',
      subtitle: 'Simple, clear, and reassuring information.',
      features: [
        'Easy-to-read charts',
        'Progress visible at a glance',
        'Personalized reports to share',
      ],
      featuresTitle: 'Intuitive interface',
    ),
    const OnboardingCardData(
      icon: Icons.lightbulb,
      iconColor: Color(0xFF60A5FA),
      title: 'Intelligent Cardiac Tracking',
      subtitle: 'Your heart monitored, effortlessly.',
      features: [
        'Continuous analysis',
        'Early detection',
        'Clear and reassuring alerts',
      ],
      featuresTitle: 'How does it work?',
    ),
    const OnboardingCardData(
      icon: Icons.person,
      iconColor: Color(0xFF4ADE80),
      title: 'Direct link with your doctor',
      subtitle: 'Your data shared securely.',
      features: [
        'Urgent alerts sent automatically',
        'Secure communication with your doctor',
        'Medical follow-up always up to date',
      ],
      featuresTitle: 'Secure connection',
    ),
  ];

  void _onContinue() async {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: AuthConstants.durationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      // Set onboarding complete
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      if (!mounted) return;
      context.go('/welcome');
    }
  }

  void _onPrev() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: AuthConstants.durationMedium,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AuthConstants.backgroundDark : AuthConstants.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Top Section - Floating Card like UserHeader
            AuthFloatingCard(
              isPrimary: true,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              borderRadius: AuthConstants.borderRadius24,
              child: Row(
                children: [
                  // Welcome message with enhanced styling
                  Expanded(
                    child: Text(
                      'Welcome to your health space',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            isDark
                                ? Colors.white.withAlpha((0.9 * 255).toInt())
                                : AuthConstants.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Skip link as clickable, theme-adaptive text
                  if (_currentPage < _pages.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('onboarding_complete', true);
                          if (!mounted) return;
                          context.go('/welcome');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color:
                                  isDark
                                      ? const Color(0xFF60A5FA)
                                      : const Color(0xFF0092DF),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // PageView with centered, adaptive cards
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder:
                          (context, i) => AuthOnboardingCard(data: _pages[i]),
                    ),
                  ),

                  // Navigation Controls
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // Navigation arrows with enhanced styling
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _EnhancedCircleIconButton(
                              icon: Icons.arrow_back_ios_new,
                              onPressed: _currentPage > 0 ? _onPrev : null,
                              isActive: _currentPage > 0,
                              theme: theme,
                            ),
                            const SizedBox(width: AuthConstants.spacingMedium),
                            if (_currentPage < _pages.length - 1)
                              _EnhancedCircleIconButton(
                                icon: Icons.arrow_forward_ios,
                                onPressed: _onContinue,
                                isActive: true,
                                theme: theme,
                              )
                            else
                              _EnhancedCircleIconButton(
                                icon: Icons.check,
                                onPressed: _onContinue,
                                isActive: true,
                                isSuccess: true,
                                theme: theme,
                              ),
                          ],
                        ),

                        const SizedBox(height: AuthConstants.buttonSpacing),

                        // Enhanced progress dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (i) => _EnhancedDot(
                              isActive: i == _currentPage,
                              theme: theme,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Fixed Bottom Section - Floating Card like UserHeader
            AuthFloatingCard(
              isPrimary: true,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              borderRadius: AuthConstants.borderRadius24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton.primary(
                        text: 'Sign up',
                        onPressed: () => context.go(RouteNames.register),
                      ),
                    ),
                    const SizedBox(height: AuthConstants.buttonSpacing),
                    // Login text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color:
                                isDark
                                    ? Colors.white.withAlpha(
                                      (0.7 * 255).toInt(),
                                    )
                                    : AuthConstants.textGray,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(RouteNames.login),
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              color:
                                  isDark
                                      ? const Color(0xFF0092DF)
                                      : const Color(0xFF0092DF),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnhancedDot extends StatelessWidget {
  final bool isActive;
  final ThemeData theme;

  const _EnhancedDot({required this.isActive, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: AuthConstants.durationMedium,
      margin: const EdgeInsets.symmetric(
        horizontal: AuthConstants.spacingSmall,
      ),
      width:
          isActive
              ? AuthConstants.dotWidthActive
              : AuthConstants.dotWidthInactive,
      height: AuthConstants.dotHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        gradient:
            isActive
                ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0092DF), Color(0xFF00C853)],
                )
                : null,
        color:
            isActive
                ? null
                : isDark
                ? Colors.white.withAlpha((0.3 * 255).toInt())
                : AuthConstants.textGrayLight,
      ),
    );
  }
}

class _EnhancedCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isActive;
  final bool isSuccess;
  final ThemeData theme;

  const _EnhancedCircleIconButton({
    required this.icon,
    required this.onPressed,
    required this.isActive,
    required this.theme,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
        isSuccess
            ? Colors.green.withAlpha((0.1 * 255).toInt())
            : isActive
            ? (isDark ? const Color(0xFF60A5FA) : theme.primaryColor).withAlpha(
              (0.1 * 255).toInt(),
            )
            : isDark
            ? Colors.white.withAlpha((0.1 * 255).toInt())
            : AuthConstants.textGrayLight;

    final iconColor =
        isSuccess
            ? Colors.green
            : isActive
            ? (isDark ? const Color(0xFF60A5FA) : theme.primaryColor)
            : isDark
            ? Colors.white.withAlpha((0.4 * 255).toInt())
            : AuthConstants.textGray;

    final borderColor =
        isActive
            ? (isSuccess
                    ? Colors.green
                    : (isDark ? const Color(0xFF60A5FA) : theme.primaryColor))
                .withAlpha((0.3 * 255).toInt())
            : Colors.transparent;

    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AuthConstants.borderRadius24),
        child: Container(
          width: AuthConstants.iconButtonSize,
          height: AuthConstants.iconButtonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: AuthConstants.borderWidth,
            ),
          ),
          child: Icon(icon, color: iconColor, size: AuthConstants.iconSize),
        ),
      ),
    );
  }
}
