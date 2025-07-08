import 'package:caredify/features/dashboard/circular_step_counter.dart';
import 'package:caredify/features/dashboard/metrics_row.dart';
import 'package:caredify/features/dashboard/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/voice_feedback_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutTrackerScreen extends ConsumerStatefulWidget {
  const WorkoutTrackerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WorkoutTrackerScreen> createState() =>
      _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends ConsumerState<WorkoutTrackerScreen> {
  final FlutterTts _tts = FlutterTts();
  int _selectedTab = 0;

  // Mock data
  final int steps = 9999;
  final int stepGoal = 10000;
  final double calories = 111;
  final double distance = 1.2;
  final int minutes = 30;
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
          await _tts.speak(t.workoutTrackerTitle);
        } catch (e) {}
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
    final List<String> _tabs = [
      AppLocalizations.of(context)!.week,
      AppLocalizations.of(context)!.month,
      AppLocalizations.of(context)!.threeMonth,
      AppLocalizations.of(context)!.year,
    ];
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.workoutTrackerTitle),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: CircularStepCounter(steps: steps, goal: stepGoal)),
              const SizedBox(height: 16),
              MetricsRow(
                calories: calories,
                distance: distance,
                minutes: minutes,
              ),
              const SizedBox(height: 24),
              // Tabs
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_tabs.length, (i) {
                    final selected = i == _selectedTab;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          _tabs[i],
                          style: Theme.of(context).textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedTab = i),
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.15),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              WeeklyChart(data: weekData, barColor: Colors.greenAccent),
            ],
          ),
        ),
      ),
    );
  }
}
