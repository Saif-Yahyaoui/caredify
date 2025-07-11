import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';

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
      title: 'Bienvenue sur CAREDIFY',
      subtitle: 'Votre cœur sous surveillance 24h/24',
      features: [],
      bottomText: 'Surveillance cardiaque intelligente',
    ),
    _OnboardingCardData(
      icon: Icons.flash_on,
      iconColor: const Color(0xFFB388FF),
      title: 'Cardio-AI',
      subtitle: 'Une intelligence qui prend soin de votre cœur.',
      features: [
        'Analyse personnalisée',
        'Prédictions selon vos habitudes',
        'Conseils utiles, jour et nuit',
      ],
      featuresTitle: 'Technologie avancée',
    ),
    _OnboardingCardData(
      icon: Icons.bar_chart,
      iconColor: const Color(0xFFB388FF),
      title: "Votre santé en un coup d'œil",
      subtitle: 'Des infos simples, claires et rassurantes.',
      features: [
        'Graphiques faciles à lire',
        'Évolution visible en un regard',
        'Rapports personnalisés à partager',
      ],
      featuresTitle: 'Interface intuitive',
    ),
    _OnboardingCardData(
      icon: Icons.lightbulb,
      iconColor: const Color(0xFF60A5FA),
      title: 'Suivi Cardiaque Intelligent',
      subtitle: 'Votre cœur sous surveillance, en toute simplicité.',
      features: [
        'Analyse continue',
        'Détection précoce',
        'Alertes claires et rassurantes',
      ],
      featuresTitle: 'Comment ça marche ?',
    ),
    _OnboardingCardData(
      icon: Icons.person,
      iconColor: const Color(0xFF4ADE80),
      title: 'Lien direct avec votre médecin',
      subtitle: 'Vos données partagées en toute sécurité.',
      features: [
        'Alertes urgentes envoyées automatiquement',
        'Échanges sécurisés avec votre médecin',
        'Suivi médical toujours à jour',
      ],
      featuresTitle: 'Connexion sécurisée',
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Welcome message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tagline
                  Text(
                    AppLocalizations.of(context)!.welcomeMessage,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onboarding_complete', true);
                        if (!mounted) return;
                        context.go('/welcome');
                      },
                      child: const Text('Passer'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _OnboardingCard(data: _pages[i]),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => _Dot(isActive: i == _currentPage),
              ),
            ),
            const SizedBox(height: 12),
            if (_currentPage == _pages.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: CustomButton.primary(
                  text: 'Continuer',
                  onPressed: _onContinue,
                  icon: Icons.arrow_forward,
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: _currentPage > 0 ? _onPrev : null,
                    color:
                        _currentPage > 0
                            ? theme.primaryColor
                            : Colors.grey[300],
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: _onContinue,
                    color: theme.primaryColor,
                  ),
                ],
              ),
            const SizedBox(height: 24),
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
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final iconBgColor = theme.primaryColor.withAlpha((0.12 * 255).round());
    final featureBgColor =
        theme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.grey[100];
    final featureTextColor = theme.colorScheme.onSurface.withAlpha(
      (0.85 * 255).round(),
    );
    return Center(
      child: Card(
        elevation: 4,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.imageAsset != null)
                Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/images/logo_dark.png'
                      : data.imageAsset!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                )
              else if (data.icon != null)
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(data.icon, color: data.iconColor, size: 40),
                ),
              const SizedBox(height: 24),
              Text(
                data.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor.withAlpha((0.85 * 255).round()),
                ),
                textAlign: TextAlign.center,
              ),
              if (data.features.isNotEmpty) ...[
                const SizedBox(height: 24),
                if (data.featuresTitle != null)
                  Text(
                    data.featuresTitle!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: featureBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        data.features
                            .map(
                              (f) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: data.iconColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: featureTextColor),
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
              if (data.bottomText != null) ...[
                const SizedBox(height: 24),
                Text(
                  data.bottomText!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor.withAlpha((0.7 * 255).round()),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
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
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isActive
                ? theme.colorScheme.primary
                : theme.dividerColor.withAlpha((0.3 * 255).round()),
        border:
            isActive
                ? Border.all(color: theme.colorScheme.secondary, width: 2)
                : null,
      ),
    );
  }
}
