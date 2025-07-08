import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/voice_feedback_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthIndexScreen extends ConsumerStatefulWidget {
  const HealthIndexScreen({Key? key}) : super(key: key);

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
          await _tts.speak(t.healthRatingTitle);
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
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.healthRatingTitle),
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
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Main Health Index Card
                _MainHealthIndexCard(),
                const SizedBox(height: 20),
                // BMI Card
                _BMICard(),
                const SizedBox(height: 20),
                // Body Fat Rate Card
                _BodyFatRateCard(),
              ],
            ),
          ),
        ),
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
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
                      Positioned(
                        top: 18,
                        left: 0,
                        right: 0,
                        child: Icon(
                          Icons.star,
                          color: Color(0xFFFFC94D),
                          size: 28,
                        ),
                      ),
                      // Grade and label
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          Text(
                            'B',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onBackground,
                              fontSize:
                                  48 * MediaQuery.of(context).textScaleFactor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'My Health Index',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onBackground,
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
                    onPressed: () => context.push('/health-index-reevaluate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC94D),
                      foregroundColor: const Color(0xFF3B2063),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: theme.textTheme.labelLarge?.copyWith(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendRow('A', 'Level : 100 ~ 96 points', Color(0xFFFFC94D)),
                  const SizedBox(height: 5),
                  _LegendRow('B', 'Level : 95 ~ 86 points', Color(0xFF7ED6D6)),
                  const SizedBox(height: 5),
                  _LegendRow('C', 'Level : 85 ~ 76 points', Color(0xFF8B5CF6)),
                  const SizedBox(height: 5),
                  _LegendRow('D', 'Level : 75 ~ 66 points', Color(0xFFFF6B81)),
                  const SizedBox(height: 5),
                  _LegendRow('E', 'Level : 60 ~ 0 points', Color(0xFFBDBDBD)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final startAngle = 3.5 * 3.1416 / 4; // 225 degrees
    final sweepAngle = 2 * 3.1416 / 2.5; // About 270 degrees
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
              color: color.withOpacity(0.15),
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
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onBackground,

                fontSize: 13,
              ),
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.bmi,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.info_outline, color: Color(0xFFBDBDBD), size: 18),
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
                    color: Color.fromARGB(255, 95, 64, 143),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.bmiHealthyLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00B8A9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _BMIScaleBar(),
          ],
        ),
      ),
    );
  }
}

class _BMIScaleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // BMI scale: 18-30
    double bmi = 22.4;
    double min = 18, max = 30;
    double percent = ((bmi - min) / (max - min)).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Color(0xFFF7F3FF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Body Fat Rate',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.info_outline, color: Color(0xFFBDBDBD), size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '18.4%',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 95, 64, 143),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'HEALTHY',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00B8A9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _BodyFatScaleBar(),
          ],
        ),
      ),
    );
  }
}

class _BodyFatScaleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Body fat scale: 15-40
    double fat = 18.4;
    double min = 15, max = 40;
    double percent = ((fat - min) / (max - min)).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Color(0xFFF7F3FF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
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
