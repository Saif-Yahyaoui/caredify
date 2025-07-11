import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/voice_feedback_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthIndexReevaluateScreen extends ConsumerStatefulWidget {
  const HealthIndexReevaluateScreen({super.key});

  @override
  ConsumerState<HealthIndexReevaluateScreen> createState() =>
      _HealthIndexReevaluateScreenState();
}

class _HealthIndexReevaluateScreenState
    extends ConsumerState<HealthIndexReevaluateScreen> {
  final TextEditingController _ageController = TextEditingController(
    text: '25',
  );
  final TextEditingController _heightController = TextEditingController(
    text: '177 cm',
  );
  final TextEditingController _weightController = TextEditingController(
    text: '65 kg',
  );
  String _sex = 'Male';
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
      if (voiceFeedbackEnabled) {
        final t = AppLocalizations.of(context)!;
        try {
          var result = await _tts.setLanguage(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'ar-SA'
                : Localizations.localeOf(context).languageCode == 'fr'
                ? 'fr-FR'
                : 'en-US',
          );
          if (result != 1) {
            await _tts.setLanguage('en-US');
          }
        } catch (e) {
          await _tts.setLanguage('en-US');
        }
        try {
          await _tts.speak(t.healthRatingTitle);
        } catch (e) {
          // Ignored: TTS error is non-critical
        }
      }
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    final isDark = theme.brightness == Brightness.dark;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.healthRatingTitle),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Reevaluate your health rating by updating your personal information.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  color: theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'REEVALUATE',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Illustration placeholder
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Icon(
                              Icons.event_available_outlined,
                              size: 120,
                              color: theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Age
                        Text(
                          'Your Age',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          hint: 'Age',
                        ),
                        const SizedBox(height: 16),
                        // Sex
                        Text(
                          'Sex',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Checkbox(
                              value: _sex == 'Female',
                              onChanged: (val) {
                                setState(() => _sex = 'Female');
                              },
                            ),
                            Text(
                              AppLocalizations.of(context)!.genderFemale,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 16),
                            Checkbox(
                              value: _sex == 'Male',
                              onChanged: (val) {
                                setState(() => _sex = 'Male');
                              },
                            ),
                            Text(
                              AppLocalizations.of(context)!.genderMale,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Height
                        Text(
                          'Your Height',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: _heightController,
                          keyboardType: TextInputType.text,
                          hint: 'Height',
                        ),
                        const SizedBox(height: 16),
                        // Weight
                        Text(
                          'Your Weight',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: _weightController,
                          keyboardType: TextInputType.text,
                          hint: 'Weight',
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Save Changes',
                          onPressed: () {},
                          backgroundColor: theme.colorScheme.secondary,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
