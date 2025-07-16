import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../shared/providers/voice_feedback_provider.dart';

class WorkoutTrackerScreen extends ConsumerStatefulWidget {
  const WorkoutTrackerScreen({super.key});

  @override
  ConsumerState<WorkoutTrackerScreen> createState() =>
      _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends ConsumerState<WorkoutTrackerScreen> {
  final FlutterTts _tts = FlutterTts();

  // Mock data
  final int steps = 7900;
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
          await _tts.speak(t.workoutTrackerTitle);
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
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.workoutTrackerTitle),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.go('/main/dashboard'),
          ),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _WorkoutScreenPremium(
            steps: 7900,
            stepGoal: 10000,
            calories: 111,
            distance: 1.2,
            minutes: 30,
            trend: [0.7, 0.8, 0.6, 0.9, 0.5, 0.8, 0.7],
            bestSteps: 12000,
            bestDistance: 8.2,
          ),
        ),
      ),
    );
  }
}

class _WorkoutScreenPremium extends StatelessWidget {
  final int steps;
  final int stepGoal;
  final double calories;
  final double distance;
  final int minutes;
  final List<double> trend;
  final int bestSteps;
  final double bestDistance;
  const _WorkoutScreenPremium({
    required this.steps,
    required this.stepGoal,
    required this.calories,
    required this.distance,
    required this.minutes,
    required this.trend,
    required this.bestSteps,
    required this.bestDistance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Premium Card with Animated Progress Ring
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4ADE80), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4ADE80).withAlpha((0.2 * 255).toInt()),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: steps / stepGoal,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withAlpha(
                        (0.2 * 255).toInt(),
                      ),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.directions_run,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$steps / $stepGoal',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Steps',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '$minutes min',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Workout Trend Chart
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity Trend (7 days)',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 120,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            trend.length,
                            (i) => FlSpot(i.toDouble(), trend[i]),
                          ),
                          isCurved: true,
                          color: const Color(0xFF4ADE80),
                          barWidth: 4,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Personal Bests
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFE0F7FA),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Color(0xFF4ADE80)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Personal Best: $bestSteps steps, ${bestDistance.toStringAsFixed(2)} km',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // AI Workout Suggestions
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFE0F7FA),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Workouts',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• 20 min brisk walk\n• 10 min stretching\n• 15 min cycling',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Health Info
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFE0F7FA),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How activity improves your health',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Boosts mood\n• Improves heart health\n• Increases energy\n• Supports weight management',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Export Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ADE80),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.share),
          label: const Text('Export Workout Log'),
          onPressed: () {},
        ),
      ],
    );
  }
}
