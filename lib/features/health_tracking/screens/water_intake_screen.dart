import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../shared/providers/voice_feedback_provider.dart';

class WaterIntakeScreen extends ConsumerStatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  ConsumerState<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends ConsumerState<WaterIntakeScreen> {
  final FlutterTts _tts = FlutterTts();

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

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
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
            onPressed: () => context.go('/main/dashboard'),
          ),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _WaterScreenPremium(
            waterIntake: 1.2,
            waterGoal: 2.0,
            trend: [1.0, 1.5, 1.2, 1.8, 1.0, 1.3, 1.2],
            streak: 5,
          ),
        ),
      ),
    );
  }
}

class _WaterScreenPremium extends StatelessWidget {
  final double waterIntake;
  final double waterGoal;
  final List<double> trend;
  final int streak;
  const _WaterScreenPremium({
    required this.waterIntake,
    required this.waterGoal,
    required this.trend,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Premium Card with Animated Water Fill
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF22D3EE), Color(0xFF0EA5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22D3EE).withAlpha((0.2 * 255).toInt()),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha((0.2 * 255).toInt()),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: waterIntake / waterGoal),
                    duration: const Duration(milliseconds: 1200),
                    builder: (context, value, child) {
                      return Container(
                        width: 60,
                        height: 60 * value,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.7 * 255).toInt()),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(30),
                          ),
                        ),
                      );
                    },
                  ),
                  const Icon(Icons.water_drop, color: Colors.white, size: 48),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${waterIntake.toStringAsFixed(1)} L',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Today',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        // Hydration Streak
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFE0F7FA),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Color(0xFF22D3EE),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Hydration streak: $streak days in a row!'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Water Intake Trend Chart
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
                  'Water Intake Trend (7 days)',
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
                          color: const Color(0xFF22D3EE),
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
        const SizedBox(height: 16),
        // Benefits Section
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
                  'Benefits of Hydration',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Boosts energy\n• Improves skin\n• Supports metabolism\n• Aids digestion',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Reminders Section
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFE0F7FA),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.alarm, color: Color(0xFF22D3EE)),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Set a reminder to drink water every 2 hours.'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Needs Calculator
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
                  'How much water do you need?',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Recommended: 35ml per kg of body weight.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Export Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF22D3EE),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.share),
          label: const Text('Export Hydration Log'),
          onPressed: () {},
        ),
      ],
    );
  }
}
