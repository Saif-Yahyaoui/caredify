// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/navigation/route_names.dart';
import '../../../shared/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingCardData> _pages = [
    _OnboardingCardData(
      imageAsset: 'assets/images/logo.png',
      title: 'Welcome to CAREDIFY',
      subtitle: 'Your heart under 24/7 monitoring',
      features: [],
      bottomText: 'Smart cardiac monitoring',
    ),
    _OnboardingCardData(
      icon: Icons.flash_on,
      iconColor: const Color(0xFFB388FF),
      title: 'Cardio-AI',
      subtitle: 'Intelligence that cares for your heart.',
      features: [
        'Personalized analysis',
        'Predictions based on your habits',
        'Helpful tips, day and night',
      ],
      featuresTitle: 'Advanced technology',
    ),
    _OnboardingCardData(
      icon: Icons.bar_chart,
      iconColor: const Color(0xFFB388FF),
      title: 'Your health at a glance',
      subtitle: 'Simple, clear, and reassuring information.',
      features: [
        'Easy-to-read charts',
        'Progress visible at a glance',
        'Personalized reports to share',
      ],
      featuresTitle: 'Intuitive interface',
    ),
    _OnboardingCardData(
      icon: Icons.lightbulb,
      iconColor: const Color(0xFF60A5FA),
      title: 'Intelligent Cardiac Tracking',
      subtitle: 'Your heart monitored, effortlessly.',
      features: [
        'Continuous analysis',
        'Early detection',
        'Clear and reassuring alerts',
      ],
      featuresTitle: 'How does it work?',
    ),
    _OnboardingCardData(
      icon: Icons.person,
      iconColor: const Color(0xFF4ADE80),
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
        duration: const Duration(milliseconds: 400),
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
        duration: const Duration(milliseconds: 400),
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
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Top Section - Floating Card like UserHeader
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDark
                          ? [
                            const Color(
                              0xFF1E293B,
                            ).withAlpha((0.9 * 255).toInt()),
                            const Color(
                              0xFF334155,
                            ).withAlpha((0.7 * 255).toInt()),
                          ]
                          : [const Color(0xFFE3F0FF), const Color(0xFFF8FAFC)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      isDark
                          ? const Color(
                            0xFF475569,
                          ).withAlpha((0.3 * 255).toInt())
                          : const Color(
                            0xFFB6D0E2,
                          ).withAlpha((0.5 * 255).toInt()),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark
                            ? Colors.black.withAlpha((0.4 * 255).toInt())
                            : const Color(
                              0xFF60A5FA,
                            ).withAlpha((0.10 * 255).toInt()),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
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
                                  : const Color(0xFF1E293B),
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
                                // No underline
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
                          (context, i) => _OnboardingCard(data: _pages[i]),
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
                            const SizedBox(width: 20),
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

                        const SizedBox(height: 16),

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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDark
                          ? [
                            const Color(
                              0xFF1E293B,
                            ).withAlpha((0.9 * 255).toInt()),
                            const Color(
                              0xFF334155,
                            ).withAlpha((0.7 * 255).toInt()),
                          ]
                          : [const Color(0xFFE3F0FF), const Color(0xFFF8FAFC)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      isDark
                          ? const Color(
                            0xFF475569,
                          ).withAlpha((0.3 * 255).toInt())
                          : const Color(
                            0xFFB6D0E2,
                          ).withAlpha((0.5 * 255).toInt()),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark
                            ? Colors.black.withAlpha((0.4 * 255).toInt())
                            : const Color(
                              0xFF60A5FA,
                            ).withAlpha((0.10 * 255).toInt()),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: 'Sign up',
                        onPressed: () => context.go(RouteNames.register),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                    : const Color(0xFF64748B),
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

class _OnboardingCardData {
  final IconData? icon;
  final Color? iconColor;
  final String? imageAsset;
  final String title;
  final String subtitle;
  final List<String> features;
  final String? featuresTitle;
  final String? bottomText;

  _OnboardingCardData({
    this.icon,
    this.iconColor,
    this.imageAsset,
    required this.title,
    required this.subtitle,
    this.features = const [],
    this.featuresTitle,
    this.bottomText,
  });
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardingCardData data;

  const _OnboardingCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [
                      const Color(0xFF1E293B).withAlpha((0.9 * 255).toInt()),
                      const Color(0xFF334155).withAlpha((0.7 * 255).toInt()),
                    ]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isDark
                    ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                    : const Color(0xFFCBD5E1).withAlpha((0.5 * 255).toInt()),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withAlpha((0.4 * 255).toInt())
                      : const Color(0xFF64748B).withAlpha((0.15 * 255).toInt()),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image or Icon
              if (data.imageAsset != null)
                Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.05 * 255).toInt())
                            : theme.primaryColor.withAlpha(
                              (0.05 * 255).toInt(),
                            ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      isDark ? 'assets/images/logo_dark.png' : data.imageAsset!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              else if (data.icon != null)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (data.iconColor ??
                            (isDark
                                ? const Color(0xFF60A5FA)
                                : theme.primaryColor))
                        .withAlpha(
                          isDark ? (0.2 * 255).toInt() : (0.15 * 255).toInt(),
                        ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    data.icon,
                    color:
                        data.iconColor ??
                        (isDark ? const Color(0xFF60A5FA) : theme.primaryColor),
                    size: 30,
                  ),
                ),

              const SizedBox(height: 20),

              // Title
              Text(
                data.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                data.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : const Color(0xFF64748B),
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Features section
              if (data.features.isNotEmpty) ...[
                const SizedBox(height: 20),

                if (data.featuresTitle != null) ...[
                  Text(
                    data.featuresTitle!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.05 * 255).toInt())
                            : theme.primaryColor.withAlpha(
                              (0.05 * 255).toInt(),
                            ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isDark
                              ? Colors.white.withAlpha((0.1 * 255).toInt())
                              : theme.primaryColor.withAlpha(
                                (0.1 * 255).toInt(),
                              ),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        data.features
                            .map(
                              (feature) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color:
                                            data.iconColor ??
                                            (isDark
                                                ? const Color(0xFF60A5FA)
                                                : theme.primaryColor),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  isDark
                                                      ? Colors.white.withAlpha(
                                                        (0.9 * 255).toInt(),
                                                      )
                                                      : const Color(0xFF475569),
                                              fontSize: 13,
                                              height: 1.3,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],

              // Bottom text
              if (data.bottomText != null) ...[
                const SizedBox(height: 16),
                Text(
                  data.bottomText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isDark
                            ? Colors.white.withAlpha((0.7 * 255).toInt())
                            : const Color(0xFF64748B),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
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
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
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
                : const Color(0xFFCBD5E1),
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
            : const Color(0xFFE2E8F0);

    final iconColor =
        isSuccess
            ? Colors.green
            : isActive
            ? (isDark ? const Color(0xFF60A5FA) : theme.primaryColor)
            : isDark
            ? Colors.white.withAlpha((0.4 * 255).toInt())
            : const Color(0xFF94A3B8);

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
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}
