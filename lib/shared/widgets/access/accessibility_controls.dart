import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/voice_feedback_provider.dart';

class AccessibilityControls extends ConsumerWidget {
  const AccessibilityControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    final cardColor =
        isDark ? const Color(0xFF232B33) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade300;
    const activeColor = Color(0xFF2140D2);
    final inactiveColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;
    final fieldColor = cardColor;

    // Providers
    final currentLocale = ref.watch(languageProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final currentTheme = ref.watch(themeModeProvider);
    final isVoiceEnabled = ref.watch(voiceFeedbackProvider);

    final languages = [
      {
        'name':
            t.language == 'Langue'
                ? 'Français'
                : t.language == 'Language'
                ? 'French'
                : t.language == 'اللغة'
                ? 'الفرنسية'
                : 'Français',
        'flag': '🇫🇷',
        'code': 'fr',
        'country': 'FR',
      },
      {
        'name':
            t.language == 'Langue'
                ? 'Arabe'
                : t.language == 'Language'
                ? 'Arabic'
                : t.language == 'اللغة'
                ? 'العربية'
                : 'Arabic',
        'flag': '🇹🇳',
        'code': 'ar',
        'country': 'TU',
      },
      {
        'name':
            t.language == 'Langue'
                ? 'Anglais'
                : t.language == 'Language'
                ? 'English'
                : t.language == 'اللغة'
                ? 'الإنجليزية'
                : 'English',
        'flag': '🇺🇸',
        'code': 'en',
        'country': 'US',
      },
    ];
    final selectedLang = languages.firstWhere(
      (l) => l['code'] == currentLocale.languageCode,
      orElse: () => languages[0],
    );

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withAlpha((0.1 * 255).toInt())
                        : Colors.black.withAlpha((0.04 * 255).toInt()),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                t.accessibilitySettings,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Language Dropdown
              Container(
                decoration: BoxDecoration(
                  color: fieldColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLang['name'],
                    icon: const Icon(Icons.arrow_drop_down, color: activeColor),
                    isExpanded: true,
                    dropdownColor: fieldColor,
                    onChanged: (value) {
                      if (value != null) {
                        final lang = languages.firstWhere(
                          (l) => l['name'] == value,
                        );
                        ref
                            .read(languageProvider.notifier)
                            .setLanguage(
                              Locale(lang['code']!, lang['country']!),
                            );
                      }
                    },
                    items:
                        languages.map((lang) {
                          return DropdownMenuItem<String>(
                            value: lang['name']!,
                            child: Row(
                              children: [
                                const Icon(Icons.language, color: activeColor),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    lang['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  lang['flag']!,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    selectedItemBuilder: (context) {
                      return languages.map((lang) {
                        return Row(
                          children: [
                            const Icon(Icons.language, color: activeColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                lang['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              lang['flag']!,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Font Size
              Text(
                t.fontSize,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => ref
                              .read(fontSizeProvider.notifier)
                              .setFontSize(FontSizeNotifier.normalSize),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            fontSize == FontSizeNotifier.normalSize
                                ? activeColor
                                : fieldColor,
                        foregroundColor:
                            isDark
                                ? Colors.white
                                : (fontSize == FontSizeNotifier.normalSize
                                    ? Colors.white
                                    : Colors.black),
                        side: const BorderSide(color: activeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        t.normal,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                              isDark
                                  ? Colors.white
                                  : (fontSize == FontSizeNotifier.normalSize
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => ref
                              .read(fontSizeProvider.notifier)
                              .setFontSize(FontSizeNotifier.largeSize),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            fontSize == FontSizeNotifier.largeSize
                                ? activeColor
                                : fieldColor,
                        foregroundColor:
                            isDark
                                ? Colors.white
                                : (fontSize == FontSizeNotifier.largeSize
                                    ? Colors.white
                                    : Colors.black),
                        side: const BorderSide(color: activeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        t.large,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                              isDark
                                  ? Colors.white
                                  : (fontSize == FontSizeNotifier.largeSize
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Theme
              Text(
                t.theme,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  const buttonCount = 3;
                  const spacing = 5.0;
                  const totalSpacing = spacing * (buttonCount - 1);
                  final buttonWidth =
                      (constraints.maxWidth - totalSpacing) / buttonCount;
                  return Row(
                    children: [
                      for (var i = 0; i < buttonCount; i++) ...[
                        SizedBox(
                          width: buttonWidth,
                          child: _buildThemeButton(
                            context,
                            ref,
                            i,
                            currentTheme,
                            activeColor,
                            fieldColor,
                          ),
                        ),
                        if (i < buttonCount - 1) const SizedBox(width: spacing),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              // Voice feedback
              Text(
                t.voiceFeedback,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isVoiceEnabled ? fieldColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isVoiceEnabled ? activeColor : borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isVoiceEnabled ? Icons.volume_up : Icons.volume_off,
                      color:
                          isVoiceEnabled
                              ? (isDark ? Colors.white : Colors.black)
                              : inactiveColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isVoiceEnabled
                          ? t.voiceFeedbackEnabled
                          : t.voiceFeedbackDisabled,
                      style: TextStyle(
                        color:
                            isVoiceEnabled
                                ? (isDark ? Colors.white : Colors.black)
                                : inactiveColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isVoiceEnabled,
                      onChanged:
                          (val) =>
                              ref.read(voiceFeedbackProvider.notifier).state =
                                  val,
                      activeColor: activeColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildThemeButton(
  BuildContext context,
  WidgetRef ref,
  int index,
  ThemeMode currentTheme,
  Color activeColor,
  Color fieldColor,
) {
  final t = AppLocalizations.of(context)!;
  final labels = [t.light, t.dark, t.system];
  final modes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
  final isSelected = currentTheme == modes[index];
  final isSystem = index == 2;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return ElevatedButton(
    onPressed:
        () => ref.read(themeModeProvider.notifier).setThemeMode(modes[index]),
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? activeColor : fieldColor,
      foregroundColor:
          isDark ? Colors.white : (isSelected ? Colors.white : Colors.black),
      side: BorderSide(color: activeColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 0),
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (index == 0)
            Icon(
              Icons.nightlight_round,
              size: 18,
              color:
                  isDark
                      ? Colors.white
                      : (isSelected ? Colors.white : Colors.black),
            ),
          if (index == 0) const SizedBox(width: 6),
          Text(
            labels[index],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color:
                  isDark
                      ? Colors.white
                      : (isSelected ? Colors.white : Colors.black),
            ),
          ),
          if (isSystem) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.systemThemeHint),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              child: Icon(
                Icons.info_outline,
                size: 16,
                color:
                    isDark
                        ? Colors.white
                        : (isSelected ? Colors.white : Colors.black),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
