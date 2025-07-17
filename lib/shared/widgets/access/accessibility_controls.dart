import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/voice_feedback_provider.dart';

/// Accessibility controls widget with language, font size, and theme toggles
class AccessibilityControls extends ConsumerWidget {
  const AccessibilityControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8), // was 10
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? const Color(
                              0xFF0092DF,
                            ).withAlpha((0.15 * 255).toInt())
                            : const Color(
                              0xFF0092DF,
                            ).withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12), // was 14
                  ),
                  child: const Icon(
                    Icons.accessibility_new,
                    color: Color(0xFF0092DF),
                    size: 20, // was 24
                  ),
                ),
                const SizedBox(width: 10), // was 16
                Text(
                  t.accessibilitySettings,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // was 22
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // was 32
            // Language Section
            _ProfessionalSection(
              title: t.language,
              icon: Icons.language,
              isDark: isDark,
              child: _ModernLanguageSelector(ref: ref, t: t),
            ),
            const SizedBox(height: 12), // was 24
            // Font Size Section
            _ProfessionalSection(
              title: t.fontSize,
              icon: Icons.text_fields,
              isDark: isDark,
              child: _ModernFontSizeSelector(ref: ref, t: t),
            ),
            const SizedBox(height: 12), // was 24
            // Theme Section
            _ProfessionalSection(
              title: t.theme,
              icon: Icons.palette,
              isDark: isDark,
              child: _ModernThemeSelector(ref: ref, t: t),
            ),
            const SizedBox(height: 12), // was 24
            // Voice Feedback Section
            _ProfessionalSection(
              title: t.voice,
              icon: Icons.volume_up,
              isDark: isDark,
              child: _ModernVoiceFeedbackToggle(ref: ref, t: t),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfessionalSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;
  final Widget child;

  const _ProfessionalSection({
    required this.title,
    required this.icon,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12), // was 20
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF1E293B).withAlpha((0.6 * 255).toInt())
                : Colors.white.withAlpha((0.8 * 255).toInt()),
        borderRadius: BorderRadius.circular(12), // was 18
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                  : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha((0.15 * 255).toInt())
                    : const Color(
                      0xFF64748B,
                    ).withAlpha((0.05 * 255).toInt()), // lighter shadow
            blurRadius: 6, // was 10
            offset: const Offset(0, 2), // was 3
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16, // was 20
                color:
                    isDark ? const Color(0xFF0092DF) : const Color(0xFF0092DF),
              ),
              const SizedBox(width: 6), // was 10
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13, // was 16
                  color:
                      isDark
                          ? Colors.white.withAlpha((0.9 * 255).toInt())
                          : const Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // was 16
          child,
        ],
      ),
    );
  }
}

class _ModernLanguageSelector extends ConsumerWidget {
  final WidgetRef ref;
  final AppLocalizations t;
  const _ModernLanguageSelector({required this.ref, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(languageProvider);
    final languages = LanguageNotifier.supportedLanguages;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children:
          languages.map((lang) {
            final isSelected = currentLocale.languageCode == lang['code'];
            return Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap:
                      () => ref
                          .read(languageProvider.notifier)
                          .setLanguage(Locale(lang['code']!, lang['country']!)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? theme.primaryColorDark.withAlpha(
                                (0.12 * 255).toInt(),
                              )
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color:
                            isSelected
                                ? theme.primaryColor
                                : theme.dividerColor.withAlpha(
                                  (0.3 * 255).toInt(),
                                ),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang['flag']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            lang['name']!,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? theme.primaryColor
                                      : theme.textTheme.bodyMedium?.color,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _ModernFontSizeSelector extends ConsumerWidget {
  final WidgetRef ref;
  final AppLocalizations t;
  const _ModernFontSizeSelector({required this.ref, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fontSize = ref.watch(fontSizeProvider);
    return Row(
      children: [
        Expanded(
          child: _ModernPillOption(
            label: t.normal,
            isSelected: fontSize == FontSizeNotifier.normalSize,
            onTap:
                () => ref
                    .read(fontSizeProvider.notifier)
                    .setFontSize(FontSizeNotifier.normalSize),
            theme: theme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ModernPillOption(
            label: t.large,
            isSelected: fontSize == FontSizeNotifier.largeSize,
            onTap:
                () => ref
                    .read(fontSizeProvider.notifier)
                    .setFontSize(FontSizeNotifier.largeSize),
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _ModernThemeSelector extends ConsumerWidget {
  final WidgetRef ref;
  final AppLocalizations t;
  const _ModernThemeSelector({required this.ref, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentTheme = ref.watch(themeModeProvider);
    return Row(
      children: [
        Expanded(
          child: _ModernPillOption(
            label: t.light,
            isSelected: currentTheme == ThemeMode.light,
            onTap:
                () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.light),
            theme: theme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ModernPillOption(
            label: t.dark,
            isSelected: currentTheme == ThemeMode.dark,
            onTap:
                () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.dark),
            theme: theme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ModernPillOption(
            label: t.system,
            isSelected: currentTheme == ThemeMode.system,
            onTap:
                () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.system),
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _ModernVoiceFeedbackToggle extends ConsumerWidget {
  final WidgetRef ref;
  final AppLocalizations t;
  const _ModernVoiceFeedbackToggle({required this.ref, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = ref.watch(voiceFeedbackProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF334155).withAlpha((0.3 * 255).toInt())
                : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.4 * 255).toInt())
                  : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Switch(
            value: isEnabled,
            onChanged:
                (val) => ref.read(voiceFeedbackProvider.notifier).state = val,
            activeColor: const Color(0xFF0092DF),
            activeTrackColor: const Color(
              0xFF0092DF,
            ).withAlpha((0.3 * 255).toInt()),
            inactiveThumbColor: isDark ? Colors.grey[400] : Colors.grey[600],
            inactiveTrackColor:
                isDark
                    ? Colors.grey[700]?.withAlpha((0.3 * 255).toInt())
                    : Colors.grey[300]?.withAlpha((0.5 * 255).toInt()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEnabled ? t.voiceFeedbackEnabled : t.voiceFeedbackDisabled,
              style: TextStyle(
                color:
                    isEnabled
                        ? const Color(0xFF0092DF)
                        : isDark
                        ? Colors.white.withAlpha((0.7 * 255).toInt())
                        : const Color(0xFF64748B),
                fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernPillOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  const _ModernPillOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ), // was 16, 12
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF0092DF).withAlpha(
                    isDark ? (0.18 * 255).toInt() : (0.09 * 255).toInt(),
                  )
                  : isDark
                  ? const Color(0xFF334155).withAlpha((0.22 * 255).toInt())
                  : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8), // was 12
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF0092DF)
                    : isDark
                    ? const Color(0xFF475569).withAlpha((0.3 * 255).toInt())
                    : const Color(0xFFE2E8F0),
            width: 1.2, // was 1.5
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(
                        0xFF0092DF,
                      ).withAlpha((0.13 * 255).toInt()), // lighter
                      blurRadius: 3, // was 4
                      offset: const Offset(0, 1), // was 2
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected
                    ? const Color(0xFF0092DF)
                    : isDark
                    ? Colors.white.withAlpha((0.85 * 255).toInt())
                    : const Color(0xFF374151),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12, // was 14
          ),
        ),
      ),
    );
  }
}
