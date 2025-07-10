import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/voice_feedback_provider.dart';
import 'package:intl/intl.dart' as intl;

/// Accessibility controls widget with language, font size, and theme toggles
class AccessibilityControls extends ConsumerWidget {
  const AccessibilityControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.language,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _LanguageSelector(ref: ref),
            const SizedBox(height: 24),
            Text(
              t.fontSize,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _FontSizeSelector(ref: ref),
            const SizedBox(height: 24),
            Text(
              t.theme,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _ThemeSelector(ref: ref),
            const SizedBox(height: 24),
            Text(
              t.voice,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _VoiceFeedbackToggle(ref: ref),
          ],
        ),
      ),
    );
  }
}

class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final currentLanguage = ref.watch(languageProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showLanguageDialog(context, ref),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Text(
              ref.read(languageProvider.notifier).currentLanguageFlag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ref.read(languageProvider.notifier).currentLanguageString,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(t.chooseLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  LanguageNotifier.supportedLanguages.map((lang) {
                    return ListTile(
                      leading: Text(
                        lang['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(lang['name']!),
                      onTap: () {
                        ref
                            .read(languageProvider.notifier)
                            .setLanguage(
                              Locale(lang['code']!, lang['country']!),
                            );
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }
}

class _FontSizeSelector extends ConsumerWidget {
  const _FontSizeSelector({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final fontSize = ref.watch(fontSizeProvider);
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _FontSizeOption(
            label: t.normal,
            isSelected: fontSize == FontSizeNotifier.normalSize,
            onTap:
                () => ref
                    .read(fontSizeProvider.notifier)
                    .setFontSize(FontSizeNotifier.normalSize),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FontSizeOption(
            label: t.large,
            isSelected: fontSize == FontSizeNotifier.largeSize,
            onTap:
                () => ref
                    .read(fontSizeProvider.notifier)
                    .setFontSize(FontSizeNotifier.largeSize),
          ),
        ),
      ],
    );
  }
}

class _FontSizeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FontSizeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _ThemeOption(
            label: t.light,
            isSelected: themeMode == ThemeMode.light,
            onTap:
                () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.light),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeOption(
            label: t.dark,
            isSelected: themeMode == ThemeMode.dark,
            onTap:
                () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.dark),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeOption(
            label: t.system,
            isSelected: themeMode == ThemeMode.system,
            onTap:
                () => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.system),
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _VoiceFeedbackToggle extends ConsumerWidget {
  const _VoiceFeedbackToggle({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceEnabled = ref.watch(voiceFeedbackProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.volume_up,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.voiceFeedback,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Switch(
            value: voiceEnabled,
            onChanged:
                (value) =>
                    ref.read(voiceFeedbackProvider.notifier).state = value,
          ),
        ],
      ),
    );
  }
}
