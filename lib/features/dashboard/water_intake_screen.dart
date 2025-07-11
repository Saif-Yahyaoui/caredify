import 'package:caredify/features/dashboard/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/voice_feedback_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaterIntakeScreen extends ConsumerStatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  ConsumerState<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends ConsumerState<WaterIntakeScreen> {
  final FlutterTts _tts = FlutterTts();

  int _selectedTab = 0;

  // Mock data
  double waterIntake = 0.5; // in liters
  final double waterGoal = 2.0; // in liters
  final List<double> weekData = [0.5, 1.0, 0.7, 1.2, 0.8, 1.5, 0.9];

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
          await _tts.speak(t.waterIntakeTitle);
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

  void _increment() {
    setState(() {
      if (waterIntake < waterGoal) {
        waterIntake += 0.25;
      }
    });
  }

  void _decrement() {
    setState(() {
      if (waterIntake > 0) {
        waterIntake -= 0.25;
      }
    });
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
          title: Text(AppLocalizations.of(context)!.waterIntakeTitle),
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
                      'assets/icons/water.svg',
                      width: 80,
                      height: 80,
                      colorFilter: const ColorFilter.mode(
                        Colors.lightBlueAccent,
                        BlendMode.srcIn,
                      ),
                      placeholderBuilder:
                          (context) => const Icon(
                            Icons.water_drop,
                            size: 80,
                            color: Colors.lightBlueAccent,
                          ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${waterIntake.toStringAsFixed(1)} L',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'gl. (500ml)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.lightBlueAccent,
                            size: 32,
                          ),
                          onPressed: _decrement,
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.lightBlueAccent,
                            size: 32,
                          ),
                          onPressed: _increment,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                        selectedColor: const Color.fromARGB(255, 21, 181, 255),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              WeeklyChart(
                data: weekData.map((v) => v / waterGoal).toList(),
                barColor: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
