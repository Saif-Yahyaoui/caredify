import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:fl_chart/fl_chart.dart';

import '../../../shared/providers/voice_feedback_provider.dart';
import '../../../shared/widgets/weekly_chart.dart';

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
            onPressed: () => context.go('/main/dashboard'),
          ),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _SleepScreenPremium(
            totalSleep: 7.0,
            trend: [7.0, 6.5, 8.0, 7.2, 6.8, 7.5, 7.0],
            quality: 'A',
          ),
        ),
      ),
    );
  }
}

class _SleepScreenPremium extends StatelessWidget {
  final double totalSleep;
  final List<double> trend;
  final String quality;
  const _SleepScreenPremium({
    required this.totalSleep,
    required this.trend,
    required this.quality,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Premium Card with Animated Moon
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF8B5CF6).withOpacity(0.2),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: 1 + 0.05 * (totalSleep % 2),
                    child: Icon(
                      Icons.nightlight_round,
                      color: Colors.white,
                      size: 64,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                '${totalSleep.toStringAsFixed(1)} h',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total Sleep',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        // Sleep Trend Chart
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
                  'Sleep Trend (7 days)',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 120,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            trend.length,
                            (i) => FlSpot(i.toDouble(), trend[i]),
                          ),
                          isCurved: true,
                          color: Color(0xFF8B5CF6),
                          barWidth: 4,
                          dotData: FlDotData(show: false),
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
        // Sleep Quality Score
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFF3F0FF),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.grade, color: Color(0xFF8B5CF6)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sleep Quality: $quality',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    quality,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Tips Section
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFF7F3FF),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for Better Sleep',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Keep a regular sleep schedule\n• Avoid caffeine late in the day\n• Create a restful environment\n• Limit screen time before bed',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Comparison Section
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFEDE9FE),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.compare, color: Color(0xFF8B5CF6)),
                SizedBox(width: 12),
                Expanded(
                  child: Text('You sleep more than 65% of users your age.'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Sleep Hygiene Checklist
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFF3F0FF),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sleep Hygiene Checklist',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '☑️ Dark, quiet room\n☑️ Comfortable bed\n☑️ No screens before bed\n☑️ Regular bedtime',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Export Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: Icon(Icons.share),
          label: Text('Export Sleep Report'),
          onPressed: () {},
        ),
      ],
    );
  }
}
