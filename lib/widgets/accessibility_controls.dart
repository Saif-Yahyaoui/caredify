import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';

/// Accessibility controls widget with language, font size, and theme toggles
class AccessibilityControls extends ConsumerWidget {
  const AccessibilityControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(fontSizeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildLanguageControl(context, ref, language)),
            const VerticalDivider(width: 30, color: AppColors.inputBorder),
            Expanded(child: _buildFontSizeToggle(context, ref, fontSize)),
            const VerticalDivider(width: 0.1, color: AppColors.inputBorder),
            Expanded(child: _buildThemeToggle(context, ref, themeMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageControl(
    BuildContext context,
    WidgetRef ref,
    Locale language,
  ) {
    final notifier = ref.read(languageProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _showLanguageDialog(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.primary, width: 1),
        ),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            children: [
              Text(
                notifier.currentLanguageFlag,
                style: TextStyle(fontSize: 16, color: colorScheme.primary),
              ),
              const SizedBox(width: 6),
              Text(
                notifier.currentLanguageString,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, color: colorScheme.primary, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeToggle(
    BuildContext context,
    WidgetRef ref,
    double fontSize,
  ) {
    final isLarge = fontSize == AppTheme.largeFontSize;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.fontSize,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch(
          value: isLarge,
          onChanged:
              (val) => ref
                  .read(fontSizeProvider.notifier)
                  .setFontSize(
                    val ? AppTheme.largeFontSize : AppTheme.normalFontSize,
                  ),
          activeColor: colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildThemeToggle(
    BuildContext context,
    WidgetRef ref,
    ThemeMode themeMode,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.theme,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.primary, width: 1),
            ),
            child: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              AppLocalizations.of(context)!.chooseLanguage,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: colorScheme.onBackground),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  LanguageNotifier.supportedLanguages.map((lang) {
                    return ListTile(
                      leading: Text(
                        lang['flag']!,
                        style: TextStyle(
                          fontSize: 24,
                          color: colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        lang['name']!,
                        style: TextStyle(color: colorScheme.onBackground),
                      ),
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
