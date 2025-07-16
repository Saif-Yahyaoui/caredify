import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_type_provider.dart';
import '../providers/voice_feedback_provider.dart';
import '../services/auth_service.dart';

class UserHeader extends ConsumerWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final voiceEnabled = ref.watch(voiceFeedbackProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final isLargeFont = fontSize == FontSizeNotifier.largeSize;
    final userType = ref.watch(userTypeProvider);

    void changeLanguage(Locale locale) {
      ref.read(languageProvider.notifier).setLanguage(locale);
    }

    void toggleTheme() {
      final notifier = ref.read(themeModeProvider.notifier);
      notifier.setThemeMode(
        themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      );
    }

    void toggleVoice() {
      ref.read(voiceFeedbackProvider.notifier).state = !voiceEnabled;
    }

    void toggleFontSize() {
      final notifier = ref.read(fontSizeProvider.notifier);
      notifier.setFontSize(
        isLargeFont ? FontSizeNotifier.normalSize : FontSizeNotifier.largeSize,
      );
    }

    // Dynamic colors and labels based on user type
    final isPremium = userType == UserType.premium;
    final avatarGradient =
        isPremium
            ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
            )
            : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8), Color(0xFF8B5CF6)],
              stops: [0.0, 0.5, 1.0],
            );
    final badgeGradient =
        isPremium
            ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
            )
            : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            );
    final badgeLabel = isPremium ? 'PREMIUM' : 'BASIC';

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top row: Profile and action buttons
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile section with modern design
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: avatarGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: (isPremium
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF3B82F6))
                              .withAlpha((0.4 * 255).toInt()),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: (isPremium
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF8B5CF6))
                              .withAlpha((0.2 * 255).toInt()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.1 * 255).toInt()),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/profile.jpeg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPremium ? 'Saif Yahyaoui' : 'User',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),

                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: badgeGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badgeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons with modern design
                  Row(
                    children: [
                      _ModernIconButton(
                        icon: Icons.notifications_none_rounded,
                        tooltip: 'Notifications',
                        onPressed: () {},
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _ModernIconButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        tooltip: 'AI Chat Assistant',
                        onPressed: () => context.go('/main/chat'),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _ModernIconButton(
                        icon: Icons.search_rounded,
                        tooltip: 'Search',
                        onPressed: () {},
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Bottom row: Controls
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Language selector with modern design
                  Container(
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? const Color(
                                0xFF475569,
                              ).withAlpha((0.3 * 255).toInt())
                              : Colors.white.withAlpha((0.7 * 255).toInt()),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDark
                                ? const Color(
                                  0xFF64748B,
                                ).withAlpha((0.2 * 255).toInt())
                                : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        _ModernLangButton(
                          label: 'Fr',
                          selected: language.languageCode == 'fr',
                          onTap: () => changeLanguage(const Locale('fr', 'FR')),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 4),
                        _ModernLangButton(
                          label: 'Ar',
                          selected: language.languageCode == 'ar',
                          onTap: () => changeLanguage(const Locale('ar', 'TN')),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 4),
                        _ModernLangButton(
                          label: 'En',
                          selected: language.languageCode == 'en',
                          onTap: () => changeLanguage(const Locale('en', 'US')),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Text size toggle with modern design
                  Expanded(
                    child: _ModernToggleButton(
                      icon: Icons.text_fields_rounded,
                      label: isLargeFont ? 'Aa -' : 'Aa +',
                      onTap: toggleFontSize,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Voice toggle with modern design
                  _ModernToggleButton(
                    icon: Icons.mic_rounded,
                    label: '',
                    onTap: toggleVoice,
                    isDark: isDark,
                    isActive: voiceEnabled,
                  ),

                  const SizedBox(width: 8),

                  // Theme toggle with modern design
                  _ModernToggleButton(
                    icon:
                        themeMode == ThemeMode.dark
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                    label: '',
                    onTap: toggleTheme,
                    isDark: isDark,
                    isActive: themeMode == ThemeMode.dark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isDark;

  const _ModernIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                : Colors.white.withAlpha((0.7 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF64748B).withAlpha((0.2 * 255).toInt())
                  : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            icon,
            size: 20,
            color:
                isDark
                    ? Colors.white.withAlpha((0.8 * 255).toInt())
                    : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _ModernLangButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _ModernLangButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  )
                  : null,
          color: selected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: const Color(
                        0xFF3B82F6,
                      ).withAlpha((0.3 * 255).toInt()),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                selected
                    ? Colors.white
                    : isDark
                    ? Colors.white.withAlpha((0.8 * 255).toInt())
                    : const Color(0xFF64748B),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _ModernToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isActive;

  const _ModernToggleButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient:
              isActive
                  ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  )
                  : null,
          color:
              isActive
                  ? null
                  : isDark
                  ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                  : Colors.white.withAlpha((0.7 * 255).toInt()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isActive
                    ? Colors.transparent
                    : isDark
                    ? const Color(0xFF64748B).withAlpha((0.2 * 255).toInt())
                    : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: const Color(
                        0xFF3B82F6,
                      ).withAlpha((0.3 * 255).toInt()),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  isActive
                      ? Colors.white
                      : isDark
                      ? Colors.white.withAlpha((0.8 * 255).toInt())
                      : const Color(0xFF64748B),
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isActive
                          ? Colors.white
                          : isDark
                          ? Colors.white.withAlpha((0.8 * 255).toInt())
                          : const Color(0xFF64748B),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
