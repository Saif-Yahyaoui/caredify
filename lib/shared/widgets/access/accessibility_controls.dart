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
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    final cardColor =
        isDark ? const Color(0xFF232B33) : const Color(0xFFF1F8FA);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;
    final activeColor = const Color(0xFF2140D2);
    final inactiveColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;
    final fieldColor = cardColor;

    // Providers
    final currentLocale = ref.watch(languageProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final currentTheme = ref.watch(themeModeProvider);
    final isVoiceEnabled = ref.watch(voiceFeedbackProvider);

    final languages = [
      {'name': 'Français', 'flag': '🇫🇷', 'code': 'fr', 'country': 'FR'},
      {'name': 'Arabe', 'flag': '🇸🇦', 'code': 'ar', 'country': 'TU'},
      {'name': 'English', 'flag': '🇬🇧', 'code': 'en', 'country': 'GB'},
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
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withOpacity(0.10)
                        : Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    icon: Icon(Icons.arrow_drop_down, color: activeColor),
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
                                Icon(Icons.language, color: activeColor),
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
                            Icon(Icons.language, color: activeColor),
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
                'Taille du texte',
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
                            fontSize == FontSizeNotifier.normalSize
                                ? Colors.white
                                : activeColor,
                        side: BorderSide(color: activeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Normal',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
                            fontSize == FontSizeNotifier.largeSize
                                ? Colors.white
                                : activeColor,
                        side: BorderSide(color: activeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Grande',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Theme
              Text(
                'Thème',
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
                  final totalSpacing = spacing * (buttonCount - 1);
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
                'Retour vocal',
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
                  color:
                      isVoiceEnabled
                          ? activeColor.withOpacity(0.08)
                          : fieldColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isVoiceEnabled ? activeColor : borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isVoiceEnabled ? Icons.volume_up : Icons.volume_off,
                      color: isVoiceEnabled ? activeColor : inactiveColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isVoiceEnabled ? 'Activé' : 'Désactivé',
                      style: TextStyle(
                        color: isVoiceEnabled ? activeColor : inactiveColor,
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
              const SizedBox(height: 20),
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
  final labels = ['Clair', 'Sombre', 'Système'];
  final modes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
  final isSelected = currentTheme == modes[index];
  final isSystem = index == 2;

  return ElevatedButton(
    onPressed:
        () => ref.read(themeModeProvider.notifier).setThemeMode(modes[index]),
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? activeColor : fieldColor,
      foregroundColor: isSelected ? Colors.white : activeColor,
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
              color: isSelected ? Colors.white : activeColor,
            ),
          if (index == 0) const SizedBox(width: 6),
          Text(
            labels[index],
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          if (isSystem) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'S’adapte automatiquement au thème clair ou sombre de votre téléphone.',
                    ),
                    duration: Duration(seconds: 4),
                  ),
                );
              },
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: isSelected ? Colors.white : activeColor,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
