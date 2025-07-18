import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../providers/user_type_provider.dart';
import '../../providers/voice_feedback_provider.dart';
import '../../services/auth_service.dart';
import '../forms/custom_text_field.dart';

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
          final result = await _tts.setLanguage(
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
    const indexGold = Color(0xFFFFC94D);
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
            onPressed: () {
              final userType = ref.read(userTypeProvider);
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else if (userType == UserType.premium) {
                context.go('/main/dashboard');
              } else {
                context.go('/main/home');
              }
            },
          ),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),

            child: _PremiumCard(
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
                        color: indexGold.withAlpha((0.2 * 255).round()),
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
                        activeColor: indexGold,
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
                        activeColor: indexGold,
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: indexGold,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final Widget child;
  const _PremiumCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF1E293B).withAlpha((0.8 * 255).toInt()),
                    const Color(0xFF334155).withAlpha((0.5 * 255).toInt()),
                  ]
                  : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark
                  ? const Color(0xFF475569).withAlpha((0.2 * 255).toInt())
                  : const Color(0xFFCBD5E1).withAlpha((0.15 * 255).toInt()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha((0.15 * 255).toInt())
                    : const Color(0xFF64748B).withAlpha((0.06 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      ),
    );
  }
}
