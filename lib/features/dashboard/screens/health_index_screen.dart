import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../shared/providers/user_type_provider.dart';
import '../../../shared/providers/voice_feedback_provider.dart';
import '../../../shared/services/auth_service.dart';

class HealthIndexScreen extends ConsumerStatefulWidget {
  const HealthIndexScreen({super.key});

  @override
  ConsumerState<HealthIndexScreen> createState() => _HealthIndexScreenState();
}

class _HealthIndexScreenState extends ConsumerState<HealthIndexScreen> {
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
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.healthRatingTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _PremiumCard(child: _MainHealthIndexCard()),
                const SizedBox(height: 20),
                _PremiumCard(child: _BMICard()),
                const SizedBox(height: 20),
                _PremiumCard(child: _BodyFatRateCard()),
              ],
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

class _MainHealthIndexCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isRtl = intl.Bidi.isRtlLanguage(locale.languageCode);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        // Circular grade with custom arc
        Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Custom arc
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: _ArcPainter(),
                  ),
                  // Star at the top
                  const Positioned(
                    top: 18,
                    left: 0,
                    right: 0,
                    child: Icon(Icons.star, color: Color(0xFFFFC94D), size: 28),
                  ),
                  // Grade and label
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'B',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          fontSize: MediaQuery.textScalerOf(context).scale(48),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'My Health Index',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 130,
              height: 40,
              child: ElevatedButton(
                onPressed: () => context.go('/main/health-index/reevaluate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC94D),
                  foregroundColor: const Color(0xFF3B2063),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppLocalizations.of(context)!.reevaluate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        // Legend
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendRow('A', 'Level : 100 ~ 96 points', Color(0xFFFFC94D)),
              SizedBox(height: 5),
              _LegendRow('B', 'Level : 95 ~ 86 points', Color(0xFF7ED6D6)),
              SizedBox(height: 5),
              _LegendRow('C', 'Level : 85 ~ 76 points', Color(0xFF8B5CF6)),
              SizedBox(height: 5),
              _LegendRow('D', 'Level : 75 ~ 66 points', Color(0xFFFF6B81)),
              SizedBox(height: 5),
              _LegendRow('E', 'Level : 60 ~ 0 points', Color(0xFFBDBDBD)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const startAngle = 3.5 * 3.1416 / 4; // 225 degrees
    const sweepAngle = 2 * 3.1416 / 2.5; // About 270 degrees
    final paint =
        Paint()
          ..color = const Color(0xFFFFC94D)
          ..strokeWidth = 12
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: rect.center, radius: size.width / 2 - 12),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
    // Draw the second arc in a different color
    paint.color = const Color.fromARGB(255, 255, 221, 141);
    canvas.drawArc(
      Rect.fromCircle(center: rect.center, radius: size.width / 2 - 12),
      startAngle + sweepAngle,
      1.8 * 3.1416 / 4, // About 90 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendRow extends StatelessWidget {
  final String grade;
  final String label;
  final Color color;
  const _LegendRow(this.grade, this.label, this.color);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withAlpha((0.15 * 255).round()),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                grade,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _BMICard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.monitor_weight,
              color: Color(0xFF00B8A9),
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.bmi,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.info_outline, color: Color(0xFFBDBDBD), size: 18),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)!.bmiValue,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 95, 64, 143),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.bmiHealthyLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00B8A9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _BMIScaleBar(),
      ],
    );
  }
}

class _BMIScaleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // BMI scale: 18-30
    const double bmi = 22.4;
    const min = 18, max = 30;
    final double percent = ((bmi - min) / (max - min)).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F3FF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFFF6B81)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.bmiLight,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmiHealthy,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmiOverweight,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmiObesity,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.bmi18,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi20,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi24,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi26,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi28,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi30,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _BodyFatRateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.fitness_center,
              color: Color(0xFF8B5CF6),
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Body Fat Rate',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.info_outline, color: Color(0xFFBDBDBD), size: 18),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '18%',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Normal',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00B8A9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _BodyFatScaleBar(),
      ],
    );
  }
}

class _BodyFatScaleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Body fat scale: 15-40
    const double fat = 18.4;
    const min = 15, max = 40;
    final double percent = ((fat - min) / (max - min)).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F3FF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFFF6B81)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.bmiThin,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmiSThin,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmiSFat,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmiObesity2,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.bmi15,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi20_2,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi25,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi30_2,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi35,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              AppLocalizations.of(context)!.bmi40,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}
