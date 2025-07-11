import 'package:caredify/features/dashboard/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/voice_feedback_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SleepRatingScreen extends ConsumerStatefulWidget {
  const SleepRatingScreen({super.key});

  @override
  ConsumerState<SleepRatingScreen> createState() => _SleepRatingScreenState();
}

class _SleepRatingScreenState extends ConsumerState<SleepRatingScreen> {
  final FlutterTts _tts = FlutterTts();
  int _selectedTab = 0;

  // Mock data
  final double totalSleep = 7.0;
  final double sleepGoal = 9.0;
  final Map<String, String> breakdown = {
    'DEEP': '2 hr 11min',
    'CORE': '4 hr 21 min',
    'REM': '1 hr',
  };
  final List<double> weekData = [0.7, 0.8, 0.6, 0.9, 0.5, 0.8, 0.7];

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
          await _tts.speak(t.sleepRatingTitle);
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
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    final List<String> tabs = [
      AppLocalizations.of(context)!.week,
      AppLocalizations.of(context)!.month,
      AppLocalizations.of(context)!.threeMonth,
      AppLocalizations.of(context)!.year,
    ];
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.sleepRatingTitle),
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/moon.svg',
                      width: 120,
                      height: 120,
                      colorFilter: const ColorFilter.mode(
                        Colors.deepPurpleAccent,
                        BlendMode.srcIn,
                      ),
                      placeholderBuilder:
                          (context) => const Icon(
                            Icons.bedtime,
                            size: 90,
                            color: Colors.deepPurpleAccent,
                          ),
                    ),

                    Column(
                      children: [
                        Text(
                          '${totalSleep.toStringAsFixed(0)}h',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'of Sleep',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sleep breakdown
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        breakdown.entries.map((e) {
                          Color color;
                          switch (e.key) {
                            case 'DEEP':
                              color = Colors.deepPurple;
                              break;
                            case 'CORE':
                              color = Colors.purpleAccent;
                              break;
                            case 'REM':
                              color = Colors.purple;
                              break;
                            default:
                              color = Colors.grey;
                          }
                          return Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                e.key,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              Text(
                                e.value,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Info text
              Card(
                color: Colors.deepPurple[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Remember, the Caredify bracelet records sleep when worn while sleeping. It activates automatically at 10:00 PM and records sleep of 4 hours or more.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.deepPurple[700],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tabs
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(tabs.length, (i) {
                    final selected = i == _selectedTab;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          tabs[i],
                          style: Theme.of(context).textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedTab = i),
                        selectedColor: const Color.fromARGB(126, 94, 36, 255),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              WeeklyChart(data: weekData, barColor: Colors.deepPurpleAccent),
            ],
          ),
        ),
      ),
    );
  }
}
