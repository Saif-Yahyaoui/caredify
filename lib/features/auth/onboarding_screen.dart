import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      image: 'assets/images/onboarding_1.png',
      title: 'Bienvenue sur CAREDIFY',
      description:
          'Prenez soin de votre santé en toute simplicité.  CAREDIFY vous accompagne chaque jour.',
      buttonText: 'Continue',
    ),
    _OnboardingPageData(
      image: 'assets/images/onboarding_2.png',
      title: 'Température, ECG, SPO2, stress…',
      description:
          'Surveillez vos données vitales au même endroit.\nDes outils pensés pour vous.',
      buttonText: 'Continue',
    ),
    _OnboardingPageData(
      image: 'assets/images/onboarding_3.png',
      title: 'Une application claire et accessible',
      description:
          'Grands textes, boutons lisibles, navigation facile. Tout est conçu pour les seniors',
      buttonText: 'Commencer',
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
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder:
                    (context, i) => _OnboardingPage(
                      data: _pages[i],
                      isLast: i == _pages.length - 1,
                      onContinue: _onContinue,
                      showSkip: i != 0,
                      onSkip: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onboarding_complete', true);
                        if (!mounted) return;
                        context.go('/login');
                      },
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => _Dot(isActive: i == _currentPage),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  _OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final bool isLast;
  final VoidCallback onContinue;
  final bool showSkip;
  final VoidCallback onSkip;
  const _OnboardingPage({
    required this.data,
    required this.isLast,
    required this.onContinue,
    required this.showSkip,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 60),
                      if (showSkip)
                        TextButton(
                          onPressed: onSkip,
                          child: Text(AppLocalizations.of(context)!.skip),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Image.asset(data.image, height: 400, fit: BoxFit.contain),
                  const SizedBox(height: 24),
                  Text(
                    data.title,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.description,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 48),
                  _GradientButton(text: data.buttonText, onPressed: onContinue),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _GradientButton({required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0092DF), Color(0xFF00C853)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;
  const _Dot({required this.isActive});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF22D3EE) : Colors.grey[300],
        border:
            isActive
                ? Border.all(color: const Color(0xFF4ADE80), width: 2)
                : null,
      ),
    );
  }
}
