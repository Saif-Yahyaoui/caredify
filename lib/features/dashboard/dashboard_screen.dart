import 'package:caredify/features/dashboard/circular_step_counter.dart';
import 'package:caredify/features/dashboard/ecg_card.dart';
import 'package:caredify/features/dashboard/health_cards_grid.dart';
import 'package:caredify/features/dashboard/health_watch_screen.dart';
import 'package:caredify/features/dashboard/metrics_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/floating_bottom_nav_bar.dart';

import '../../providers/health_metrics_provider.dart';
import '../profile/profile_screen.dart';
import '../../providers/voice_feedback_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
      if (voiceFeedbackEnabled) {
        _speakTab(_selectedIndex);
      }
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    final voiceFeedbackEnabled = ref.read(voiceFeedbackProvider);
    if (voiceFeedbackEnabled) {
      _speakTab(index);
    }
  }

  /// 🔈 Speak tab info in localized TTS voice
  Future<void> _speakTab(int index) async {
    final context = this.context;
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Detect language
    String ttsLang;
    switch (locale) {
      case 'ar':
        ttsLang = 'ar-SA';
        break;
      case 'fr':
        ttsLang = 'fr-FR';
        break;
      default:
        ttsLang = 'en-US';
    }
    try {
      var result = await _tts.setLanguage(ttsLang);
      if (result != 1) {
        // Fallback to English if language not supported
        await _tts.setLanguage('en-US');
      }
    } catch (e) {
      // Fallback to English if any error
      await _tts.setLanguage('en-US');
    }

    String message;
    switch (index) {
      case 0:
        message = t.homeTab;
        break;
      case 1:
        message = t.watchTab;
        break;
      case 2:
        message = t.chatTab;
        break;
      case 3:
        message = t.appointmentsTab;
        break;
      case 4:
        message = t.profileTab;
        break;
      default:
        message = '';
    }

    try {
      await _tts.speak(message);
    } catch (e) {
      // Optionally log or ignore
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(healthMetricsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _tabContents(metrics)[_selectedIndex]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: FloatingBottomNavBar(
                selectedIndex: _selectedIndex,
                onTabSelected: _onTabSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tabContents(healthMetrics) => [
    _DashboardHome(metrics: healthMetrics),
    const HealthWatchScreen(), // Watch
    Center(child: Text(AppLocalizations.of(context)!.chatTab)),
    Center(child: Text(AppLocalizations.of(context)!.appointmentsTab)),
    const ProfileScreen(),
    const HealthWatchScreen(),
  ];
}

class _DashboardHome extends ConsumerWidget {
  final dynamic metrics;
  const _DashboardHome({required this.metrics});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              200, // Account for bottom nav and padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // Reduced from 24
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Hello Saif!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12), // Reduced from 16
            Center(
              child: CircularStepCounter(steps: metrics.steps, goal: 10000),
            ),
            const SizedBox(height: 12), // Reduced from 16
            MetricsRow(
              calories: metrics.calories,
              distance: metrics.distance,
              minutes: metrics.activeMinutes,
            ),
            const SizedBox(height: 12), // Reduced from 16
            HealthCardsGrid(
              heartRate: metrics.heartRate,
              heartRateMax: 100,
              waterIntake: metrics.waterIntake * 1000,
              waterGoal: 1500,
              sleepHours: metrics.sleepHours.toDouble(),
              sleepGoal: 9.0,
              workoutMinutes: metrics.activeMinutes,
              workoutGoal: 60,
              onHeartTap: () => context.push('/heart'),
              onWaterTap: () => context.push('/water'),
              onSleepTap: () => context.push('/sleep'),
              onWorkoutTap: () => context.push('/workout'),
              onHabitsTap: () => context.push('/habits'),
              onHealthIndexTap: () => context.push('/health-index'),
            ),
            const SizedBox(height: 12), // Reduced from 16
            const ECGCard(),
            const SizedBox(height: 20), // Reduced from 24
          ],
        ),
      ),
    );
  }
}
