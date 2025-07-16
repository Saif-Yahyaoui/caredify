import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:fl_chart/fl_chart.dart';

import '../../../shared/providers/voice_feedback_provider.dart';

class HeartTrackerScreen extends ConsumerStatefulWidget {
  const HeartTrackerScreen({super.key});

  @override
  ConsumerState<HeartTrackerScreen> createState() => _HeartTrackerScreenState();
}

class _HeartTrackerScreenState extends ConsumerState<HeartTrackerScreen> {
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
          await _tts.speak('${t.heartTrackerTitle}. ${t.startMeasuring}');
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

  // Mock data
  final int bpm = 0;
  final int spo2 = 0;
  final String bloodPressure = '00/00';

  void _startHeartMeasurement() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Heart measurement started!')));
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.heartTrackerTitle),
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
          child: _HeartTrackerScreenPremium(
            bpm: 72,
            trend: [72, 75, 70, 68, 74, 73, 72],
          ),
        ),
      ),
    );
  }
}

class _HeartTrackerScreenPremium extends StatelessWidget {
  final int bpm;
  final List<int> trend;
  const _HeartTrackerScreenPremium({required this.bpm, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Premium Card with Animated Heart
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B81), Color(0xFFFFA07A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF6B81).withOpacity(0.2),
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
                tween: Tween(begin: 1.0, end: 1.2),
                duration: Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: 1 + 0.05 * (bpm % 2),
                    child: Icon(Icons.favorite, color: Colors.white, size: 64),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                '$bpm',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'BPM',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        // Heart Rate Trend Chart
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
                  'Heart Rate Trend (7 days)',
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
                            (i) => FlSpot(i.toDouble(), trend[i].toDouble()),
                          ),
                          isCurved: true,
                          color: Color(0xFFFF6B81),
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
        // Normal Range Info
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFFFF1F3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFFF6B81)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Normal resting heart rate for adults: 60-100 BPM. Your average is healthy.',
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
          color: Color(0xFFFFF7F0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for a Healthy Heart',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Stay hydrated\n• Manage stress\n• Get enough sleep\n• Exercise regularly',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Warning Section
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFFFE4E1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B81)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Consult a doctor if you experience chest pain, dizziness, or irregular heartbeat.',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Share/Export Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6B81),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: Icon(Icons.share),
          label: Text('Share/Export Health Data'),
          onPressed: () {},
        ),
      ],
    );
  }
}
